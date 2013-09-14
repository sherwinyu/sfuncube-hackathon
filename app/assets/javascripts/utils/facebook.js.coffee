class Friend extends Ember.Object
  name: ""
  data: ""
  ###
      user:
        name: friendPayload.name
        email: friendPayload.email
        info:
          uid: friendPayload.id
          name: friendPayload.name
          email: friendPayload.email
          provider: "FACEBOOK"
          other_info: friendPayload
  ###
  pictureUrl: ""

  constructor: (friendPayload) ->
    @data = friendPayload
    @name = friendPayload?.name
    @pictureUrl = friendPayload?.picture?.data?.url
    @location = friendPayload?.location?.name

  # param term string -- the search term
  # returns integer rank
  scoreAgainstTerm: (term)->
    terms = term.trim().split(/\s+/)
    # regexs is an array of regular expressions matching for the beginning of
    regexs = (new RegExp "\\b#{term}", "i" for term in terms)
    # check to see how many of the regexs match
    filtered = regexs.filter (regex) => regex.test @name
    # return that as the score
    filtered.length
    @set 'score', filtered.length
    filtered.length

SfuncubeHackathon.FriendFilter = Ember.Object.extend
  # filterAndRankAgainst -- public entry point for friendFilter
  # Behavior:
  #   1) it calls _filterAndRank with the friendSource and the curried scoring function
  # Context:
  #   Currently, is called by SelectRecipientView in the `source` autocomplete function.
  #
  # param term: a string indicating what to search against
  # returns: a promise of a list of friends
  filterAndRankAgainst: (term) ->
    @_filterAndRank( @facebookFriends(), term)

  # Returns a promise of an array of friends
  _filterAndRank: (pfriends, term) ->
    pfriends.then (friends) =>
      # friends is an array of Friend
      friends = friends.sort (a, b) ->
        b.scoreAgainstTerm(term) - a.scoreAgainstTerm(term)
      friends.slice(0, 6)

  facebookFriends: ->
    @_friends ||= facebook.query("/me/friends?fields=name,picture,location").then (friendPayloads) =>
      derp = friendPayloads.data.map (friendPayload) =>
        new Friend(friendPayload)


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
      dfd.resolve(response)
    dfd.promise()

window.fbAsyncInit = ->
  FB.init
    appId: "585881908138577"
    status: true
    cookie: true
    oauth: true

  FB.getLoginStatus (response)-> console.log "FB login status " , response
