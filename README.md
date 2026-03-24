# Rearrange Windows

When switching between office and home, I always have to rearrange a few windows because different screens are connected to my MacBook.

With the help of Gemini and Claude I created this small AppleScript which allows me to store the positions and sizes of my most-used apps for different locations.

## Compiling

You should be able to sign the compiled script, so please make sure you have registered a developer account with Apple.

For easy compiling I provided the `build.sh` script.

## Installation

Move the compiled `RearrangeWindows.app` to your `Applications` folder.

Then create a file `~/Library/Application Support/RearrangeWindows/RearrangeWindows.conf`.

This file should contain the names of the processes whose main window positions you want to store.

**Example:**

```text
Signal
Calendar
Mail
MSTeams
```

If you do not know the name of the process, open `Find Window Name.applescript` in `Script Editor` and run it.
You then have five seconds to bring the application you're interested in to the front.

## Usage

### Storing positions

Arrange the windows any way you like.
Start `RearrangeWindows.app`, click "Save" and enter a name for the arrangement.

### Restoring positions

**Note:** When you have **Stage Manager** active, bring the windows you want to rearranged, to the front.
I couldn't figure out how to do this with AppleScript.

Then run `RearrangeWindows.app`, select "Restore" and choose the arrangement you saved.
