$(document).ready(function () {
    $("#slider1").s3Slider({
        timeOut: 8000
    });

    $("#frmLogin input").keypress(function (event) {
        var code = (event.keyCode ? event.keyCode : event.which);
        if(code == 13){
            
        }
    });
});