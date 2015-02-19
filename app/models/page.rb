class Page < ActiveRecord::Base
  enum category: [ :about ]

  def self.about_text
    where(category: Page.categories[:about]).first.try(:text)
  end
end
