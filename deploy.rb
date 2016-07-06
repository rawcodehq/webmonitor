#!/usr/bin/env ruby

# Deploy script
# 0. Bump the version
# 0.1 Commit the mix file
# 1. Build the release
# 2. Build the digests
# 3. SCP over the release tarball
# 4. Extract it on the server
# 5. Restart the server

# 0. Bump the version
current_version = File.read("mix.exs").lines.grep(/version/).first.gsub(/.*"(.*)".*/, '\1').strip
version_tokens = current_version.split(".")
patch = version_tokens.last.strip.to_i + 1
prefix = version_tokens[0..-2].join(".")
new_version = [prefix, patch].join(".")
puts new_version
cmd = "sed -i -e 's/\"#{current_version}\"/\"#{new_version}\"/' mix.exs"
system cmd

# 1. Build the release
# 2. Build the digests
system "MIX_ENV=prod mix compile phoenix.digest release"

# 3. SCP over the release tarball
system "scp webmonitor@webmonitorhq.com "
# 4. Extract it on the server
# 5. Restart the server
