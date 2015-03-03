class PartyPresenter < BasePresenter
  def index
    default.merge({
      total: record.candidates.map(&:donation_amounts).flatten.sum,
      candidates: record.candidates.map { |c| c.as_json(:default).except(:party) }
    })
  end

  def show
    default.merge({
      total: record.candidates.map(&:donation_amounts).flatten.sum,
      candidates: record.candidates.map { |c| c.presenter.show }
    })
  end

  def default
    {
      id: record.slug,
      name: record.name,
      link: "/v1/parties/#{record.slug}.json"
    }
  end
end
