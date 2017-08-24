Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B459D2095DCA1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 16:12:39 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
Date: Thu, 24 Aug 2017 23:15:14 +0000
Message-ID: <1503616402.22880.24.camel@intel.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
 <1503508401.2042.174.camel@hpe.com> <1503606666.22880.19.camel@intel.com>
 <CAPcyv4gY+7C8jN8g84L3-7Y661vKWqxG5odamFqGF+HriF=Q2g@mail.gmail.com>
 <x4960dcoetl.fsf@segfault.boston.devel.redhat.com>
 <1503610260.2042.177.camel@hpe.com>
 <CAPcyv4hF-0Asic+sfXGhN+rvWb6mOb2GpSzWAqkr+U=zO-pt=A@mail.gmail.com>
In-Reply-To: <CAPcyv4hF-0Asic+sfXGhN+rvWb6mOb2GpSzWAqkr+U=zO-pt=A@mail.gmail.com>
Content-Language: en-US
Content-ID: <0D03F4F360D05943B15AC6290EB96C52@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "toshi.kani@hpe.com" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA4LTI0IGF0IDE1OjExIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgQXVnIDI0LCAyMDE3IGF0IDI6NDAgUE0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbT4NCj4gd3JvdGU6DQo+ID4gT24gVGh1LCAyMDE3LTA4LTI0IGF0IDE3OjA3
IC0wNDAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiA+ID4gRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+IHdyaXRlczoNCj4gPiA+IA0KPiA+ID4gPiA+ID4gSSBoaXQgYW4gaW5m
aW5pdGUgY2xlYXIgbG9vcCB3aGVuIERTTSBDbGVhciBVbmNvcnJlY3RhYmxlDQo+ID4gPiA+ID4g
PiBFcnJvcg0KPiA+ID4gPiA+ID4gZnVuY3Rpb24gZmFpbHMuwqDCoEhhdmVuJ3QgbG9va2VkIGlu
dG8gdGhlIGRldGFpbHMsIGJ1dCBJDQo+ID4gPiA+ID4gPiBzdXNwZWN0DQo+ID4gPiA+ID4gPiB0
aGlzIHVuY29uZGl0aW9uYWwgcmV0cnkgaXMgdGhlIGNhdXNlIG9mIHRoaXMuDQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gVGhhbmtzIFRvc2hpIC0gdGhhdCBtYWtlcyBzZW5zZS4gSSB0aGluayB0aGUg
cmlnaHQgdGhpbmcgdG8gZG8NCj4gPiA+ID4gPiB3b3VsZCBiZSBpZiB0aGUgRFNNIGZhaWxzLCBy
ZXR1cm4gYW4gRUlPIHllcz8gKE9yIHNob3VsZCB3ZQ0KPiA+ID4gPiA+IGlnbm9yZSB0aGUgZmFj
dCB0aGF0IHRoZXJlIHdhcyBhbiBlcnJvciwgY2xlYXIgLT5oYXNfZXJyLCBhbmQNCj4gPiA+ID4g
PiBsZXQNCj4gPiA+ID4gPiB0aGUgd3JpdGUgdGFrZSBpdHMgY291cnNlIChwb3NzaWJseSBnZW5l
cmF0ZSBhIENNQ0kpDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSXQgd2lsbCBzdGlsbCBiZSBpbiB0
aGUgYmFkYmxvY2sgbGlzdCwgYW5kIGZvciByZWFkcw0KPiA+ID4gPiA+IC0+cndfYnl0ZXMNCj4g
PiA+ID4gPiB3aWxsIHN0aWxsIGNoZWNrIGFuZCBmYWlsIHRoZW0uDQo+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gSSdsbCBzZW5kIG91dCBhIG5ldyBzZXJpZXMgd2l0aCBhIGZpeCwgYnV0IHdlIHJlYWxs
eSBuZWVkIHRvDQo+ID4gPiA+ID4gZ2V0DQo+ID4gPiA+ID4gYSB1bml0IHRlc3QgZm9yIEJUVCBl
cnJvciBjbGVhcmluZywgYW5kIEknbSB3b3JraW5nIG9uDQo+ID4gPiA+ID4gaW1wbGVtZW50aW5n
IHRoZSBuZXcgZXJyb3IgaW5qZWN0aW9uIERTTXMgaW4gbGlibmRjdGwgYW5kDQo+ID4gPiA+ID4g
bmZpdF90ZXN0IHRvIGRvIHRoYXQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBJIHRo
aW5rIGFzIG11Y2ggYXMgcG9zc2libGUgd2Ugc2hvdWxkIHRyeSB0byBub3QgZmFpbCB3cml0ZXMu
DQo+ID4gPiA+IExlYXZlDQo+ID4gPiA+IHRoZSBiYWRibG9jayBlbnRyeSBpbiBwbGFjZSBzbyB0
aGF0IHdlIGdldCBhbiBlcnJvciBvbiB0aGUgbmV4dA0KPiA+ID4gPiByZWFkLiBVcHBlci1sZXZl
bCBzb2Z0d2FyZSByZWFjdHMgbW9yZSBhZ2dyZXNzaXZlbHkgdG8gd3JpdGUNCj4gPiA+ID4gZXJy
b3JzDQo+ID4gPiA+IHRoYW4gcmVhZCBlcnJvcnMuDQo+ID4gPiANCj4gPiA+IEkgZG9uJ3QgdGhp
bmsgaXQncyB3aXNlIHRvIGxpZSBhYm91dCBkYXRhIGludGVncml0eS7CoMKgSWYgYSB3cml0ZQ0K
PiA+ID4gY2Fubm90IGJlIGNvbXBsZXRlZCwgaXQgKm5lZWRzKiB0byBmYWlsLsKgwqBZb3UgY2Fu
J3QgbWFrZSBhbnkNCj4gPiA+IGFzc3VtcHRpb25zIGFib3V0IHdoYXQgYXBwbGljYXRpb25zIHdp
bGwgZG8gd2l0aCB0aGUgcmVzdWx0Lg0KPiA+IA0KPiA+IEFncmVlZC7CoMKgcG1lbSBkcml2ZXIg
cmV0dXJucyB3aXRoIEVJTyBvbiB3cml0ZSBpbiB0aGlzIHNjZW5hcmlvIGFzDQo+ID4gd2VsbC4N
Cj4gDQo+IEFoIHRydWUsIEkgdGhpbmsgd2UgaGFkIHRoaXMgZGlzY3Vzc2lvbiBiZWZvcmUgYW5k
IHlvdSBjb252aW5jZWQgbWUgdG8NCj4gZ28gdGhlIEVJTyByb3V0ZSB0aGVuIGFzIHdlbGwuIFNv
IGNvbnNpZGVyIG1lIHJlLWNvbnZpbmNlZC4NCg0KSSdsbCBob2xkIG9mZiBvbiBzZW5kaW5nIHRo
aXMgb3V0IGZvciBub3cgLSBUaGVyZSBpcyBhbm90aGVyIHBsYWNlIHdoZXJlDQp3ZSBhdHRlbXB0
IHRvIGNsZWFyIGVycm9ycywgYW5kIHRoYXQgaXMgZHVyaW5nIGluaXQsIGlmIHdlIGZpbmQgZXhp
c3RpbmcNCmZyZWUtbGlzdCBibG9ja3MgdGhhdCBoYXZlIGVycm9ycy4gSSB0aGluayB0aGUgcmln
aHQgdGhpbmcgdG8gZG8gaGVyZSBpZg0KdGhlIGNsZWFyaW5nIGZhaWxzLCBpcyB0byBtYWtlIHRo
ZSBidHQgcmVhZCBvbmx5LiBJJ2xsIHJlYWxseSB3YW50IHRvDQp0ZXN0IHRoaXMgc3R1ZmYgb3V0
IHByb3Blcmx5IHdpdGggY3JhZnRpbHkgaW5qZWN0ZWQgZXJyb3JzLCBzbyBnb2luZyB0bw0KZ2V0
IHRoYXQgc29ydGVkIG91dCBmaXJzdC4NCg0KCS1WaXNoYWwKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
