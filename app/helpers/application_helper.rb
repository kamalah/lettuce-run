module ApplicationHelper
def flash_message
		if flash[:alert]
			content_tag :div, class: "alert alert-danger"do
				content_tag :p do
					"#{flash[:alert]}"
				end
			end
		elsif flash[:notice]
			content_tag :div, class: "alert alert-success" do
				content_tag :p do
					"#{flash[:notice]}"
				end
			end
		end
	end
end
