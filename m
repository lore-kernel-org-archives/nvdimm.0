Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D92892095B9C1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 14:39:25 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
Date: Thu, 24 Aug 2017 21:40:55 +0000
Message-ID: <1503610260.2042.177.camel@hpe.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
 <1503508401.2042.174.camel@hpe.com>	<1503606666.22880.19.camel@intel.com>
 <CAPcyv4gY+7C8jN8g84L3-7Y661vKWqxG5odamFqGF+HriF=Q2g@mail.gmail.com>
 <x4960dcoetl.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x4960dcoetl.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <FF236E604CB65246B325BFF2657B92D0@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA4LTI0IGF0IDE3OjA3IC0wNDAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiBE
YW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4gd3JpdGVzOg0KPiANCj4gPiA+
ID4gSSBoaXQgYW4gaW5maW5pdGUgY2xlYXIgbG9vcCB3aGVuIERTTSBDbGVhciBVbmNvcnJlY3Rh
YmxlIEVycm9yDQo+ID4gPiA+IGZ1bmN0aW9uIGZhaWxzLsKgwqBIYXZlbid0IGxvb2tlZCBpbnRv
IHRoZSBkZXRhaWxzLCBidXQgSSBzdXNwZWN0DQo+ID4gPiA+IHRoaXMgdW5jb25kaXRpb25hbCBy
ZXRyeSBpcyB0aGUgY2F1c2Ugb2YgdGhpcy4NCj4gPiA+IA0KPiA+ID4gVGhhbmtzIFRvc2hpIC0g
dGhhdCBtYWtlcyBzZW5zZS4gSSB0aGluayB0aGUgcmlnaHQgdGhpbmcgdG8gZG8NCj4gPiA+IHdv
dWxkIGJlIGlmIHRoZSBEU00gZmFpbHMsIHJldHVybiBhbiBFSU8geWVzPyAoT3Igc2hvdWxkIHdl
DQo+ID4gPiBpZ25vcmUgdGhlIGZhY3QgdGhhdCB0aGVyZSB3YXMgYW4gZXJyb3IsIGNsZWFyIC0+
aGFzX2VyciwgYW5kIGxldA0KPiA+ID4gdGhlIHdyaXRlIHRha2UgaXRzIGNvdXJzZSAocG9zc2li
bHkgZ2VuZXJhdGUgYSBDTUNJKQ0KPiA+ID4gDQo+ID4gPiBJdCB3aWxsIHN0aWxsIGJlIGluIHRo
ZSBiYWRibG9jayBsaXN0LCBhbmQgZm9yIHJlYWRzIC0+cndfYnl0ZXMNCj4gPiA+IHdpbGwgc3Rp
bGwgY2hlY2sgYW5kIGZhaWwgdGhlbS4NCj4gPiA+IA0KPiA+ID4gSSdsbCBzZW5kIG91dCBhIG5l
dyBzZXJpZXMgd2l0aCBhIGZpeCwgYnV0IHdlIHJlYWxseSBuZWVkIHRvIGdldA0KPiA+ID4gYSB1
bml0IHRlc3QgZm9yIEJUVCBlcnJvciBjbGVhcmluZywgYW5kIEknbSB3b3JraW5nIG9uDQo+ID4g
PiBpbXBsZW1lbnRpbmcgdGhlIG5ldyBlcnJvciBpbmplY3Rpb24gRFNNcyBpbiBsaWJuZGN0bCBh
bmQNCj4gPiA+IG5maXRfdGVzdCB0byBkbyB0aGF0Lg0KPiA+ID4gDQo+ID4gDQo+ID4gSSB0aGlu
ayBhcyBtdWNoIGFzIHBvc3NpYmxlIHdlIHNob3VsZCB0cnkgdG8gbm90IGZhaWwgd3JpdGVzLiBM
ZWF2ZQ0KPiA+IHRoZSBiYWRibG9jayBlbnRyeSBpbiBwbGFjZSBzbyB0aGF0IHdlIGdldCBhbiBl
cnJvciBvbiB0aGUgbmV4dA0KPiA+IHJlYWQuIFVwcGVyLWxldmVsIHNvZnR3YXJlIHJlYWN0cyBt
b3JlIGFnZ3Jlc3NpdmVseSB0byB3cml0ZSBlcnJvcnMNCj4gPiB0aGFuIHJlYWQgZXJyb3JzLg0K
PiANCj4gSSBkb24ndCB0aGluayBpdCdzIHdpc2UgdG8gbGllIGFib3V0IGRhdGEgaW50ZWdyaXR5
LsKgwqBJZiBhIHdyaXRlDQo+IGNhbm5vdCBiZSBjb21wbGV0ZWQsIGl0ICpuZWVkcyogdG8gZmFp
bC7CoMKgWW91IGNhbid0IG1ha2UgYW55DQo+IGFzc3VtcHRpb25zIGFib3V0IHdoYXQgYXBwbGlj
YXRpb25zIHdpbGwgZG8gd2l0aCB0aGUgcmVzdWx0Lg0KDQpBZ3JlZWQuICBwbWVtIGRyaXZlciBy
ZXR1cm5zIHdpdGggRUlPIG9uIHdyaXRlIGluIHRoaXMgc2NlbmFyaW8gYXMNCndlbGwuDQoNClRo
YW5rcywNCi1Ub3NoaQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3Jn
Cmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
