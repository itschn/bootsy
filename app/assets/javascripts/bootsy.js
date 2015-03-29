//= require jquery.remotipart
//= require bootsy/polyfill
//= require bootsy/wysihtml5
//= require bootsy/bootstrap-wysihtml5
//= require bootsy/bootsy
//= require bootsy/bootstrap.file-input
//= require bootsy/init
//= require bootsy/editor_options
//= require bootsy/translations


window.BootsyFileupload = window.BootsyFileupload || {};

BootsyFileupload.init = function() {
  var fails, fileCount, filesToUpload, reloadPage, successes;
  filesToUpload = 0;
  fileCount = 0;
  fails = 0;
  successes = 0;
  reloadPage = $('[data-fileupload]').data('fileupload') === 'reload-page';
  return $('[data-fileupload]').fileupload({
    autoUpload: true,
    previewMaxheight: 10,
    previewMaxwidth: 10,
    limitConcurrentUploads: 0,
    disableVideoPreview: true,
    disableImagePreview: true,
    uploadTemplateId: 'bootsy-template-upload',
    downloadTemplateId: 'bootsy-template-download',
    progress: function(e, data) {
      var progress;
      if (data.context) {
        progress = parseInt(data.loaded / data.total * 100, 10);
        return data.context.find('.progress-bar').css('width', progress + '%');
      }
    }
  }).bind('fileuploadadd', function(e, data) {
    filesToUpload++;
  }).bind('fileuploaddone', function(e, data) {
    fileCount++;
    successes++;
    if (reloadPage && fileCount === filesToUpload) {
      location.reload();
    }
  });
};