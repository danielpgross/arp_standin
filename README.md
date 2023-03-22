# ARP Stand-in

Respond to ARP requests on behalf of another machine. Useful for keeping a sleeping machine accessible on the network.

## Installation

Follow these instructions to install ARP Stand-in as a systemd service that runs automatically on boot:

```sh
git clone https://github.com/danielpgross/arp_standin
cd arp_standin
bundle exec rake install # You might need to use `sudo` for this

# Create systemd service
sudo cp arp-standin.example.service /etc/systemd/system/arp-standin.service
sudo nano /etc/systemd/system/arp-standin.service
# Be sure to set the three configuration environment variables:
# STANDIN_MAC_ADDR: The MAC address of the machine to answer on behalf of.
# STANDIN_IP_ADDR: The IP address of the machine to answer on behalf of.
# NETWORK_INTERFACE: The network interface to send/receive on.
sudo systemctl daemon-reload
sudo systemctl enable arp-standin.service
sudo systemctl start arp-standin.service
systemctl status arp-standin.service
```

## Development

After cloning the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danielpgross/arp_standin.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
