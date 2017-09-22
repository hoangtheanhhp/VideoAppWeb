OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '291477272712-ddllhda7jkhc34buqsafli23ofpgr63r.apps.googleusercontent.com',
           'BPzqStBYsRADVsXXBjuqEA-1', scope: 'email, profile'
end