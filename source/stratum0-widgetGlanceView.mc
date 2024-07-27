using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.Lang;
import Toybox.Test;

(:glance)
class WidgetGlanceView extends Ui.GlanceView {

    var data = null;

    function initialize(data) {
      GlanceView.initialize();
      me.data = data;
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
        var open = data[0];
        var openedBy = data[1];
        var since = data[2];

        if (!open) {
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "Stratum 0 closed", Graphics.TEXT_JUSTIFY_LEFT);
        } else {
          dc.drawText(10 ,0 , Graphics.FONT_GLANCE, "Stratum 0 open", Graphics.TEXT_JUSTIFY_LEFT);
        }
        
        var timeUser = Lang.format("$1$, $2$", [openedBy, since]);
        dc.drawText(10 ,dc.getHeight() / 2, Graphics.FONT_GLANCE, timeUser, Graphics.TEXT_JUSTIFY_LEFT);
    }

}