$(document).ready(function(){
    // Hide the UI at start
    $("#container").hide();

    function CloseUI() {
        $("#container").hide();
    }

    window.addEventListener("message", (event) => {
        const data = event.data;

        if (data.type === "close") {
            CloseUI();
        }
    
    });

    // Closing the ui when pressing escape key
    document.onkeyup = function(data) {
        if (data.which == 27) {
            CloseUI();
        }
    };
});
