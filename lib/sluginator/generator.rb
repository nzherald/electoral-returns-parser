module Sluginator
  class Generator
    def before_validation (record)
      record.slug = sanitize(record.name)
    end

    private

    def sanitize(text)
      text.to_ascii.downcase.gsub(' ', '-')
    end
  end
end
