module MiceHelper
  def convert_sex(male_or_female)
    if male_or_female.male?
      string = "<p style='color:#0088CD;'>♂</p>"
    elsif male_or_female.female?
      string = "<p style='color:#D94D48;'>♀</p>"
    else
      string =  ""
    end
    string
  end

  def convert_status(status)
    case status.to_sym
    when :available
      return "利用可能"
    when :reserved
      return "予約済み"
    when :used
      return "使用済み"
    else 
      return ""
    end
  end
end
