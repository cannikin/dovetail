class Hash
  def has_at_least?(other)
    other.keys.all? do |key|
      (self[key] && self[key] == other[key]) || (other[key] == nil && !self.has_key?(key))
    end
  end
end