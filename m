Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0705.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc09::705])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87B521A1E03
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 12:44:04 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 0/2] fix dm-snap for dax
Date: Tue, 28 Jun 2016 19:43:26 +0000
Message-ID: <1467143000.3504.431.camel@hpe.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
Content-Language: en-US
Content-ID: <49AF3059A3F22F43BC6FCF0B51BAEEB0@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

U29ycnksIHN1YmplY3QgbGluZSBzaG91bGQgYmUgIltQQVRDSCAwLzJdIGZpeCBkbS1zbmFwIGZv
ciBkYXgiDQotVG9zaGkNCg0KT24gVHVlLCAyMDE2LTA2LTI4IGF0IDEzOjM3IC0wNjAwLCBUb3No
aSBLYW5pIHdyb3RlOg0KPiBJIG5vdGljZWQgdGhhdCBkbS1zbmFwIHJlbG9hZHMgRE0gdGFibGUg
b2YgdGFyZ2V0IG1hcHBlZC1kZXZpY2UsIHdoaWNoDQo+IGZhaWxzIGZvciBkYXgtY2FwYWJsZSBk
ZXZpY2UgYWZ0ZXIgZGF4IHN1cHBvcnQgaXMgYWRkZWQuwqDCoElkZWFsbHksDQo+IGFkZGluZyBk
YXggc3VwcG9ydCB0byBkbS1zbmFwIHNvbHZlcyB0aGUgaXNzdWUsIGJ1dCBpdCBjYW5ub3QgYmUg
ZG9uZQ0KPiBlYXNpbHkuwqDCoFRoaXMgcGF0Y2gtc2V0IGFsbG93cyBkbS1zbmFwIHRvIHdvcmsg
d2l0aCBkYXgtY2FwYWJsZSB0YXJnZXQNCj4gZGV2aWNlcyB3aGVuIGJpby1iYXNlZCBvcGVyYXRp
b24gaXMgdXNlZC4NCj4gDQo+IGRheCBvcGVyYXRpb24gaXMgdW5zdXBwb3J0ZWQgd2l0aCBkbS1z
bmFwLCBzdWNoIHRoYXQ6DQo+IMKgYSkgQWZ0ZXIgc25hcHNob3QgaXMgdGFrZW4sIG1vdW50IHdp
dGggZGF4IG9wdGlvbiB0byBhIHRhcmdldCBkZXZpY2UNCj4gwqDCoMKgwqBvciBhIHNuYXBzaG90
IGRldmljZSBmYWlscy7CoMKgVGhleSBjYW4gYmUgbW91bnRlZCB3aXRob3V0IGRheC4NCj4gwqBi
KSBBZnRlciBzbmFwc2hvdCBpcyB0YWtlbiB0byBhIGRheC1tb3VudGVkIHRhcmdldCBkZXZpY2Us
IGFueSB3cml0ZXPCoA0KPiDCoMKgwqDCoHRvIHRoZSB0YXJnZXQgZGV2aWNlIGZhaWxzIChFSU8p
Lg0KPiANCj4gYikgY2FuIGJlIHByb3RlY3RlZCBieSBjaGFuZ2luZyBsdmNyZWF0ZSB0byBmYWls
IHdoZW4gc25hcHNob3QgaXMNCj4gcmVxdWVzdGVkIHRvIGEgZGF4LW1vdW50ZWQgdGFyZ2V0IGRl
dmljZS7CoA0KPiANCj4gLSBQYXRjaCAxIHNvbHZlcyBhbiBlcnJvciB3aGVuIGx2cmVtb3ZlIGlz
IG1hZGUgdG8gYSBzbmFwc2hvdCBkZXZpY2UuDQo+IC0gUGF0Y2ggMiBzb2x2ZXMgYW4gZXJyb3Ig
d2hlbiBsdmNyZWF0ZSAtLXNuYXBzaG90IGlzIG1hZGUgdG8gYSBkYXgtDQo+IMKgIGNhcGFibGUg
ZGV2aWNlLg0KPiANCj4gLS0tDQo+IFRvc2hpIEthbmkgKDIpOg0KPiDCoDEvMiBkbTogdXBkYXRl
IHRhYmxlIHR5cGUgY2hlY2sgZm9yIGRheA0KPiDCoDIvMiBkbSBzbmFwOiBhZGQgZmFrZSBvcmln
aW5fZGlyZWN0X2FjY2Vzcw0KPiANCj4gLS0tDQo+IMKgZHJpdmVycy9tZC9kbS1pb2N0bC5jIHwg
MTEgKysrKysrKysrKy0NCj4gwqBkcml2ZXJzL21kL2RtLXNuYXAuY8KgwqB8wqDCoDggKysrKysr
KysNCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCj4gTGlu
dXgtbnZkaW1tIG1haWxpbmcgbGlzdA0KPiBMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnDQo+IGh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWls
aW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
