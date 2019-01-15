module SharedValidators
  extend ActiveSupport::Concern

  def word_count_too_long?(input_html, max_word_count)
    raw_text = ActionView::Base.full_sanitizer.sanitize(input_html)
    raw_text.scan(/\s+|$/).length > max_word_count
  end
end
