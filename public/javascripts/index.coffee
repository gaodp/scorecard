class LegislativeVote
  constructor: (defaults = {}) ->
    @_id = ko.observable defaults._id
    @caption = ko.observable defaults.caption
    @description = ko.observable defaults.description
    @dateTime = ko.observable defaults.dateTime

class LegislativeSession
  constructor: (defaults = {}) ->
    @_id = ko.observable defaults._id
    @name = ko.observable defaults.name
    @current = ko.observable defaults.current

class LegislativeMember
  constructor: (defaults = {}) ->
    @_id = ko.observable defaults._id
    @type = ko.observable defaults.type
    @firstName = ko.observable defaults.firstName
    @middleName = ko.observable defaults.middleName
    @lastName = ko.observable defaults.lastName
    @party = ko.observable defaults.party
    @district = ko.observable defaults.district
    @city = ko.observable defaults.city
    @photoUri = ko.observable defaults.photoUri

    @fullName = ko.computed =>
      @firstName() + " " + @lastName()

    @tagline = ko.computed =>
      partyAndDistrict = @party() + " - District " + @district()

      if @city()?
        partyAndDistrict += " - " + @city()

      partyAndDistrict

class ScoreCard
  constructor: ->
    @sessions = ko.observableArray []
    @selectedSession = ko.observable undefined

    @members = ko.observableArray []
    @selectedMember = ko.observable undefined

    @selectedSession.subscribe (newSelectedSession) =>
      gaodpRequest 'members', {sessionId: newSelectedSession._id()}, (memberData) =>
        constructedMembers = for member in memberData
          new LegislativeMember(member)

        @members(constructedMembers)

        if constructedMembers[0]?
          @selectedMember(constructedMembers[0])

gaodpRequest = (resource, data, callback) ->
  if typeof data == 'function'
    callback = data
    data = undefined

  urlForResource = 'http://gga.apis.gaodp.org/api/v1/' + resource

  $.ajax
    dataType: 'jsonp'
    data: data
    url: urlForResource
    success: callback

$(document).ready ->
  scorecardModel = new ScoreCard
  window.scorecardModel = scorecardModel
  ko.applyBindings scorecardModel

  gaodpRequest 'sessions', (sessionData) ->
    constructedSessions = for session in sessionData
      new LegislativeSession(session)

    scorecardModel.sessions(constructedSessions)

    if constructedSessions[0]?
      scorecardModel.selectedSession(constructedSessions[0])
