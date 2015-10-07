class MyDevise::RegistrationsController < Devise::RegistrationsController
  # def new
  #   super
  #   session[:plan_id] = params[:plan_id]
  # end
  
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
    def after_sign_up_path_for(resource)
      if session[:plan_id]
        "/plans/#{session[:plan_id]}"
      end    
  end

    def after_inactive_sign_up_path_for(resource)
      if session[:plan_id]
        "/plans/#{session[:plan_id]}"
      end
    end
end