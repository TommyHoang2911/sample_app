module ApplicationHelper
  def full_title page_title
    page_title.blank? ? t("base_title") : page_title + t("gen_title")
  end
end
