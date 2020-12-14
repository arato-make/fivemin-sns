class TagChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tag_channel_#{session[:tag_name]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def post
  end

  def session
    session_key_name = Rails.application.config.session_options[:key]
    cookies.encrypted[session_key_name]&.with_indifferent_access
  end

  def cookies
    connection.send(:cookies)
  end
end
