module PlansHelper
	def calendar(date = Date.today, &block)
    	Calendar.new(self, date, block).table
  	end
end
