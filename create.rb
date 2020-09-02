# frozen_string_literal: true

require 'erb'
require 'json'
require './utils/string_extension.rb'

# the code creator with erb template
class Creater
  def read_content_template(json)
    Dir.foreach('./content_template') do |file|
      if file != '.' && file != '..'
        yield json, file
        json['data'] = JSON.parse(File.read('./content_template/' + file))
        create(json)
      end
    end
  end

  def create(json)
    Dir.foreach('./template') do |file|
      if file != '.' && file != '..'
        Dir.mkdir('dist') unless FileTest.exist?('dist')
        fromfile = 'template/' + file
        dirname = File.basename(fromfile, '.erb')
        tofile = create_to_file(json, dirname)
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

  def create_to_file(json, dirname)
    filename = if dirname == 'entity'
                 json['class_name'] + '.java'
               else
                 json['class_name'] + dirname.firstup + '.java'
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
