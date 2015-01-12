# Enc

Enc is a role-based customizable puppet external node classifier.

## Installation

Install the gem on your puppetmaster server:
```bash
gem install enc
```

Configure etc/puppet/puppet.conf
```conf
[master]
  external_nodes = /usr/bin/atlas-node-classify
```

## Configuration

### Overview

Enc itself does not know anything about how you handle your mapping from "hostnames" to "roles".
This functionality is provided by you, either using one of Enc's builtin provider types, or by writing your own.

Enc looks for manifest files in the following locations:
* /etc/enc/manifests/[role].yaml
* /etc/enc/manifests/[hostname].yaml

These manifests are merged to produce the final, actual manifest for a node. If multiple roles are provided
for a host, the manifests will be merged in the order that the roles are provided. In this way, you can 
easily override defaults provided by a role in order to test specific behaviour on a single server before rolling
it out to all servers.

If no roles are provided for a host, then only the hostname.yaml will be used.

### Host to Role mapping

To specify the mapping, you must write a ruby shim. Create the file /etc/enc/user.rb. As an example (and a 
fairly useful case), Enc provides an out-of-the-box url role provider. You can use it by writing user.rb like so:

```
require 'enc/url_provider'
Enc.role_provider = Enc.url_provider('http://myserver.com/roles')
```

The server is expected to return a JSON array of roles at ```http://myserver.com/roles/[hostname]```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/enc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
