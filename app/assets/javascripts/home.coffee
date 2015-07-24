# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $(document).ready ->
    # setInterval () ->
    #     a = ['WOOHOO!', 'YAY!', 'HOORAY!']
    #     w = a[Math.floor(Math.random()*a.length)];
    #     $('#phrase').text(w)
    # , 2000

div_id_class = (id, class_, content) ->
  "<div id=#{id} class=#{class_}>#{content}</div>"
div_id = (id, content) ->
  "<div id=#{id}>#{content}</div>"
div_class = (class_ , content) ->
  "<div class=#{class_}>#{content}</div>"
div = (content) ->
  "<div>#{content}</div>"
user_profile = (user) ->
  "<img src='#{user.avatar_url}'/> #{user.name}"
img = (url) ->
  "<img src='#{url}'/>"
append_commentinput = (article) ->
  $("#comment_#{article.id}").append div_id_class("error_#{article.id}","error","")
  x = document.createElement("TEXTAREA")
  x.setAttribute("id", "input_#{article.id}_body")
  x.setAttribute("placeholder","Comment here!")
  $("#comment_#{article.id}").append x
  $("#comment_#{article.id}").append div_id_class("input_#{article.id}","pointer","Enter")
  $("#input_#{article.id}").on "click", (event) ->
    id = event.target.id.split "_"
    $.ajax
      url: "/comment"
      data: {comment: {user_id: gon.current_user.id , article_id: id[1], body: $("#input_#{id[1]}_body").val()}}
      type: "post"
      dataType: "json"
      success: (data, textStatus, jqXHR) ->
        if data.error
          $("#error_#{id[1]}").html(data.error.body)
        else
          # console.log data.comment
          append_comment(data.comment)
          $("#input_#{data.comment.article_id}_body").val("")

append_toggleComments = (article) ->
  $("#article_#{article.id}").append div_id_class("comment_#{article.id}_button","pointer","Comments")
  $("#comment_#{article.id}_button").on "click", (event) ->
    id = event.target.id.split "_"
    $("#comment_#{id[1]}").slideToggle()


user_div = (article,append_div) ->
  $.ajax
    url: "/home/find_user"
    data: {ownerid: article.user_id,articleif}
    type: "POST"
    dataType: "JSON"
    error: (jqXHR, textStatus, errorThrown) ->
    #  $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      $("#{append_div}").append div(user_profile(data.user))
      $("#{append_div}").append div(img(article))
      $("#{append_div}").append div(article.body)

appendtableEDc = (comment) ->
  innerhtml = "<table><tr><td>" + div_id_class("edit_#{comment.id}","pointer","Edit") + "</td><td>" +  div_id_class("destroy_#{comment.id}","pointer","Destroy") + "</td></tr></table>"
  $("#comment_#{comment.id}").append innerhtml
  $("#destroy_#{comment.id}").on "click", (event) ->
    id = event.target.id.split "_"
    $.ajax
      url: "/comment/#{comment.id}"
      type: "delete"
      success: () ->
        $("#comment_#{id[1]}").remove()
        Deleted_log({article_id: "", comment_id: "#{id[1]}"})

  $("#edit_#{comment.id}").on "click", (event) -> Comment_edit(event)

Comment_edit = (event) ->
  id = event.target.id.split "_"
  text = $("#comment_#{id[1]}_body").text()
  $("#comment_#{id[1]}_body").html("")
  x = document.createElement("TEXTAREA")
  x.setAttribute("id", "edit_#{id[1]}_body")
  $("#comment_#{id[1]}_body").append x
  $("#edit_#{id[1]}_body").val(text)
  $("#edit_#{id[1]}").html("OK")
  $("#edit_#{id[1]}").off "click"
  $("#edit_#{id[1]}").on "click", (event) -> Comment_edit_update(event,text)

Comment_edit_update = (event,text) ->
  id = event.target.id.split "_"
  edit_text = $("#edit_#{id[1]}_body").val()
  if edit_text isnt text and edit_text isnt ""
    $.ajax
      url: "/comment/#{id[1]}"
      data: {body: edit_text}
      type: "PATCH"
    $("#comment_#{id[1]}_body").html(edit_text)
  else
    $("#comment_#{id[1]}_body").html(text)
  $("#edit_#{id[1]}").html("Edit")
  $("#edit_#{id[1]}").off "click"
  $("#edit_#{id[1]}").on "click", (event) -> Comment_edit(event)

appendtableED = (article) ->
  innerhtml =  "<table><tr><td>" + div_id_class("edit_#{article.id}","pointer","Edit") + "</td><td>" +  div_id_class("destroy_#{article.id}","pointer","Destroy") + "</td></tr></table>"
  $("#article_#{article.id}").append innerhtml
  $("#destroy_#{article.id}").on "click", (event) ->
    id = event.target.id.split "_"
    $.ajax
      url: "/home/#{article.id}"
      type: "delete"
      success: () ->
        $("#article_#{id[1]}").remove()
        Deleted_log({article_id: "#{id[1]}", comment_id: ""})


  $("#edit_#{article.id}").on "click", (event) ->  Article_edit(event)

Article_edit = (event) ->
  id = event.target.id.split "_"
  text = $("#article_#{id[1]}_body").text()
  $("#article_#{id[1]}_body").html("")
  x = document.createElement("TEXTAREA")
  x.setAttribute("id", "edit_#{id[1]}_body")
  $("#article_#{id[1]}_body").append x
  $("#edit_#{id[1]}_body").val(text)
  $("#edit_#{id[1]}").html("OK")
  $("#edit_#{id[1]}").off "click"
  $("#edit_#{id[1]}").on "click", (event) -> Article_edit_update(event)
Article_edit_update = (event) ->
  id = event.target.id.split "_"
  edit_text = $("#edit_#{id[1]}_body").val()
  $.ajax
    url: "/home/#{id[1]}"
    data: {body: edit_text}
    type: "PATCH"
  $("#article_#{id[1]}_body").html(edit_text)
  $("#edit_#{id[1]}").html("Edit")
  $("#edit_#{id[1]}").off "click"
  $("#edit_#{id[1]}").on "click", (event) -> Article_edit(event)

append_comment = (comment) ->
  $("#commentContent_#{comment.article_id}").append div_id("comment_#{comment.id}",img(comment.avatar_url)+comment.user.name+div_id("comment_#{comment.id}_body",comment.body))
  if gon.current_user.id == comment.user_id
    appendtableEDc(comment)

Deleted_log = (object) ->
  # console.log object
  $.ajax
    url: "/home/deleted"
    type: "post"
    data: {data: object}
    dataType: "JSON"
    error: (jqXHR, textStatus, errorThrown) ->
    #  $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->

CreateArticle = (article) ->
  $("#article_block").prepend div_id("CompleteArticle_#{article.id}","")
  $("#CompleteArticle_#{article.id}").append div_id_class("article_#{article.id}","article","")
  $("#article_#{article.id}").append div(img(article.owner_avatar_url)+article.owner.name)
  $("#article_#{article.id}").append div(img(article.avatar_url))
  $("#article_#{article.id}").append div_id("article_#{article.id}_body",article.body)
  if gon.current_user.id == article.user_id
    appendtableED(article)
  append_toggleComments(article)
  $("#CompleteArticle_#{article.id}").append div_id_class("comment_#{article.id}","article_comments","")
  $("#comment_#{article.id}").append div_id("commentContent_#{article.id}","")
  for comment in article.comments
    append_comment(comment)
  append_commentinput(article)

append_removebutton = (mutual_friend) ->
  $("#friend_#{mutual_friend.id}").append div_id_class("remove_#{mutual_friend.id}","pointer","Remove")
  $("#remove_#{mutual_friend.id}").on "click",(event) ->
    change_friendstate("remove",gon.current_user.id,mutual_friend.id)
    $("#friend_#{mutual_friend.id}").remove()
    $("#not").append div_id("friend_#{mutual_friend.id}",user_profile(mutual_friend))
    append_addbutton(mutual_friend)
append_confirmedbutton = (unconfirmed_friend) ->
  innerhtml = "<table><tr><td>" + div_id_class("OK_#{unconfirmed_friend.id}","pointer","confirm") + "</td><td>" +  div_id_class("NO_#{unconfirmed_friend.id}","pointer","reject") + "</td></tr></table>"
  $("#friend_#{unconfirmed_friend.id}").append innerhtml
  $("#OK_#{unconfirmed_friend.id}").on "click",(event) ->
    change_friendstate("confirm",gon.current_user.id,unconfirmed_friend.id)
    $("#friend_#{unconfirmed_friend.id}").remove()
    $("#mutual").append div_id("friend_#{unconfirmed_friend.id}",user_profile(unconfirmed_friend))
    append_removebutton(unconfirmed_friend)
  $("#NO_#{unconfirmed_friend.id}").on "click",(event) ->
    change_friendstate("reject",gon.current_user.id,unconfirmed_friend.id)
    $("#friend_#{unconfirmed_friend.id}").remove()
    $("#not").append div_id("friend_#{unconfirmed_friend.id}",user_profile(unconfirmed_friend))
    append_addbutton(unconfirmed_friend)
append_addbutton = (not_friend) ->
  $("#friend_#{not_friend.id}").append div_id_class("add_#{not_friend.id}","pointer","Add")
  $("#add_#{not_friend.id}").on "click",(event) ->
    change_friendstate("add",gon.current_user.id,not_friend.id)
    $("#friend_#{not_friend.id}").remove()


change_friendstate = (state,userID,friendID) ->
  $.ajax
    url: "/home/change_friendstate"
    type: "post"
    data: {state: state, user_id: userID, friend_id: friendID}
    dataType: "JSON"
    error: (jqXHR, textStatus, errorThrown) ->
    #  $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log data

create_list = (mutual_friends,unconfirmed_friends,not_friends) ->
  for mutual_friend in mutual_friends
    $("#mutual").append div_id("friend_#{mutual_friend.id}",user_profile(mutual_friend))
    append_removebutton(mutual_friend)

  for unconfirmed_friend in unconfirmed_friends
    $("#unconfirmed").append div_id("friend_#{unconfirmed_friend.id}",user_profile(unconfirmed_friend))
    append_confirmedbutton(unconfirmed_friend)

  for not_friend in not_friends
    $("#not").append div_id("friend_#{not_friend.id}",user_profile(not_friend))
    append_addbutton(not_friend)

jQuery ->
  console.log gon.not_friends
  console.log gon.mutual_friends
  console.log gon.unconfirmed_friends

$(document).ready ->
  for article in gon.articles
    CreateArticle(article)
  create_list(gon.mutual_friends, gon.unconfirmed_friends, gon.not_friends)




refreshpage = ->
  $.ajax
    url: "/home/searchnew"
    type: "get"
    dataType: "JSON"
    error: (jqXHR, textStatus, errorThrown) ->
    #  $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      # console.log data.articles
      for article in data.articles
        if document.getElementById("CompleteArticle_#{article.id}")
          $("#article_#{article.id}_body").html(article.body)
          # Temp_A = $("#CompleteArticle_#{article.id}").clone()
          $("#CompleteArticle_#{article.id}").remove()
          CreateArticle(article)
        else
          CreateArticle(article)
      for comment in data.comments
        if document.getElementById("comment_#{comment.id}")
          $("#comment_#{comment.id}_body").html(comment.body)
        else
          append_comment(comment)
        if gon.current_user.id isnt comment.user_id
          if $("#comment_#{comment.article_id}").css('display') is 'none'
            $("#comment_#{comment.article_id}").slideToggle()

      for deleted in data.deleteds
        if deleted.article_id
          $("#CompleteArticle_#{deleted.article.id}").remove()
        else
          $("#comment_#{deleted.comment_id}").remove()
      $("#mutual").html("")
      $("#unconfirmed").html("")
      $("#not").html("")
      create_list(data.mutual_friends, data.unconfirmed_friends, data.not_friends)
setInterval refreshpage, 1000*10
