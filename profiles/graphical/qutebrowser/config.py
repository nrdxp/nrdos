c.auto_save.session = True
c.changelog_after_upgrade = 'patch'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = 'auto'
c.completion.use_best_match = True
c.confirm_quit = ['downloads']
c.content.pdfjs = True
c.content.print_element_backgrounds = False
c.content.tls.certificate_errors = 'ask-block-thirdparty'
c.content.webrtc_ip_handling_policy = 'default-public-interface-only'
c.downloads.location.suggestion = 'both'
c.hints.find_implementation = 'javascript'
c.hints.leave_on_load = True
c.input.insert_mode.auto_load = True
c.input.mode_override = 'normal'
c.qt.args = [ 'enable-gpu-rasterization' ]
c.scrolling.smooth = True
c.session.lazy_restore = True
c.tabs.select_on_remove = 'last-used'
c.tabs.show = 'switching'
c.hints.chars = "asdfghjklvbcntyruewom"
c.colors.hints.fg = '#EFF0EB'
c.colors.hints.bg = '#1E1F29'
c.colors.hints.match.fg = '#5AF78E'
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'y': 'https://youtube.com/results?search_query={}',
    'wiki': 'https://en.wikipedia.org/w/index.php?search={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
    'g': 'https://www.google.com/search?source=&q={}',
    'gi': 'https://www.google.com/search?tbm=isch&q={}',
    'aur': 'https://aur.archlinux.org/packages/?O=0&K={}',
    'r': 'https://doc.rust-lang.org/stable/std/?search={}'
}

# leave listed modes easily with <a-j>
for mode in\
        ['caret', 'command', 'hint',
            'insert', 'passthrough', 'prompt',
            'yesno']:
    config.bind('<Alt+j>', 'leave-mode', mode=mode)

# Bindings for normal mode
config.bind(',p', 'spawn --userscript qute-pass -M gopass -d "wofi -d"')
config.bind(',P', 'set-cmd-text -s :open -p')
config.bind(',r', 'restart')
config.bind(',c', 'config-source')
config.bind(';I', 'hint images download')
config.bind('X', 'undo')
config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')
config.bind('x', 'tab-close')
