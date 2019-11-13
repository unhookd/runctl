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
      indicateProgress(dashboardContainer);
    }

    fetch('?p=1')
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
              el.scrollTop = el.scrollHeight;
              el.classList.add('terminal-pinged');
              setTimeout(function() {
                el.classList.remove('terminal-pinged');
              }, 333);
            }, 33);
          }
        }
      });

      setTimeout(refreshIndex, 1000);
    })
    .catch(e => {
      console.log('There has been a problem with your fetch operation: ' + e.message);
      indicateProgress(dashboardContainer);
    });
  };

  refreshIndex(true);

});
