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

  def treemap
    {
      name: record.name,
      colour: record.colour,
      children: record.candidates.map do |c|
        {
          name: c.name,
          children: c.donations.map do |d|
            {
              name: d.donor.name,
              value: d.amount
            }
          end
        }
      end
    }
  end


  def default
    {
      id: record.slug,
      name: record.name,
      link: "/v1/parties/#{record.slug}.json"
    }
  end
end
