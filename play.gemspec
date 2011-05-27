## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'play'
  s.version           = '0.0.5'
  s.date              = '2011-05-27'
  s.rubyforge_project = 'play'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "Your company's dj. ►" 
  s.description = "We want to play music at our office. Everyone has their own
  library on their own machines, and everyone except for me plays shitty music.
  Play is designed to make office music more palatable."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Zach Holman"]
  s.email    = 'github.com@zachholman.com'
  s.homepage = 'https://github.com/holman/play'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## If your gem includes any executables, list them here.
  s.executables = ["play"]
  s.default_executable = 'play'

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  #s.rdoc_options = ["--charset=UTF-8"]
  #s.extra_rdoc_files = %w[README LICENSE]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('rack', ["~>1.2.2"])
  s.add_dependency('sinatra')
  s.add_dependency('activerecord')
  s.add_dependency('sqlite3')
  s.add_dependency('mustache')
  s.add_dependency('SystemTimer')
  s.add_dependency('ruby-audioinfo')
  s.add_dependency('oa-oauth')
  s.add_dependency('yajl-ruby')
  s.add_dependency('mysql2')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('running_man')
  s.add_development_dependency('mocha')

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    README.md
    Rakefile
    bin/play
    config.ru
    db/migrate/01_create_schema.rb
    lib/play.rb
    lib/play/album.rb
    lib/play/app.rb
    lib/play/app/api.rb
    lib/play/artist.rb
    lib/play/client.rb
    lib/play/core_ext/hash.rb
    lib/play/history.rb
    lib/play/library.rb
    lib/play/office.rb
    lib/play/song.rb
    lib/play/templates/album_songs.mustache
    lib/play/templates/artist_songs.mustache
    lib/play/templates/index.mustache
    lib/play/templates/layout.mustache
    lib/play/templates/now_playing.mustache
    lib/play/templates/play_history.mustache
    lib/play/templates/profile.mustache
    lib/play/templates/search.mustache
    lib/play/templates/show_song.mustache
    lib/play/templates/song.mustache
    lib/play/user.rb
    lib/play/views/album_songs.rb
    lib/play/views/artist_songs.rb
    lib/play/views/index.rb
    lib/play/views/layout.rb
    lib/play/views/now_playing.rb
    lib/play/views/play_history.rb
    lib/play/views/profile.rb
    lib/play/views/search.rb
    lib/play/views/show_song.rb
    lib/play/vote.rb
    play.gemspec
    play.yml.example
    public/css/base.css
    test/helper.rb
    test/spec/mini.rb
    test/test_album.rb
    test/test_api.rb
    test/test_app.rb
    test/test_artist.rb
    test/test_client.rb
    test/test_library.rb
    test/test_office.rb
    test/test_play.rb
    test/test_song.rb
    test/test_user.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
