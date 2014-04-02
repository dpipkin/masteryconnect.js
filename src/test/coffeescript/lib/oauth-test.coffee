oauth = require('./oauth')
should = require('should')

describe('oauth', ->
	describe('nonce()', ->
		it('should return random 32-digit hexidecimal string', ->
			oauth.nonce().should.not.equal(oauth.nonce())
			/[0-9A-Za-z]{32}/.test(oauth.nonce()).should.be.true
		)
	)
	describe('sign()', ->
		it('should return success with valid signature method', ->
			params =
				oauth_consumer_key: 'oauth_consumer_key'
				oauth_nonce: oauth.nonce()
				oauth_signature_method: 'HMAC-SHA1'
				oauth_timestamp: Date.now()
				oauth_token: 'oauth_token'
				oauth_version: '1.0'

			oauth.sign('POST', 'url', params, 'consumerSecret', 'tokenSecret').cata(
				success: -> should(true).ok
				failure: -> should(false).ok
			)
		)
		it('should return failure with unknown signature method', ->
			params =
				oauth_consumer_key: 'oauth_consumer_key'
				oauth_nonce: oauth.nonce()
				oauth_signature_method: 'pandora'
				oauth_timestamp: Date.now()
				oauth_token: 'oauth_token'
				oauth_version: '1.0'

			oauth.sign('POST', 'url', params, 'consumerSecret', 'tokenSecret').cata(
				success: -> should(false).ok
				failure: -> should(true).ok
			)
		)
	)
	describe('authorization()', ->
		it('should return success', ->
			oauth.authorization('POST', 'url', {}, 'consumerKey', 'consumerSecret', 'token', 'tokenSecret').cata(
				success: (auth) -> auth.hasOwnProperty('oauth_signature').should.be.true
				failure: -> should(true).ok
			)
		)
	)
)
