class CardsController < ApplicationController
	include CardsHelper
	before_action :authenticate_user!
	before_action :set_card_form, only: [:detail]
	before_action :set_find_owner_form, only: [:detail]
	layout 'application'

	def testing_display
    @cards = Card.where(:owner_id => current_user.id.to_s, :transfer_status => 0, :deleted_status => 0).order_by([:create_date, :desc])[0..6]
    @card = @cards[0]
  	@cardimages = []
		@cards.each{|card|
			puts card.photo.url
			puts card.photo.thumb.url

			cardimage_front = Cardimage.where(:card_id => card._id.to_s, :image_type => "front").order_by([:create_date, :desc])[0]
			cardimage_back = Cardimage.where(:card_id => card._id.to_s, :image_type => "back").order_by([:create_date, :desc])[0]
			# cardimages_result.each{|cardimage_result|
			# 	@cardimages << cardimage_result
			# }
			@cardimages << [cardimage_front, cardimage_back]
		}

		@cards_and_images = @cards.zip(@cardimages).map{|c,i| [c,i]}
  end

	def index
		flash[:info] = nil # Remove any info stuff
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
		respond_to do |format|
		  format.html
		  format.js
		end
	end

	def graveyard
		@cards = Card.where(:owner_id => current_user.id.to_s, :transfer_status => 0, :deleted_status => 1).order_by([:create_date, :desc])
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
		flash[:info][:card_condition] = params[:cards]["card_condition"].to_s
		flash[:info][:card_condition_select] = params[:cards]["card_condition_select"].to_s
		if params[:cards]["name"].to_s == "" then
			cardname = "(not set)"
		else
			cardname = params[:cards]["name"].to_s
		end
		if params[:cards]["card_condition_select"].to_s == "Other" then
			if params[:cards]["card_condition"].to_s == "" then
				card_condition = "(not set)"
			else
				card_condition = params[:cards]["card_condition"].to_s
			end
		else
			card_condition = params[:cards]["card_condition_select"]
			flash[:info][:card_condition] = card_condition
		end
		if card_condition != "" and params[:cards]["userid"] != "" and cardname != "" and params[:cards]["game"] != "" and params[:cards]["collection"] != "" then
			# Front image is required
			if params[:cards]["front_image"] then
				card_created = Card.create(
					cardname: cardname,
					cardgame: params[:cards]["game"].to_s,
					searchable_name: cardname.downcase.to_s,
					cardcollection: params[:cards]["collection"].to_s,
					card_condition: card_condition.to_s,
					create_date: Time.new(),
					update_date: Time.new(),
					owner_id: params[:cards]["userid"].to_s
				)
				if params[:cards]["card_condition_select"].to_s == "Other" then
					# Store Cardcondition so we have a list of what people are entering if other is selected
					Cardcondition.create(
						condition: card_condition.to_s.downcase
					)
				end
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
			flash[:info][:card_condition] = ""
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
			if @card[:unique_identifier] == nil then
				if @card[:unique_identifier] == "" then
					rs = "VA-"
					7.times{|i| rs+='ABCDEFGHIJKLMNOPQRSTUVWXYZ'[rand(26), 1]}
					rs = rs + "-#{(Card.count + 1).to_s}"
					@card.update_attributes(:unique_identifier => rs)
					@card.save
					@card[:unique_identifier] = rs
				else
					@card.update_attributes(:unique_identifier => @card[:unique_identifier])
				end
			else
				@card.update_attributes(:unique_identifier => @card[:unique_identifier])
			end
			# Check if owner matches the database
			if (@card.owner_id == current_user._id.to_s) or ((current_user.accounttype == "vendor" and current_user.identity_verified == 1) or (current_user.accounttype == "expert") or (current_user.accounttype == "admin")) then
				@method = env['REQUEST_METHOD']
				if current_user.timezone == '' or current_user.timezone == nil then
					@timezone = current_user.timezone
				else
					@timezone = current_user.timezone
				end
				if env['REQUEST_METHOD'] == "GET" then
					# get Owner info
					if @card.owner_id.to_s != current_user._id.to_s then
						# if the owner doesnt match
						@card_owner_info = User.find(@card.owner_id)
					else
						# If the owner matches
						@card_owner_info = current_user
					end
					render :template => "cards/detail"
				else
					puts "POST detected"
					if params[:cards].present?
						puts "Params: card_id=#{params[:id]}, notes_text=#{params[:cards]['notes_text']}"
						puts "Full cards params: #{params[:cards].inspect}"
						notes_text = ''
						if params[:cards]['image_only_upload'] == 'true' then
							notes_text = 'Replace card image'
						end
						if params[:cards]['cardname'] or params[:cards]['card_condition'] then
							puts "Lets update card id=#{@card._id}"
							update_card = Card.find(@card._id)
							# Check if the entry is different
							if params[:cards]['cardname'].to_s != update_card['cardname'] then
								if params[:cards]['cardname'].to_s.length > 0 then
									notes_text = "Change card name from \"#{update_card['cardname']}\" to \"#{params[:cards]['cardname'].to_s}\""
								end
							end
							if params[:cards]["card_condition_select"] != "Other"  then
								if update_card['card_condition'].to_s != params[:cards]["card_condition"].to_s then
									# use the typed condition if the name is different
									card_condition = params[:cards]["card_condition"].to_s
								else
									# If the name is the same then use the selectbox
									card_condition = params[:cards]["card_condition_select"].to_s
								end
							else
								card_condition = params[:cards]["card_condition"].to_s
							end
							if card_condition.downcase != update_card['card_condition'].to_s.downcase then
								if card_condition.to_s.length > 0 then
									if notes_text.to_s.length > 0
										notes_text = "#{notes_text}, and c"
									else
										notes_text = "C"
									end
									notes_text = "#{notes_text}hange card condition from \"#{update_card['card_condition'].to_s}\" to \"#{card_condition.to_s}\""
								end
							end
							if params[:cards]['notes_text'] then
								if params[:cards]['notes_text'].to_s.length > 1 and params[:cards]['notes_text'].to_s.length <= 500 then
									if notes_text == '' then
										notes_text = params[:cards]['notes_text'].to_s
									else
										notes_text = "#{notes_text}. User comment: \"#{params[:cards]['notes_text']}\""
									end
								end
							end
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
							if params[:cards]['cardname'] then
								if params[:cards]['cardname'].to_s.length > 1 then
									update_card.update_attributes(cardname: params[:cards]['cardname'].to_s, searchable_name: params[:cards]['cardname'].to_s.downcase)
								end
							end
							# If card condition not set
							if card_condition then
								# Then update the card condition first
								if card_condition.to_s.length > 1 then
									update_card.update_attributes(card_condition: card_condition)
									if params[:cards]['card_condition_select'] == "Other" then
										# Store Cardcondition so we have a list of what people are entering
										Cardcondition.create(
											condition: params[:cards]['card_condition'].downcase
										)
									end
								end
							end
							redirect_to "/cards/detail/#{params[:id]}" # Redirect back to cards if successful
						else
							# Or display an error
							puts "Error encountered. Redirect back to #{request.original_fullpath}"
							flash[:error] = "Must include a comment if you aren't changing the fields"
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

	def cancelvalidation
		card_to_cancel_validation = Card.find(params[:id])
		if card_to_cancel_validation.owner_id.to_s == current_user._id.to_s then
			puts "ID: #{params[:id]}\n\bInspect info: #{card_to_cancel_validation.inspect}"
			card_to_cancel_validation.update_attributes(validation_status: 0)
			validation_queue = Validationqueue.where(card_id: card_to_cancel_validation._id.to_s)
			validation_queue.each {|v| puts v.delete}
			Cardnote.create(
				text: "User cancelled expert validation",
				create_date: Time.new(),
				card_id: params[:id].to_s
			)
		end
		redirect_to cards_detail_url_path(card_to_cancel_validation)
	end

	def deletecard
		card_to_update = Card.find(params[:id])
		if (card_to_update.owner_id.to_s == current_user._id.to_s) or (current_user.accounttype == "vendor" or current_user.accounttype == "admin") then
			puts "ID: #{params[:id]}\n\bInspect info: #{card_to_update.inspect}"
			card_to_update.update_attributes(deleted_status: 1)

			redirect_to cards_index_path
		else
			redirect_to "/"
		end
	end

	def undeletecard
		card_to_update = Card.find(params[:id])
		if (card_to_update.owner_id.to_s == current_user._id.to_s) or (current_user.accounttype == "vendor" or current_user.accounttype == "admin") then
			puts "ID: #{params[:id]}\n\bInspect info: #{card_to_update.inspect}"
			card_to_update.update_attributes(deleted_status: 0)

			redirect_to cards_index_path
		else
			redirect_to "/"
		end
	end

	def permadeletecard
		if current_user.accounttype == "admin" then
			if remove_card(params[:id]) then
				puts "Gone"
				redirect_to "/admin"
			else
				puts "Didn't delete"
				redirect_to "/admin"
			end
		else
			redirect_to "/"
		end
	end

	# Helpers
	def detect_and_set_timezone
		if request.location != nil then
			if request.location.timezone != nil then
				if request.location.timezone.to_s.length > 0 then
					user = User.find(current_user._id)
					user.update_attributes(timezone: request.location.timezone)
					user.save
				end
			end
		end
	end
end
