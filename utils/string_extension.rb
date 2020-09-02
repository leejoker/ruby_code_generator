# frozen_string_literal: true

# extension methods for String class
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
