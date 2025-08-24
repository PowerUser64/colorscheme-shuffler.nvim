# colorscheme-shuffle.nvim

Tests not passing? Feeling spontaneous? Mix up your editor theme with colorscheme-shuffle.nvim!

```lua
{
    'PowerUser64/colorscheme-shuffle.nvim'
    lazy = false,
    priority = 100, -- use high priority when using startup-related events in opts.shuffle_events
    opts = {},
}
```

## Default config

```lua
opts = {
    deck = nil,          -- colorschemes to pick from (default: all)
    blacklist = {},      -- any colorschemes that shouldn't be picked (default: none)
    shuffle_events = {}, -- which vim events to shuffle on? (use UIEnter for startup)
    notify = true,       -- print the name of the colorscheme upon switching
}
```

### Example config

A (non-default) example of how you could configure this plugin:

```lua
opts = {
    deck = nil, -- use all colorschemes
    blacklist = {
        -- blacklist all default light themes
        "delek",
        "morning",
        "peachpuff",
        "shine",
        "zellner",
    },
    shuffle_events = {
        'UIEnter', -- shuffle on startup (make sure to not lazy load for this)
        FileType = { 'javascript' }, -- shuffle when entering javascript files
    },
    notify = true,
}
```

## API

- `next()` - Call this function to change to the next random colorscheme. Pass a list of colorschemes to pick from a specific list.
- `append_blacklist()` - Add a new colorscheme to the blacklist. Useful if you want to distribute your configuration across multiple files.
- `append_deck()` - Add a new colorscheme to the list of all colorschemes, applying the blacklist filters.

## Acknowledgments

- [tetzng/random-colorscheme.nvim](https://github.com/tetzng/random-colorscheme.nvim/) - An implementation of a similar concept to this, which was used as a reference in some places.
