#Define reactive vars for form states
defaultUploadState    = new ReactiveVar false

imageUploadState     = new ReactiveVar false
imageUploadError     = new ReactiveVar false
imageUploadProgress  = new ReactiveVar false

Template.index.onRendered ->
  # Highlight code examples
  $('pre').each (i, block) ->
    hljs.highlightBlock block

Template.index.events
  'change #defaultUpload': (e, template) ->
    _.each e.currentTarget.files, (file) ->
      Collections.defaultFilesCollection.insert 
        file: file
        meta: {}
        onUploaded: (error, fileObj) ->
          throw new Meteor.Error 500, error if error
          # Unbind previously uploaded file from `file` input
          template.$(e.target).val ''
          template.$(e.currentTarget).val ''
          # Show uploaded file link
          defaultUploadState.set fileObj

  'change #imageUpload': (e, template) ->
    imageUploadError.set false
    _.each e.currentTarget.files, (file) ->
      done = false
      Collections.images.insert
        file: file
        meta: {}
        onUploaded: (error, fileObj) ->
          if error
            imageUploadError.set error
            throw new Meteor.Error 400, error

          done = true
          # Unbind previously uploaded file from `file` input
          template.$(e.target).val ''
          template.$(e.currentTarget).val ''

          # Show uploaded image
          imageUploadProgress.set false
          imageUploadState.set fileObj
        onBeforeUpload: ->
          allowedExt = ['jpeg', 'jpg', 'png', 'gif']
          if allowedExt.inArray(@ext) and @size < 10 * 1024 * 1024
            true
          else
            "Please upload file in next formats: #{allowedExt.join(', ')} with size less than 10 Mb. You have tried to upload file with \"#{@ext}\" extension and with \"#{Math.round((@size/(1024*1024)) * 100) / 100}\" MB"
        onProgress: (progress) ->
          if not done
            imageUploadProgress.set "#{progress}"
          else
            imageUploadProgress.set false

Template.index.helpers
  defaultUploadState: ->
    defaultUploadState.get()
  imageUploadProgress: ->
    imageUploadProgress.get()
  imageUploadError: ->
    imageUploadError.get()
  imageUploadState: ->
    imageUploadState.get()