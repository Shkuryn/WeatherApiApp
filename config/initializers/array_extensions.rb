class Array
  def avg
    sum = self.inject(0.0) { |sum, x| sum + x }
    (sum / size).round(2)
  end
end
