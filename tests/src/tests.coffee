test "something", ->
  testRegex = VerEx().something()
  testString = undefined
  testString = ""
  ok not testRegex.test(testString), "empty string doesn't have something"
  testRegex.lastIndex = 0
  testString = "a"
  ok testRegex.test(testString), "a is something"

test "anything", ->
  testRegex = VerEx().startOfLine().anything()
  testString = "what"
  ok testRegex.test(testString), "Passes!"

test "anythingBut", ->
  testRegex = VerEx().startOfLine().anythingBut("w")
  testString = "what"
  ok testRegex.test(testString), "starts with w"

test "somethingBut", ->
  testRegex = VerEx().somethingBut("a")
  testString = undefined
  testString = ""
  ok not testRegex.test(testString), "empty string doesn't have something"
  testRegex.lastIndex = 0
  testString = "b"
  ok testRegex.test(testString), "doesn't start with a"
  testRegex.lastIndex = 0
  testString = "a"
  ok not testRegex.test(testString), "starts with a"

test "startOfLine", ->
  testRegex = VerEx().startOfLine().then("a")
  testString = undefined
  testString = "a"
  ok testRegex.test(testString), "Starts with a"
  testRegex.lastIndex = 0
  testString = "ba"
  ok not testRegex.test(testString), "Doesn't start with a"

test "endOfLine", ->
  testRegex = VerEx().find("a").endOfLine()
  testString = undefined
  testString = "a"
  ok testRegex.test(testString), "Ends with a"
  testRegex.lastIndex = 0
  testString = "ab"
  ok not testRegex.test(testString), "Doesn't end with a"

test "maybe", ->
  testRegex = VerEx().startOfLine().then("a").maybe("b")
  testString = undefined
  testString = "acb"
  ok testRegex.test(testString), "Maybe has a b after an a"
  testRegex.lastIndex = 0
  testString = "abc"
  ok testRegex.test(testString), "Maybe has a b after an a"

test "anyOf", ->
  testRegex = VerEx().startOfLine().then("a").anyOf("xyz")
  testString = undefined
  testString = "ay"
  ok testRegex.test(testString), "Has an x, y, or z after a"
  testRegex.lastIndex = 0
  testString = "abc"
  ok not testRegex.test(testString), "Doesn't have an x, y, or z after a"

test "or", ->
  testRegex = VerEx().startOfLine().then("abc").or("def")
  testString = undefined
  testString = "defzzz"
  ok testRegex.test(testString), "Starts with abc or def"
  testRegex.lastIndex = 0
  testString = "xyzabc"
  ok not testRegex.test(testString), "Doesn't start with abc or def"

test "lineBreak", ->
  testRegex = undefined
  testString = undefined
  testRegex = VerEx().startOfLine().then("abc").lineBreak().then("def")
  testString = "abc\r\ndef"
  ok testRegex.test(testString), "abc then line break then def"
  testRegex.lastIndex = 0
  testString = "abc\ndef"
  ok testRegex.test(testString), "abc then line break then def"
  testRegex.lastIndex = 0
  testString = "abc\r\n def"
  ok not testRegex.test(testString), "abc then line break then space then def"

test "br", ->
  testRegex = undefined
  testString = undefined
  testRegex = VerEx().startOfLine().then("abc").lineBreak().then("def")
  testString = "abc\r\ndef"
  ok testRegex.test(testString), "abc then line break then def"
  testRegex.lastIndex = 0
  testString = "abc\ndef"
  ok testRegex.test(testString), "abc then line break then def"
  testRegex.lastIndex = 0
  testString = "abc\r\n def"
  ok not testRegex.test(testString), "abc then line break then space then def"

test "tab", ->
  testRegex = undefined
  testString = undefined
  testRegex = VerEx().startOfLine().tab().then("abc")
  testString = "\tabc"
  ok testRegex.test(testString), "tab then abc"
  testRegex.lastIndex = 0
  testString = "abc"
  ok not testRegex.test(testString), "no tab then abc"

test "withAnyCase", ->
  testRegex = undefined
  testString = undefined
  testRegex = VerEx().startOfLine().then("a")
  testString = "A"
  ok not testRegex.test(testString), "not case insensitive"
  testRegex = VerEx().startOfLine().then("a").withAnyCase()
  testString = "A"
  ok testRegex.test(testString), "case insensitive"
  testRegex.lastIndex = 0
  testString = "a"
  ok testRegex.test(testString), "case insensitive"

test "searchOneLine", ->
  testRegex = undefined
  testString = undefined
  testRegex = VerEx().startOfLine().then("a").br().then("b").endOfLine()
  testString = "a\nb"
  ok testRegex.test(testString), "b is on the second line"
  testRegex = VerEx().startOfLine().then("a").br().then("b").endOfLine().searchOneLine()
  testString = "a\nb"
  ok testRegex.test(testString), "b is on the second line but we are only searching the first"
