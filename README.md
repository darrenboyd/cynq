# Cynq

Easy synchronization of local files to cloud based storage.

Built on top of the Fog gem.

Note that this is an early release, and only supports AWS for remotes.

## Installation

Add this line to your application's Gemfile:

    gem 'cynq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cynq

## Configuration

Cynq works best with 'project' directories.  A directory that contains another directory
that contains what you want to upload to remote storage.  Your ```cynq.yml```
configuration file will live in your project directory.

For example, if you had...

    project_dir/
      source_files/
      build/
        index.html
        styles/style.css
      cynq.yml

A sample configuration file would look like...

```yaml
---
local_root: build
remotes:
  production:
    directory: www.my-site-bucket.com
  beta:
    directory: beta.my-site-bucket.com
```

This would instruct cynq to upload the contents of the ```build``` directory.
The ```build``` directory itself is not uploaded, making your ```index.hml```
file at the 'top-level' of your bucket.

You also need AWS key information in your environment.  Make sure to do something
like the following (e.g. for bash)...

    export AWS_ACCESS_KEY_ID=your_key_id
    export AWS_SECRET_ACCESS_KEY=your_keys_secret


## Usage

The following command uploads to the remote destination described as *beta*.

    $ cynq deploy beta

If you just want to see what would happen...

    $ cynq deploy --dry-run beta


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
