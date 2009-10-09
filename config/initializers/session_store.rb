# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ext_js_session',
  :secret      => 'eeb0195f1b2f8ff12fddee37dcddc3e5611eb213f6337c01a1add481f2bc87025c05830bcf63992d839b09d283b868b7e98bc12324e799bcb9cd529ec32d23b8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
