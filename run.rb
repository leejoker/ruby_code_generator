# frozen_string_literal: true

require './create.rb'

creater = Creater.new
str = IO.read('config.json')
config = JSON.parse(str)
puts config
creater.read_content_template(config) do |json, file|
  filename = File.basename(file, '.json')
  json['table_name'] = json['table_prefix'] + filename.underscore
  json['class_name'] = json['class_prefix'] + filename.firstup
  json['module_name'] = filename.downcase
end
