module.exports = (grunt)->
  # project configuration
  grunt.initConfig
    # load package information
    pkg: grunt.file.readJSON 'package.json'

    coffeelint:
      options:
        indentation:
          value: 2
          level: "error"
        no_trailing_semicolons:
          level: "error"
        no_trailing_whitespace:
          level: "error"
        max_line_length:
          level: "ignore"
      default: ["Gruntfile.coffee", "src/**/*.coffee"]

    clean:
      default: "assets/js"
      leap: "assets/plugin/leap"

    coffee:
      default:
        src: "src/coffee/main.coffee"
        dest: "assets/js/main.js"
      leap:
        src: "src/coffee/leap.coffee"
        dest: "assets/plugin/leap/leap.js"

    # watching for changes
    watch:
      default:
        files: ["src/coffee/*.coffee"]
        tasks: ["clean", "coffeelint", "coffee"]
        options:
          livereload: true

    connect:
      default:
        options:
          port: 3000
          base: ""

    open:
      default:
        path: "http://localhost:<%= connect.default.options.port %>"

  # load plugins that provide the tasks defined in the config
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-open"

  # register tasks
  grunt.registerTask "run", ["connect", "open", "build", "watch"]
  grunt.registerTask "build", ["clean", "coffeelint", "coffee"]
  grunt.registerTask "default", ["build", "watch"]
