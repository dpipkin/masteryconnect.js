lazy = require('lazy.js')
truthy = require('truthy.js')

encode =
	authorizationHeader: (map) ->
		'OAuth realm="",' +
		lazy(map)
			.pairs()
			.sortBy((_) -> _[0])
			.map((_) -> _[0] + '="' + encode.rfc3986(_[1].toString()) + '"')
			.toArray()
			.join(',')

	rfc3986: (string) ->
		encodeURIComponent(string)
			.replace(/!/g, '%21')
			.replace(/\*/g, '%2A')
			.replace(/\(/g, '%28')
			.replace(/\)/g, '%29')
			.replace(/'/g, '%27')

	url: (map) ->
		lazy(map)
			.pairs()
			.sortBy((_) -> _[0])
			.map((t) -> encode.rfc3986(t[0].toString()) + '=' + encode.rfc3986(t[1].toString()))
			.toArray()
			.join('&')

module.exports = Object.freeze(encode)
