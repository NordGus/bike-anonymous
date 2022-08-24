class License::IdPdf < Prawn::Document
  def initialize(license)
    @license = license

    super(page_layout: :landscape)

    license_code
    dates
    cyclist_name
  end

  private

  def license_code
    text "License #{@license.code}", size: 26, style: :bold
  end

  def dates
    move_down 10
    text "Registration Date: #{@license.registered_at.strftime("%B %d %Y")}"
    text "Expiration Date: #{@license.expires_at.strftime("%B %d %Y")}"
  end

  def cyclist_name
    move_down 10
    text "First Name: #{@license.first_name}"
    text "Last Name: #{@license.last_name}"
  end
end