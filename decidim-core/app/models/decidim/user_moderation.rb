# frozen_string_literal: true

module Decidim
  class UserModeration < ApplicationRecord
    include Traceable
    include Loggable

    belongs_to :user, foreign_key: :decidim_user_id, class_name: "Decidim::UserBaseEntity"
    has_one :blocking, through: :user
    has_many :reports, class_name: "Decidim::UserReport", dependent: :destroy

    scope :blocked, -> { joins(:user).where(decidim_users: { blocked: true }) }
    scope :unblocked, -> { joins(:user).where(decidim_users: { blocked: false }) }

    delegate :organization, to: :user

    def self.log_presenter_class_for(_log)
      Decidim::AdminLog::UserModerationPresenter
    end

    def self.ransackable_attributes(_auth_object = nil)
      []
    end

    def self.ransackable_associations(_auth_object = nil)
      %w(reports user)
    end
  end
end
