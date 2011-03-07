#
# RVM
#
rvm_lib_path = "#{`echo $rvm_path`.strip}/lib"
$LOAD_PATH.unshift(rvm_lib_path) unless $LOAD_PATH.include?(rvm_lib_path)
require 'rvm'

run "rvm 1.9.2"
run "rvm gemset create #{app_name}"
create_file ".rvmrc" do
  "rvm 1.9.2@#{app_name}\n"
end
run "rvm rvmrc trust"
RVM.gemset_use! app_name

#
# Gems
#
gem "formtastic"
gem "jquery-rails"

gem "autotest", :group => [:development, :test]
gem "autotest-growl", :group => [:development, :test]
gem "capybara", :group => [:development, :test]
gem "cucumber-rails", :group => [:development, :test]
gem "factory_girl_rails", :group => [:development, :test]
gem "rspec-rails", :group => [:development, :test]
gem "thin", :group => [:development, :test]
gem "webrat", :group => [:development, :test]

run 'bundle install'

#
# Cleanup
#
remove_file "public/index.html"
remove_file "public/images/rails.png"
remove_dir  "test"

#
# Formatastic
#
generate 'formtastic:install'

#
# RSpec / Cucumber
#
generate 'rspec:install'
generate 'cucumber:install --capybara --rspec'

# http://groups.google.com/group/cukes/msg/58e701bc138c5a9b
gsub_file 'features/support/env.rb', "require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript'", ""

#
# jQuery
#
remove_file "public/javascripts/rails.js"
generate 'jquery:install --ui'
gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

#
# Database
#
rake "db:migrate"
