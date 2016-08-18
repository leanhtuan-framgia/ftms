class Message < ApplicationRecord
  belongs_to :chat_room, polymorphic: true
  belongs_to :user

  validates :content, presence: true

  scope :load_messages, ->{includes(:user).order id: :desc}
  scope :unseen, ->{where seen: false}

  delegate :name, to: :user, prefix: true, allow_nil: true

  def is_owner? user_id
    self.user_id == user_id
  end

  class << self
    def unseen_number
      count = unseen.size
      count > 0 ? count : nil
    end
  end

  def broadcast_message active_room_id, current_user
    channel = "channel_#{chat_room_type.downcase}_#{active_room_id}"
    MessageBroadcastJob.perform_later channel, self, current_user
  end
end
