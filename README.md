# Rearrange Windows

When switching workplaces between office and home, I always had to rearrange a few of my windows because there are different screens connected to my Macbook.

With the help of Gemini and Claude I created this small AppleScript which allows me to store the positions and sizes of my mostly used apps for different locations.

## Compiling

You should be able to sign the compiled script, so please make sure you registered a developer account with apple.

For easy compiling I provided the `build.sh` script.

## Installation

Move the compiled `RearrangeWindows.app` to you `Applications` folder.

Then create a file `~/Library/Application Support/RearrangeWindows/RearrangeWindows.conf`.

This file should contain the names of the processes you want the main window of to be stored.

**Example:**

```text
Signal
Calendar
Mail
MSTeams
```

If you do not know the name of the process, open `Find Window Name.applescript` in `Script Editor` and run it.
You then have five seconds to bring the application you're interested in, to the front.

## Usage

### Storing positions

Arrange the windows any way you like.
Start `RearrangeWindows.app`, click "Save" and give a name for the arrangement.

### Restoring positions

**Note** When you have stage manager active, bring the windows you want to get rearranged, to the front.
All of them.
I couldn't figure out how to do this with applescript.

Then run `RearrangeWindows.app`, select "Restore" and the arrangement you saved.
