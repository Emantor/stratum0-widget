using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;

(:glance)
class WidgetGlanceView extends Ui.GlanceView {

    var data as Null or Array = null;

    function initialize(data) {
      GlanceView.initialize();
      me.data = data as Array;
    }
    
    function onUpdate(dc) {
        System.println("glance: onUpdate()");
    	  dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

        if (data == null) {
          System.println("data is null");
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "No BG data", Graphics.TEXT_JUSTIFY_LEFT);
          return;
        }

        System.println("Accessing data");
        var havedata = data[0] as Boolean;
        if (!havedata) {
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "No valid data", Graphics.TEXT_JUSTIFY_LEFT);
        }
        var open = data[1] as Boolean;
        if (!open) {
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "Stratum 0 closed", Graphics.TEXT_JUSTIFY_LEFT);
        } else {
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "Stratum 0 open", Graphics.TEXT_JUSTIFY_LEFT);
        }

        var openedBy = data[2] as String;
        var since = data[3] as Number;
        var ts1 = new Time.Moment(since);
        var conditions = Weather.getCurrentConditions();
        var location = conditions.observationLocationPosition;
        var moment = Gregorian.localMoment(location, ts1);
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);

        var timeUser = " - ";
        timeUser = Lang.format("$1$, $2$.$3$ $4$:$5$", [
          openedBy,
          info.day.format("%02u"),
          info.month.format("%02u"),
          info.hour.format("%02u"),
          info.min.format("%02u")
        ]);
        dc.drawText(10 ,dc.getHeight() / 2, Graphics.FONT_GLANCE, timeUser, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
