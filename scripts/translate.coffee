# Description:
#   Simple Translation tool using Google API.
#
# Commands:
#   hubot e2j <phrase> - Translates <phrase> from English into Japanese.
#   hubot j2e <phrase> - Translates <phrase> from Japanese into English.
#   hubot j2c <phrase> - Translates <phrase> from Japanese into Chinese.
#   hubot c2j <phrase> - Translates <phrase> from Chinese into Japanese.
#   hubot e2c <phrase> - Translates <phrase> from English into Chinese.
#   hubot c2e <phrase> - Translates <phrase> from Chinese into English.

languages =
  "af": "Afrikaans",
  "sq": "Albanian",
  "ar": "Arabic",
  "az": "Azerbaijani",
  "eu": "Basque",
  "bn": "Bengali",
  "be": "Belarusian",
  "bg": "Bulgarian",
  "ca": "Catalan",
  "zh-CN": "Simplified Chinese",
  "zh-TW": "Traditional Chinese",
  "hr": "Croatian",
  "cs": "Czech",
  "da": "Danish",
  "nl": "Dutch",
  "en": "English",
  "eo": "Esperanto",
  "et": "Estonian",
  "tl": "Filipino",
  "fi": "Finnish",
  "fr": "French",
  "gl": "Galician",
  "ka": "Georgian",
  "de": "German",
  "el": "Greek",
  "gu": "Gujarati",
  "ht": "Haitian Creole",
  "iw": "Hebrew",
  "hi": "Hindi",
  "hu": "Hungarian",
  "is": "Icelandic",
  "id": "Indonesian",
  "ga": "Irish",
  "it": "Italian",
  "ja": "Japanese",
  "kn": "Kannada",
  "ko": "Korean",
  "la": "Latin",
  "lv": "Latvian",
  "lt": "Lithuanian",
  "mk": "Macedonian",
  "ms": "Malay",
  "mt": "Maltese",
  "no": "Norwegian",
  "fa": "Persian",
  "pl": "Polish",
  "pt": "Portuguese",
  "ro": "Romanian",
  "ru": "Russian",
  "sr": "Serbian",
  "sk": "Slovak",
  "sl": "Slovenian",
  "es": "Spanish",
  "sw": "Swahili",
  "sv": "Swedish",
  "ta": "Tamil",
  "te": "Telugu",
  "th": "Thai",
  "tr": "Turkish",
  "uk": "Ukrainian",
  "ur": "Urdu",
  "vi": "Vietnamese",
  "cy": "Welsh",
  "yi": "Yiddish"


module.exports = (robot) ->
    # english <-> japanese    
    robot.respond /e2j (.*)/, (msg) ->
        translate msg, "en", "ja"

    robot.respond /j2e (.*)/, (msg) ->
        translate msg, "ja", "en"

    # chinese <-> japanese
    robot.respond /c2j (.*)/, (msg) ->
        translate msg, "zh-CN", "ja"

    robot.respond /j2c (.*)/, (msg) ->
        translate msg, "ja", "zh-CN"

    # chinese <-> english
    robot.respond /c2e (.*)/, (msg) ->
        translate msg, "zh-CN", "en"

    robot.respond /e2c (.*)/, (msg) ->
        translate msg, "en", "zh-CN"

translate = (msg, fromLang, toLang) ->
    phrase = msg.match[1]
    msg.http("https://translate.google.com/translate_a/single")
      .query({
        client: 't'
        hl: 'en'
        sl: fromLang
        ssel: 0
        tl: toLang
        tsel: 0
        q: phrase
        ie: 'UTF-8'
        oe: 'UTF-8'
        otf: 1
        dt: ['bd', 'ex', 'ld', 'md', 'qca', 'rw', 'rm', 'ss', 't', 'at']
      })
      .header('User-Agent', 'Mozilla/5.0')
      .get() (err, res, body) ->
        if err
          msg.send "Failed to connect to GAPI"
          robot.emit 'error', err, res
          return

        try
          if body.length > 4 and body[0] == '['
            parsed = eval(body)
            language = languages[parsed[2]]
            parsed = parsed[0] and parsed[0][0] and parsed[0][0][0]
            parsed and= parsed.trim()
            if parsed
              if toLang is undefined
                msg.send "#{phrase} is #{language} for #{parsed}"
              else
                # msg.send "The #{language} #{phrase} translates as #{parsed} in #{languages[toLang]}"
                # msg.send "#{phrase}(#{language}) <=> #{parsed}(#{languages[toLang]})"
                msg.reply "#{parsed}"
          else
            throw new SyntaxError 'Invalid JS code'

        catch err
          msg.send "Failed to parse GAPI response"
          robot.emit 'error', err
