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

### Templating variables
#### Getting the current user
**current_user.accounttype**
This gets the current account type which can be:
* standard - standard user for collector
* vendor - standard user for shopkeepers (and other B2B type users)
* admin - can't be signed up with. This will come at a later date. For now we just edit the database.

**current_user.identity_verified**
This shows the verification status for the user. They are either verified or not verified.

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

#### Cardgame model
* gamename

##### How to create
In either **rails console** or **heroku run rails console** do the following
```ruby
Cardgame.create(gamename: "Magic: The Gathering")
```

#### Cardcollection model
* collectname
##### About
This is currently not in use, but eventually we will use this

##### How to create
In either **rails console** or **heroku run rails console** do the following
```ruby
Cardcollection.create(collectionname: "Default collection")
```


#### Cardcondition model
* condition

##### How to create
In either **rails console** or **heroku run rails console** do the following
```ruby
Cardcondition.create(condition: "Mint")
Cardcondition.create(condition: "Slightly Worn")
Cardcondition.create(condition: "Worn")
Cardcondition.create(condition: "Damaged")
```
