# Blink Build

*Build* is a new service being built by the guys behind [Blink Shell](https://twitter.com/BlinkShell/), the best SSH and mosh client for iOS and iPadOS. It's [currently in beta](https://github.com/blinksh/blink/discussions/1698) and allows you to SSH into any container publicly available without taking care of the underlying infrastructure, network or firewall. And it's fully integrated in Blink Shell. [I have started tinkering](https://twitter.com/pirafrank/status/1423633599459471361) with it and I have to say it's a great match with my *workspace* for a portable dev environment!

## Update

The service has been updated significantly recently and I don't know if steps below are still actual. I leave them here for reference.

[This is](https://www.youtube.com/watch?v=78XukJvz5vg) what is like.

Updated official documentation is available [here](https://docs.blink.sh/build/start).

## First setup

Authenticate and turn on the VM (aka the *machine*)

```sh
build device authenticate
```

## Run workspace

```sh
build status
build machine start
build machine status
build ssh-key add
build ssh-key list
```

then bring the workspace up and enter it

```sh
build up --image pirafrank/workspace:bundle bundle
build ssh bundle
```

For more information, run the commands with the `--help` flag.

## Disclaimer

*Build* is a paid service and requires a subscription.

I am not affiliated to Blink Shell developers in any way.
