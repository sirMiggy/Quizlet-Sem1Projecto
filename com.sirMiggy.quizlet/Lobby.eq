
public class Lobby : LayerWidget, EventReceiver
{	
	ClickWidget b;
	BoxWidget bigbox;
	BoxWidget lowbox;
	BoxWidget mainmenu;
	LayerWidget qlet;

    public void initialize() {
        base.initialize();
        bigbox = BoxWidget.vertical();
        lowbox = BoxWidget.horizontal();
        mainmenu = BoxWidget.vertical();
        //mainmenu.add_box(5,ButtonWidget.for_string("Home").set_event("home"));
        mainmenu.add_box(100,qlet = new QuizletWidget());
        add(mainmenu);
        bigbox.add_box(90,b = FramelessButtonWidget.for_text("Tap to Start\nQuizlet").set_event("start"));
        lowbox.add_box(40,ButtonWidget.for_string("Help?"));
        lowbox.add_box(20,CanvasWidget.for_color(Color.instance("white")));
        lowbox.add_box(40,ButtonWidget.for_string("Quit"));
        bigbox.add_box(15,lowbox);
        add(bigbox);
    }
    public void on_event(Object o){
    	if("start".equals(o)){
    		remove(bigbox);
    	}
    	/*if("home".equals(o)){
    		remove(qlet);
    		mainmenu.add_box(95,qlet = new QuizletWidget());
    		add(bigbox);
    	}*/
	}
}