require 'erb'
require 'json'

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

class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def firstdown
    self[0, 1].downcase + self[1, length - 1]
  end

  def firstup
    self[0, 1].upcase + self[1, length - 1]
  end
end

creater = Creater.new
creater.proc
