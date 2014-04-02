Http = require('./http')
lazy = require('lazy.js')
should = require('should')

random = -> lazy.generate((-> Math.floor(Math.random() * 10))).take(16).toString('')
http = new Http(
	process.env.MASTERYCONNECTJS_BASEURL,
	process.env.MASTERYCONNECTJS_OAUTHCONSUMERKEY
	process.env.MASTERYCONNECTJS_OAUTHCONSUMERSECRET
	process.env.MASTERYCONNECTJS_OAUTHTOKEN
	process.env.MASTERYCONNECTJS_OAUTHTOKENSECRET
)

describe('Http', ->
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
	describe('get()', ->
		it('should work without id', (done) ->
			http.get('students')
				.then((_) -> _.getOrElse(null).length.should.be.above(0))
				.done(-> done())
		)
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
	)
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
)
