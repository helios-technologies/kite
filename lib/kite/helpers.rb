module Kite::Helpers

  KITE_ENV_FILEPATH = '.kite_env'

  # Check config/cloud.yml file to be complete
  def check_cloud_config(config)
    raise Kite::Error, 'The config/cloud.yml is not filled out!' unless config.find { |key, hash| hash.find { |k, v| v.nil? } }.nil?
  end

  # Parse config/cloud.yml, returning the output hash
  def parse_cloud_config
    cloud_config = YAML.load(File.read('config/cloud.yml'))
    check_cloud_config(cloud_config)

    cloud_config
  end

  def kite_env
    if ENV['KITE_ENV']
      ENV['KITE_ENV']
    else
      File.read KITE_ENV_FILEPATH
    end
  end
end
