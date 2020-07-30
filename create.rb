require 'erb'
require 'json'
require './string_extension.rb'

class Creater
  def proc
    str = IO.read('config.json')
    config = JSON.parse(str)
    puts config
    create(config)
  end

  def create(_json)
    Dir.foreach('./template') do |file|
      if file != '.' && file != '..'
        Dir.mkdir('dist') unless FileTest.exist?('dist')
        fromfile = 'template/' + file
        dirname = File.basename(fromfile, '.erb')

        todir = if dirname == 'serviceImpl'
                  'dist/service/impl'
                else
                  "dist/#{dirname}"
                end
        Dir.mkdir(todir) unless FileTest.exist?(todir)

        data = _json
        filename = if dirname == 'entity'
                     data['class_name'] + '.java'
                   else
                     data['class_name'] + dirname.firstup + '.java'
                   end
        tofile = File.new(todir + '/' + filename, 'w')

        File.open(fromfile) do |fh|
          e = ERB.new(fh.read)
          tofile.print e.result(binding)
        end
        tofile.close
      end
    end
  end
end
