module TreemapRoutes
  extend self

  def included(base)
    Routes.electorates('/v1/treemaps/electorates.json', base)
    Routes.parties('/v1/treemaps/parties.json', base)
    Routes.donors('/v1/treemaps/donors.json', base)
  end

  module Routes
    extend self

    def electorates(path, base)
      base.get path do
        JSON.pretty_generate Electorate.all.map { |c| c.as_json(:treemap) }
      end
    end

    def parties(path, base)
      base.get path do
        JSON.pretty_generate Party.all.map { |c| c.as_json(:treemap) }
      end
    end

    def donors(path, base)
      base.get path do
        JSON.pretty_generate Donor.all.map { |c| c.as_json(:treemap) }
      end
    end
  end
end
