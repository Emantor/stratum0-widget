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
    var base;

    function initialize(base, data) {
      GlanceView.initialize();
      me.data = data as Array;
      me.base = base;
    }
    
    function onUpdate(dc) {
        System.println("glance: onUpdate()");
    	  dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

        if (data == null) {
          System.println("data is null");
          dc.drawText(0 ,0 , Graphics.FONT_GLANCE, "No BG data", Graphics.TEXT_JUSTIFY_LEFT);
          return;
        }

        System.println("Accessing data");
        var havedata = data[0] as Boolean;
        if (data.size() < 4 or !havedata) {
          dc.drawText(0 ,0 , Graphics.FONT_GLANCE, "No valid data", Graphics.TEXT_JUSTIFY_LEFT);
          return;
        }

        var format = self.base.getFormatData(data);

        dc.drawText(0 ,0 , Graphics.FONT_GLANCE, format[0], Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(0 ,dc.getHeight() / 2, Graphics.FONT_GLANCE, format[1], Graphics.TEXT_JUSTIFY_LEFT);
    }
}
