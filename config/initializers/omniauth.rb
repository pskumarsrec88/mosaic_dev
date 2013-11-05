Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1779786772159900', 'cb0af250f5a8092e7edb49acb7a131f2', :scope => 'email,read_stream, read_friendlists, publish_actions, publish_stream, user_photos, friends_photos, offline_access'
end