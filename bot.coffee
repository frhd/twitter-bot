twit    = require 'twit'
config  = require './config.js'
request = require 'request'

ONE_SECOND = 1000
ONE_MINUTE = 60 * ONE_SECOND

DEFAULT_OPTIONS = 
  "queryList" : ["virtualreality", "#vr", "#oculus", "#vive", "revrsed", "psvr"]
  "frequencyInMinutes" : 5

rand = (arr) ->
  index = Math.floor(Math.random()*arr.length)
  return arr[index]

Twitter = new twit config

queryList = DEFAULT_OPTIONS.queryList

retweet = () ->
  params =
    q: rand queryList
    result_type: 'mixed'
    lang: 'en'

  Twitter.get 'search/tweets', params, (err, data) ->
    tweet = data.statuses
    randomTweet = rand tweet

    if !err?
      retweetId = randomTweet.id_str
      Twitter.post 'statuses/retweet/:id',
        id: retweetId
        (err, response) ->
          if response? && !err?
            console.log 'Retweeted!'
          if err?
            console.log 'Something went wrong while Retweeting.'
            console.log err.message
    else
      console.log 'Something went wrong while Searching.'
      console.log err

favoriteTweet = () ->
  params =
    q: rand queryList
    result_type: 'mixed'
    lang: 'en'

  Twitter.get 'search/tweets', params, (err, data) ->
    tweet = data.statuses
    randomTweet = rand tweet

    if typeof randomTweet != 'undefined'
      Twitter.post 'favorites/create', {id: randomTweet.id_str}, (err, response) ->
        if err?
          console.log 'Something went wrong on Favorite Tweet.'
          console.log err.message
        else
          console.log 'Favorite OK.'

setCustomTimeout = (callback, time) ->
  internalCallback = ( (seconds) -> 
    return () ->

      if time?
        interval = time
      else 
        if !config.frequencyInMinutes?
          config.frequencyInMinutes = DEFAULT_OPTIONS.frequencyInMinutes
        interval = config.frequencyInMinutes * ONE_MINUTE * ONE_SECOND
      
      setTimeout internalCallback, interval
      callback()

      return
  )()

  setTimeout internalCallback, config.frequencyInMinutes
  return

#---------------------
options = 
  url: 'https://raw.githubusercontent.com/revrsed/bot/master/query.json'
  headers: {'Cache-Control':'no-cache'}

getAndSetConfig = () ->
  request.get options, (err, resp, body) ->
    try
      console.log 'getting new config'
      config = (JSON.parse body)  
      console.log config
    catch err
      console.log 'config sucks, using fallback'
      config = DEFAULT_OPTIONS

    return

config = {}

setCustomTimeout getAndSetConfig, 5 * ONE_MINUTE, 0

#retweet()
#favoriteTweet()

setCustomTimeout retweet
setCustomTimeout favoriteTweet

