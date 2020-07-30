# frozen_string_literal: true

require 'erb'
require 'json'
require './string_extension.rb'

# the code creator with erb template
class Creater
  def proc
    str = IO.read('config.json')
    config = JSON.parse(str)
    puts config
    create(config)
  end

  def create(json)
    Dir.foreach('./template') do |file|
      if file != '.' && file != '..'
        Dir.mkdir('dist') unless FileTest.exist?('dist')
        fromfile = 'template/' + file
        dirname = File.basename(fromfile, '.erb')
        tofile = create_to_file(dirname)
        create_from_erb(json, fromfile, tofile)
        tofile.close
      end
    end
  end

  def create_to_dir(dirname)
    todir = if dirname == 'serviceImpl'
              'dist/service/impl'
            else
              "dist/#{dirname}"
            end
    Dir.mkdir(todir) unless FileTest.exist?(todir)
    todir
  end

  def create_to_file(dirname)
    filename = if dirname == 'entity'
                 data['class_name'] + '.java'
               else
                 data['class_name'] + dirname.firstup + '.java'
               end
    File.new(create_to_dir(dirname) + '/' + filename, 'w')
  end

  def create_from_erb(json, fromfile, tofile)
    data = json
    File.open(fromfile) do |fh|
      e = ERB.new(fh.read)
      tofile.print e.result(binding)
    end
  end
end
