class UsersController < ApplicationController
	def show
		@plans = current_user.plans
	end

end
