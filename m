Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA3922130A506
 for <linux-nvdimm@lists.01.org>; Wed,  7 Aug 2019 16:52:28 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Fix fallthrough warning
Date: Wed, 7 Aug 2019 23:49:56 +0000
Message-ID: <e4279fee162036bc43d12894efbdd0e8e4ce4393.camel@intel.com>
References: <156521347159.1442374.1381360879102718899.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156521347159.1442374.1381360879102718899.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <97D880388598894E976D514BA3DF7688@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE5LTA4LTA3IGF0IDE0OjMxIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFVzZSB0aGUgZXhwZWN0ZWQgJ2ZhbGwgdGhyb3VnaCcgZGVzaWduYXRpb24gdG8gZml4Og0KPiAN
Cj4gICAgIHRvb2xzL3Rlc3RpbmcvbnZkaW1tL3Rlc3QvbmZpdC5jOiBJbiBmdW5jdGlvbg0KPiDi
gJhuZF9pbnRlbF90ZXN0X2ZpbmlzaF9xdWVyeeKAmToNCj4gICAgIHRvb2xzL3Rlc3RpbmcvbnZk
aW1tL3Rlc3QvbmZpdC5jOjQzMzoxMzogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQNCj4gbWF5IGZh
bGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dDQo+ICAgICAgICBmdy0+c3RhdGUg
PSBGV19TVEFURV9VUERBVEVEOw0KPiAgICAgICAgfn5+fn5+fn5+fl5+fn5+fn5+fn5+fn5+fn5+
fg0KPiAgICAgdG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9uZml0LmM6NDM1OjI6IG5vdGU6IGhl
cmUNCj4gICAgICAgY2FzZSBGV19TVEFURV9VUERBVEVEOg0KPiAgICAgICBefn5+DQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4g
LS0tDQo+ICB0b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYyB8ICAgIDMgKy0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQoNCkxvb2tzIGdv
b2QsDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+
DQoNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYw0K
PiBiL3Rvb2xzL3Rlc3RpbmcvbnZkaW1tL3Rlc3QvbmZpdC5jDQo+IGluZGV4IDUwN2U2ZjRjYmI1
My4uYmY2NDIyYTZhZjdmIDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5nL252ZGltbS90ZXN0
L25maXQuYw0KPiArKysgYi90b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYw0KPiBAQCAt
NDI4LDEwICs0MjgsOSBAQCBzdGF0aWMgaW50IG5kX2ludGVsX3Rlc3RfZmluaXNoX3F1ZXJ5KHN0
cnVjdA0KPiBuZml0X3Rlc3QgKnQsDQo+ICAJCQlkZXZfZGJnKGRldiwgIiVzOiBzdGlsbCB2ZXJp
ZnlpbmdcbiIsIF9fZnVuY19fKTsNCj4gIAkJCWJyZWFrOw0KPiAgCQl9DQo+IC0NCj4gIAkJZGV2
X2RiZyhkZXYsICIlczogdHJhbnNpdGlvbiBvdXQgdmVyaWZ5XG4iLCBfX2Z1bmNfXyk7DQo+ICAJ
CWZ3LT5zdGF0ZSA9IEZXX1NUQVRFX1VQREFURUQ7DQo+IC0JCS8qIHdlIGFyZSBnb2luZyB0byBm
YWxsIHRocm91Z2ggaWYgaXQncyAiZG9uZSIgKi8NCj4gKwkJLyogZmFsbCB0aHJvdWdoICovDQo+
ICAJY2FzZSBGV19TVEFURV9VUERBVEVEOg0KPiAgCQluZF9jbWQtPnN0YXR1cyA9IDA7DQo+ICAJ
CS8qIGJvZ3VzIHRlc3QgdmVyc2lvbiAqLw0KPiANCj4gX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18NCj4gTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdA0KPiBM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnDQo+IGh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4v
bGlzdGluZm8vbGludXgtbnZkaW1tDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
