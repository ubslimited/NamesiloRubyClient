require 'spec_helper'
require 'namesilo_client'
require 'dotenv'
require 'nokogiri'

describe NamesiloClient do

  # Load API key
  Dotenv.load
  client = NamesiloClient::API.new(ENV['APIKEY'])  

  it "has get_account" do
    response = client.get_contact_list()
    expect(response.length).to be > 0
    xml_doc  = Nokogiri::XML(response)
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('contactList')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

  it "has list_domains" do
    response = client.list_domains()
    expect(response.length).to be > 0
    xml_doc  = Nokogiri::XML(response)
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listDomains')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

  it "has list_domains_array" do
    domains = client.list_domains_array()
    expect(domains.kind_of?(Array)).to be true
  end

  it "has get_domain_info" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      domain_doc = Nokogiri::XML(client.get_domain_info(domain.text()))
      expect(domain_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('getDomainInfo')
      expect(domain_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # Test list_dns_records
  it "has list_dns_records" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      dns_doc = Nokogiri::XML(client.list_dns_records(domain.text()))
      expect(dns_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('dnsListRecords')
      expect(dns_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # Test check_transfer_status
  it "has check_transfer_status" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      transfer_doc = Nokogiri::XML(client.check_transfer_status(domain.text()))
      expect(transfer_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('checkTransferStatus')
    end
  end

  # Test check_register_availability
  it "has check_register_availability" do
    status_doc = Nokogiri::XML(client.check_register_availability('namesilo.com,namesilo.org,namesilo.net'))
    expect(status_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('checkRegisterAvailability')
  end


  # get_portfolio_list
  it "has get_portfolio_list" do
    xml_doc  = Nokogiri::XML(client.get_portfolio_list())
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('portfolioList')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end
  
  # Test list_name_servers
  it "has list_name_servers" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      ns_doc = Nokogiri::XML(client.list_name_servers(domain.text()))
      expect(ns_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listRegisteredNameServers')
      expect(ns_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # Test list_email_forwards
  it "has list_email_forwards" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      ef_doc = Nokogiri::XML(client.list_email_forwards(domain.text()))
      expect(ef_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listEmailForwards')
      expect(ef_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # Test get_registrant_verification_status
  it "has get_registrant_verification_status" do
    xml_doc  = Nokogiri::XML(client.get_registrant_verification_status())
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('registrantVerificationStatus')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

  # Test get_account_balance
  it "has get_account_balance" do
    xml_doc  = Nokogiri::XML(client.get_account_balance())
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('getAccountBalance')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

  # Test get_prices
  it "has get_prices" do
    xml_doc  = Nokogiri::XML(client.get_prices())
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('getPrices')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end  

  # Test list_orders
  it "has list_orders" do
    xml_doc  = Nokogiri::XML(client.list_orders())
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listOrders')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

end
