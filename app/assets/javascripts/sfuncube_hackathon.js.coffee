#= require ./store
#= require_tree ./utils
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self

SfuncubeHackathon.register('friendFilter:main', SfuncubeHackathon.FriendFilter)
SfuncubeHackathon.inject('view:selectRecipient', 'friendFilter', 'friendFilter:main') #SfuncubeHackathon.FriendFilter)
