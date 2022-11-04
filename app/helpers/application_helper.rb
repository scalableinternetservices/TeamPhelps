module ApplicationHelper
    $roles = {0=>"Instructor",1=>"Student"}

    def role_to_text(role_id)
        text = $roles[role_id]
      end
  
    def is_instructor?(role_id)
        $roles[role_id] == 0
    end

    def is_student?(role_id)
        $roles[role_id] == 1
    end

end
