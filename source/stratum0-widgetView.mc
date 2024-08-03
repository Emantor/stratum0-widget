import Toybox.Graphics;
import Toybox.WatchUi;

class stratum0_mainWidgetView extends WatchUi.View {

    var base;
    function initialize(base) {
        View.initialize();
        me.base = base;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        var format = self.base.getFormatData(self.base.getData());
        var drw = self.findDrawableById("status");
        drw.setText(format[0]);
        drw = self.findDrawableById("date");
        drw.setText(format[1]);
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
