# Use SentryPeer<sup>&reg;</sup> to help prevent VoIP cyberattacks and fraudulent VoIP phone calls (toll fraud)

[![Stability: Active](https://masterminds.github.io/stability/active.svg)](https://masterminds.github.io/stability/active.html)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/sentrypeer/sentrypeerhq?sort=semver)](https://github.com/SentryPeer/SentryPeeHQ/releases)
[![CI](https://github.com/SentryPeer/SentryPeerHQ/actions/workflows/ci.yml/badge.svg)](https://github.com/SentryPeer/SentryPeerHQ/actions/workflows/ci.yml)

## Table of Contents
* [Introduction](#introduction)
* [Getting started with SentryPeerHQ](#getting-started-with-sentrypeerhq)
* [License](#license)
* [Contributing](#contributing)
* [Trademark](#trademark)
* [Questions, Bug reports, Feature Requests](#questions-bug-reports-feature-requests)
* [Special Thanks](#special-thanks)
* [Sponsorship](#sponsorship)

<img alt="SentryPeerHQ Screenshot" src="https://raw.githubusercontent.com/SentryPeer/SentryPeerHQ/main/priv/static/images/sentrypeer-app-screenshot-overview.png">

### Introduction

Use SentryPeer<sup>&reg;</sup> to help prevent VoIP cyberattacks, fraudulent VoIP phone calls (toll fraud) and improve cybersecurity by detecting early stage reconnaissance attempts.

Being able to detect and alert on customer traffic anomalies helps you deal with potential VoIP fraud. When a customer or customer account is flagged, you can take action to help prevent VoIP fraud and notify them about a potential handset or PBX security issue.

[SentryPeerHQ](https://sentrypeer.com) is a web app and set of APIs for managing and querying the data from [SentryPeer](https://sentrypeer.org) nodes that you run your self, or you can subscribe to the [SentryPeerHQ](https://sentrypeer.com) cloud service
and consume the data from the [SentryPeer](https://sentrypeer.org) nodes that we run via our APIs.

_You'll always be able to use SentryPeerHQ for **free** to consume the data you provide from the [SentryPeer](https://sentrypeer.org) nodes that you run yourself._

### Getting started with SentryPeerHQ

The easiest way to get started with SentryPeerHQ is [in the cloud](https://sentrypeer.com/pricing) (we run it on [fly.io](https://fly.io/)).

### Can SentryPeerHQ be self-hosted?

Yes, but it's a bit of work. We'll be making it much easier as we progress. It’s exactly the same product as our Cloud offering except that you'll have to use your own email, Pg/timescaledb database and OAuth 2.0 provider (we use [Postmark](https://postmarkapp.com/) and [Auth0](https://auth0.com/)). Get in touch if you want help to self-host SentryPeerHQ. 

## Technology

SentryPeerHQ is an [Elixir/Phoenix application](https://www.phoenixframework.org/) (web app and RESTful API) which uses [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) and is backed by a [PostgreSQL](https://www.postgresql.org/) database with [timescaledb](https://github.com/timescale/timescaledb). On the frontend we use [TailwindCSS](https://tailwindcss.com/) for styling.

### License

Great reading - [How to choose a license for your own work](https://www.gnu.org/licenses/license-recommendations.en.html)

This work is licensed under [AGPL 3.0](./LICENSE). [Why AGPL?](https://www.gnu.org/licenses/why-affero-gpl.en.html)

`SPDX-License-Identifier: AGPL-3.0`

### Contributing

See [CONTRIBUTING](./CONTRIBUTING.md)

### Trademark

[**SENTRYPEER**](https://trademarks.ipo.gov.uk/ipo-tmcase/page/Results/1/UK00003700947) and the [**SENTRYPEER ICON**](https://trademarks.ipo.gov.uk/ipo-tmcase/page/Results/1/UK00003847726) 
are registered trademarks of Gavin Henry.

### Questions, Bug reports, Feature Requests

New issues can be raised at:

https://github.com/SentryPeer/SentryPeerHQ/issues

It's okay to raise an issue to ask a question.

### Special Thanks

Special thanks to:
- [Fly.io](https://fly.io) for crediting the SentryPeer account for hosting the SentryPeerHQ web app on their infrastructure
- [AppSignal](https://www.appsignal.com/) for Application performance monitoring sponsorship in the SentryPeerHQ web app

### Sponsorship

Special thanks to [Deutsche Telekom Security GmbH](https://github.com/telekom-security) for sponsoring us! Very kind!