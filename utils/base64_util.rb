# frozen_string_literal: true

require 'base64'

# tools to handle with base64 string
class Base64Util
  def decode_str(base64_str, file_path)
    File.open(file_path, 'r+') do |file|
      File.write(file, Base64.decode64(base64_str))
    end
  end

  def decode_bytes(base64_str, file_path)
    File.open(file_path, 'wb') do |file|
      File.binwrite(file, Base64.decode64(base64_str))
    end
  end
end
