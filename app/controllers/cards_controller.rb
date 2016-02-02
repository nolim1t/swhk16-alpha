class CardsController < ApplicationController
	before_action :authenticate_user!
	layout 'application'

	def index
		@cards = Card.where(:owner_id => current_user.id.to_s).order_by([:updated_at, :asc]).limit(6)
	end

	# POST /cards/new
	def newform
		puts "new card"
		if params[:cards]["userid"] != "" and params[:cards]["name"] != "" and params[:cards]["game"] != "" and params[:cards]["collection"] != "" then
			if params[:cards]["Upload Picture"] then
				Card.create(
					cardname: params[:cards]["name"].to_s,
					cardgame: params[:cards]["game"].to_s,
					cardcollection: params[:cards]["collection"].to_s,
					owner_id: params[:cards]["userid"].to_s
				)
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
