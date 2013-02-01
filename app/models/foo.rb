class Foo < ActiveRecord::Base
  attr_accessible :description, :name, :state

  state_machine :initial => :incomplete do
  	event :activate do 
  		transition :incomplete => :active
  	end
  	event :deactivate do
  		transition :active => :inactive
  	end

  	around_transition do |record, transition, block|
  		RequestStore.store[:current_event] ||= []
  		begin
  			RequestStore.store[:current_event].push(transition.event.to_s)
  			puts "** around_transition / before calling block #{RequestStore.store[:current_event]}"
  			block.call
  			puts "** around_transition / after calling block #{RequestStore.store[:current_event]}"
  		ensure
  			puts "** around_transition / in ensure #{RequestStore.store[:current_event]}"
  			RequestStore.store[:current_event].pop
  		end
  	end
  end

  around_save :create_audit

  def create_audit
  	puts "** create_audit / before yielding #{RequestStore.store[:current_event]}"
  	ret = yield
  	puts "** create_audit / after yielding #{RequestStore.store[:current_event]}"
  	puts " ... would've created the audit log here"
  end

  def current_event
  	(RequestStore.store[:current_event] || []).last
  end
end
