import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.Communications;
import Toybox.System;
import Toybox.Time;
import Toybox.Application.Storage;

(:background)
class StratumBackgroundDelegate extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
    }

    public function onTemporalEvent() as Void {
        fetchdata();
    }

    function fetchdata() {
        var url = "https://status.stratum0.org/status.json";
        var params = null;
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

   function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
     if (responseCode != 200) {
        Background.exit([false, null, null, null]);
     }

     var state = null;
     var open = false;
     var trigger = null;
     var lastchange = null;

     state = data.get("state") as Dictionary;
     open = state.get("open");
     trigger = state.get("trigger_person");
     lastchange = state.get("lastchange") as Number;
     System.println("Have data, exiting");
     Background.exit([true, open, trigger, lastchange]);
    }

}
(:background, :glance)
class stratum0_widgetApp extends Application.AppBase {

    var glance = null;
    var background = null;

    function initialize() {
        AppBase.initialize();
        if(Background.getTemporalEventRegisteredTime() == null) {
            Background.registerForTemporalEvent(new Time.Duration(5 * 60));
        }
        background = new $.StratumBackgroundDelegate();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("Startup");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new stratum0_widgetView() ];
    }

    function getGlanceView() {
        var data = Storage.getValue("bgdata");
        if (data) {
            System.println("Starting glance with data");
            glance = new $.WidgetGlanceView(data);
        } else {
            System.println("Starting glance with null");
            glance = new $.WidgetGlanceView(null);
        }
        return [ glance ];
    }

    function onBackgroundData(data) {
        System.println("Got BG data");
        if (data instanceof Number) {
            System.println("Error receiving background data");
        }
        Storage.setValue("bgdata", data);
    }

    public function getServiceDelegate() {
        return [background];
    }
}

function getApp() as stratum0_widgetApp {
    return Application.getApp() as stratum0_widgetApp;
}
