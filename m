Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6E4021951CA9
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 14:51:11 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm: fix phys_addr for nvdimm_clear_poison
Date: Tue, 25 Apr 2017 21:49:50 +0000
Message-ID: <1493156958.26622.8.camel@hpe.com>
References: <20170425211651.7640-1-toshi.kani@hpe.com>
 <20170425214422.GB15722@omniknight.lm.intel.com>
In-Reply-To: <20170425214422.GB15722@omniknight.lm.intel.com>
Content-Language: en-US
Content-ID: <1365CE7062905441BACC7666CC2782B2@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE3LTA0LTI1IGF0IDE1OjQ0IC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IE9uIDA0LzI1LCBUb3NoaSBLYW5pIHdyb3RlOg0KPiA+IG52ZGltbV9jbGVhcl9wb2lzb24oKSBl
eHBlY3RzIGEgcGh5c2ljYWwgYWRkcmVzcywgbm90IGFuIG9mZnNldC4NCj4gPiBGaXggbnNpb19y
d19ieXRlcygpIHRvIGNhbGwgbnZkaW1tX2NsZWFyX3BvaXNvbigpIHdpdGggYSBwaHlzaWNhbA0K
PiA+IGFkZHJlc3MuDQo+IA0KPiBHb29kIGNhdGNoIQ0KPiANCj4gPiANCj4gPiBTaWduZWQtb2Zm
LWJ5OiBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5jb20+DQo+ID4gQ2M6IERhbiBXaWxsaWFt
cyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IENjOiBEYXZlIEppYW5nIDxkYXZlLmpp
YW5nQGludGVsLmNvbT4NCj4gPiBDYzogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRl
bC5jb20+DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL252ZGltbS9jbGFpbS5jIHzCoMKgwqDCoDMg
KystDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL2NsYWltLmMgYi9kcml2ZXJz
L252ZGltbS9jbGFpbS5jDQo+ID4gaW5kZXggY2E2ZDU3Mi4uMGIzMTA3MyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL252ZGltbS9jbGFpbS5jDQo+ID4gKysrIGIvZHJpdmVycy9udmRpbW0vY2xh
aW0uYw0KPiA+IEBAIC0yNTQsNyArMjU0LDggQEAgc3RhdGljIGludCBuc2lvX3J3X2J5dGVzKHN0
cnVjdA0KPiA+IG5kX25hbWVzcGFjZV9jb21tb24gKm5kbnMsDQo+ID4gwqAJCQkJJiYgKCFuZG5z
LT5jbGFpbSB8fA0KPiA+ICFpc19uZF9idHQobmRucy0+Y2xhaW0pKSkgew0KPiA+IMKgCQkJbG9u
ZyBjbGVhcmVkOw0KPiA+IMKgDQo+ID4gLQkJCWNsZWFyZWQgPSBudmRpbW1fY2xlYXJfcG9pc29u
KCZuZG5zLT5kZXYsDQo+ID4gb2Zmc2V0LCBzaXplKTsNCj4gPiArCQkJY2xlYXJlZCA9IG52ZGlt
bV9jbGVhcl9wb2lzb24oJm5kbnMtPmRldiwNCj4gPiArCQkJCQluc2lvLT5yZXMuc3RhcnQgKyBv
ZmZzZXQsDQo+ID4gc2l6ZSk7DQo+IA0KPiBTaG91bGQgd2UgYmUgdXNpbmcgbnNpby0+cmVzLnN0
YXJ0IGhlcmUgb3IgbnNpby0+YWRkciA/DQoNCm5zaW8tPmFkZHIgaXMgYSB2aXJ0dWFsIGFkZHJl
c3MuICBXZSBuZWVkIHRvIHBhc3MgdGhlIHBoeXNpY2FsIGFkZHJlc3MNCm9mIHRoaXMgcmFuZ2Uu
DQoNClRoYW5rcywNCi1Ub3NoaQ0KDQoNCj4gDQo+ID4gwqAJCQlpZiAoY2xlYXJlZCA8IHNpemUp
DQo+ID4gwqAJCQkJcmMgPSAtRUlPOw0KPiA+IMKgCQkJaWYgKGNsZWFyZWQgPiAwICYmIGNsZWFy
ZWQgLyA1MTIpIHsKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
