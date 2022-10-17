# Circus Tent

These are resources for automated or manual installation of the
[circus](https://github.com/augustunderground/circus) gym environment.

## Prerequisites

| Software                                                                                                                           | Version                                                                   |
|------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| [fedora](https://getfedora.org/)                                                                                                   | `Fedora release 36 (Thirty Six)`                                          |
| [miniconda](https://docs.conda.io/en/latest/miniconda.html)                                                                            | `22.9.0`                                                                  |
| [spectre](https://www.cadence.com/en_US/home/tools/custom-ic-analog-rf-design/circuit-simulation/spectre-simulation-platform.html) | `@(#)$CDS: spectre  version 20.1.0 64bit 10/14/2021 02:50 (csvcm36c-2) $` |

While the environment has been tested with the aforementioned software, it is
possible and quite likely that it will work with slightly newer versions as
well.

## Installation

This will only install the GPDK180 resources in this repository. As such, only
the following environments will work with the gym registry:

```python
env = gym.make('circus:mil-gpdk180-geom-v0')
env = gym.make('circus:mil-gpdk180-geom-v1')
env = gym.make('circus:mil-gpdk180-elec-v0')
env = gym.make('circus:mil-gpdk180-elec-v1')
env = gym.make('circus:sym-gpdk180-geom-v0')
env = gym.make('circus:sym-gpdk180-geom-v1')
env = gym.make('circus:sym-gpdk180-elec-v0')
env = gym.make('circus:sym-gpdk180-elec-v1')
env = gym.make('circus:fca-gpdk180-geom-v0')
env = gym.make('circus:fca-gpdk180-geom-v1')
env = gym.make('circus:fca-gpdk180-elec-v0')
env = gym.make('circus:fca-gpdk180-elec-v1')
env = gym.make('circus:rfa-gpdk180-geom-v0')
env = gym.make('circus:rfa-gpdk180-geom-v1')
env = gym.make('circus:rfa-gpdk180-elec-v0')
env = gym.make('circus:rfa-gpdk180-elec-v1')
```

For more/other PDKs `circus` must be extended. See the
[repository](https://github.com/augustunderground/circus) and 
[documentation](https://augustunderground.github.io/circus/)
for more information.

### Automated Process

**DO NOT** run this in another conda environment. Be sure to `conda deactivate`
before running the install script.

```sh
$ git clone https://github.com/electronics-and-drives/circus-tent.git && \
    pushd ./circus-tent && ./install.sh && popd
```

**Note:** When prompted for the PDK path, insert the complete path to
`gpdk.scs`. For example:

```
...
Specify the complete path to gpdk.scs in GPDK 180: /opt/pdk/gpdk180_v3.3/models/spectre/gpdk.scs
```

### Testing the installation

If the installation was successful, the environments are in the gym registry
and can be used as follows.

```python
import gym

env     = gym.make('circus:sym-gpdk180-geom-v0')
obs     = env.reset()
act     = env.action_space.sample()
o,r,d,i = env.step(act)
```

### Manual Process

If automation scares you, your in the right industry. Here is a description of
what the installer does, so you can do it by hand.

Clone this repository wherever is convenient for you:

```sh
$ git clone https://github.com/electronics-and-drives/circus-tent.git
```

Change into the directory:

```sh
$ cd circus-tent
```

Create the conda Environment:

```sh
$ conda env create -f environment.yml
```

Activate the environment:

```sh
$ conda activate circus
```

Install custom dependencies and circus from github:

```sh
(circus) $ pip install git+https://github.com/augustunderground/pynut.git
(circus) $ pip install git+https://github.com/augustunderground/pyspectre.git
(circus) $ pip install git+https://github.com/augustunderground/serafin.git
(circus) $ pip install git+https://github.com/augustunderground/circus.git
```

Create the circus home directory:

```sh
$ mkdir ~/.circus
```

Alternatively, you can set `CIRCUS_HOME` in your environment, which should
point to a directory with the same structure.

Copy the contents of `./circus` to `~/.circus`:

```sh
$ cp -vr ./circus/* ~/.circus/
```

Adjust the include path in `~/.circus/pdk/gpdk180.yml`:

```yaml
include:
  - path: "/opt/pdk/gpdk180_v3.3/models/spectre/gpdk.scs" # CHANGE THIS
    section: "stat"
testbench:
# ...
```

**Alternative:**

If `~/.circus` doesn't work for you, the environment variable `CIRCUS_HOME`
can be used. In this case the path in `$CIRCUS_HOME/pdk/gpdk180.yml` to the PDK
still needs adjustment.

**Alternative:**

If none of the above works, the environment constructor accepts keyword
arguemnts:

- `ckt_cfg`: path to `ckt_id.yml`
- `pdk_cfg`: path to `pdk_id.yml`
- `netlist`: path to `ckt_id.scs`

That's it, the circus tent is setup, feel free to start clowning around.
