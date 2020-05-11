$(function() {
  var file;

  var validateFile = function(file) {
    if (file == undefined) return false;
    if (file.size > 300000000) {
      alert("300 MB以上のファイルをアップロードすることはできません。");
      return false;
    }
    if (!validateFileType(file.type)) {
      alert(file.type + "のファイルタイプはサポートしておりません。可能なファイルタイプ: " + arrowTypes.join(", "))
      return false;
    }
    return true;
  };

  var arrowTypes = ["audio/mpeg", "audio/mp3", "audio/wav"];
  var validateFileType = function(type) {
    var ret = false;
    for (var i=0; i < arrowTypes.length; i++) {
      if (type == arrowTypes[i]) {
        ret = true;
      }
    }
    return ret;
  }

  $(document).on("drop", "#newCmp #drop-zone", function(e) {
    e.preventDefault();
    $(this).removeClass("dragover");
    var tmpfile = e.originalEvent.dataTransfer.files[0];
    if (validateFile(tmpfile)) {
      file = tmpfile;
      $("#drop-zone .desc").text(file.name + " (" + file.type + ")");
    }
  });
  $(document).on("dragover", "#newCmp #drop-zone", function(e) {
    e.preventDefault();
    $(this).addClass("dragover");
  });
  $(document).on("dragleave", "#newCmp #drop-zone", function(e) {
    e.preventDefault();
    $(this).removeClass("dragover");
  });

  $(document).on("click", "#newCmp #upload", function(e) {
    if (!file) return false;
    var $this = $(this);
    $this.hide();

    var filename = 'heroku-' + new Date().getTime();
    var type = file.type;
    if (file.type === 'audio/mpeg') {
      type = 'audo/mp3';
    }
    $.ajax('/upload?name=' + filename + "&type=" + type).done(function(data) {
      console.log(data);
      var formdata = new FormData();
      for (key in data.fields) { formdata.append(key, data.fields[key]); }
      formdata.append("file", file);

      console.log(data.url);
      $.ajax({
        url: data.url,
        data: formdata,
        processData: false,
        contentType: false,
        method: 'post'
      }).done(function() {
        console.log("transcribe");
        // aws upload
        $.ajax({
          url: "/transcribe",
          data: {
            name: filename,
            uri: data.url + "/upload/" + filename,
            format: type.split("/")[1],
            lang: $("#lang").val(),
            number: $("#number").val()
          },
          method: 'post'
        }).done(function(res) {
          console.log(res);
          window.location.href = window.location.origin;
        }).fail(function(err) {
          $("#drop-zone .desc").text("失敗: " + err.message);
          $this.show();
        });

      }).fail(function(err) {
        console.log(err);
        $("#drop-zone .desc").text("失敗: " + err.message);
        $this.show();
      });
    });

  });
});
