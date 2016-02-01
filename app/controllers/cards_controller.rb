class CardsController < ApplicationController
	before_action :authenticate_user!
	layout 'application'

	def index
		# @cards = Card.all
	end

	# POST /cards/new
	def newform
		puts "new card"
		puts params[:cards].inspect
		redirect_to :cards_index
	end
	# GET /cards/new
	def new

	end

	def transfer

	end

	def transferred

	end

end
