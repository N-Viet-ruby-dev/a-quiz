# frozen_string_literal: true

class QuestionBroadcastJob < ApplicationJob
  queue_as :question

  def perform(notifications)
    notifications.each do |notification|
      ActionCable.server.broadcast "question_channel_#{notification.user_id}",
                                   notification: render_notification(notification, notification.user),
                                   counter: render_counter(Notification.where(user_id: notification.user_id).not_seen.size)
    end
  end

  def render_notification(notification, current_user)
    ApplicationController.renderer.render(partial: "shared/notification",
                                          locals: { notification: notification, current_user: current_user })
  end

  def render_counter(counter)
    ApplicationController.renderer.render(partial: "shared/counter",
                                          locals: { counter: counter })
  end
end
