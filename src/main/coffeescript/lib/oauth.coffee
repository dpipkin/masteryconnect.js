bilby = require('bilby')
lazy = require('lazy.js')
oauthsign = require('oauth-sign')

oauth =
	authorization: (method, url, parameters, consumerKey, consumerSecret, token, tokenSecret) ->
		params = bilby.extend(
			parameters,
			oauth_consumer_key: consumerKey
			oauth_nonce: oauth.nonce()
			oauth_signature_method: 'HMAC-SHA1'
			oauth_timestamp: Math.floor((new Date()).getTime() / 1000)
			oauth_token: token
			oauth_version: '1.0'
		)

		oauth.sign(method, url, params, consumerSecret, tokenSecret).cata(
			success: ((signature) -> bilby.success(
				oauth_consumer_key: params.oauth_consumer_key
				oauth_nonce: params.oauth_nonce
				oauth_signature: signature
				oauth_signature_method: params.oauth_signature_method
				oauth_timestamp: params.oauth_timestamp
				oauth_token: params.oauth_token
				oauth_version: params.oauth_version
			)),
			failure: bilby.failure('Expected valid signature.')
		)

	nonce: -> lazy([0..31]).map(->
		base64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
		base64[Math.floor(Math.random() * base64.length)]
	).toArray().join('')

	sign: (method, url, parameters, consumerSecret, tokenSecret) ->
		switch (parameters.oauth_signature_method || null)
			when 'HMAC-SHA1'
				bilby.success(oauthsign.hmacsign(method, url, parameters, consumerSecret, tokenSecret))
			else bilby.failure(['Expected supported signature method.'])

module.exports = Object.freeze(oauth)
