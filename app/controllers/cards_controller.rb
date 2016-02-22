class CardsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_card_form, only: [:detail]
	before_action :set_find_owner_form, only: [:detail]
	layout 'application'

	def index
		@listincoming = Transfer.where(receiver_email: current_user.email).count # Check i
		@owner_cards = Card.where(:owner_id => current_user.id.to_s, :transfer_status => 0, :deleted_status => 0).order_by([:create_date, :desc])
		@cards = params[:search_text].present? ? @owner_cards.where(searchable_name:  /#{Regexp.escape(params[:search_text].downcase.to_s)}/).paginate(:page => params[:page], :per_page => 7) : @owner_cards.paginate(:page => params[:page], :per_page => 7)
		# raise params[:search_text].inspect
		# .order_by([:updated_at, :asc])
		# If no cards, show new card url
		# If no cards and shopkeeper, show vendor url
		if current_user.accounttype == "vendor" and @cards.length == 0 then
			redirect_to "/vendor"
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
		@cards_and_images = @cards.zip(@cardimages).map{|c,i| [c,i]}
		# @cards_search = Cardnote.where({cardname: "#{params[:search_text]}"})
	end

	def edit
		@card = Card.where(:id => params[:id].to_s)[0]
	end

	# POST /cards/new
	def newform
		flash[:info] = {}
		flash[:info][:cardname] = params[:cards]["name"]
		flash[:info][:cardgame] = params[:cards]["game"]
		flash[:info][:cardcollection] = params[:cards]["collection"]
		flash[:info][:card_condition] = params[:cards]["card_condition"].to_s.capitalize
		if CardsHelper::ValidateCardCondition.valid_condition(params[:cards]["card_condition"].to_s.downcase) and params[:cards]["userid"] != "" and params[:cards]["name"] != "" and params[:cards]["game"] != "" and params[:cards]["collection"] != "" then
			# Front image is required
			if params[:cards]["front_image"] then
				card_created = Card.create(
					cardname: params[:cards]["name"].to_s,
					cardgame: params[:cards]["game"].to_s,
					searchable_name: params[:cards]["name"].downcase.to_s,
					cardcollection: params[:cards]["collection"].to_s,
					card_condition: params[:cards]["card_condition"].to_s.downcase,
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
				flash[:error] = "A card must require a front image"
				redirect_to request.original_fullpath
			end
		else
			puts "Invalid parameters"
			flash[:error] = "The form must be completed before continuing"
			redirect_to request.original_fullpath
		end
	end
	# GET /cards/new
	def new
		if flash[:info] == nil then
			flash[:info] = {}
			flash[:info][:cardname] = ""
			flash[:info][:cardgame] = "Magic: The Gathering"
			flash[:info][:cardcollection] = "Default collection"
			flash[:info][:card_condition] = "Mint"
		end
		puts flash.inspect
		# Populate dropdowns
		@cardcollection = []
		@gamelist = []
		Cardgame.each{|game| @gamelist << game.gamename }
		Cardcollection.each{|coll| @cardcollection << coll.collectionname}
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
			if (@card.owner_id == current_user._id.to_s) or (current_user.accounttype == "vendor" or current_user.accounttype == "admin") then
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
					if params[:cards].present?
						puts "Params: card_id=#{params[:id]}, notes_text=#{params[:cards]['notes_text']}"
						puts "Full cards params: #{params[:cards].inspect}"
						if params[:cards]['image_only_upload'] == 'true' then
							notes_text = 'Replace card image'
						else
							notes_text = params[:cards]['notes_text']
						end
						if notes_text != '' then
							# Create a card note
							Cardnote.create(
								text: notes_text.to_s,
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
							# If card condition not set
							if params[:cards]['card_condition'] then
								if params[:cards]['card_condition'].to_s.downcase != @card.card_condition.to_s.downcase then
									if params[:cards]['card_condition'].to_s.downcase == params[:cards]['card_condition_verify'].to_s.downcase then
										if CardsHelper::ValidateCardCondition.change_condition(@card.card_condition.downcase, params[:cards]['card_condition'].downcase) then
											puts "Lets update card id=#{@card._id}"
											update_card = Card.find(@card._id)
											update_card.update_attributes(card_condition: params[:cards]['card_condition'].downcase)
											# Redirect on success
											redirect_to "/cards/detail/#{params[:id]}" # Redirect back to cards if successful
										else
											flash[:error] = "Card condition not allowed to go from #{@card.card_condition.downcase} to #{params[:cards]['card_condition'].downcase}"
											puts flash[:error]
											redirect_to request.original_fullpath
										end
									else
										# Doesn't match
										flash[:error] = "Please type out the card condition name in the text box in order to change the condition"
										puts flash[:error]
										redirect_to request.original_fullpath
									end
								else
									# Nothing to change
									redirect_to "/cards/detail/#{params[:id]}" # Redirect back to cards if successful
								end
							else
								redirect_to "/cards/detail/#{params[:id]}" # Redirect back to cards if successful
							end
						else
							# Or display an error
							puts "Error encountered. Redirect back to #{request.original_fullpath}"
							flash[:error] = "Must include a comment"
							redirect_to request.original_fullpath
						end # END: Check presence of notes text
					end # End: check if card is present
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


  def set_card_form
    @card = Card.where(:id => params[:id].to_s)[0]
    @card_form = render_to_string(
            :partial => '/cards/add_picture_form',
            :locals => {
              :card => @card
            }
          )
  end

  def set_find_owner_form
  	@find_owner_form = render_to_string(:partial => '/cards/find_owner_form')
  end

	def request_validation
		puts "ID: #{params[:id]}"
		cards = Card.where(:id => params[:id].to_s)
		if cards.length == 1 then
			@card = cards[0]
			if @card.owner_id == current_user._id.to_s then
				check_queue = Validationqueue.where(:requestor_email_address => current_user.email, :card_id => @card._id.to_s)
				if check_queue.length == 0 then
					Cardnote.create(
						text: "Requested validation by expert",
						create_date: Time.new(),
						card_id: params[:id].to_s
					)
					# Check if this card is in the validation queue
					Validationqueue.create(
						entry_date: Time.new(),
						card_id: @card._id.to_s,
						requestor_email_address: current_user.email
					)
					# Update validation status
					update_card = Card.find(@card._id)
					update_card.update_attributes(validation_status: 1)
				end
			end
			redirect_to cards_detail_url_path(@card)
		else
			redirect_to cards_detail_url_path(@card)
		end
	end
end
