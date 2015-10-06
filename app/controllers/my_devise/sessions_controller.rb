class MyDevise::SessionsController < Devise::SessionsController 
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
    end
  end
end