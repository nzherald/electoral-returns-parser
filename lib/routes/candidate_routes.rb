module CandidateRoutes
  extend self

  def included(base)
    Routes.index('/v1/candidates.json', base)
    Routes.show('/v1/candidates/:id.json', base)
  end

  module Routes
    extend self

    def index(path, base)
      base.get path do
        JSON.pretty_generate Candidate.all.includes(:electorate, :party).map { |c| c.as_json(:index) }
      end
    end

    def show(path, base)
      base.get path do
        begin
          record = Candidate.find_by(slug: params[:id])
        rescue ActiveRecord::RecordNotFound
          halt 404
        end
        JSON.pretty_generate record.as_json(:show)
      end
    end

  end
end
