require_relative 'spec_helper'

describe "hipsnip-jetty::default" do
	chef_run = ChefSpec::ChefRunner.new.converge 'hipsnip-jetty::default'
	node = chef_run.node
	it "should include the java::default recipe" do
		expect(chef_run).to include_recipe 'hipsnip-jetty::default'
	end
	it "should create the folders necessary for jetty" do
		[node['jetty']['home'], node['jetty']['base']].each do |path|
			expect(chef_run).to create_directory path
			directory = chef_run.directory(path)
			expect(directory).to be_owned_by(node['jetty']['user'], node['jetty']['group'])
		end
	end
	it "should download jetty" do
		expect(chef_run).to create_remote_file(node['jetty']['download']).with(
			:source  => node['jetty']['link'],
  			:checksum => node['jetty']['checksum']
		)
	end
	it "should execute ruby block 'Extract Jetty'" do
		expect(chef_run).to execute_ruby_block 'Extract Jetty'
	end
	it "should execute ruby block 'Copy Jetty files to jetty home'" do
		expect(chef_run).to execute_ruby_block 'Copy Jetty files to jetty home'
	end
	it "should execute ruby block 'Create new jetty base'" do
		expect(chef_run).to execute_ruby_block 'Create new jetty base'
	end

	it "should create the file /etc/default/jetty" do
		path = '/etc/default/jetty';
		expect(chef_run).to create_file path
		file = chef_run.file(path)
		#expect(file).to be_owned_by(node['jetty']['user'], node['jetty']['group'])
	end
	it "should create the file /etc/jetty/jetty.conf" do
		path = '/etc/jetty/jetty.conf';
		expect(chef_run).to create_file path
		file = chef_run.file(path)
	end
	it "should create file 'start.ini'" do
		expect(chef_run).to create_cookbook_file "#{node['jetty']['home']}/start.ini"
	end
	it "should create logs folder" do
		path = !node['jetty']['logs'].empty? ? node['jetty']['logs'] :  "#{node['jetty']['home']}/logs"
		expect(chef_run).to create_directory path
		directory = chef_run.directory(path)
		expect(directory).to be_owned_by(node['jetty']['user'], node['jetty']['group'])
	end
	it "should create the file '#{node['jetty']['home']}/resources/jetty-logging.properties'" do
		path = "#{node['jetty']['home']}/resources/jetty-logging.properties"
		expect(chef_run).to create_file path
		file = chef_run.file(path)
		#expect(file).to be_owned_by(node['jetty']['user'], node['jetty']['group'])
	end
	it "should set to start on boot time" do
		expect(chef_run).to set_service_to_start_on_boot 'jetty'
	end
end
