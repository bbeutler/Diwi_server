# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.12.0] - 2020-10-27

- Additional testing and documentation added for API
- Date range filter and keyword search for looks works as expected

## [0.11.0] - 2020-10-23

- Looks can save multiple photos on update and create requests
- Looks need to have at least one photo
- Tag titles validation uniqueness by consumer
- Global search includes months to filter looks by
- Global search includes filtering by tag (friend)
- Global search keyword search updated


## [0.10.0] - 2020-10-16

- Looks have a location attribute
- Looks have many photos
- Photos belong to one look
- User needs to enter their password to update their account details
- No consumer fields required at this time
- Adding friends to looks should be the same as before
- Cleans up database of all unneeded tables

## [0.9.1] - 2020-07-16

### Fixed

- Thumbnail images in Events index view

## [0.9.0] - 2020-03-05

### Added

- User can create looks from multiple clothing items
- Tag model exapnded to include looks, clothing items and events
- Updated Clothing Items adding looks, dates_worn and note
- Add Elastic Search for User Content
- Add Push notifications
- Add Group messaging

## [0.8.4] - 2020-02-12

### Removed

- Clothing Item type_of is now optional

## [0.8.3] - 2020-01-20

### HotFix

- Fixed bug when event has no location and location params sent to edit event endpoint
- Create a new location for event if no location is present

## [0.8.2] - 2020-01-15

### Added

- Added Event Tag Serializer
- Event Update Form can now create and
  destroy event tags and event clothing items

## [0.8.1] - 2020-01-15

### Added

- User update form object and update user update spec

## [0.8.0] - 2020-01-13

### Added

- Updates event clothing item serializer
- Adds clothing types endpoint

## [0.7.0] - 2019-07-30

### Added

- Sample clothes for staging users and their events

## [0.6.0] - 2019-07-26

### Added

- Renders user and profile along with jwt during login

## [0.5.1] - 2019-07-25

### Fixed

- No authenticity token verification for user_token route

## [0.5.0] - 2019-07-24

### Added

- Event clothing item routes
- New routes for Clothing and Event
- New clothing types
- Updates abilities, model, and controllers across app
- Updates specs and docs

### Fixed

- Updates to location and event tables

## [0.4.0] - 2019-07-22

### Added

- Enables Rails views for password update form
- Carrierwave and mailchimp configuration
- Namespaces api controllers to `api/v1`
- Terms and terms acceptance routes and models

### Fixed

- Updates config files for 5.2

## [0.3.0] - 2019-07-15

### Added

- Events, Locations, Clothing Items
- Rake task to add all sample data

## [0.2.0] - 2019-07-08

### Added

- Username to Consumer Model

### Fixed

- Swagger nested models

## [0.1.0] - 2019-07-08

### Added

- Rollbar error reporting for staging and production environments

### Fixed

- Swagger implementation on staging
