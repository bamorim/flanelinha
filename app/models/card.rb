class Card < ApplicationRecord
  belongs_to :account

  def valid_thru= valid
    self.valid_month, self.valid_year = valid.split("/").map(&:to_i)

  end
  def valid_thru
    "%02d/%02d" % [valid_month, valid_year]
  end

  def digits= d
    self.last_digits = d.split("").last(4).join("")
  end

  def as_json opts
    default_opts = {
      only: [:last_digits, :id],
      methods: :valid_thru
    }
    super(default_opts.merge(opts))
  end
end
