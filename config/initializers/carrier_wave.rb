if Rails.env.production? 
    CarrierWave.configure do |config|
        config.fog_credentials = {
            # Configuration for Amazon S3
            :provider => 'AWS', 
            :aws_access_key_id => ENV['AKIA6OHDO3NOAXF5V5XR'], 
            :aws_secret_access_key => ENV['P5wpOQOiL+M+dGy8aTHgAx+2C/pHKvkWOUDvsvN1']
        }
        config.fog_directory = ENV['sampleapp-1981']
    end
end