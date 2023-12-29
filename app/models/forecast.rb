# frozen_string_literal: true

# == Schema Information
#
# Table name: forecasts
#
#  id          :integer          not null, primary key
#  epoch_time  :datetime
#  temperature :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Forecast < ApplicationRecord
end
