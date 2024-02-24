local M = {}

---@param command string command to execute on term start
function M.term_right(command)
    local buf_nr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_open_win(buf_nr, true, {
        split = "right",
        win = 0,
    })

    vim.fn.termopen(command)
end

---@param command string command to execute on term start
function M.term_bottom(command)
    local buf_nr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_open_win(buf_nr, true, {
        split = "below",
        win = 0,
    })

    vim.fn.termopen(command)
end

function M.term_new()
    local buf_nr_cmd_line = vim.api.nvim_create_buf(false, true)
    local buf_nr_terminal = vim.api.nvim_create_buf(false, true)

    local win_nr_cmd_line = vim.api.nvim_open_win(buf_nr_cmd_line, true, {
        split = "right",
        win = 0,
    })

    local win_nr_terminal = vim.api.nvim_open_win(buf_nr_terminal, false, {
        split = "below",
        win = win_nr_cmd_line,
    })

    local height_cmd_line = 1
    local height_terminal = math.floor(vim.o.lines - height_cmd_line)

    vim.api.nvim_win_set_height(win_nr_cmd_line, height_cmd_line)
    vim.api.nvim_win_set_height(win_nr_terminal, height_terminal)
end

---@param opts table config
function M.setup(opts)
    local opts = opts
        or {
            theme = "old",
            shell = "zsh",
            keymap = {
                open_vertical = "<leader>o",
                open_horizontal = "<leader>p",
            },
        }

    vim.keymap.set("n", "<leader>x", ":q!<CR>", { silent = true, noremap = true })
    vim.keymap.set("t", "<leader>x", "<c-\\><c-n> :q!<CR>", { silent = true, noremap = true })

    -- TODO -> check insert if moving to text buffer
    vim.keymap.set("t", "<c-w>h", "<c-\\><c-n> <c-w>h i", { silent = true, noremap = true })
    vim.keymap.set("t", "<c-w>j", "<c-\\><c-n> <c-w>j i", { silent = true, noremap = true })
    vim.keymap.set("t", "<c-w>k", "<c-\\><c-n> <c-w>k i", { silent = true, noremap = true })
    vim.keymap.set("t", "<c-w>l", "<c-\\><c-n> <c-w>l i", { silent = true, noremap = true })

    -- theme: old ----------------------------------------------

    if opts.theme == "old" then
        vim.keymap.set("n", opts.keymap.open_vertical, function()
            M.term_right(opts.shell)
        end, { silent = true, noremap = true })

        vim.keymap.set("n", opts.keymap.open_horizontal, function()
            M.term_bottom(opts.shell)
        end, { silent = true, noremap = true })
    end

    -- theme: new ----------------------------------------------

    if opts.theme == "new" then
        vim.keymap.set("n", opts.keymap.open_vertical, function()
            M.term_new()
        end, { silent = true, noremap = true })
    end

    -- autocmds ------------------------------------------------

    local terminal = vim.api.nvim_create_augroup("tt", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = terminal,
        callback = function()
            vim.cmd([[

                setlocal cursorline

            ]])
        end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        group = terminal,
        callback = function()
            vim.cmd([[

                setlocal nocursorline

            ]])
        end,
    })
end

return M
