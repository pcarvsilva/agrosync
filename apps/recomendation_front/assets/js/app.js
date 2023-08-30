// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"

// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import { BarChart } from "./bar_chart"

let Hooks = {}

let scrollAt = () => {
  let scrollTop = document.documentElement.scrollTop || document.body.scrollTop
  let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight
  let clientHeight = document.documentElement.clientHeight

  return scrollTop / (scrollHeight - clientHeight) * 100
}


Hooks.InfiniteScroll = {
  page() { return this.el.dataset.page },
  mounted() {
    this.pending = this.page()
    window.addEventListener("scroll", e => {
      if (this.pending == this.page() && scrollAt() > 90) {
        this.pending = this.page() + 1
        this.pushEvent("load-more", { page: this.page })
      }
    })
  },
  reconnected() { this.pending = this.page() },
  updated() { this.pending = this.page() }
}

export const InfiniteScroll = {
  page() {
    return this.el.dataset.page;
  },
  loadMore(entries) {
    const target = entries[0];
    if (target.isIntersecting && this.pending == this.page()) {
      this.pending = this.page() + 1;
      this.pushEvent("load-more", {});
    }
  },
  mounted() {
    this.pending = this.page();
    this.observer = new IntersectionObserver(
      (entries) => this.loadMore(entries),
      {
        root: null, // window by default
        rootMargin: "0px",
        threshold: 1.0,
      }
    );
    this.observer.observe(this.el);
  },
  beforeDestroy() {
    this.observer.unobserve(this.el);
  },
  updated() {
    this.pending = this.page();
  },
};
Hooks.BarChart = BarChart

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks, })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "rgb(22 163 74)" }, shadowColor: "rgba(0, 0, 0, .3)" })


let topBarScheduled = undefined;
window.addEventListener("phx:page-loading-start", () => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 120);
  };
});
window.addEventListener("phx:page-loading-stop", () => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
