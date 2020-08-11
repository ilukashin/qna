$(document).on('turbolinks:load',function (){

    $('.rating').on('ajax:success', function (e) {
        var xhr = e.detail[2]
        $('#rating', this).html(xhr.responseText)
    });
});
