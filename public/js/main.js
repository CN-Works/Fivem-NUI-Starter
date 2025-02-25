$(document).ready(function(){
    // Hide the UI at start
    $("#container").hide();

    function CloseUI() {
        $("#container").hide();
    }

    function OpenUI() {
        $("#container").show();
    }

    window.addEventListener("message", (event) => {
        const data = event.data;

        if (data.type === "close") {
            CloseUI();
            return
        }

        if (data.type === "open") {
            OpenUI();
            return
        }
        
        console.log("Nothing happened.")
    });

    // Closing the ui when pressing escape key
    document.onkeyup = function(data) {
        if (data.which == 27) {
            CloseUI();
        }
    };
});
