module Presentable
  def as_json(presenter_type = :default)
    presenter_class = Object.const_get "#{self.class.name}Presenter"
    presenter_class.new(self).public_send(presenter_type)
  end
end
