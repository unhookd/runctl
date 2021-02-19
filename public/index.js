/* */

window.addEventListener('DOMContentLoaded', (contentLoadedEvent) => {

  var dashboardContainer = document.getElementById("dashboard-container")

  var indicateProgress = function(element) {
    var progressIndicator = document.createElement("progress");

    while (element.firstChild) {
      element.removeChild(element.firstChild);
    }

    element.appendChild(progressIndicator);
  };

  var refreshIndex = function(firstTime) {
    if(firstTime) {
      //indicateProgress(dashboardContainer);
      setTimeout(refreshIndex, 100);
      return;
    }

    var searchParams = new URLSearchParams(window.location.search);

    fetch('?p=1' + '&pod=' + (searchParams.get("pod") || '') + '&c=' + (searchParams.get("c") || ''))
    .then(response => {
      return response.text()
    })
    .then(dashboardHtml => {
      morphdom(dashboardContainer, dashboardHtml, {
        childrenOnly: true,
        onNodeAdded: function(el) {
          el.scrollTop = el.scrollHeight;
        },
        onBeforeElUpdated: function(fromEl, toEl) {
          if (fromEl.isEqualNode(toEl)) {
            return false
          }

          return true
        },
        onElUpdated: function(el) {
          if (el.className === 'terminal') {
            setTimeout(function() {
              //el.scrollTop = el.scrollHeight;

              //if (Math.abs(el.getBoundingClientRect().bottom - window.innerHeight) < (window.innerHeight * 0.25)) {
              //  el.scrollIntoView({behavior: "auto", block: "end", inline: "nearest"});
              //}

              el.scrollIntoView(false);
              //var ns = "margin-top: " + (-parseInt(el.clientHeight) + 256) + "px";
              //el.style = ns;

              el.classList.add('terminal-pinged');
              setTimeout(function() {
                el.classList.remove('terminal-pinged');
              }, 333);
            }, 0);
          }
        }
      });

      setTimeout(refreshIndex, 500);
    })
    .catch(e => {
      console.log('There has been a problem with your fetch operation: ' + e.message);
      indicateProgress(dashboardContainer);
    });
  };

  refreshIndex(true);

});
