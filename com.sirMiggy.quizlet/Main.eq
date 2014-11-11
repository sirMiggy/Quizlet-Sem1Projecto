public class Main : LayerWidget
{	
 public void initialize() {
        base.initialize();
        set_size_request_override(px("80mm"), px("100mm"));
		add(new SplashWidget().add_image(IconCache.get("eqela_splash_logo")).set_next(new Mysplash()));
	}
	class Mysplash :LayerWidget
	{
		public void initialize() {
	        base.initialize();
			add(new SplashWidget().set_background_color(Color.instance("white")).add_image(IconCache.get("id")).set_next(new Lobby()));
		}
	}
}