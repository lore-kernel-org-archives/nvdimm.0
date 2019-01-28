Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH] nfit: add Hyper-V NVDIMM DSM command set to white list
Date: Mon, 28 Jan 2019 22:58:41 +0000
Message-ID: <PU1P153MB01693CEF0955362BA0AD09BCBF960@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4gnpn9VBHBoSFn_2sAdvfD85wRffvfYfuurwMxXYSBAZQ@mail.gmail.com>
 <PU1P153MB0169CE6B02AE7D67E25DDD89BF960@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hGYFuW901KZ1xCR4TucgRTkqZ=SOsLOK0MpKq0BBCokw@mail.gmail.com>
In-Reply-To: <CAPcyv4hGYFuW901KZ1xCR4TucgRTkqZ=SOsLOK0MpKq0BBCokw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>
List-ID: <linux-nvdimm@lists.01.org>

PiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2VudDog
TW9uZGF5LCBKYW51YXJ5IDI4LCAyMDE5IDE6NTUgUE0NCj4gDQo+IE9uIE1vbiwgSmFuIDI4LCAy
MDE5IGF0IDE6NDAgUE0gRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4gd3JvdGU6DQo+
IA0KPiA+IEkgbWFkZSB0aGUgYmVsb3cgc2ltcGxlIGNoYW5nZS4gSXMgdGhpcyBlbm91Z2g/IFBs
ZWFzZSBzdWdnZXN0IHRoZSBwcm9wZXINCj4gPiB3b3JkaW5nL3NlbnRlbmNlLCBhcyBJJ20gcmVs
YXRpdmVseSBuZXcgdG8gTlZESU1NLCBhbmQgSSBkb24ndCByZWFsbHkga25vdw0KPiB0aGUgaGlz
dG9yeSBvZiB0aGUgc3RhbmRhcmRpemF0aW9uIHByb2Nlc3MuDQo+IA0KPiBIb3cgYWJvdXQgc29t
ZXRoaW5nIGEgYml0IG1vcmUgcmVsZXZhbnQgZm9yIHRoZSBjb2RlIGluIHF1ZXN0aW9uOg0KPiAN
CiANCj4gVGhlcmUgYXJlIDQgImxlZ2FjeSIgTlZESU1NIGNvbW1hbmQgc2V0cw0KPiAoTlZESU1N
X0ZBTUlMWV97SU5URUwsTVNGVCxIUEUxLEhQRTJ9KSB0aGF0IHdlcmUgY3JlYXRlZCBiZWZvcmUg
YW4gRUZJDQo+IHdvcmtpbmcgZ3JvdXAgd2FzIGVzdGFibGlzaGVkIHRvIGNvbnN0cmFpbiB0aGlz
IHByb2xpZmVyYXRpb24uIFRoZQ0KPiBuZml0IGRyaXZlciBwcm9iZXMgZm9yIHRoZSBzdXBwb3J0
ZWQgY29tbWFuZCBzZXQgYnkgR1VJRC4gTm90ZSwgSWYNCj4geW91J3JlIGEgcGxhdGZvcm0gZGV2
ZWxvcGVyIGxvb2tpbmcgdG8gYWRkIGEgbmV3IGNvbW1hbmQgc2V0IHRvIHRoaXMNCj4gcHJvYmUg
Y29uc2lkZXIgdXNpbmcgYW4gZXhpc3Rpbmcgc2V0LCBvciBvdGhlcndpc2Ugc2VlayBhcHByb3Zh
bCB0bw0KPiBwdWJsaXNoIHRoZSBjb21tYW5kIHNldCBhdA0KPiBodHRwOi8vd3d3LnVlZmkub3Jn
L1JGSUNfTElTVA0KDQpMb29rcyBwZXJmZWN0ISBMZXQgbWUgdXNlIHRoaXMsIHJlYmFzZSB0aGUg
cGF0Y2ggdG8gDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9udmRpbW0vbnZkaW1tLmdpdC90YWcvP2g9bGlibnZkaW1tLWZpeGVzLTUuMC1yYzQNCmFuZCBw
b3N0IGEgdjIgbGF0ZXIgdG9kYXkuDQoNClRoYW5rcywNCi0tIERleHVhbg0K
