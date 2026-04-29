vim.keymap.set('n', '<leader>p', '<cmd>TypstPreviewToggle<CR>', { desc = "Toggle [P]review" })

-- Enable Spellcheck
vim.opt_local.spell = true
vim.opt.spellcapcheck = ''
vim.opt.spelllang = 'en'
vim.keymap.set({'i', 'n'}, '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { desc = "Autocorrect Last Spelling Error" })
vim.keymap.set({'i', 'n'}, '<C-g>', 'zg', { desc = "Add word to dictionary" })
vim.keymap.set({'i', 'n'}, '<C-w>', 'zw', { desc = "Remove word from dictionary" })

