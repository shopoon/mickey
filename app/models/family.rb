class Family < ActiveRecord::Base
  extend Enumerize

  validates :genotype, presence: true
  validates :number, presence: true
  validates :birth, presence: true

  has_many :mice

  scope :by_genotype, -> (genotype) { where(genotype: genotype) }

  enumerize :genotype, in: [:WT, :A1KO, :V1KO], default: :WT

  def self.latest_with_genotype(genotype)
    latest_record = self.where(genotype: genotype).order("number DESC").first
  end

  def self.latest_number_with_genotype(genotype)
    if latest_record = latest_with_genotype(genotype)
      return latest_record.number.to_i
    else
      return 0
    end
  end

  def male_count
    self.mice.select{|m| m.sex.male? && m.status.available? }.count
  end

  def female_count
    self.mice.select{|m| m.sex.female? && m.status.available? }.count
  end

  def display_name
    "#{genotype}-#{number}"
  end

end
