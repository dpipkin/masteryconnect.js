encode = require('./encode')
oauth = require('./oauth')
should = require('should')

describe('encode', ->
	describe('authorizationHeader()', ->
		it('should return string representation of an authorization', ->
			oauth.authorization('GET', 'url', {}, 'consumerKey', 'consumerSecret', 'token', 'tokenSecret').cata(
				success: (auth) ->
					encoded = encode.authorizationHeader(auth)

					encoded.indexOf('OAuth realm=').should.be.equal(0)
					encoded.indexOf('oauth_signature=').should.not.be.equal(-1)
				failure: -> should(false).ok
			)
		)
	)
	describe('rfc3986()', ->
		it('should return RFC 3986 compatible string', ->
			encode.rfc3986('hello there!').should.equal('hello%20there%21')
		)
	)
	describe('url()', ->
		it('should return string representation of a map', ->
			encode.url(test2: 'test2', test1: 'test1').should.equal('test1=test1&test2=test2')
		)
	)
)
