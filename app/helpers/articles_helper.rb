module ArticlesHelper

  def custom_link_without_id_for_form(cust_l) #= article.custom_link
    cust_l.blank? ? cust_l : cust_l.gsub(/\A\d+-?/, '')
  end

end
