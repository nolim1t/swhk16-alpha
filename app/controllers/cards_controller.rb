class CardsController < ApplicationController
	before_action :authenticate_user!
	layout 'application'

	def index
		# @cards = Card.all
	end

	def new

	end

	def transfer

	end

	def transferred

	end
end
