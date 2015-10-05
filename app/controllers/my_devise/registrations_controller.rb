class MyDevise::RegistrationsController < Devise::RegistrationsController
  def new
    super
    session[:plan_id] = params[:plan_id]
  end
  
  def create
    super
    if session[:plan_id]
       plan = Plan.find_by(session[:plan_id])
       plan.user_id = current_user.user_id
       plan.save
       
    end
  end
end