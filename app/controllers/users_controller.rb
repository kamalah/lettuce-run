class UsersController < ApplicationController
	before_action :authenticate_user!
	def show
		@plans = current_user.plans.where(active: true)
	end
end
