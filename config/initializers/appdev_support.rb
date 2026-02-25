if Rails.env.development?
  AppdevSupport.config do |config|
    config.action_dispatch = true
    config.active_record   = true
    config.pryrc           = :minimal
  end
  
  AppdevSupport.init
end
