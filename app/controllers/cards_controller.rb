class CardsController < ApplicationController
	before_action :authenticate_user!
	layout 'application'

	def index
		# @cards = Card.all
	end

	# POST /cards/new
	def newform
		puts "new card"
		if params[:cards]["name"] != "" and params[:cards]["game"] != "" and params[:cards]["collection"] != "" then
			if params[:cards]["Upload Picture"] then
				puts params[:cards].inspect
				redirect_to :cards_index
			else
				puts "Need a picture"
				@errormsg = "A card requires a photo"
				@prefilled_name = params[:cards]["name"]
				@prefilled_game = params[:cards]["game"]
				@prefilled_collection = params[:cards]["collection"]
				render :template => "cards/new"
			end
		else
			puts "Invalid parameters"
			@errormsg = "Please complete the entire form"
			render :template => "cards/new"
		end
	end
	# GET /cards/new
	def new
		@prefilled_name = ""
		@prefilled_game = ""
		@prefilled_collection = ""
		render :template => "cards/new"
	end

	def transfer

	end

	def transferred

	end

end
