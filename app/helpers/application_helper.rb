module ApplicationHelper
    $roles = {0=>"Instructor",1=>"Student", 2=>"TA"}

    def role_to_text(role_id)
        text = $roles[role_id]
    end

    def role_to_id(role)
        id = $roles.key(role)
    end
  
    def is_instructor?(role_id)
        role_id == 0
    end

    def is_student?(role_id)
        role_id == 1
    end

    def is_ta?(role_id)
        role_id == 2
    end

end
