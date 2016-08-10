class Message < ApplicationRecord
  belongs_to :chat_room, polymorphic: true
  belongs_to :user

  scope :load_messages, -> {includes(:user).limit Settings.chats.message_per_page}

  delegate :name, to: :user, prefix: true, allow_nil: true
end
