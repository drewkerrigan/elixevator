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

Here is a simple example of an elevator receiving a pickup call for floor 3 while on floor 1

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

Here is a more complex example of a multi-pickup situation, notes inline

```

Elixevator.create(7)

#initial state, floor 1, goal 1
assert {:ok, {7, 1, 1}} == Elixevator.get_status(7)

#pickup calls are made for floors 3, 2, 6, and 1 respectively
:ok = Elixevator.pickup(7, 3, 1)
:ok = Elixevator.pickup(7, 2, -1)
:ok = Elixevator.pickup(7, 6, -1)
:ok = Elixevator.pickup(7, 1, 1)

#elevator first makes it's way to floor 3
Elixevator.step(7)
assert {:ok, {7, 2, 3}} == Elixevator.get_status(7)

#once it gets there, the front of the queue (FIFO) is popped, and the new goal is 2
Elixevator.step(7)
assert {:ok, {7, 3, 2}} == Elixevator.get_status(7)

#the person on the 2nd floor wanted to go down, but 6 needs to be picked up first because they requested a pickup
#before the person on the 2nd floor was able to press any buttons. It would be possible to add additional logic to the
#Finite State Machine in order to calculate shortest distances and more efficiently use the people's time by scanning
#the future goals and picking the next goal based on distance rather than a simple FIFO, but that is for another day.
Elixevator.step(7)
assert {:ok, {7, 2, 6}} == Elixevator.get_status(7)

Elixevator.step(7)
assert {:ok, {7, 3, 6}} == Elixevator.get_status(7)

Elixevator.step(7)
assert {:ok, {7, 4, 6}} == Elixevator.get_status(7)

Elixevator.step(7)
assert {:ok, {7, 5, 6}} == Elixevator.get_status(7)

Elixevator.step(7)
assert {:ok, {7, 6, 1}} == Elixevator.get_status(7)

Elixevator.step(7) # 5
Elixevator.step(7) # 4
Elixevator.step(7) # 3
Elixevator.step(7) # 2
Elixevator.step(7) # 1
assert {:ok, {7, 1, 1}} == Elixevator.get_status(7)
```