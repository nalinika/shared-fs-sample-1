on_app_servers_and_utilities do
  run! "ln -snf #{config.shared_path}/config/master.key #{config.release_path}/config/master.key"
end
