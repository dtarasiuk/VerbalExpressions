module.exports = (grunt) ->
  grunt.initConfig 
    qunit:
      files: ["tests/index.html"]
    coffee: 
      compile:
        options:
          bare: true
        files:
          "bin/VerbalExpressions.js": "src/VerbalExpressions.coffee",
          "tests/bin/tests.js": "tests/src/tests.coffee"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-qunit"

  grunt.registerTask "build", "coffee"
  grunt.registerTask "default", "build"
  grunt.registerTask "test", ["build", "qunit"]
