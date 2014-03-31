lazy = require('lazy.js')
masteryconnect = require('./masteryconnect')
oauth = require('oauth')
should = require('should')

random = -> lazy.generate((-> Math.floor(Math.random() * 10))).take(16).toString('')
http = new masteryconnect.Http(
	(if process.env.MASTERYCONNECTJS_PORT is 443 then 'https://' else 'http://') +
		process.env.MASTERYCONNECTJS_HOST +
		process.env.MASTERYCONNECTJS_PATH,
	new oauth.OAuth(null, null, null, process.env.MASTERYCONNECTJS_OAUTHCONSUMERSECRET, '1.0A', null, 'HMAC-SHA1'),
	process.env.MASTERYCONNECTJS_OAUTHTOKEN
	process.env.MASTERYCONNECTJS_OAUTHTOKENSECRET
)

describe('masteryconnect', ->
	describe('Http', ->
		describe('post()', ->
			it('should work', (done) ->
				student = student:
					first_name: 'post'
					last_name: 'unittest'
					student_number: random()

				http.post('students', student)
				.then((_) -> _.fold(((_) -> _.success), false).should.be.true)
				.done(-> done())
			)
		)
		describe('get()', ->
			it('should work with id', (done) ->
				# Hack because performance is poor against staging.
				student = student:
					first_name: 'get'
					last_name: 'unittest'
					student_number: random()

				http.post('students', student)
				.then((_) ->
					id = _.map((_) -> _.student.id).getOrElse(-1)
					http.get('students', id)
				).then((_) ->
					_.getOrElse(null).should.have.property('student')
				).done(-> done())
			)
			it('should work without id', (done) ->
				http.get('students')
				.then((_) -> _.getOrElse(null).length.should.be.above(0))
				.done(-> done())
			)
		)
		describe('put()', ->
			it('should work', (done) ->
				# Hack because performance is poor against staging.
				student = student:
					first_name: 'put'
					last_name: 'unittest'
					student_number: random()

				http.post('students', student)
				.then((_) ->
					id = _.map((_) -> _.student.id).getOrElse(-1)
					http.put('students', id, student: first_name: 'put')
				).then((_) ->
					_.getOrElse(false).success.should.be.true
				).done(-> done())
			)
		)
		describe('delete()', ->
			it('should work', (done) ->
				# Hack because performance is poor against staging.
				student = student:
					first_name: 'delete'
					last_name: 'unittest'
					student_number: random()

				http.post('students', student)
				.then((_) ->
					id = _.map((_) -> _.student.id).getOrElse(-1)
					http.delete('students', id)
				).then((_) ->
					_.getOrElse(false).success.should.be.true
				).done(-> done())
			)
		)
	)
	describe('Client', ->
		describe('withSession()', ->
			it('should work', (done) ->
				client = new masteryconnect.Client(
					process.env.MASTERYCONNECTJS_HOST,
					process.env.MASTERYCONNECTJS_PORT,
					process.env.MASTERYCONNECTJS_PATH,
					process.env.MASTERYCONNECTJS_OAUTHCONSUMERSECRET,
					process.env.MASTERYCONNECTJS_OAUTHTOKEN,
					process.env.MASTERYCONNECTJS_OAUTHTOKENSECRET
				)
				student = student:
					first_name: 'withsession'
					last_name: 'unittest'
					student_number: random()

				client.withSession((session) ->
					session.postStudent(student)
					.then((_) -> _.fold(((_) -> _.student.id), -1))
					.then((id) -> session.putStudent(id, student: first_name: 'withsessionput'); id)
					.then((id) -> session.deleteStudent(id))
					.done(-> done())
				)
			)
		)
	)
)
