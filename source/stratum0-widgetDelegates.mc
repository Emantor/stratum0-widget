//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This delegate is for the main page of our application that pushes the menu
//! when the onMenu() behavior is received.
class stratum0_mainWidgetDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onSelect() as Boolean {
        return self.onMenu();
    }
    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        // Generate a new Menu with a drawable Title
        var menu = new WatchUi.Menu2({:title=> "Stratum 0"});

        // Add menu items for demonstrating toggles, checkbox and icon menu items
        menu.addItem(new WatchUi.MenuItem("Open", "Open door", "open", null));
        menu.addItem(new WatchUi.MenuItem("Close", "Close door", "close", null));
        menu.addItem(new WatchUi.MenuItem("Claim", "Takeover space", "claim", null));
        WatchUi.pushView(menu, new $.stratum0_menuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class stratum0_menuDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item as WatchUi.MenuItem) {
        return;
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
