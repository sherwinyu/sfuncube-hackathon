# For more information see: http://emberjs.com/guides/routing/

SfuncubeHackathon.Router.map ()->
  @resource 'referral', ->
    @route 'new'
SfuncubeHackathon.ReferralRoute = Ember.Route.extend
  activate: ->
    debugger

SfuncubeHackathon.IndexRoute = Ember.Route.extend
  activate: ->

  actions:
    login: ->
      facebook.login()

    postToTimeline: ->
      opts =
        friendIds: @get('selectedFriends').map( (friend) -> friend.data.id)
      facebook.solarStory(opts)
