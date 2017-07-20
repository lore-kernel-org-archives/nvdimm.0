Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E39E21CE749E
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jul 2017 15:44:42 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: Persistent Memory type vs Reserved Memory type
Date: Thu, 20 Jul 2017 22:45:35 +0000
Message-ID: <1500590179.2042.41.camel@hpe.com>
References: <840966580.1026784.1500509061384.ref@mail.yahoo.com>
 <840966580.1026784.1500509061384@mail.yahoo.com>
 <CAPcyv4juhhxZN9b1yVnFjboJUNMXJzLL8k5yf-+GXNE+aj86kw@mail.gmail.com>
 <2095070705.1732096.1500573379101@mail.yahoo.com>
In-Reply-To: <2095070705.1732096.1500573379101@mail.yahoo.com>
Content-Language: en-US
Content-ID: <E24F134BBD9F4E48BD281F48ED28A436@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "soccer_liu@yahoo.com" <soccer_liu@yahoo.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA3LTIwIGF0IDE3OjU2ICswMDAwLCBTb2NjZXIgTGl1IHdyb3RlOg0KPiBJ
IGFtIHNvcnJ5IGZvciBub3QgYmVpbmcgbW9yZSBjbGVhci4NCj4gSW4gQUNQSSBzcGVjIDIuNiwg
dGhlIFRhYmxlIDE1LTMxNyBoYXMgYWxsIHRoZSBVRUZJIE1lbW9yeSBUeXBlcyBhbmQNCj4gbWFw
cGluZyB0byBBQ1BJIGFkZHJlc3MgcmFuZ2UgdHlwZXMuDQo+IEhlcmUgYXJlIHRoZSBhY3R1YWwg
dHlwZXMgdGhhdCBJIHJlZmVycmVkIHRvOg0KPiDigJxQZXJzaXN0ZW504oCdLT4gRWZpUGVyc2lz
dGVudE1lbW9yeSAoMTQp4oCcUmVzZXJ2ZWTigJ3CoCAtPiBSZXNlcnZlZCB0eXBlDQo+IDE1wqAN
Cj4gQXBwYXJlbnRseSwgb25seSBteSBwcml2YXRlIGtlcm5lbCB3b3JrcyBhcyBleHBlY3RlZCB3
aGVuIGRlYWxpbmcNCj4gd2l0aCBSZXNlcnZlZCB0eXBlICgxNSkgYnV0IGNhbm5vdCBib290IHdp
dGggYW55wqBFZmlQZXJzaXN0ZW50TWVtb3J5DQo+IGRldmljZS4gSSBkaWQgc2VlIGEgRWZpUGVy
c2lzdGVudE1lbW9yeSBkZXZpY2Ugd29ya2luZyB3aXRoIFVidW50dQ0KPiBPUy4gSSBhbSBzdXNw
ZWN0aW5nIGl0J3MgbXkgZW52aXJvbm1lbnQgaXNzdWVzIChrY29uZmlnIGZsYWdzIG9yDQo+IG90
aGVycyksIEkgYW0gY3VyaW91cyBhYm91dCBhbnlvbmUgaGFzIGFueSBpZGVhIG9uIGhvdyB0byBk
ZWJ1ZyB0aGlzDQo+IGtpbmQgb2YgImRvZXMgbm90IGJvb3QgaXNzdWUiIG9yIGFueW9uZSBoYXMg
c2VlbsKgRWZpUGVyc2lzdGVudE1lbW9yecKgDQo+IGxpa2UgdGhpcz8NCg0KSSdkIHJlY29tbWVu
ZCB5b3UgZW5hYmxlIHNlcmlhbCBjb25zb2xlIG9uIHlvdXIgc3lzdGVtLCBhbmQgYWRkIHRoZQ0K
Zm9sbG93aW5nIGJvb3Qgb3B0aW9ucy4gIE5vdGUsIHlvdSB3b3VsZCBuZWVkIHRvIGNoYW5nZSB0
aGUgcGFyYW1ldGVyDQpvZiBjb25zb2xlPSBvcHRpb24gYWNjb3JkaW5nIHRvIHlvdXIgc2V0dXAu
ICBUaGlzIHNob3VsZCBoZWxwIHlvdSB0bw0KaWRlbnRpZnkgd2hlcmUgdGhlIHByb2JsZW0gaXMu
DQoNCmNvbnNvbGU9dHR5UzEsMTE1MjAwIGNvbnNvbGU9dHR5MSwxMTUyMDAgbGlibnZkaW1tLmR5
bmRiZyBuZml0LmR5bmRiZw0KbmRfcG1lbS5keW5kYmcgbmRfYnR0LmR5bmRiZyBlZmk9ZGVidWcg
aWdub3JlX2xvZ2xldmVswqANCg0KLVRvc2hpDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
