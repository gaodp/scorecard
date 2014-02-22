class LegislativeVote
  constructor: (defaults = {}, retrievalCallback) ->
    @_id = ko.observable defaults._id
    @caption = ko.observable defaults.caption
    @description = ko.observable defaults.description
    @dateTime = ko.observable defaults.dateTime

    unless @caption()?
      gaodpRequest "vote/#{@_id()}", (voteData) =>
        @caption = voteData.caption
        @description = voteData.description
        @dateTime = voteData.dateTime

        if retrievalCallback?
          retrievalCallback(this)

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
    @yea = ko.observableArray defaults.yea
    @nay = ko.observableArray defaults.nay

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

    @membersById = {}
    @votesById = {}

    @selectedSession.subscribe (newSelectedSession) =>
      gaodpRequest 'members', {sessionId: newSelectedSession._id()}, (memberData) =>
        constructedMembers = for member in memberData
          newMember = new LegislativeMember(member)
          @membersById[memberData._id] = newMember

          newMember

        @members(constructedMembers)

        if constructedMembers[0]?
          @selectedMember(constructedMembers[0])

    @selectedMember.subscribe (newSelectedMember) =>
      gaodpRequest "member/#{newSelectedMember._id()}/votes", (memberVoteData) =>
        for voteKind in ["yea", "nay"]
          newSelectedMember[voteKind]([])

          for voteId in memberVoteData[voteKind]
            if @votesById[voteId]?
              newSelectedMember[voteKind].push @votesById[voteId]
            else
              newVote = new LegislativeVote {_id: voteId}, (builtVote) ->
                newSelectedMember[voteKind].push builtVote
              @votesById[voteId] = newVote

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
