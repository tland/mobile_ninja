# MobileNinja

Mobile Ninja makes it easy to detect mobile devices that access your rails applications. It allows you to write a different set of mobile-specific view templates and automatically serves the mobiles with those view templates.

## Installation

Add this line to your application's Gemfile:

    gem 'mobile_ninja'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mobile_ninja

## Usage

To enable Mobile Ninja, add this line to your application controller:

```
class ApplicationController < ActionController::Base
  enable_mobile_ninja
end
```

Then you can write new view templates for mobile devies and place them in the following directory.
```
app/views_mobile/
```
