/**
 * Created by jari on 19/07/15.
 * Too lazy to also do this in coffeescript or any fancy framework...
 */

$(document).ready(function () {
  $.get("/async/match", function (data) {
    var html = Handlebars.compile($("#matches-template").html())({ matches: data, nothing: !data.length })
    $("#matches").html(html)

    $(".loading").fadeOut(function() {
      $(".done-loading").fadeIn();
    })

    var subtemplate = Handlebars.compile($("#subdiag-template").html())
    $(document).on('click', ".submodal", function() {
      var subreddits = $(this).attr("data-subreddits").split(",");
      subreddits.pop()
      $("#subDiag .modal-body").html(subtemplate({ subreddits: subreddits }));
      $("#subDiag").modal();
    });
  })
})
