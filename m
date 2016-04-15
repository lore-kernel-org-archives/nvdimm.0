Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id E73D51A2353
 for <linux-nvdimm@lists.01.org>; Fri, 15 Apr 2016 10:00:33 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, btt: add btt startup debug
Date: Fri, 15 Apr 2016 17:00:31 +0000
Message-ID: <1460739631.3012.5.camel@intel.com>
References: <146068804238.24085.7095431982077468731.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <146068804238.24085.7095431982077468731.stgit@dwillia2-desk3.jf.intel.com>
Content-Language: en-US
Content-ID: <1036724346561C409298E467582E4B84@intel.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTA0LTE0IGF0IDE5OjQwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFJlcG9ydCB0aGUgcmVhc29uIGZvciBidHQgcHJvYmUgZmFpbHVyZXMgd2hlbiBkZWJ1ZyBpcyBl
bmFibGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFt
c0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbnZkaW1tL2J0dC5jIHzCoMKgwqDCoDYg
KysrKystDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KDQpSZXZlaXdlZC1ieTogVmlzaGFsIFZlcm1hIDxWaXNoYWwubC52ZXJtYUBpbnRlbC5jb20+
DQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9idHQuYyBiL2RyaXZlcnMvbnZk
aW1tL2J0dC5jDQo+IGluZGV4IGNjOWZhZmVkOTM2Mi4uNjhhN2MzYzFlZWQ5IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL252ZGltbS9idHQuYw0KPiArKysgYi9kcml2ZXJzL252ZGltbS9idHQuYw0K
PiBAQCAtMTM4MywxMSArMTM4MywxNSBAQCBpbnQgbnZkaW1tX25hbWVzcGFjZV9hdHRhY2hfYnR0
KHN0cnVjdA0KPiBuZF9uYW1lc3BhY2VfY29tbW9uICpuZG5zKQ0KPiDCoAlzdHJ1Y3QgYnR0ICpi
dHQ7DQo+IMKgCXNpemVfdCByYXdzaXplOw0KPiDCoA0KPiAtCWlmICghbmRfYnR0LT51dWlkIHx8
ICFuZF9idHQtPm5kbnMgfHwgIW5kX2J0dC0+bGJhc2l6ZSkNCj4gKwlpZiAoIW5kX2J0dC0+dXVp
ZCB8fCAhbmRfYnR0LT5uZG5zIHx8ICFuZF9idHQtPmxiYXNpemUpIHsNCj4gKwkJZGV2X2RiZygm
bmRfYnR0LT5kZXYsICJpbmNvbXBsZXRlIGJ0dA0KPiBjb25maWd1cmF0aW9uXG4iKTsNCj4gwqAJ
CXJldHVybiAtRU5PREVWOw0KPiArCX0NCj4gwqANCj4gwqAJcmF3c2l6ZSA9IG52ZGltbV9uYW1l
c3BhY2VfY2FwYWNpdHkobmRucykgLSBTWl80SzsNCj4gwqAJaWYgKHJhd3NpemUgPCBBUkVOQV9N
SU5fU0laRSkgew0KPiArCQlkZXZfZGJnKCZuZF9idHQtPmRldiwgIiVzIG11c3QgYmUgYXQgbGVh
c3QgJWxkDQo+IGJ5dGVzXG4iLA0KPiArCQkJCWRldl9uYW1lKCZuZG5zLT5kZXYpLCBBUkVOQV9N
SU5fU0laRQ0KPiArIFNaXzRLKTsNCj4gwqAJCXJldHVybiAtRU5YSU87DQo+IMKgCX0NCj4gwqAJ
bmRfcmVnaW9uID0gdG9fbmRfcmVnaW9uKG5kX2J0dC0+ZGV2LnBhcmVudCk7DQo+IA0KPiBfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0DQo+IExpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcNCj4gaHR0cHM6Ly9s
aXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlz
dApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4v
bGlzdGluZm8vbGludXgtbnZkaW1tCg==
