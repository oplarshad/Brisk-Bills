class Employee::Slimtimer < ActiveRecord::Base
   belongs_to  :employee
   
   has_many :owned_tasks, :class_name => 'SlimtimerTask', :foreign_key => :owner_employee_slimtimer_id
   has_many :time_entries, :class_name => 'SlimtimerTimeEntry', :dependent => :destroy, :foreign_key => :employee_slimtimer_id

   validates_presence_of [:employee_id, :api_key, :username, :password]

end

Employee.class_eval do
   has_one :slimtimer, :class_name => 'Employee::Slimtimer', :dependent => :destroy, :foreign_key => :employee_id
   
   # This ensures validation and save in the employee ActiveScaffold do_cupdate & do_create 
   def scaffold_update_follow_with_slimtimer
     (scaffold_update_follow_without_slimtimer || []) << :slimtimer
   end

   # We kind of need for there to be a scaffold_update_follow if alias_method_chain is to work:
   def scaffold_update_follow; end unless self.respond_to? :scaffold_update_follow
   
   alias_method_chain :scaffold_update_follow, :slimtimer
  
   def slimtimer_api_key
     slimtimer.api_key unless slimtimer.nil?
   end
 
   def slimtimer_username
     slimtimer.username unless slimtimer.nil?
   end

   def slimtimer_password
     slimtimer.password unless slimtimer.nil?
   end

   def slimtimer_api_key=(val)
     build_slimtimer if slimtimer.nil?
     
     slimtimer.api_key = val
   end

   def slimtimer_username=(val)
     build_slimtimer if slimtimer.nil?
     
     slimtimer.username = val
   end

   def slimtimer_password=(val)
     build_slimtimer if slimtimer.nil?
     
     slimtimer.password = val
   end

end
