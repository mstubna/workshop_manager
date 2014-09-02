
module.exports = ->

  # display exception stack trace
  @option 'stack', true

  # load the deployment credentials
  @deploy_config = @file.readJSON './secrets/aws_credentials.json'

  # grunt configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    exec:
      preview:
        command: 'node app'

    aws_s3:
      options:
        accessKeyId:      @deploy_config.key_id
        secretAccessKey:  @deploy_config.secret
        region:           @deploy_config.bucket_region_name
        bucket:           @deploy_config.bucket_name
        differential:     true
      production:
        files: [
          { expand: true, cwd: 'build/', src: ['**'], dest: '' },
          { dest: '/', cwd: 'build/', action: 'delete' },
        ]

    watch:
      coffeescripts:
        files: ['source/coffeescripts/**']
        tasks: 'coffee'
      stylesheets:
        files: ['source/stylesheets/**']
        tasks: 'sass'
      markdown:
        files: ['source/content/**', 'source/templates/**']
        tasks: 'markdown'
      assets:
        files: ['source/images/**', 'source/vendor/**', 'source/fonts/**', 'source/views/**']
        tasks: 'copy:assets'

    # convert coffeescript -> js
    coffee:
      options:
        join: true
      project:
        files: ['build/javascripts/workshop_manager.js': 'source/coffeescripts/workshop_manager/*.coffee',
                'build/javascripts/main.js': 'source/coffeescripts/*.coffee']

    # convert scss -> css
    sass:
      project:
        options:
          noCache: true
        files: [
          expand: true
          cwd: 'source/stylesheets'
          src: ['*.scss']
          dest: 'build/stylesheets'
          ext: '.css'
        ]

    copy:
      # copy assets to build folder
      assets:
        files: [
          { expand: true, cwd: 'source/images/', src: ['**'], dest: 'build/images/' }
          { expand: true, cwd: 'source/vendor/', src: ['**'], dest: 'build/vendor/' }
          { expand: true, cwd: 'source/fonts/', src: ['**'], dest: 'build/fonts/' }
          { expand: true, cwd: 'source/views/', src: ['**'], dest: 'build/' }
        ]

  # load npm tasks
  @loadNpmTasks 'grunt-exec'
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-sass'
  @loadNpmTasks 'grunt-markdown'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-contrib-copy'
  @loadNpmTasks 'grunt-aws-s3'

  # custom tasks

  @task.registerTask 'preview', =>
    @task.run 'exec:preview'

  @task.registerTask 'build', =>
    @file.delete 'build'
    @file.mkdir 'build'
    @task.run ['coffee', 'sass', 'copy']

  @task.registerTask 'build_watch', =>
    @task.run ['build', 'watch']

  @task.registerTask 'deploy', (env) =>
    @task.run "aws_s3:production"
