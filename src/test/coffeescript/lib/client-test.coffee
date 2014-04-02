Client = require('./client')
lazy = require('lazy.js')
should = require('should')

random = -> lazy.generate((-> Math.floor(Math.random() * 10))).take(16).toString('')
client = new Client(
	process.env.MASTERYCONNECTJS_BASEURL,
	process.env.MASTERYCONNECTJS_OAUTHCONSUMERKEY
	process.env.MASTERYCONNECTJS_OAUTHCONSUMERSECRET
	process.env.MASTERYCONNECTJS_OAUTHTOKEN
	process.env.MASTERYCONNECTJS_OAUTHTOKENSECRET
)

describe('Client', ->
	describe('withSession()', ->
		it('should work', (done) ->
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
