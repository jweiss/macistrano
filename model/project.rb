#
#  project.rb
#  macistrano
#
#  Created by Pom on 25.04.08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'
require 'hpricot'
require 'notification_hub'
require 'host'

class Project
  include NotificationHub
  notify :stage_loaded, :when => :stage_tasks_loaded
  
  attr_accessor :name, :id, :stages, :host, :fully_loaded
  
  def fully_loaded?
    fully_loaded
  end

  def stages_url
    "#{host.url}/projects/#{self.id}/stages.xml"
  end
  
  def fetch_stages
    LoadOperationQueue.queue_request stages_url, self, {:username => host.username, :password => host.password}
  end

  def url_finished(data)
    self.stages = to_stages data
    notify_stages_loaded self
  end
  
  def stage_loaded(notification)
    notify_project_fully_loaded(self) if stages.select{|stage| !stage.fully_loaded?}.empty?
  end
  
  def to_stages response
    stages = []

    doc = Hpricot.XML response
    (doc/'stage').each do |data|
      stage = Stage.new
      stage.id = (data/:id).text
      stage.name = (data/:name).text
      stage.project = self
      stage.fetch_tasks
      stages << stage
    end
    notify_project_fully_loaded(self) if stages.empty?
    stages
  end
end
