lazy = require('lazy.js')
truthy = require('truthy.js')

encode =
	authorizationHeader: (a) -> truthy.opt.objecty(a).map((_) ->
		'OAuth realm="",' +
		lazy(_)
			.pairs()
			.sortBy((_) -> _[0])
			.map((_) -> _[0] + encode.rfc3986(_[1].toString()).map((_) -> '="' + _ + '"').getOrElse(''))
			.toArray()
			.join(',')
	)

	rfc3986: (s) -> truthy.opt.stringy(s).map((_) ->
		encodeURIComponent(_)
			.replace(/!/g, '%21')
			.replace(/\*/g, '%2A')
			.replace(/\(/g, '%28')
			.replace(/\)/g, '%29')
			.replace(/'/g, '%27')
	)

	url: (m) -> truthy.opt.objecty(m).map((_) ->
		lazy(_)
			.pairs()
			.sortBy((_) -> _[0])
			.map((t) ->
				encode.rfc3986(t[0].toString()).getOrElse('') +
				encode.rfc3986(t[1].toString()).map((_) ->  '=' + _).getOrElse('')
			)
			.toArray()
			.join('&')
	)

module.exports = Object.freeze(encode)
