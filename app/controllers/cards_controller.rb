class CardsController < ApplicationController
	before_action :authenticate_user!
	layout 'application'

	def index
		@cards = Card.where(:owner_id => current_user.id.to_s).order_by([:updated_at, :asc]).limit(6)
		if @cards.length == 0 then
			redirect_to :cards_new_url
		end
		@cardimages = []
		@cards.each{|card|
			puts card.photo.url
			puts card.photo.thumb.url

			cardimages_result = Cardimage.where(:card_id => card._id.to_s, :image_type => "front").order_by([:create_date, :desc]).limit(2)
			cardimages_result.each{|cardimage_result|
				@cardimages << cardimage_result
			}
		}
		@cards_search = Cardnote.where({name: /#{params[:search_text]}/})
	end

	# POST /cards/new
	def newform
		@prefilled_name = params[:cards]["name"]
		@prefilled_game = params[:cards]["game"]
		@prefilled_collection = params[:cards]["collection"]
		if params[:cards]["userid"] != "" and params[:cards]["name"] != "" and params[:cards]["game"] != "" and params[:cards]["collection"] != "" then
			# Front image is required
			if params[:cards]["front_image"] then
				card_created = Card.create(
					cardname: params[:cards]["name"].to_s,
					cardgame: params[:cards]["game"].to_s,
					cardcollection: params[:cards]["collection"].to_s,
					create_date: Time.new(),
					update_date: Time.new(),
					owner_id: params[:cards]["userid"].to_s
				)
				# Create other images
				Cardnote.create(
					text: "Card initial upload complete",
					create_date: Time.new(),
					card_id: card_created._id.to_s
				)
				# Create Front image
				Cardimage.create(
					create_date: Time.new(),
					photo: params[:cards]["front_image"],
					image_type: "front",
					image_note: "Front image uploaded",
					card_id: card_created._id.to_s
				)
				# Create back image if exists
				if params[:cards]["back_image"] then
					Cardimage.create(
						create_date: Time.new(),
						photo: params[:cards]["back_image"],
						image_type: "back",
						image_note: "Back image uploaded",
						card_id: card_created._id.to_s
					)
				end
				redirect_to :cards_index
			else
				puts "Need a picture"
				@errormsg = "A card requires a photo"
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

	def detail
		puts "ID: #{params[:id]}"
		cards = Card.where(:id => params[:id].to_s)
		if cards.length == 1 then
			@card = cards[0]
			@cardnote = Cardnote.where(:card_id => @card._id.to_s).order_by([:create_date, :desc]).limit(5)
			cardimages_1 =  Cardimage.where(:card_id => @card._id.to_s, :image_type => 'front').order_by([:image_type, :desc],[:create_date, :desc]).limit(1)
			cardimages_2 =  Cardimage.where(:card_id => @card._id.to_s, :image_type => 'back').order_by([:image_type, :desc],[:create_date, :desc]).limit(1)
			@cardimages = []
			cardimages_1.each{|card_1|
				@cardimages << card_1
			}
			cardimages_2.each{|card_2|
				@cardimages << card_2
			}
			# Check if owner matches the database
			if @card.owner_id == current_user._id.to_s then
				@method = env['REQUEST_METHOD']
				if current_user.timezone == '' or current_user.timezone == nil then
					@timezone = current_user.timezone
				else
					@timezone = current_user.timezone
				end
				if env['REQUEST_METHOD'] == "GET" then
					render :template => "cards/detail"
				else
					puts "POST detected"
					puts "Params: card_id=#{params[:id]}, notes_text=#{params[:cards]['notes_text']}"
					puts "Full cards params: #{params[:cards].inspect}"
					if params[:cards]['notes_text'] != '' then
						Cardnote.create(
							text: params[:cards]['notes_text'].to_s,
							create_date: Time.new(),
							card_id: params[:id].to_s
						)
						# Check images
						if params[:cards]['front_image'] != nil then
							Cardimage.create(
								create_date: Time.new(),
								photo: params[:cards]['front_image'],
								image_type: "front",
								image_note: "front image uploaded",
								card_id: params[:id].to_s
							)
						end # END: Check front image
						if params[:cards]['back_image'] != nil then
							# if a new back image is specified
							Cardimage.create(
								create_date: Time.new(),
								photo: params[:cards]["back_image"],
								image_type: "back",
								image_note: "Back image uploaded",
								card_id: params[:id].to_s
							)
						end # END: Check back image
						redirect_to request.original_fullpath
					else
						flash[:error] = "Must include a comment"
						redirect_to request.original_fullpath
					end # END: Check presence of notes text
				end # END: check if get or post
			else
				redirect_to '/'
			end
		else
			redirect_to '/'
		end
	end

	def transfer

	end

	def transferred

	end

end
