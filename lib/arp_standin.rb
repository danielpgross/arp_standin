# frozen_string_literal: true

require_relative "arp_standin/version"
require 'pcaprub'
require 'packetfu'
require 'ipaddr'

module ArpStandin
  class Error < StandardError; end

  CAPTURE_SNAPSHOT_LENGTH = 72 # ARP frame has 72 bytes, https://networkengineering.stackexchange.com/q/77729
  
  class Server
    def initialize(standin_ip_addr:, standin_mac_addr:, network_interface:)
      @standin_ip_addr = standin_ip_addr
      @standin_mac_addr = standin_mac_addr
      @network_interface = network_interface
      puts "Initialized with IP #{@standin_ip_addr}, MAC #{@standin_mac_addr} on #{@network_interface}"
  
      @my_mac_addr = my_mac_address
      raise "Failed to detect my MAC address" if @my_mac_addr.nil?
      puts "My MAC address: #{@my_mac_addr}"
    end
  
    def run!
      capture = PCAPRUB::Pcap.open_live(@network_interface, CAPTURE_SNAPSHOT_LENGTH, true, 1)
      filter = "arp and arp[6:2] == 1 and arp[24:4] == 0x#{IPAddr.new(@standin_ip_addr).hton.unpack1('H*')}"
      puts "Begin capture with filter: #{filter}"
      capture.setfilter(filter)
  
      capture.each_data do |packet|
        arp_request_packet = PacketFu::Packet.parse(packet)
        puts "Got request packet from IP: #{arp_request_packet.arp_saddr_ip}, MAC: #{arp_request_packet.arp_saddr_mac}"
        arp_reply_packet(arp_request_packet).to_w(@network_interface)
      end
    end
  
    def arp_reply_packet(arp_request_packet)
      # Build Ethernet header
      arp_reply_packet = PacketFu::ARPPacket.new
      arp_reply_packet.eth_saddr = @my_mac_addr
      arp_reply_packet.eth_daddr = arp_request_packet.arp_saddr_mac
      # Build ARP Packet
      arp_reply_packet.arp_saddr_mac = @standin_mac_addr
      arp_reply_packet.arp_daddr_mac = arp_request_packet.arp_saddr_mac
      arp_reply_packet.arp_saddr_ip = @standin_ip_addr
      arp_reply_packet.arp_daddr_ip = arp_request_packet.arp_saddr_ip
      arp_reply_packet.arp_opcode = 2
  
      arp_reply_packet
    end

    def my_mac_address
      File.read("/sys/class/net/#{@network_interface}/address").chomp
    end
  end
end