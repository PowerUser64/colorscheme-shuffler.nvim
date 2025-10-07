# colorscheme-shuffler.nvim

Tests not passing? Feeling spontaneous? Mix up your editor theme with colorscheme-shuffler.nvim!

```lua
{
    'PowerUser64/colorscheme-shuffler.nvim'
    opts = {},
}
```

## Default config

```lua
{
    deck = nil,          -- deck of colorschemes to pick from (default: all installed)
    use_env_var = false, -- on startup, default to the theme stored in the NVIM_INIT_THEME env variable. Also, set this variable when changing themes.
    blacklist = {},      -- any colorschemes that shouldn't be picked (default: none)
    shuffle_events = {}, -- which vim events to shuffle on?
    notify = true,       -- print the name of the colorscheme upon switching
}
```

### Example config

A (non-default) example of how you could configure this plugin:

```lua
{
    deck = nil, -- use all colorschemes
    use_env_var = true, -- make running nvim in the builtin terminal respect your colorscheme
    blacklist = {
        -- blacklist all builtin light themes
        "delek",
        "morning",
        "peachpuff",
        "shine",
        "zellner",
    },
    shuffle_events = {
        'FileWritePost', -- shuffle when writing files
        FileType = { 'javascript' }, -- shuffle when entering javascript files
        'ON_LOAD', -- shuffle on plugin load (special non-vim event, make sure to not lazy load for this)
    },
    notify = true,
}
```

Note the special `ON_LOAD` event. Using this event will cause
colorscheme-shuffler.nvim to shuffle the colorscheme while it is calling its
setup function. This can replace setting a colorscheme with
`vim.cmd.colorscheme()`. Also, the `notify` option does not apply here, and the
command will always be run silently. This is because it prevents issues with
things like custom notification systems (like noice.nvim) not being ready yet.
Please file an issue if you would like a config option to change this.

## API

- `next()` - Call this function to change to the next random colorscheme. Pass a list of colorschemes to pick from a specific list.
- `append_blacklist()` - Add a new colorscheme to the blacklist and apply the blacklist. Useful if you want to split up your config.
- `append_deck()` - Add a new colorscheme to the list of all colorschemes, applying the blacklist filters. Useful if you want to split up your config.
- `print_colorscheme()` - Print the current colorscheme with vim.notify, in the same way that `config.notify = true` will.

## Acknowledgments

- [tetzng/random-colorscheme.nvim](https://github.com/tetzng/random-colorscheme.nvim/) - An implementation of a similar concept to this, which was used as a reference in some places.
