class CandidatePresenter < BasePresenter
  def index
    default.merge({
      total: record.total_donations,
      link: "/v1/candidates/#{record.slug}.json"
    })
  end

  def show
    default.merge({
      donations: record.donations_list,
      total: record.total_donations
    })
  end

  def default
    {
      id: record.slug,
      first_names: record.first_names,
      last_name: record.last_name,
      electorate: record.electorate.name,
      party: record.party.name
    }
  end

end
