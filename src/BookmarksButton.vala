public struct Bookmark {
    string name;
    string url;
    bool one_time;
}

public class BookmarksButton : Gtk.Box {
    private Gtk.MenuButton button;
    public Gee.ArrayList<Bookmark?> bookmarkList;
    public TabbedWebView* webview;
    private Gtk.Button add_bookmark_button;
    public BookmarksButton() {
        Object ();
        button = new Gtk.MenuButton ();
        button.icon_name = "bookmarks-symbolic";
        button.add_css_class("flat");
        
        button.popover = populated_popover ();

        this.append (button);
    }

    private Gtk.Popover populated_popover() {
        Gtk.Popover popover = new Gtk.Popover ();
        Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow();
        Gtk.Box layout_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 4);
        scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.ALWAYS);

        this.add_bookmark_button = new IconButton.with_label("bookmark-add-symbolic", "Add Bookmark");
        add_bookmark_button.clicked.connect(() => {
            var bookmark = Bookmark() {
                name = webview->current_webview->get_title(),
                url  = webview->current_webview->get_uri(),
                one_time = false,
            };
            var bookmark_button = 
                new Gtk.Button.with_label("%s%s".printf(bookmark.name, bookmark.one_time ? " (one time)" : ""));
            bookmark_button.clicked.connect(() => {
                webview->add_new_tab(bookmark.url);
                if (bookmark.one_time) bookmarkList.remove(bookmark);
            });
            layout_box.append(bookmark_button);
        });

        layout_box.append(add_bookmark_button);

        foreach (var bookmark in bookmarkList) {
            var bookmark_button = 
                new Gtk.Button.with_label("%s (%s) (%s)".printf(bookmark.name, bookmark.url, bookmark.one_time ? "" : "one time"));
            bookmark_button.clicked.connect(() => {
                webview->add_new_tab(bookmark.url);
                if (bookmark.one_time) bookmarkList.remove(bookmark);
            });
            layout_box.append(bookmark_button);
        }

        scrolled_window.child = layout_box;

        popover.set_child(scrolled_window);
        return popover;
    }
}