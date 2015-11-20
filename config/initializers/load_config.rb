# http://railscasts.com/episodes/85-yaml-configuration-file
APP_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/config.yml")[::Rails.env].symbolize_keys
