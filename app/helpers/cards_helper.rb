module CardsHelper
  class ValidateCardCondition
    def self.valid_condition(condition)
      if condition == "mint" or condition == "slightly worn" or condition == "worn" or condition == "damaged" then
        true
      else
        false
      end
    end
  end
end
