class PlayingCard
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end

  def as_json
    {
      rank: rank,
      suit: suit
    }
  end

  def self.from_json(data)
    new(data['rank'], data['suit'])
  end
end
