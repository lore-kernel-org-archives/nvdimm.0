Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D68420082E9F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 10:37:16 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
Date: Thu, 8 Jun 2017 17:38:21 +0000
Message-ID: <1496943475.9288.5.camel@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
 <1496869051.9288.1.camel@hpe.com>
 <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
 <1496871186.9288.3.camel@hpe.com>
 <b91c4a7b-3e19-df5d-12e7-61cdf1bc2c84@hpe.com>
 <CAPcyv4hocL=1Mzqa+nJCdmRz7YgxUc3P1w-nn7F=uQG8wu94KA@mail.gmail.com>
In-Reply-To: <CAPcyv4hocL=1Mzqa+nJCdmRz7YgxUc3P1w-nn7F=uQG8wu94KA@mail.gmail.com>
Content-Language: en-US
Content-ID: <B947811C99E89B4B91EC94A67C8BBA90@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Knippers, Linda" <linda.knippers@hpe.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA2LTA4IGF0IDEwOjM0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgSnVuIDgsIDIwMTcgYXQgMTA6MzAgQU0sIExpbmRhIEtuaXBwZXJzIDxsaW5kYS5r
bmlwcGVyc0BocGUuYw0KPiBvbT4gd3JvdGU6DQo+IFsuLl0NCj4gPiBXYXNuJ3QgRGFuIGNvbmNl
cm5lZCBhYm91dCBob3cgdGhlIE9TIGNhbiBrbm93IHdoZXRoZXIgdGhlIEZXDQo+ID4gc3VwcG9y
dHMgdGhhdCBiaXQgaW4gdGhlIFN0YXJ0IEFSUz8NCj4gPiANCj4gPiBUaGUgUXVlcnkgQVJTIENh
cGFiaWxpdGllcyBEU00gaGFzIGEgYml0IHRoYXQgdGVsbHMgdGhlIE9TIHdoZXRoZXINCj4gPiB0
aGUgcGxhdGZvcm0gc3VwcG9ydHMgdGhlIG5vdGlmaWNhdGlvbiBhbmQgdGhlIHBvaW50IG9mIHRo
ZQ0KPiA+IG5vdGlmaWNhdGlvbiB3YXMgdG8gdGVsbCB0aGUgT1MgaXQgY291bGQgZG8gYSBTdGFy
dCBBUlMgd2l0aCBiaXQgMQ0KPiA+IHNldC7CoMKgT2YgY291cnNlLCBpZiB5b3UgZ2V0IHRoZSBu
b3RpZmljYXRpb24gdGhlbiB0aGF0IG1lYW5zIHRoZQ0KPiA+IHBsYXRmb3JtIGhhcyB0aGUgY2Fw
YWJpbGl0eSB0byBkZWxpdmVyIGl0LCBidXQgaXQgbWlnaHQgbm90IGh1cnQgdG8NCj4gPiBjaGVj
ayB0aGUgZmxhZyBmcm9tIHRoZSBRdWVyeSBDYXBhYmlsaXRpZXMgYml0Lg0KPiANCj4gR29vZCBw
b2ludCwgeWVzLCBJIHRoaW5rIGl0IGlzIHNhZmUgdG8gYXNzdW1lIHRoYXQgYSBCSU9TIHRoYXQg
Y2xhaW1zDQo+IHRvIHN1cHBvcnQgdW4tY29ycmVjdGFibGUgZXJyb3Igbm90aWZpY2F0aW9uIGFs
c28gc3VwcG9ydHMgdGhpcyBTdGFydA0KPiBBUlMgZmxhZy4NCg0KWWVzLCBBQ1BJIDYuMiwgc2Vj
dGlvbiA5LjIwLjcuMiwgZGVmaW5lcyB0aGF0Og0KDQrCoMKgwqDCoMKgwqBVcG9uIHJlY2Vpdmlu
ZyB0aGUgbm90aWZpY2F0aW9uLCB0aGUgT1NQTSBtYXkgZGVjaWRlIHRvIGlzc3VlDQrCoMKgwqDC
oMKgwqBhIFN0YXJ0IEFSUyB3aXRoIEZsYWdzIEJpdCBbMV0gc2V0IHRvIHByZXBhcmUgZm9yIHRo
ZSByZXRyaWV2YWwNCsKgwqDCoMKgwqDCoG9mIGV4aXN0aW5nIHJlY29yZHMgYW5kIGlzc3VlIHRo
ZSBRdWVyeSBBUlMgU3RhdHVzIGZ1bmN0aW9uIHRvDQrCoMKgwqDCoMKgwqByZXRyaWV2ZSB0aGUg
cmVjb3Jkcy4NCg0KU28swqBJIGJlbGlldmUgaXQgaXMgc2FmZSB0byBhc3N1bWUgdGhhdCBCSU9T
IHN1cHBvcnRpbmcgMHg4MSBhbHNvDQpzdXBwb3J0cyBmbGFncyBCaWcgWzFdLiAgU29ycnksIHRo
aXMgaXMgd2hhdCBJIHNob3VsZCBoYXZlIHNhaWQgaW4gbXkNCnByZXZpb3VzIGVtYWlsLi4uDQoN
ClRoYW5rcywNCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
