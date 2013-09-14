# For more information see: http://emberjs.com/guides/routing/

SfuncubeHackathon.Router.map ()->
  @resource 'referral', ->
    @route 'new'
SfuncubeHackathon.ReferralRoute = Ember.Route.extend
  activate: ->
    debugger

SfuncubeHackathon.IndexRoute = Ember.Route.extend
  activate: ->
    debugger
  actions:
    lumparound: ->
      debugger

