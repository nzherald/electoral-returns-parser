class ElectoratePresenter < BasePresenter
  def index
    default.merge({
      total: record.candidates.map(&:donation_amounts).flatten.sum,
      candidates: record.candidates.map { |c| c.as_json(:default) }
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
      children: record.candidates.map do |c|
        {
          name: c.name,
          children: c.donations.map do |d|
            {
              name: d.donor.name,
              colour: d.candidate.party.colour,
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
      name: record.name
    }
  end
end
