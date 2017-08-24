Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 361BE2095AE56
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 13:30:25 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
Date: Thu, 24 Aug 2017 20:32:58 +0000
Message-ID: <1503606666.22880.19.camel@intel.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
 <1503508401.2042.174.camel@hpe.com>
In-Reply-To: <1503508401.2042.174.camel@hpe.com>
Content-Language: en-US
Content-ID: <C2BC0045D0C5474B9930C1E0369A5AF7@intel.com>
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
To: "toshi.kani@hpe.com" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA4LTIzIGF0IDE3OjIzICswMDAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3Rl
Og0KPiBPbiBUdWUsIDIwMTctMDgtMjIgYXQgMTY6MTkgLTA2MDAsIFZpc2hhbCBWZXJtYSB3cm90
ZToNCj4gwqA6DQo+ID4gKw0KPiA+ICsvKiBUaGUgYmxvY2sgaGFkIGEgbWVkaWEgZXJyb3IsIGFu
ZCBuZWVkcyB0byBiZQ0KPiA+IGNsZWFyZWQgKi8NCj4gPiAraWYgKGJ0dF9pc19iYWRibG9jayhi
dHQsIGFyZW5hLCBhcmVuYS0NCj4gPiA+IGZyZWVsaXN0W2xhbmVdLmJsb2NrKSkgew0KPiA+IA0K
PiA+ICthcmVuYS0+ZnJlZWxpc3RbbGFuZV0uaGFzX2VyciA9IDE7DQo+ID4gK25kX3JlZ2lvbl9y
ZWxlYXNlX2xhbmUoYnR0LT5uZF9yZWdpb24sDQo+ID4gbGFuZSk7DQo+ID4gKw0KPiA+ICthcmVu
YV9jbGVhcl9mcmVlbGlzdF9lcnJvcihhcmVuYSwgbGFuZSk7DQo+ID4gKy8qIE9LIHRvIGFjcXVp
cmUgYSBkaWZmZXJlbnQgbGFuZS9mcmVlIGJsb2NrDQo+ID4gKi8NCj4gPiArZ290byByZXRyeTsN
Cj4gDQo+IEkgaGl0IGFuIGluZmluaXRlIGNsZWFyIGxvb3Agd2hlbiBEU00gQ2xlYXIgVW5jb3Jy
ZWN0YWJsZSBFcnJvcg0KPiBmdW5jdGlvbiBmYWlscy7CoMKgSGF2ZW4ndCBsb29rZWQgaW50byB0
aGUgZGV0YWlscywgYnV0IEkgc3VzcGVjdCB0aGlzDQo+IHVuY29uZGl0aW9uYWwgcmV0cnkgaXMg
dGhlIGNhdXNlIG9mIHRoaXMuDQoNClRoYW5rcyBUb3NoaSAtIHRoYXQgbWFrZXMgc2Vuc2UuIEkg
dGhpbmsgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvIHdvdWxkIGJlDQppZiB0aGUgRFNNIGZhaWxzLCBy
ZXR1cm4gYW4gRUlPIHllcz8gKE9yIHNob3VsZCB3ZSBpZ25vcmUgdGhlIGZhY3QgdGhhdA0KdGhl
cmUgd2FzIGFuIGVycm9yLCBjbGVhciAtPmhhc19lcnIsIGFuZCBsZXQgdGhlIHdyaXRlIHRha2Ug
aXRzIGNvdXJzZQ0KKHBvc3NpYmx5IGdlbmVyYXRlIGEgQ01DSSkNCg0KSXQgd2lsbCBzdGlsbCBi
ZSBpbiB0aGUgYmFkYmxvY2sgbGlzdCwgYW5kIGZvciByZWFkcyAtPnJ3X2J5dGVzIHdpbGwNCnN0
aWxsIGNoZWNrIGFuZCBmYWlsIHRoZW0uDQoNCkknbGwgc2VuZCBvdXQgYSBuZXcgc2VyaWVzIHdp
dGggYSBmaXgsIGJ1dCB3ZSByZWFsbHkgbmVlZCB0byBnZXQgYSB1bml0DQp0ZXN0IGZvciBCVFQg
ZXJyb3IgY2xlYXJpbmcsIGFuZCBJJ20gd29ya2luZyBvbiBpbXBsZW1lbnRpbmcgdGhlIG5ldw0K
ZXJyb3IgaW5qZWN0aW9uIERTTXMgaW4gbGlibmRjdGwgYW5kIG5maXRfdGVzdCB0byBkbyB0aGF0
Lg0KDQo+IA0KPiBUaGFua3MsDQo+IC1Ub3NoaQ0KPiANCj4gCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
