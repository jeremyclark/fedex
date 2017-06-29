module Fedex
  class Address
    attr_accessor :changes
    attr_reader :score, :confirmed, :available, :status, :residential,
                :business, :company, :street_lines, :city, :state,
                :province_code, :postal_code, :country_code, :validation_result

    def initialize(options)
      @changes           = options[:changes]
      @score             = options[:score].to_i
      @confirmed         = options[:delivery_point_validation] == "CONFIRMED"
      @available         = options[:delivery_point_validation] != "UNAVAILABLE"
      @validation_result = options[:validation_result]

      @status      = options[:residential_status]
      @residential = status == "RESIDENTIAL"
      @business    = status == "BUSINESS"

      address        = options[:address]

      @company       = options[:company_name]
      @street_lines  = address[:street_lines]
      @city          = address[:city]
      @state         = address[:state_or_province_code]
      @province_code = address[:state_or_province_code]
      @postal_code   = address[:postal_code]
      @country_code  = address[:country_code]

      @options = options
    end

    def self.validate_address(options = {})
      @credentials = Credentials.new(options.delete(:credentials))
      Request::Address.new(@credentials, options).process_request
    end
  end
end
