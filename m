Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 731C021A1348D
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 15:44:44 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2] x86, uaccess: introduce copy_from_iter_wt for pmem /
 writethrough operations
Date: Fri, 5 May 2017 22:44:40 +0000
Message-ID: <1494024273.30303.71.camel@hpe.com>
References: <20170427063054.soejyqocqqrihfdw@gmail.com>
 <149340820800.28724.16189291963486607562.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1494016773.30303.69.camel@hpe.com>
 <CAPcyv4igCk9EBXSCVr8W1B-oNwq8q5kr7AMTkwvnMAhdwMgjRA@mail.gmail.com>
In-Reply-To: <CAPcyv4igCk9EBXSCVr8W1B-oNwq8q5kr7AMTkwvnMAhdwMgjRA@mail.gmail.com>
Content-Language: en-US
Content-ID: <8A23498DC05EBE4FACADA88123ACAA65@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "mingo@redhat.com" <mingo@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA1LTA1IGF0IDE1OjI1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgTWF5IDUsIDIwMTcgYXQgMTozOSBQTSwgS2FuaSwgVG9zaGltaXRzdSA8dG9zaGku
a2FuaUBocGUuY29tPg0KPiB3cm90ZToNCiA6DQo+ID4gPiAtLS0NCj4gPiA+IENoYW5nZXMgc2lu
Y2UgdGhlIGluaXRpYWwgUkZDOg0KPiA+ID4gKiBzL3dyaXRldGhydS93dC8gc2luY2Ugd2UgYWxy
ZWFkeSBoYXZlIGlvcmVtYXBfd3QoKSwNCj4gPiA+IHNldF9tZW1vcnlfd3QoKSwgZXRjLiAoSW5n
bykNCj4gPiANCj4gPiBTb3JyeSBJIHNob3VsZCBoYXZlIHNhaWQgZWFybGllciwgYnV0IEkgdGhp
bmsgdGhlIHRlcm0gInd0IiBpcw0KPiA+IG1pc2xlYWRpbmcuwqDCoE5vbi10ZW1wb3JhbCBzdG9y
ZXMgdXNlZCBpbiBtZW1jcHlfd3QoKSBwcm92aWRlIFdDDQo+ID4gc2VtYW50aWNzLCBub3QgV1Qg
c2VtYW50aWNzLg0KPiANCj4gVGhlIG5vbi10ZW1wb3JhbCBzdG9yZXMgZG8sIGJ1dCBtZW1jcHlf
d3QoKSBpcyB1c2luZyBhIGNvbWJpbmF0aW9uIG9mDQo+IG5vbi10ZW1wb3JhbCBzdG9yZXMgYW5k
IGV4cGxpY2l0IGNhY2hlIGZsdXNoaW5nLg0KPiANCj4gPiBIb3cgYWJvdXQgdXNpbmcgIm5vY2Fj
aGUiIGFzIGl0J3MgYmVlbg0KPiA+IHVzZWQgaW4gX19jb3B5X3VzZXJfbm9jYWNoZSgpPw0KPiAN
Cj4gVGhlIGRpZmZlcmVuY2UgaW4gbXkgbWluZCBpcyB0aGF0IHRoZSAiX25vY2FjaGUiIHN1ZmZp
eCBpbmRpY2F0ZXMNCj4gb3Bwb3J0dW5pc3RpYyAvIG9wdGlvbmFsIGNhY2hlIHBvbGx1dGlvbiBh
dm9pZGFuY2Ugd2hlcmVhcyAiX3d0Ig0KPiBzdHJpY3RseSBhcnJhbmdlcyBmb3IgY2FjaGVzIG5v
dCB0byBjb250YWluIGRpcnR5IGRhdGEgdXBvbg0KPiBjb21wbGV0aW9uIG9mIHRoZSByb3V0aW5l
LiBGb3IgZXhhbXBsZSwgbm9uLXRlbXBvcmFsIHN0b3JlcyBvbiBvbGRlcg0KPiB4ODYgY3B1cyBj
b3VsZCBwb3RlbnRpYWxseSBsZWF2ZSBkaXJ0eSBkYXRhIGluIHRoZSBjYWNoZSwgc28NCj4gbWVt
Y3B5X3d0IG9uIHRob3NlIGNwdXMgd291bGQgbmVlZCB0byB1c2UgZXhwbGljaXQgY2FjaGUgZmx1
c2hpbmcuDQoNCkkgc2VlLiAgSSBhZ3JlZSB0aGF0IGl0cyBiZWhhdmlvciBpcyBkaWZmZXJlbnQg
ZnJvbSB0aGUgZXhpc3Rpbmcgb25lDQp3aXRoICJfbm9jYWNoZSIuICAgVGhhdCBzYWlkLCBJIHRo
aW5rICJ3dCIgb3IgIndyaXRlLXRocm91Z2giIGdlbmVyYWxseQ0KbWVhbnMgdGhhdCB3cml0ZXMg
YWxsb2NhdGUgY2FjaGVsaW5lcyBhbmQga2VlcCB0aGVtIGNsZWFuIGJ5IHdyaXRpbmcgdG8NCm1l
bW9yeS4gIFNvLCBzdWJzZXF1ZW50IHJlYWRzIHRvIHRoZSBkZXN0aW5hdGlvbiB3aWxsIGhpdCB0
aGUNCmNhY2hlbGluZXMuICBUaGlzIGlzIG5vdCB0aGUgY2FzZSB3aXRoIHRoaXMgaW50ZXJmYWNl
Lg0KDQpUaGFua3MsDQotVG9zaGkNCiAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
