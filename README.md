# Elixevator

# Dependencies

### Erlang

Install Erlang R16B02 using kerl

```
curl -O https://raw.github.com/spawngrid/kerl/master/kerl; chmod a+x kerl
```

Create ~/.kerlrc

```
KERL_CONFIGURE_OPTIONS="--disable-hipe --enable-smp-support --enable-threads
                        --enable-kernel-poll  --enable-darwin-64bit"
```

Build, install, and activate R16B02

```
./kerl build R16B02 r16b02
./kerl install r16b02 ~/erlang/r16b02
. ~/erlang/r16b02/activate
```

More information about kerl and those commands [here](https://gist.github.com/drewkerrigan/7795322)

### Elixir

Homebrew for Mac OS X
Update your homebrew to latest with brew update
Install Elixir: 

```
brew install elixir
```

Fedora 17+ and Fedora Rawhide

```
sudo yum -y install elixir
```

Arch Linux (on AUR)

```
yaourt -S elixir
```

openSUSE (and SLES 11 SP3+)
Add Erlang devel repo with zypper ar -f obs://devel:languages:erlang/ erlang
Install Elixir: 

```
zypper in elixir
```

Gentoo

```
emerge --ask dev-lang/elixir
```

Chocolatey for Windows

```
cinst elixir
```

# Build

```
mix
```

# Test

```
mix test
```

# Implementation

![Diagram](https://raw.githubusercontent.com/drewkerrigan/elixevator/master/diagram.jpg "Diagram")



# Usage

```
id = 1
Elixevator.create(id)
{:ok, status} = Elixevator.get_status(id) 
# status = {1, 1, 1}

Elixevator.pickup(id, 3, 1)
{:ok, status} = Elixevator.get_status(id) 
# status = {1, 1, 3}

Elixevator.step(id)
{:ok, status} = Elixevator.get_status(id) 
# status = {1, 2, 3}

Elixevator.step(id)
{:ok, status} = Elixevator.get_status(id) 
# status = {1, 3, 3}
```
