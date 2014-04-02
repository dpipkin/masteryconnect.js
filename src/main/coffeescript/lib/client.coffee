bilby = require('bilby')
Http = require('./http')

client = class Client
	constructor: (@baseUrl, @consumerKey, @consumerSecret, @token, @tokenSecret) ->

	withSession: (f) ->
		http = new Http(@baseUrl, @consumerKey, @consumerSecret, @token, @tokenSecret)

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

module.exports = Object.freeze(client)
