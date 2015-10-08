class MyDevise::SessionsController < Devise::SessionsController 
  def create
    super
    if (session[:plan_id] && current_user)
      plan = Plan.find_by(id: session[:plan_id])
      plan.user_id = current_user.id
      plan.save
      session[:plan_id] = nil
    end
  end
  protected
    def after_sign_in_path_for(resource_or_scope)
      if session[:plan_id]
        "/plans/#{session[:plan_id]}"
      end
    end
end