(->
  VerbalExpression = (args...) ->
    verbalExpression = Object.create(RegExp::)
    verbalExpression = (RegExp.apply(verbalExpression, args) or verbalExpression)
    VerbalExpression.injectClassMethods verbalExpression
    verbalExpression
  createVerbalExpression = ->
    new VerbalExpression()
  root = this
  VerbalExpression.injectClassMethods = (verbalExpression) ->
    for method of VerbalExpression::
      verbalExpression[method] = VerbalExpression::[method]  if VerbalExpression::hasOwnProperty(method)
    verbalExpression

  VerbalExpression:: =
    _prefixes: ""
    _source: ""
    _suffixes: ""
    _modifiers: "gm"
    sanitize: (value) ->
      return value.source if value.source
      value.replace /[^\w]/g, (character) ->
        "\\" + character


    add: (value) ->
      @_source += value or ""
      @compile @_prefixes + @_source + @_suffixes, @_modifiers
      this

    startOfLine: (enable=true) ->
      @_prefixes = if enable isnt false then "^" else ""
      @add ""
      this

    endOfLine: (enable=true) ->
      @_suffixes = if enable isnt false then "$" else ""
      @add ""
      this

    then: (value) ->
      @add "(?:#{@sanitize(value)})"
      this

    find: (value) ->
      @then value

    maybe: (value) ->
      @add "(?:#{@sanitize(value)})?"
      this

    anything: ->
      @add "(?:.*)"
      this

    anythingBut: (value) ->
      @add "(?:[^#{@sanitize(value)}]*)"
      this

    something: ->
      @add "(?:.+)"
      this

    somethingBut: (value) ->
      @add "(?:[^#{@sanitize(value)}]+)"
      this

    replace: (source, value) ->
      source = source.toString()
      source.replace this, value

    lineBreak: ->
      @add "(?:(?:\\n)|(?:\\r\\n))"
      this

    br: ->
      @lineBreak()

    tab: ->
      @add "\\t"
      this

    word: ->
      @add "\\w+"
      this

    anyOf: (value) ->
      @add "[#{@sanitize(value)}]"
      this

    any: (value) ->
      @anyOf value

    range: (args...) ->
      @add "[" + ([args[i-1] + '-' + args[i] for i in args.length when i % 2].join ' ') + "]"
      this

    addModifier: (modifier) ->
      @_modifiers += modifier if @_modifiers.indexOf(modifier) is -1
      @add ""
      this

    removeModifier: (modifier) ->
      @_modifiers = @_modifiers.replace(modifier, "")
      @add ""
      this

    withAnyCase: (enable) ->
      unless enable is false
        @addModifier "i"
      else
        @removeModifier "i"
      @add ""
      this

    stopAtFirst: (enable) ->
      unless enable is false
        @removeModifier "g"
      else
        @addModifier "g"
      @add ""
      this

    searchOneLine: (enable) ->
      if enable isnt false then @removeModifier "m" else @addModifier "m"
      @add ""
      this

    multiple: (value) ->
      value = (if value.source then value.source else @sanitize(value))
      value += "+" if not (value.substr(-1) in '*+')
      @add value
      this

    or: (value) ->
      @_prefixes += "(?:"
      @_suffixes = ")" + @_suffixes
      @add ")|(?:"
      @then value  if value
      this

    beginCapture: ->
      @_suffixes += ")"
      @add "(", false
      this

    endCapture: ->
      @_suffixes = @_suffixes.substring(0, @_suffixes.length - 1)
      @add ")", true
      this

  if typeof module isnt "undefined" and module.exports
    module.exports = createVerbalExpression
  else if typeof define is "function" and define.amd
    define VerbalExpression
  else
    root.VerEx = createVerbalExpression
).call()