Collections.defaultFilesCollection = new Meteor.Files
  storagePath: 'assets/' #write ro folder where script is executing, note: this folder will be removed after application updates or refresh

Collections.images = new Meteor.Files
  collectionName: 'Images'
  storagePath: 'assets/'
  onBeforeUpload: ->
    allowedExt = ['jpeg', 'jpg', 'png', 'gif']
    true if allowedExt.inArray(@ext) and @size < 10 * 1024 * 1024
  debug: true # Let's see some stats - monitor browser's and server's console