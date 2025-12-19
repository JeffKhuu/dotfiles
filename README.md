# dotfiles
Configuration Files

## Usage
1. `$ sudo apt install stow` Install *stow* to symlink dotfiles.
2. `$ git clone https://github.com/JeffKhuu/dotfiles.git ~/dotfiles` Clone the repository to the home folder. 
3. `$ cd dotfiles` Change directories into the cloned dotfiles
4. `$ stow [config_name]` Grab the desired set of configurations

## Available Configurations
* `nvim` Neovim repository

## Common Additional Dependencies
* `$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash` Install Node Version Manager (nvm)
* `$ nvm install node`
* `$ sudo apt install build-essential`
