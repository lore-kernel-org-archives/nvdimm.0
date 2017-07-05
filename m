Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B872C20958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 16:45:32 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 12/16] libnvdimm, nfit: enable support for volatile
 ranges
Date: Wed, 5 Jul 2017 23:46:00 +0000
Message-ID: <1499297819.2042.5.camel@hpe.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
 <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
 <d073b4a1-ff90-b44a-adf2-ad44c0d70c69@hpe.com>
 <CAPcyv4huf0ENTz=LEVC6xC7xKRPc-GAZJsZMTSYpy+UoaduTMg@mail.gmail.com>
 <595580A6.9000004@hpe.com>
 <CAPcyv4gtTYEUELPtr9mi5QkGL+cm=jcFR-Oe07OCuNM9izh6jA@mail.gmail.com>
 <d545a1ea-0199-7462-58c5-067cdc22cacc@hpe.com>
 <CAPcyv4gnkpWXJ7jOJ7r0kWLKoLfuqJzdHTjANBUPztyTWUrOjA@mail.gmail.com>
 <595589CF.5010605@hpe.com>
 <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
In-Reply-To: <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
Content-Language: en-US
Content-ID: <1644281EC7992B45957F7A84574234DC@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "x86@kernel.org" <x86@kernel.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA2LTI5IGF0IDE4OjI4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgSnVuIDI5LCAyMDE3IGF0IDQ6MTQgUE0sIExpbmRhIEtuaXBwZXJzIDxsaW5kYS5r
bmlwcGVyc0BocGUuYw0KPiBvbT4gd3JvdGU6DQo+ID4gT24gMDYvMjkvMjAxNyAwNjo1OCBQTSwg
RGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBKdW4gMjksIDIwMTcgYXQgMzo0OSBQ
TSwgTGluZGEgS25pcHBlcnMgPGxpbmRhLmtuaXBwZXJzQGgNCj4gPiA+IHBlLmNvbT4gd3JvdGU6
DQo+ID4gPiA+ID4gVGhlIHBhcmVudCByZWdpb24gb2YgdGhlIG5hbWVzcGFjZSB3aWxsIGhhdmUg
YSAndm9sYXRpbGUnDQo+ID4gPiA+ID4gdHlwZToNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAjIGNh
dCAvc3lzL2J1cy9uZC9kZXZpY2VzL3JlZ2lvbjAvZGV2dHlwZQ0KPiA+ID4gPiA+IG5kX3ZvbGF0
aWxlDQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gSWYgYWxsIEkga25vdyBpcyB0aGUgL2Rl
di9wbWVtIGRldmljZSBuYW1lLCBob3cgZG8gSSBmaW5kIHRoYXQ/DQo+ID4gPiA+IA0KPiA+ID4g
DQo+ID4gPiDCoMKgwqDCoGNhdCAkKHJlYWRsaW5rIC1mIC9zeXMvYmxvY2svcG1lbTAvZGV2aWNl
KS8uLi9kZXZ0eXBlDQo+ID4gPiANCj4gPiA+IC4uLnRoaXMgaXMgd2hlcmUgJ25kY3RsIGxpc3Qn
IHdpbGwgZ2V0IHRoZSBpbmZvcm1hdGlvbi4NCj4gPiA+IA0KPiA+IA0KPiA+IFRoYW5rcy4NCj4g
PiANCj4gPiBJIHRoaW5rIHdlIG5lZWQgYSBzZWN0aW9uIDQgcG1lbSBtYW5wYWdlIGxpa2UgZXhp
c3RzIGZvcg0KPiA+IG1lbSwgc2QsIGZkLCBtZCwgZXRjLiwgd2hlcmUgd2UgY2FuIHB1dCBzdHVm
ZiBsaWtlIHRoaXMsIGFzIHdlbGwNCj4gPiBhcyBwcm92aWRpbmcgc29tZSBvdmVydmlldyBpbmZv
cm1hdGlvbiB0aGF0IHdpbGwgcG9pbnQgcGVvcGxlIHRvDQo+ID4gb3RoZXIgcmVzb3VyY2VzLsKg
wqBJJ2xsIGdpdmUgdGhhdCBzb21lIHRob3VnaHQgdW5sZXNzIHRoZXJlIGlzIG9uZQ0KPiA+IGFs
cmVhZHkgdGhhdCBJJ20gbm90IGZpbmRpbmcuDQo+ID4gDQo+IA0KPiBBICJwbWVtIiBtYW4gcGFn
ZSBzb3VuZHMgbGlrZSBhIGdyZWF0IGlkZWEsIEkgd2Fzbid0IGF3YXJlIHdlIGV2ZW4NCj4gaGFk
IGFuIHNkIG1hbiBwYWdlLg0KDQpTb3JyeSBmb3IgYmVpbmcgbGF0ZSB0byByZXNwb25kLCBidXQg
SSBhZ3JlZSB3aXRoIExpbmRhIHRoYXQgdGhpcyANCm5hbWluZyBwb2xpY3kgaXMgbGlrZWx5IHRv
IGNvbmZ1c2UgdXNlcnMuICBJIGFsc28gY2FyZSBsZXNzIGFib3V0IHRoZQ0KY3VycmVudCB1c2Vy
cyB3aG8gdXNlIG1lbW1hcCBvcHRpb24uICBUaGlzIGNhc2UgaXMgcG1lbS1lbXVsYXRpb24gYW5k
DQp0aGV5IGtub3cgd2hhdCB0aGV5IGFyZSBkb2luZy4NCg0KQXNzdW1pbmcgYmxvY2sgZGV2aWNl
IGludGVyZmFjZSBpcyBuZWVkZWQgKGluIGFkZGl0aW9uIHRvIGRldmljZS1kYXgpDQpmb3Igdm9s
YXRpbGUgcmFuZ2UgZm9yIHVzZS1jYXNlcyBsaWtlIHN3YXAgZGV2aWNlLCBJIHdvbmRlciBpZiB1
c2VyIGNhbg0KYWN0dWFsbHkgc3BlY2lmeSBhIHJpZ2h0IHBtZW0gZGV2aWNlIGZvciBzd2FwIGZy
b20gT1MtaW5zdGFsbCBHVUkgd2hlbg0KYm90aCB2b2xhdGlsZSBhbmQgcGVyc2lzdGVudCBibG9j
ayBkZXZpY2VzIGFyZSBsaXN0ZWQgYXMgL2Rldi9wbWVtTi4gDQpTb21ldGltZXMgd2UgYXJlIHJl
c3RyaWN0ZWQgd2l0aCBHVUkgbWVudS4gIFNvbWUgdXNlcnMgdXNlIEdVSSBhbGwgdGhlDQp0aW1l
IGxpa2UgV2luZG93cyBhcyB3ZWxsLg0KDQpDYW4gd2UgZGlmZmVyZW50aWF0ZSB0aGUgbmFtaW5n
IGJ5IGFkZGluZyAndicgbGlrZSAncG1lbU52JyAoaWYgeW91DQpjYW4ndCBnbyB3aXRoICd2bWVt
TicpPyAgSSBkb24ndCB0aGluayBoYXZpbmcgJ3MnIGZvciBCVFQgd2FzIHRoYXQgYmFkLg0KIEl0
J3MgYmVlbiBoZWxwZnVsIHRvIHRlbGwgdXNlcnMgdGhhdCB0aGVzZSBwbWVtIGRldmljZXMgYXJl
IG5vdCBieXRlLQ0KYWRkcmVzc2FibGUuICBJIGFsc28gdGhpbmsgdGhhdCBCVFQgZm9yIHZvbGF0
aWxlIHJhbmdlIG1ha2VzIG5vIHNlbnNlDQoodW5sZXNzIGVtdWxhdGVkIGFzIHBlcnNpc3RlbnQg
bWVtb3J5IGJ5IG1lbW1hcCBvcHRpb24pLg0KDQpUaGFua3MsDQotVG9zaGkNCg0KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
