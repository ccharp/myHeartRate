//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Communications as Comm;

var page = 0;
var strings = ["","","","",""];
var stringsSize = 5;

class BaseView extends Ui.View
{
    function initialize()
    {
        Comm.setMailboxListener( method(:onMail) );
    }

    function onUpdate(dc)
    {
    	// Didn't do anything but draw text as Comm sample
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );

        font = Ui.loadResource(Rez.Fonts.id_gamecube_120);

		var hour = cloclTime.hour.toString();
		dc.drawTest(45,0, 
    }

    function onMail(mailIter)
    {
        var mail;

        mail = mailIter.next();

        while( mail != null )
        {
            var i;
            for( i = (stringsSize - 1) ; i > 0 ; i -= 1 )
            {
                strings[i] = strings[i-1];
            }
            strings[0] = mail;
            page = 1;
            mail = mailIter.next();
        }

        Comm.emptyMailbox();
        Ui.requestUpdate();
    }
}

class BaseInputDelegate extends Ui.BehaviorDelegate
{
    var cnt = 0;
    function onMenu()
    {
        var menu = new Ui.Menu();
        menu.addItem( "Hello World.", :hello );
        menu.addItem( "Ackbar", :trap );
        menu.addItem( "Garmin", :garmin );
        Ui.pushView( menu, new MenuInput(), SLIDE_IMMEDIATE );
        return true;
    }

	// Do nothing but preserve code
    function onTap()
    {

//        if( page == 0 )
//        {
//            page = 1;
//        }
//        else
//        {
//            page = 0;
//        }
//        Ui.requestUpdate();
    }
}

class MenuInput extends Ui.MenuInputDelegate
{
    var cnt = 0;
    function onMenuItem(item)
    {
        var listener = new CommListener();

        if( item == :hello ) {
            Comm.transmit( "Hello World.", null, listener );
        }
        else if( item == :trap ) {
            Comm.transmit( "IT'S A TRAP!", null, listener );
        }
        else if( item == :garmin ) {
            Comm.transmit( "ConnectIQ", null, listener );
        }
    }
}

class CommListener extends Comm.ConnectionListener
{
    function onComplete()
    {
        Sys.println( "Transmit Complete" );
    }

    function onError()
    {
        Sys.println( "Transmit Failed" );
    }
}

class CommExample extends App.AppBase
{
    //! Constructor
    function initialize()
    {
    }

    function onStart()
    {
    
    }

    function onStop()
    {
    }

    function getInitialView()
    {
        return [ new BaseView(), new BaseInputDelegate() ];
    }
}
