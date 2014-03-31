bilby = require('bilby')
lazy = require('lazy.js')
oauth = require('oauth')
q = require('q')
truthy = require('truthy.js')

masteryconnect =
	Http: class Http
		@handle: (deferred) -> (error, response) ->
			if truthy.bool.existy(error) then deferred.reject(error)
			else deferred.resolve(Http.parse(response))

		@parse: (response) ->
			if not truthy.bool.existy(response) then bilby.none
			else
				try
					json = JSON.parse(response)
				catch
					json = {}

				if truthy.bool.objecty(json) and truthy.bool.lengthy(json) then bilby.some(json)
				else bilby.none

		constructor: (@baseUri, @oauth, @oauthToken, @oauthTokenSecret) ->

		delete: (entity, id, parameters) ->
			deferred = q.defer()

			@oauth.delete(
				@url(entity, id, truthy.opt.existy(parameters).getOrElse(null)),
				@oauthToken,
				@oauthTokenSecret,
				Http.handle(deferred)
			)

			deferred.promise

		get: (entity, id, parameters) ->
			deferred = q.defer()

			@oauth.get(
				@url(entity, truthy.opt.existy(id).getOrElse(null), truthy.opt.existy(parameters).getOrElse(null)),
				@oauthToken,
				@oauthTokenSecret,
				Http.handle(deferred)
			)

			deferred.promise

		post: (entity, payload, parameters) ->
			deferred = q.defer()

			@oauth.post(
				@url(entity, null, truthy.opt.existy(parameters).getOrElse(null)),
				@oauthToken,
				@oauthTokenSecret,
				JSON.stringify(payload),
				'application/json',
				Http.handle(deferred)
			)

			deferred.promise

		put: (entity, id, payload, parameters) ->
			deferred = q.defer()

			@oauth.put(
				@url(entity, id, truthy.opt.existy(parameters).getOrElse(null)),
				@oauthToken,
				@oauthTokenSecret,
				JSON.stringify(payload),
				'application/json',
				Http.handle(deferred)
			)

			deferred.promise

		url: (entity, id, parameters) ->
			@baseUri + entity + truthy.opt.existy(id).map((_) -> '/' + _.toString()).getOrElse('') + '.json' +
				truthy.opt.existy(parameters).map((_) ->
					'?' + lazy(_).reduce(((a, b, c) -> a + c.toString() + '=' + b.toString() + '&'), '').slice(0, -1)
				).getOrElse('')

	Client: class Client
		constructor: (@host, @port, @path, @oauthConsumerSecret, @oauthToken, @oauthTokenSecret) ->

		withSession: (f) ->
			http = new Http(
				(if @port is 443 then 'https://' else 'http://') + @host + @path,
				new oauth.OAuth(null, null, null, @oauthConsumerSecret, '1.0A', null, 'HMAC-SHA1'),
				@oauthToken,
				@oauthTokenSecret
			)

			f(Object.freeze(
				getTeacher: bilby.bind(http.get)(http, 'teachers')
				getTeachers: bilby.bind(http.get)(http, 'teachers', null)
				postTeacher: bilby.bind(http.post)(http, 'teachers')
				putTeacher: bilby.bind(http.put)(http, 'teachers')
				deleteTeacher: bilby.bind(http.delete)(http, 'teachers')
				getStudent: bilby.bind(http.get)(http, 'students')
				getStudents: bilby.bind(http.get)(http, 'students', null)
				postStudent: bilby.bind(http.post)(http, 'students')
				postStudents: bilby.bind(http.post)(http, 'students') # Only students allow for multiple.
				putStudent: bilby.bind(http.put)(http, 'students')
				deleteStudent: bilby.bind(http.delete)(http, 'students')
				getSection: bilby.bind(http.get)(http, 'sections')
				getSections: bilby.bind(http.get)(http, 'sections', null)
				postSection: bilby.bind(http.post)(http, 'sections')
				putSection: bilby.bind(http.put)(http, 'sections')
				deleteSection: bilby.bind(http.delete)(http, 'sections')
				getStandards: bilby.bind(http.get)(http, 'standards', null)
				getScores: bilby.bind(http.get)(http, 'scores', null)
				getAssessments: bilby.bind(http.get)(http, 'assessments', null)
			))

module.exports = Object.freeze(masteryconnect)
