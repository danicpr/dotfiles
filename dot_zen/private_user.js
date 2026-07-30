// ==========================================
// USER.JS - ZEN BROWSER CUSTOM CONFIG
// ==========================================

// --- UI & Modificaciones Visuales ---
// Habilita el soporte para userChrome.css y userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Configuración de la interfaz
user_pref("browser.tabs.inTitlebar", 1);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("zen.view.compact.enable-at-startup", true);
user_pref("zen.view.use-single-toolbar", false);
user_pref("zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url", true);

// --- Rendimiento & Red ---
// Desactiva el prefetch DNS e HTTP especulativo para ahorrar recursos
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);

// --- Privacidad & Seguridad ---
user_pref("privacy.globalprivacycontrol.was_ever_enabled", true);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("dom.forms.autocomplete.formautofill", true);
user_pref("signon.rememberSignons", false);

// --- Ajustes de Mods (Zen Mods) ---
user_pref("mod.sameerasw_zen_animations", "1");
user_pref("mod.sameerasw_zen_compact_sidebar_type", "0");
user_pref("mod.sameerasw_zen_empty_tab_logo", "1");
user_pref("mod.sameerasw_zen_light_tint", "2");
user_pref("mod.sameerasw.zen_bg_blur", "3px");
user_pref("mod.sameerasw.zen_bg_color_enabled", false);
user_pref("mod.sameerasw.zen_bg_img_enabled", false);
user_pref("mod.sameerasw.zen_bg_opacity", "0.8");
user_pref("mod.sameerasw.zen_compact_sidebar_width", "165px");
user_pref("mod.sameerasw.zen_tab_switch_anim", true);
user_pref("mod.sameerasw.zen_trackpad_anim", true);
user_pref("mod.sameerasw.zen_transparent_glance_enabled", true);
user_pref("mod.sameerasw.zen_transparent_sidebar_enabled", true);
user_pref("mod.sameerasw.zen_urlbar_zoom_anim", true);

user_pref("uc.fixcontext.applyzenaccent", true);
user_pref("uc.fixcontext.applyzengradient", true);
user_pref("uc.fixcontext.ergonomicsfortabs", true);
user_pref("uc.fixcontext.restoreicons", true);
user_pref("uc.hidecontext.askchatbot", true);
user_pref("uc.hidecontext.bookmark", true);
user_pref("uc.hidecontext.checkspelling", true);
user_pref("uc.hidecontext.copylink", true);
user_pref("uc.hidecontext.icons", false);
user_pref("uc.hidecontext.image", true);
user_pref("uc.hidecontext.inspect", false);
user_pref("uc.hidecontext.mutetab", true);
user_pref("uc.hidecontext.printselection", true);
user_pref("uc.hidecontext.reloadtab", true);
user_pref("uc.hidecontext.screenshot", false);
user_pref("uc.hidecontext.search", true);
user_pref("uc.hidecontext.searchinpriv", true);
user_pref("uc.hidecontext.selectalltabs", true);
user_pref("uc.hidecontext.selectalltext", true);
user_pref("uc.hidecontext.sendtodevice", true);
user_pref("uc.hidecontext.separators", true);

user_pref("theme-better_find_bar-enable_custom_background", true);
user_pref("theme.better_find_bar.custom_background", "#2d2c39");
user_pref("theme.better_find_bar.textbox_width", "800");

user_pref("zen.mods.AudioIndicatorEnhanced.audioWave.enabled", true);
user_pref("zen.mods.AudioIndicatorEnhanced.hoverScaleAnimationEnabled", true);
user_pref("zen.mods.AudioIndicatorEnhanced.returnOldIcons", true);
