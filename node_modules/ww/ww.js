var ww = function () {
	'use strict';

	var nextTickTasks = [], nextTickProgress = false;

	var cc = 1;

	var nextTickDo =
		typeof Promise === 'function' && typeof Promise.resolve === 'function' ?
			function resolvePromise(fn) { Promise.resolve().then(fn); } :
			typeof process === 'object' && typeof process.nextTick === 'function' ?
				process.nextTick :
				typeof setImmediate === 'function' ? setImmediate :
					function setTimeout_(fn) { setTimeout(fn, 0) };

	var slice = [].slice;

	ww.makeSync = makeSync;

	ww.resolve = resolve;
	ww.reject = reject;

	ww.wait = wait;
	ww.all = all;

	return ww;

	// *** ww
	function ww(setup, cb) {
		if (setup != null) {
			if (typeof setup === 'number')
				return wait.apply(null, arguments);

			if (typeof setup.next === 'function')
				return gtorcb(setup, cb);

			if (typeof setup.then === 'function')
				return ww(function (res, rej) { setup.then(res, rej); }, cb);

			if (setup.constructor === Array ||
					setup.constructor === Object)
						return all(setup, cb);
		}

		if (typeof setup !== 'function')
			throw new TypeError('first argument "setup" must be a function');

		// callback mode
		if (typeof cb === 'function') {
			var last = function (err, val) {
				var args = arguments.length > 2 ? [err, slice.call(arguments, 1)] :
					arguments.length === 1 && !(err instanceof Error) ? [null, err] :
						arguments;
				cb.apply(null, args);
			};
			try {
				var r = setup(last, last);

				if (r != null && typeof r.next === 'function')
					return gtorcb(r, cb);

				if (r != null && typeof r.then === 'function')
					return ww(function (res, rej) { r.then(res, rej); }, cb);

				return;
			}
			catch (err) { cb(err); return; }
		}

		// promise & thunk mode

		var called = false, bombs = [], results;

		var fire = function fire() {
			if (!results) return;
			var bomb;
			while (bomb = bombs.shift())
				bomb.apply(null, results);
		}; // fire

		var callback = function callback(err, val) {
			if (!results)
				results = arguments.length > 2 ? [err, slice.call(arguments, 1)] :
					arguments.length === 1 && !(err instanceof Error) ? [null, err] :
						arguments;
			nextTick(fire);
		}; // callback

		// pre-setup
		if (cb === true)
			try {
				called = true;
				var r = setup(callback, callback);

				if (r != null && typeof r.next === 'function')
					return gtorcb(r, cb);

				if (r != null && typeof r.then === 'function')
					return ww(function (res, rej) { r.then(res, rej); }, cb);
			}
			catch (err) { callback(err); }

		var thunk = function thunk(cb) {
			var next, thunk = ww(function (cb) { next = cb; }, true);

			try {
				if (!called) {
					called = true;
					var r = setup(callback, callback);

					if (r != null && typeof r.next === 'function')
						gtorcb(r, callback);

					if (r != null && typeof r.then === 'function')
						ww(function (res, rej) { r.then(res, rej); }, callback);
				}
			} catch (err) { next(err); }

			bombs.push(function (err, val) {
				try {
					var r = cb.apply(null, arguments);
					next(null, r);
				}
				catch (err) { next(err); }
			});

			if (results) nextTick(fire);

			return thunk;
		}; // thunk

		thunk.then = function then(res, rej) {
			return thunk(function (err, val) {
				return err ?
					typeof rej === 'function' ? rej(err) : err :
					typeof res === 'function' ? res(val) : val;
			});
		}; // then

		thunk['catch'] = function (rej) {
			return thunk(function (err, val) {
				return err ?
					typeof rej === 'function' ? rej(err) : err :
					val;
			});
		}; // catch

		return thunk;
	} // ww

	// *** wait
	function wait(msec, val, cb) {
		return ww(function (res, rej) {
			setTimeout(res, msec, val);
		}, cb);
	} // wait

	// *** gtorcb
	function gtorcb(gtor, cb) {

		if (typeof gtor === 'function') gtor = gtor();

		return ww(function (res, rej) {
			next();
			function next(err, val) {
				if (arguments.length > 2)
					val = slice.call(arguments, 1);
				else if (arguments.length === 1 && !(err instanceof Error))
					val = err, err = null;
				try { var obj = err ? gtor.throw(err) : gtor.next(val); }
				catch (err) { rej(err); }
				val = obj.value;
				if (obj.done) res(val);
				else if (!val) next(null, val);
				else if (val instanceof Error) next(val);
				else if (val.constructor === Array ||
					val.constructor === Object)
						all(val, next);
				else if (typeof val === 'function') val(next);
				else if (typeof val.then === 'function') val.then(next, next);
				else next(null, val);
			} // next
		}, cb);
	} // gtorcb

	// *** resolve
	function resolve(val, cb) {
		return ww(function (res, rej) {
			res(val);
		}, cb == null ? true : cb);
	} // resolve

	// *** reject
	function reject(err, cb) {
		return ww(function (res, rej) {
			rej(err);
		}, cb == null ? true : cb);
	} // reject

	// *** all
	function all(arg, cb) {
		if (arg == null ||
			(arg.constructor !== Array &&
				arg.constructor !== Object))
			throw new TypeError('first argument is not an array or an object');

		return ww(arg.constructor === Array ? array : object, cb);

		function array(res, rej) {
			var n = arg.length;
			if (n === 0) { res([]); return; }

			var result = new Array(n);
			arg.forEach((p, i) => p.then(val => {
				result[i] = val;
				--n || res(result);
			}, rej));
		} // allArray

		function object(res, rej) {
			var keys = Object.keys(arg);
			var n = keys.length;
			if (n === 0) { res({}); return; }

			var result = keys.reduce((that, prop) => (that[prop] = undefined, that), {});
			keys.forEach(prop => arg[prop].then(val => {
				result[prop] = val;
				--n || res(result);
			}, rej));
		} // allObject

	} // all

	// *** makeSync
	function makeSync(num) {
		if (typeof num !== 'number' || num !== num)
			throw new TypeError('number of parallel must be a number');

		if (num <= 0)
			throw new RangeError('number of parallel must be a positive number');

		var resolves = [];

		return function sync(val) {
			return ww(function (res, rej) {
				resolves.push({res: res, val: val});
				if (resolves.length >= num)
					resolves.forEach(elem => (elem.res)(elem.val));
			});
		} // sync
	} // makeSync

	// *** nextTick
	function nextTick(fn) {
		nextTickTasks.push(fn);
		if (nextTickProgress) return;
		nextTickProgress = true;
		if (--cc >= 0) return cc = 100, nextTickExecutor();
		// console.log('@@@' + cc + new Error().stack.split('\n').slice(2).filter(x=>x.indexOf('ww')>0).join('\n'));
		nextTickDo(nextTickExecutor);
	} // nextTick

	// *** nextTickExecutor
	function nextTickExecutor() {
		while (nextTickTasks.length) (nextTickTasks.shift())();
		nextTickProgress = false;
	} // nextTickExecutor

}();

if (typeof module === 'object' && module && module.exports)
	module.exports = ww;
