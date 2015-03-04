class DonationPresenter < BasePresenter
  def show
    default.merge({
      name: record.donor.name,
      candidate: record.candidate.name,
      party: record.candidate.party.name,
      electorate: record.candidate.electorate.name,
      amount: record.amount
    })
  end

  alias_method :index, :show

end
