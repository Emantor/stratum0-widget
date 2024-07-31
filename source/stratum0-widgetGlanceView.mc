using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.Test;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;
import Toybox.Position;

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
        if (data.size() < 4 or !havedata) {
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "No valid data", Graphics.TEXT_JUSTIFY_LEFT);
          return;
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
        dc.drawText(10 ,0 , Graphics.FONT_GLANCE, openStatus, Graphics.TEXT_JUSTIFY_LEFT);

        var since = data[3] as Number;
        var ts1 = new Time.Moment(since);
        var location = new Position.Location({
          :latitude =>  52.266666,
          :longitude => 10.516667,
          :format => :degrees
        });
        var moment = Gregorian.localMoment(location, ts1);
        var info;
        if (moment != null) {
          info = Gregorian.info(moment, Time.FORMAT_SHORT);
        } else {
          info = Gregorian.info(ts1, Time.FORMAT_SHORT);
        }

        var timeUser = Lang.format("$1$.$2$. $3$:$4$", [
          info.day.format("%02u"),
          info.month.format("%02u"),
          info.hour.format("%02u"),
          info.min.format("%02u")
        ]);
        dc.drawText(10 ,dc.getHeight() / 2, Graphics.FONT_GLANCE, timeUser, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
