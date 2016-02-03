# Vaultron.co
## What
This is the site (and application for vaultron.co)

## Technology stack (so far)
* Ruby on Rails 4
* MongoID
* Heroku with github autodeploy (and preview branches)

## Setting up
* in command line **sudo vim /etc/hosts (or any of your favorite editors)**
* Ensure you got mongodb running (for your convienience, you can use the script in **mongodockerconfig**)
* Add entry for **localdb** (for example: 192.168.59.103 or 127.0.0.1)
* Save file
* Run **rails s**

### ImageMagic Issues on OS X
* If you have problems doing a bundle install, do a **brew uninstall imagemagick** followed by **brew install imagemagick --disable-openmp**

## Auto-review apps
* The format for pull request review apps is: *https://vaultronvault-pr-XX.herokuapp.com/* (where *XX* is the pull request number)
* Auto-provisioning takes time
* Settings for auto-provisioning is in *app.json*

## Development Notes
This is some notes on what sort of things you can use.

### Environment variables
Please set the following **before** you run the app. Heroku is configured already.

* AWS_ACCESS_KEY (required)
* AWS_SECRET_KEY (required)
* AWS_REGION (optional: defaults to us-east-1)
* S3_BUCKET_NAME (optional: defaults to vaultron-beta-dev)

### Cards model
* cardname - name of the card (string)
* cardcollection - collection where the card belongs to (string)
* cardgame - game where the card belongs to (string)
* photo.url - URL to the original image
* photo.thumb.url - URL to the thumbnail (defined in app/uploaders/cardupload_upload.rb)

### Related to cards
Each card maintains a history of notes and new images.

The idea is images have a history (not visible)

#### Cardnotes model
* text -  General text notes added by the user
* create_date - When the image was created

#### Cardimages model
* image_type - Either 'front' or 'back'
* photo.url - URL to original image (beware might be large)
* photo.thumb.url - URL to the thumbnail (recommended)
* image_note -  General notes about the image
* create_date - When the image was created
