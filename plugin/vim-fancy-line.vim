scriptencoding utf-8

augroup MAX_FANCY_LINE
    set noshowmode    | " mode would otherwise be shown twice- in lightline and below. We want to deactivate one.
    set laststatus=2  | " required by AirLine and Lightline, without status line does not appear until a window split


    if (&term ==? 'linux')
        let g:group_active         = 'StatusLineTerm'
        let g:group_inactive       = 'StatusLineTermNC'
        let g:group_tabline        = 'TabLine'
        let g:status_sym_start         = ''
        let g:status_sym_end           = '▶'
        let g:status_sym_sep_start     = '│'
        let g:status_sym_sep_end       = '│'
        let g:symbol_branch            = ''
        let g:symbol_screen_edge       = '░'
    else
        let g:group_active         = 'StatusLine'
        let g:group_inactive       = 'StatusLineNC'
        let g:group_tabline        = 'TabLine'
        let g:status_sym_start         = ''
        let g:status_sym_end           = ''
        let g:status_sym_sep_start     = '│'
        let g:status_sym_sep_end       = '│'
        let g:symbol_branch            = ''
        let g:symbol_screen_edge       = '░'
    endif


    " this function reverts foreground color and background color of a given
    " highlight group and returns the name of a newly created _invert group
    function! CreateInvertGroup(highlight_group)
        let w:gui_bg=synIDattr(synIDtrans(hlID(a:highlight_group)), 'bg', 'gui')
        let w:gui_fg=synIDattr(synIDtrans(hlID(a:highlight_group)), 'fg', 'gui')
        let w:cterm_bg=synIDattr(synIDtrans(hlID(a:highlight_group)), 'bg', 'cterm')
        let w:cterm_fg=synIDattr(synIDtrans(hlID(a:highlight_group)), 'fg', 'cterm')

        if(w:gui_bg ==# '')   | let w:gui_bg   = 'NONE' | endif
        if(w:gui_fg ==# '')   | let w:gui_fg   = 'NONE' | endif
        if(w:cterm_bg ==# '') | let w:cterm_bg = 'NONE' | endif
        if(w:cterm_fg ==# '') | let w:cterm_fg = 'NONE' | endif

        let l:retval=a:highlight_group.'_invert'

        if(0 == synIDattr(synIDtrans(hlID(a:highlight_group)), 'reverse', 'cterm'))
            exec 'highlight! '.l:retval.' ctermfg='.w:cterm_bg.' ctermbg=0 guifg='.w:gui_bg.' guibg=NONE'
        else
            exec 'highlight! '.l:retval.' ctermfg='.w:cterm_fg.' ctermbg=0 guifg='.w:gui_fg.' guibg=NONE'
        endif

        return l:retval
    endfunction

    function! UpdateStatus(highlight_group)
        let l:invert_group = CreateInvertGroup(a:highlight_group)
        let l:mode = get({
                    \  'n'      : 'normal',
                    \  'i'      : 'insert',
                    \  'R'      : 'replace',
                    \  'v'      : 'visual',
                    \  'V'      : 'visual line',
                    \  "\<C-V>" : 'visual block',
                    \  'c'      : 'command',
                    \  's'      : 'select',
                    \  'S'      : 'select line',
                    \  "\<C-s>" : 'select block',
                    \  't'      : 'terminal'
                    \ }, mode(), mode())
        return ''
                    \ .'%#StatusLineHighlight#'
                    \ .'%#'.a:highlight_group.'#'
                    \ .g:symbol_screen_edge
                    \ .'%{&buftype != "" ? " ".&buftype : ""}'
                    \ .' '.l:mode.g:status_sym_sep_start
                    \ .'%{argc() > 1 ? " ".(argidx() + 1).":".argc()." ".g:status_sym_sep_start : ""}'
                    \ .'%{haslocaldir() ? fnamemodify(getcwd(), ":.:~")." " :""}'
                    \ .'%{&readonly ? " 🔒" : ""}'
                    \ .'%{&modified ? " 💾 " : ""}'
                    \ .'%{" [".winbufnr(0)."] "}'
                    \ .'%{bufname("%") == "" ? "" : fnamemodify(expand("%"), ":~:.")}'
                    \ .'%{&titlestring ? has("nvim") ? b:term_title:expand(&titlestring) : "" }'
                    \ .'%{exists("w:quickfix_title") ? w:quickfix_title : ""}'
                    \ .' '
                    \ .'%#'.l:invert_group.'#'
                    \ .g:status_sym_end
                    \ .'%#Ignore#'
                    \ .'%<'
                    \ .''
                    \ .'%='
                    \ .''
                    \ .'%#'.l:invert_group.'#'
                    \ .g:status_sym_start
                    \ .'%#'.a:highlight_group.'#'.' '
                    \ .'%{&buftype == "" ? "" : &buftype." ".g:status_sym_sep_end." "}'
                    \ .'%{&filetype == "" ?  "" :&filetype." ".g:status_sym_sep_end." "}'
                    \ .'%{&spell ? &spelllang." ".g:status_sym_sep_end : ""}'
                    \ .'%{&fileencoding =~ "^$\\|^utf\-8$" ? "" : &fileencoding." ".g:status_sym_sep_end." "}'
                    \ .'%{&fileformat =~ "^$\\|^unix$" ? "" : &fileformat." ".g:status_sym_sep_end}'
                    \ .' '
                    \ .'%cx%-l: '
                    \ .g:status_sym_sep_end
                    \ .' '
                    \ .'%p%% '
                    \ .g:symbol_screen_edge
                    \ .'%#NonText#'
    endfunction

    function! UpdateTabline(highlight_group)
        let l:invert_group = CreateInvertGroup(a:highlight_group)
        let l:git_branch   = systemlist('git branch --show-current')
        let l:git_branch   = (v:shell_error || l:git_branch == []) ? "" : g:status_sym_sep_start . ' ' . g:symbol_branch . ' ' . l:git_branch[0]

        return ''
                    \ .'%#'.a:highlight_group.'#'
                    \ .g:symbol_screen_edge
                    \ .' '
                    \ .'%#'.a:highlight_group.'#'
                    \ .'%-2( %)'
                    \ .'%{fnamemodify(getcwd(-1), ":~")}'
                    \ .' '
                    \ .l:git_branch
                    \ .' '
                    \ .'%#'.l:invert_group.'#'
                    \ .g:status_sym_end
                    \ .'%<'
                    \ .'%='
                    \ .'%#'.l:invert_group.'#'
                    \ .g:status_sym_start
                    \ .'%(%#'.a:highlight_group.'#%)'
                    \ .' '
                    \ .'%-2(%)'
                    \ .'%(%#'.a:highlight_group.'#%)'
                    \ .'%(%{v:servername} %{v:this_session}%)'
                    \ .g:status_sym_sep_end.' '
                    \ .'%-3(%)'
                    \ .'%#'.a:highlight_group.'#'
                    \ .'%{tabpagenr()}/%{tabpagenr()}'
                    \ .' '
                    \ .g:symbol_screen_edge
                    \ .'%##'
    endfunction


    if $USER ==? 'root'
        let highlight_group_root = "ErrorMsg"
        let invert_group = CreateInvertGroup(highlight_group_root)
        let g:group_tabline = highlight_group_root
    endif

    function! ApplyColorScheme()
        " set termguicolors | " When on, uses highlight-guifg and highlight-guibg attributes in the terminal (=24bit color) incompatible with nvim
        " set t_ut=
        " set up statusline, global and current window individually
        set statusline=%!UpdateStatus(g:group_inactive)
        setlocal statusline=%!UpdateStatus(g:group_active)
        " set up the tabline (match colors)
        set tabline=%!UpdateTabline(g:group_tabline)

        " otherwise 'bold' can mess up icon sizes and I do not know why
        " highlight! StatusLine cterm=reverse
        " exec 'highlight! User3 guifg=#D2A032 guibg='.l:fgcolor

        " workaround for VertSplit looking as a repeated slash, because its an
        " italic bar...
        " highlight! VertSplit gui=NONE cterm=NONE term=NONE
    endfunction
    call ApplyColorScheme()

    " apply colors from the loaded colorscheme...
    " when changing the colorscheme also apply new colors to the statusbar...
    autocmd ColorScheme * call ApplyColorScheme()
    autocmd WinEnter    * setlocal statusline=%!UpdateStatus(g:group_active)
    autocmd WinLeave    * setlocal statusline<
augroup END " MAX_FANCYLINE

" vim: shiftwidth=4 tabstop=4 expandtab softtabstop=4
