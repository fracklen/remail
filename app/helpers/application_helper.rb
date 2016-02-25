module ApplicationHelper
  def obfuscate_email(email)
    parts = email.split('@')
    parts[0] = parts[0].gsub(/^(.*?)(.{1,4})$/, '\1****')
    parts.join('@')
  end
end
