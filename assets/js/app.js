// SPDX-License-Identifier: AGPL-3.0                      
// Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org> 
//   _____            _              _____                
//  / ____|          | |            |  __ \               
// | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __  
//  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__| 
//  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |    
// |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|    
//                              __/ |                     
//                             |___/
//
// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// SentryPeerHQ JavaScript
import SentrypeerApiLoggerRealtime from "./api_logger_realtime"
import SentrypeerCalHeatmap from "./cal_heatmap"

let Hooks = {
    SentrypeerApiLoggerRealtime: SentrypeerApiLoggerRealtime,
    SentrypeerCalHeatmap: SentrypeerCalHeatmap
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    hooks: Hooks,
    params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.delayedShow(200))
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// SentryPeerHQ JavaScript
// Copy to clipboard
window.addEventListener("sentrypeerhq:copy_client_secret", (event) => {
    if ("clipboard" in navigator) {
        const text = event.target.value;
        const copy_button = document.getElementById("copy_client_secret_button");
        navigator.clipboard.writeText(text).then(() => {
            copy_button.classList.add("has-tooltip");
            setTimeout(() => {
                copy_button.classList.remove("has-tooltip");

            }, 2000);
        });
    } else {
        alert("Sorry, your browser does not support the clipboard copy feature.");
    }
});

// Dark mode
function darkExpected() {
    return localStorage.theme === 'dark' || (!('theme' in localStorage) &&
        window.matchMedia('(prefers-color-scheme: dark)').matches);
}

function initDarkMode() {
    // On page load or when changing themes, best to add inline in `head` to avoid FOUC
    if (darkExpected()) document.documentElement.classList.add('dark');
    else document.documentElement.classList.remove('dark');
}

window.addEventListener("toogle-darkmode", e => {
    if (darkExpected()) localStorage.theme = 'light';
    else localStorage.theme = 'dark';
    initDarkMode();
})

initDarkMode();

// GScroll To Top
let scrollToTopButton = document.getElementById("btn-back-to-top");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function () {
    scrollFunction();
};

function scrollFunction() {
    if (
        document.body.scrollTop > 20 ||
        document.documentElement.scrollTop > 20
    ) {
        scrollToTopButton.style.display = "block";
    } else {
        scrollToTopButton.style.display = "none";
    }
}

// When the user clicks on the button, scroll to the top of the document
scrollToTopButton.addEventListener("click", backToTop);

function backToTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}

