Agent = require('keep-alive-agent')
bilby = require('bilby')
encode = require('./encode')
oauth = require('./oauth')
q = require('q')
qio = require('q-io/http')
truthy = require('truthy.js')

http = class Http
	@entityPath: (entity, id) -> entity + truthy.opt.existy(id).map((_) -> '/' + _.toString()).getOrElse('') + '.json'

	@parse: (response) ->
		if not truthy.bool.existy(response) then bilby.none
		else
			try
				json = JSON.parse(response)
			catch
				json = {}

			if truthy.bool.objecty(json) and truthy.bool.lengthy(json)
				bilby.some(json)
			else
				bilby.none

	@querystring: (parameters) -> truthy.opt.lengthy(parameters).map((_) -> '?' + encode.url(_)).getOrElse('')

	constructor: (@baseUrl, @consumerKey, @consumerSecret, @token, @tokenSecret) ->
		@agent = if @baseUrl.indexOf('https:') == 0 then new Agent().Secure() else new Agent()

	delete: (entity, id, parameters) -> @withoutBody('DELETE')(entity, id, parameters)

	get: (entity, id, parameters) -> @withoutBody('GET')(entity, id, parameters)

	post: (entity, payload, parameters) -> @withBody('POST')(entity, null, payload, parameters)

	put: (entity, id, payload, parameters) -> @withBody('PUT')(entity, id, payload, parameters)

	withoutBody: (verb) => (entity, id, parameters) =>
		deferred = q.defer()
		oauthUrl = @baseUrl + http.entityPath(entity, id)
		requestUrl = oauthUrl + http.querystring(parameters)

		oauth.authorization(verb, oauthUrl, parameters, @consumerKey, @consumerSecret, @token, @tokenSecret).cata(
			success: (auth) ->
				authHeader = encode.authorizationHeader(auth)
				request =
					agent: @agent
					headers: 'Authorization': authHeader
					method: verb
					url: requestUrl

				qio.request(request)
					.then((_) -> _.body.read())
					.then((_) -> deferred.resolve(Http.parse(_.toString())))
					.catch((_) -> deferred.reject(_))
					.done()

			failure: (e) -> deferred.reject(e)
		)

		deferred.promise

	withBody: (verb) => (entity, id, payload, parameters) =>
		deferred = q.defer()
		oauthUrl = @baseUrl + http.entityPath(entity, id)
		requestUrl = oauthUrl + http.querystring(parameters)

		oauth.authorization(verb, oauthUrl, parameters, @consumerKey, @consumerSecret, @token, @tokenSecret).cata(
			success: (auth) ->
				authHeader = encode.authorizationHeader(auth)
				json = JSON.stringify(payload)
				request =
					agent: @agent
					charset: 'UTF-8'
					headers:
						'Authorization': authHeader
						'Content-Length': Buffer.byteLength(json, 'utf8')
						'Content-Type': 'application/json'
					method: verb
					url: requestUrl
					body: [json]

				qio.request(request)
					.then((_) -> _.body.read())
					.then((_) -> deferred.resolve(Http.parse(_.toString())))
					.catch((_) -> deferred.reject(_))
					.done()

			failure: (e) -> deferred.reject(e)
		)

		deferred.promise

module.exports = Object.freeze(http)
