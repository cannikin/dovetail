class Hash
  def has_at_least?(other)
    other.keys.all? do |key|
      (self[key] && self[key] == other[key]) || other[key] == nil
    end
  end
end