class Setting < ApplicationRecord

  def self.[](nimetus)
    Setting.where(name: nimetus).first.try(:value)
  end
end