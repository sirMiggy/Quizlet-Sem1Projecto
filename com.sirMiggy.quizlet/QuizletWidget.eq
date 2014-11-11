class QuizletWidget : LayerWidget, EventReceiver
{
    TextInputWidget text;
    ListSelectorWidget list;
    Collection items;
    BoxWidget vbox;
    ClickWidget buttonadd;
    ClickWidget buttonlets;
    class AddEvent
    {
    }

    class QuizLet
    {
    }

	 public void start() {
        base.start();
        if(text != null) {
            text.grab_focus();
        }
    }

	  public void delete_item(String todelete) {
        items.remove(todelete);
        on_items_changed();
    }

	class DeleteConfirmDialog : YesNoDialogWidget
    {
        property QuizletWidget widget;
        property String todelete;

        public void initialize() {
            set_title("Confirmation");
            set_text("Are you sure to delete the task `%s'".printf().add(todelete).to_string());
            base.initialize();
        }

        public bool on_yes() {
            widget.delete_item(todelete);
            return(false);
        }
    }

    class NewDialog : LayerWidget
    {
        property Collection todisplay;

        public void initialize() {
            base.initialize();
            Log.message("NewDialog");
            int n = todisplay.count();
            var vbox = BoxWidget.vertical();
           // var samplelist = ListSelectorWidget.for_items(todisplay);
           // samplelist.set_show_desc(false);
          //  samplelist.set_show_icon(false);
            Object ss1 = todisplay.get(0);
            Object ss2 = todisplay.get(1);
            String s1 = "%s".printf().add(ss1).to_string();
            String s2 = "%s".printf().add(ss2).to_string();
            vbox.add_box(100,new Box().set_c1(s1).set_c2(s2));
           // vbox.add_box(50,samplelist);
            //vbox.add_box(25,new Box().set_c1("blue").set_c2("red"));
            add(vbox);
            }
    }

    class Splitter : LayerWidget, EventReceiver
    {
        property Collection definitions;
        Collection boxes;
        Collection toPass;
        LayerWidget nd;
        public void initialize(){
            base.initialize();
            boxes = LinkedList.create();
            var boxing = BoxWidget.vertical();
            var inboxing = BoxWidget.vertical();
            foreach(String sentence in definitions){
                toPass = SplitQuoted.split(sentence,45); // Hyphen
                Log.message("Topas");
                Log.message(toPass.count());
                boxes.append(nd = new NewDialog().set_todisplay(toPass));                
            }
            var scroll = VScrollerWidget.instance();
            foreach(Object o in boxes){
                inboxing.add_box(30,(LayerWidget)o);
            }
            scroll.add(inboxing);
            boxing.add_box(90,scroll) ;
            boxing.add_box(10,ButtonWidget.for_string("Quit").set_event("quit"));
            add(boxing);
        }
        public void on_event(Object o){
            if("quit".equals(o)){
                
            }
        }
    }

    class Box : AnimationListener, EventReceiver, LayerWidget
    {
        Widget current;
        Widget next;
        String color;
        property String c1;
        property String c2;
        ChangerWidget changer;

        public void nextcolor(){
            if (color.equals(c1)){
                color = c2;
            }
            else if (color.equals(c2)){
                color = c1;
            }
            next = LabelWidget.for_string(color);
            changer.add_changer(next);
            changer.activate(next,true,this);
        }

        public void on_animation_listener_end(){
            remove(current);
            current = next ;
        }

        public void initialize() {
            base.initialize();
            Log.message("Boxing Class");
            changer = ChangerWidget.instance();
            color = c1;
            add(changer);
            nextcolor();
            add(FramelessButtonWidget.for_text("").set_event("ye"));

        }
         public void on_event(Object o) {
            if("ye".equals(o)) {
                nextcolor();
                return;
            }
        }
    }

    public void initialize() {
        base.initialize();
        set_draw_color(Color.instance("black"));
        add(CanvasWidget.for_color(Color.instance("white")));
        vbox = BoxWidget.vertical();
        vbox.set_margin(px("1mm"));
        vbox.set_spacing(px("1mm"));
        var input = BoxWidget.horizontal();
        input.set_spacing(px("1mm"));
        input.add_box(1, text = TextInputWidget.instance());
        input.add_box(0, buttonadd = ButtonWidget.for_string("Add").set_event(new AddEvent()));
        list = ListSelectorWidget.instance();
        list.set_show_desc(false);
        list.set_show_icon(false);
        vbox.add_box(10, buttonlets = ButtonWidget.for_string("Let's Quiz").set_event(new QuizLet()));
        vbox.add_box(80, list);
        vbox.add_box(10, input);
        add(vbox);
		text.set_listener(this);
		load_items();
    }

    public void cleanup() {
        base.cleanup();
        list = null;
        text = null;
    }

	void on_items_changed() {
	    save_items();
        if(list != null) {
            list.set_items(items);
        }
		
    }

    void add_item(String item) {
        if(String.is_empty(item)) {
            return;
        }
        if(items == null) {
            items = LinkedList.create();
        }
        items.prepend(item);
        on_items_changed();
    }

    void on_add_event() {
        add_item(text.get_text());
        text.set_text("");
        text.grab_focus();
    }

    public void on_event(Object o) {
        if(o is QuizLet) {
            remove(list,true);
            remove(vbox,true);
            remove(buttonlets,true);
            add(new Splitter().set_definitions(items));
            return;
        }
        if(o is AddEvent) {
            on_add_event();
            return;
        }
		if(o is TextInputWidgetEvent && ((TextInputWidgetEvent)o).get_selected()) {
            on_add_event();
            return;
        }
		if(o is String) {
            Popup.widget(get_engine(), new DeleteConfirmDialog().set_widget(this).set_todelete((String)o));
            return;
        }
        
    }

		void save_items() {
        var ad = ApplicationData.for_this_application();
        if(ad == null) {
            return;
        }
        ad.mkdir_recursive();
        var sb = StringBuffer.create();
        foreach(String item in items) {
            sb.append(item);
            sb.append_c('\n');
        }
        ad.entry("items.txt").set_contents_string(sb.to_string());
    }

    void load_items() {
        var ad = ApplicationData.for_this_application();
        if(ad == null) {
            return;
        }
        var i = LinkedList.create();
        foreach(String line in ad.entry("items.txt").lines()) {
            i.add(line);
        }
        items = i;
        on_items_changed();
    }
}