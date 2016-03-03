module CardsHelper
  def remove_card(id)
    begin
      card_to_permadelete = Card.find(id)
      if card_to_permadelete then
        Cardimage.where(card_id: id.to_s).each{|cardimage|
					cardimage.destroy
				}
				# Now remove the notes
				Cardnote.where(card_id: id.to_s).each{|cardnote|
					cardnote.destroy
				}
				# Delete the card
				card_to_permadelete.destroy

        # All done!
        true
      else
        false
      end
    rescue
      false
    end
  end

  class ValidateCardCondition
    def self.valid_condition(condition)
      if condition == "mint" or condition == "slightly worn" or condition == "worn" or condition == "damaged" then
        true
      else
        false
      end
    end

    def self.change_condition(before, after)
      if before == "mint" then
        # mint can go to any status
        true
      elsif before == "slightly worn" then
        # can go anywhere but mint
        if after != "mint" then
          true
        else
          false
        end
      elsif before == "worn" then
        # can only be set to damaged
        if after == "damaged" then
          true
        else
          false
        end
      else
        # damaged can't be changed
        false
      end
    end
  end
end
