# frozen_string_literal: true

module Decidim
  module Admin
    # A form object used to update the current organization from the admin
    # dashboard.
    #
    class OrganizationForm < Form
      include TranslatableAttributes

      mimic :organization

      translatable_attribute :name, String
      attribute :reference_prefix, String
      attribute :time_zone, String
      attribute :twitter_handler, String
      attribute :facebook_handler, String
      attribute :instagram_handler, String
      attribute :youtube_handler, String
      attribute :github_handler, String
      attribute :default_locale, String
      attribute :badges_enabled, Boolean
      attribute :user_groups_enabled, Boolean
      attribute :comments_max_length, Integer, default: 0
      attribute :rich_text_editor_in_public_views, Boolean
      attribute :enable_machine_translations, Boolean
      attribute :machine_translation_display_priority, String
      attribute :enable_participatory_space_filters, Boolean

      attribute :send_welcome_notification, Boolean
      attribute :customize_welcome_notification, Boolean

      translatable_attribute :welcome_notification_subject, String
      translatable_attribute :welcome_notification_body, Decidim::Attributes::RichText

      translatable_attribute :admin_terms_of_service_body, Decidim::Attributes::RichText

      validates :welcome_notification_subject, :welcome_notification_body, translatable_presence: true, if: proc { |form| form.customize_welcome_notification }

      validates :name, translatable_presence: true
      validates :time_zone, presence: true
      validates :time_zone, time_zone: true
      validates :default_locale, :reference_prefix, presence: true
      validates :default_locale, inclusion: { in: :available_locales }
      validates :admin_terms_of_service_body, translatable_presence: true
      validates :comments_max_length, presence: true, numericality: { greater_than_or_equal_to: 0 }
      validates :machine_translation_display_priority,
                inclusion: { in: Decidim::Organization::AVAILABLE_MACHINE_TRANSLATION_DISPLAY_PRIORITIES },
                if: :machine_translation_enabled?

      def machine_translation_priorities
        Decidim::Organization::AVAILABLE_MACHINE_TRANSLATION_DISPLAY_PRIORITIES.map do |priority|
          [
            priority,
            I18n.t("activemodel.attributes.organization.machine_translation_display_priority_#{priority}")
          ]
        end
      end

      private

      def available_locales
        current_organization.available_locales
      end

      def machine_translation_enabled?
        Decidim.config.enable_machine_translations
      end
    end
  end
end
