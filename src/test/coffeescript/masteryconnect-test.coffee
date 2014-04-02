masteryconnect = require('./masteryconnect')
should = require('should')

describe('masteryconnect', ->
	describe('Client', -> it('should be exported', -> masteryconnect.hasOwnProperty('Client').should.be.true))
)
