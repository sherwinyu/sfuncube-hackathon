SfuncubeHackathon.FriendFilter = Ember.Object.extend()

jQuery ->
   $('body').prepend('<div id="fb-root"></div>')
   $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: 'true'

window.facebook =
  scope: 'email, user_education_history, user_interests, user_likes, user_activities, friends_status, user_status, friends_about_me, friends_activities, friends_education_history, friends_interests, friends_location, friends_religion_politics'
  unwrap: (dfd) ->
    x = null
    dfd.always( (result) -> x = result)
    x

  login: ->
    dfd = new $.Deferred()
    FB.login ((response) ->
      if response.authResponse
        debugger
        console.log "User did auth"
        dfd.resolve(response)
      else
        console.log "User didn't auth.."
        dfd.reject(response)
    ), scope: facebook.scope
    dfd.promise()

  status: ->
    FB.getLoginStatus (response) ->
      console.log "status: ", response

  query: (query) ->
    dfd = new $.Deferred()
    FB.api query, (response) ->
      debugger
      dfd.resolve(response)
    dfd.promise()

window.fbAsyncInit = ->
  FB.init
    appId: "585881908138577"
    status: true
    cookie: true
    oauth: true

  FB.getLoginStatus (response)-> console.log "FB login status " , response
