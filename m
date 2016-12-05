Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37D5381FE6
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 13:43:07 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nfit: Fix extended status translations for ACPI DSMs
Date: Mon, 5 Dec 2016 21:43:05 +0000
Message-ID: <1480974124.2586.0.camel@intel.com>
References: <1480973246-32078-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4hMB3GnphdfRqmoda6ZuxtPvPZM65ksM6tHc-WVBkwDSw@mail.gmail.com>
In-Reply-To: <CAPcyv4hMB3GnphdfRqmoda6ZuxtPvPZM65ksM6tHc-WVBkwDSw@mail.gmail.com>
Content-Language: en-US
Content-ID: <8075C29D89CC2F49ACA97F5DDA1AE146@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTEyLTA1IGF0IDEzOjM3IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgRGVjIDUsIDIwMTYgYXQgMToyNyBQTSwgVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20NCj4gPiB3cm90ZToNCj4gPiANCj4gPiBBQ1BJIERTTXMgY2FuIGhhdmUg
YW4gJ2V4dGVuZGVkJyBzdGF0dXMgd2hpY2ggY2FuIGJlIG5vbi16ZXJvIHRvDQo+ID4gY29udmV5
DQo+ID4gYWRkaXRpb25hbCBpbmZvcm1hdGlvbiBhYm91dCB0aGUgY29tbWFuZC4gSW4gdGhlIHhs
YXRfc3RhdHVzDQo+ID4gcm91dGluZSwNCj4gPiB3aGVyZSB3ZSB0cmFuc2xhdGUgdGhlIGNvbW1h
bmQgc3RhdHVzZXMsIHdlIHdlcmUgcmV0dXJuaW5nIGFuIGVycm9yDQo+ID4gZm9yDQo+ID4gYSBu
b24temVybyBleHRlbmRlZCBzdGF0dXMsIGV2ZW4gaWYgdGhlIHByaW1hcnkgc3RhdHVzIGluZGlj
YXRlZA0KPiA+IHN1Y2Nlc3MuDQo+ID4gDQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2ls
bGlhbXNAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFs
LmwudmVybWFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IMKgZHJpdmVycy9hY3BpL25maXQvY29y
ZS5jIHwgMiArLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9uZml0L2NvcmUuYyBi
L2RyaXZlcnMvYWNwaS9uZml0L2NvcmUuYw0KPiA+IGluZGV4IDcxYTdkMDcuLmQxNGYwOWIgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9hY3BpL25maXQvY29yZS5jDQo+ID4gKysrIGIvZHJpdmVy
cy9hY3BpL25maXQvY29yZS5jDQo+ID4gQEAgLTE2OSw3ICsxNjksNyBAQCBzdGF0aWMgaW50IHhs
YXRfc3RhdHVzKHZvaWQgKmJ1ZiwgdW5zaWduZWQgaW50DQo+ID4gY21kLCB1MzIgc3RhdHVzKQ0K
PiA+IMKgwqDCoMKgwqDCoMKgwqB9DQo+ID4gDQo+ID4gwqDCoMKgwqDCoMKgwqDCoC8qIGFsbCBv
dGhlciBub24temVybyBzdGF0dXMgcmVzdWx0cyBpbiBhbiBlcnJvciAqLw0KPiA+IC3CoMKgwqDC
oMKgwqDCoGlmIChzdGF0dXMpDQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHN0YXR1cyAmIDB4ZmZm
ZikNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlPOw0KPiAN
Cj4gSSBkb24ndCB0aGluayB0aGlzIGlzIHJpZ2h0LCBiZWNhdXNlIHdlIGhhdmUgbm8gaWRlYSBh
dCB0aGlzIHBvaW50DQo+IHdoZXRoZXIgZXh0ZW5kZWQgc3RhdHVzIGlzIGZhdGFsIG9yIG5vdC4N
Cj4gDQo+IEVhY2ggJ2Nhc2UnIHN0YXRlbWVudCBpbiB0aGF0ICdzd2l0Y2gnIHNob3VsZCBiZSBy
ZXR1cm5pbmcgMCBpZiBpdA0KPiBkb2VzIG5vdCBzZWUgYW55IGVycm9ycy4gQmVjYXVzZSB0aGF0
J3MgdGhlIG9ubHkgcGFydCBvZiB0aGUgZnVuY3Rpb24NCj4gd2l0aCBwZXItY29tbWFuZCBrbm93
bGVkZ2Ugb2YgZXh0ZW5kZWQgYmVpbmcgYmVuaWduIC8gaW5mb3JtYXRpb25hbCB2cw0KPiBmYXRh
bC4NCg0KR29vZCBwb2ludCAtIEkgd2FzIHdvbmRlcmluZyBqdXN0IHRoYXQuLiBJJ2xsIHJlc2Vu
ZC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgt
bnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlz
dHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
