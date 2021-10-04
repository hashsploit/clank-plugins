![Clank Plugins Logo](clank-plugins-logo.png)

This repository is dedicated for example and trusted Lua plugins written for [Clank](https://github.com/hashsploit/clank).

Lua is a simple and lightweight language that has a low entry-barrier for those who are interested in modding/creating customizable events especially for games that utilize a DME server for gameplay.
It is also widely used in many games as a scripting/modding language.

## Plugins

The `plugins/` directory holds a collection of clank plugins.

- **hello-world** - This is a demo Hello World example plugin.
- **LuaInterpreter** - An interactive Lua shell via the `lua` command.

The `lib/` directory holds facade libraries intended to aid in the development of plugins outside of the clank environment.

## Development

### Creating a new plugin
A plugin must be a folder named the plugin name which must be alphanumeric without spaces [A-Za-z0-9-_].

Within the plugin folder there must be an `init.lua` (or `init.lub`) file which must directly return a table structure
of the following values:

#### init.lua structure
| Key             | Type                 | Example            | Notes                                                            |
|-----------------|----------------------|--------------------|------------------------------------------------------------------|
| name            | `string`             | SomeOtherPlugin    | Plugin name. (>3 chars <32 chars alphanumeric [A-Za-z0-9-_])     |
| description     | `string`             | Does x, y, and z   | Detailed plugin purpose/description.                             |
| version         | `table`              | 0.1.0              | major=0, minor=1, revision(patch)=0 See https://semver.org/      |
| events          | `table`              |                    | Events to subscribe to. (See the Events table below)             |
| run_on          | `table` or `integer` | DME_SERVER         | Array of strings of what emulation modes this plugin may run on. |
| commands        | `table`              |                    | CLI commands to register. See [hello-world](plugins/hello-world/init.lua) example.|

##### Events table
| Event Name                | Parameters            | Description                                           |
|---------------------------|-----------------------|-------------------------------------------------------|
| **PLUGIN_DEV_TEST_EVENT** | Sample table data     | Called on `test [plugin] [params]`.                   |
| PLUGIN_INIT_EVENT         |                       | Called on plugin initialization/enable.               |
| PLUGIN_SHUTDOWN_EVENT     |                       | Called on plugin shutdown/disable.                    |
| TICK_EVENT                |                       | Called on a regular occuring timer.                   |

##### Run_on table
| Key                                | Description                                                           |
|------------------------------------|-----------------------------------------------------------------------|
| MEDIUS_UNIVERSE_INFORMATION_SERVER | This plugin may run on the Medius Universe Information Server.        |
| MEDIUS_AUTHENTICATION_SERVER       | This plugin may run on the Medius Authentication Server.              |
| MEDIUS_LOBBY_SERVER                | This plugin may run on the Medius Lobby Server.                       |
| DME_SERVER                         | This plugin may run on the Distributed Memory Engine Server.          |
| NAT_SERVER                         | This plugin may run on the Network Address Translation Server.        |


An example `init.lua` file can be seen in the [hello-world](plugins/hello-world/init.lua) demo plugin.

### Programming convention
These are recommended programming conventions to follow while developing your plugin.

| Key                | Type       | Example            | Notes                                                         |
|--------------------|------------|--------------------|---------------------------------------------------------------|
| Lua Variable       | Snake Case | `velocity_x`       | All lower-case, using underscores for word-breaks.            |
| Lua Function       | Camel Case | `setPosition()`    | Camel case starts with a lower-case word, the rest are upper. |
| Lua Table Variable | Snake Case | `box.name_tag`     | All lower-case, using underscores for word-breaks.            |
| Lua Table Function | Camel Case | `box.isGravityOn`  | Camel case starts with a lower-case word, the rest are upper. |

Spacing should be consistent. It is recommended to use hard-tabs (tab character) rather than spaces, however, if you started
a project with spaces, stick with it unless you convert all the spaces to hard-tabs.

### Clank Lua Plugin API
Under Construction.

| Function                           | Returns  | Description                                                           |
|------------------------------------|----------|-----------------------------------------------------------------------|
| clank.sleep(ms)                    | `nil`    | Have the current plugin thread sleep for `ms` milliseconds.           |
| clank.getConfig()                  | `table`  | Return a table representation of the Clank JSON config.               |
| clank.getPluginPath()              | `string` | Return the plugin's current path.                                     |


### Using the Clank Plugin Dev Utility
The `clankp` executable script acts as a swiss-army-knife development tool. The following sections describe each functionality.

#### Debugging & Running your plugin
During the development phase of writing a Clank plugin you will want to run/debug your plugin.
You can do so using the debug/run tool built in. Run `./clankp debug <plugin>` to load and initialize <plugin> only or `./clank debug` to load and initialize all available plugins.

You will be dropped into an interactive REPL CLI where you can run the `help` command to view plugin manipulation tools to further test and debug your plugin.

#### Compiling your plugins
You can compile your plugin to Lua byte-code chunks using the `./clankp compile` command.
All the plugins in the `plugins` folder will be compiled to Lua byte-code in a newly created `bin` folder.
These compiled files now have the `.lub` file extension.

#### Docker
The `clankp` executable script has functionality to automatically build and run a test container with Lua built-in.
Executing any of the "Docker Dev Commands" will build the Dockerfile into an image.
You can remove the image at any point by using `docker rmi clank-plugin-dev`.

