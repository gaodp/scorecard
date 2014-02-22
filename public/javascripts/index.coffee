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

class LegislativeVote
  constructor: (defaults = {}) ->
    @_id = ko.observable defaults._id
    @caption = ko.observable defaults.caption
    @description = ko.observable defaults.description

class ScoreCard
  @sessions = ko.observableArray []
  @members = ko.observableArray []

  @selectedSession = ko.observable undefined
  @selectedMember = ko.observable undefined
