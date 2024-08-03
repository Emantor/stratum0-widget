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
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new stratum0_mainWidgetView(self), new stratum0_mainWidgetDelegate() ];
    }

    function getData() {
        return Storage.getValue("bgdata");
    }
    function getGlanceView() {
        var data = Storage.getValue("bgdata");
        if (data) {
            System.println("Starting glance with data");
            glance = new $.WidgetGlanceView(self, data);
        } else {
            System.println("Starting glance with null");
            glance = new $.WidgetGlanceView(self, null);
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

    public function getFormatData(data) {
        if (!data[0]) {
            return ["", ""];
        }

        var open = data[1] as Boolean;
        var openedBy = data[2] as String;
        var openStatus;

        if (!open) {
            openStatus = Lang.format("$1$: $2$", [
                "Closed",
                openedBy
            ]);
        } else {
            openStatus = Lang.format("$1$: $2$", [
                "Open",
                openedBy
            ]);
        }
        var since = data[3] as Number;
        var location = new Position.Location({
            :latitude =>  52.266666,
            :longitude => 10.516667,
            :format => :degrees
        });
        var moment = null;

        moment = Gregorian.localMoment(location, since);

        var info;
        if (moment != null) {
            info = Gregorian.info(moment, Time.FORMAT_SHORT);
        } else {
            var ts1 = new Time.Moment(since);
            info = Gregorian.info(ts1, Time.FORMAT_SHORT);
        }

        var timeUser = Lang.format("$1$.$2$. $3$:$4$", [
            info.day.format("%02u"),
            info.month.format("%02u"),
            info.hour.format("%02u"),
            info.min.format("%02u")
        ]);
        return [openStatus, timeUser];
    }
}

function getApp() as stratum0_widgetApp {
    return Application.getApp() as stratum0_widgetApp;
}
