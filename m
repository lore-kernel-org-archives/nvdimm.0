Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0FC121BADAD8
 for <linux-nvdimm@lists.01.org>; Sat,  1 Jul 2017 22:20:28 -0700 (PDT)
Message-ID: <1498972923.28685.1.camel@kernel.org>
Subject: Re: [PATCH] libnvdimm: fix the clear-error check in nsio_rw_bytes
From: Vishal Verma <vishal@kernel.org>
Date: Sat, 01 Jul 2017 23:22:03 -0600
In-Reply-To: <CAPcyv4jz_zOGieP+TeF0yPUMBgh1qDkFoms2W4g=+hN1-SZcBw@mail.gmail.com>
References: <20170701003252.13171-1-vishal.l.verma@intel.com>
 <20170701003252.13171-2-vishal.l.verma@intel.com>
 <CAPcyv4jz_zOGieP+TeF0yPUMBgh1qDkFoms2W4g=+hN1-SZcBw@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA2LTMwIGF0IDE4OjM5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gRnJpLCBKdW4gMzAsIDIwMTcgYXQgNTozMiBQTSwgVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jCj4gb20+IHdyb3RlOgo+ID4gQSBsZWZ0b3ZlciBmcm9tIHRoZSAnYmFuZGFp
ZCcgZml4IHRoYXQgZGlzYWJsZWQgQlRUIGVycm9yIGNsZWFyaW5nCj4gPiBpbgo+ID4gcndfYnl0
ZXMgcmVzdWx0ZWQgaW4gYW4gaW5jb3JyZWN0IGNoZWNrLiBBZnRlciB3ZSBjb252ZXJ0ZWQgdGhl
c2UKPiA+IGNoZWNrcwo+ID4gb3ZlciB0byB1c2UgdGhlIE5WRElNTV9JT19BVE9NSUMgZmxhZywg
dGhlIG5kbnMtPmNsYWltIGNoZWNrIHdhcwo+ID4gYm90aAo+ID4gcmVkdW5kYW50LCBhbmQgaW5j
b3JyZWN0LiBSZW1vdmUgaXQuCj4gPiAKPiA+IENjOiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGlu
dGVsLmNvbT4KPiA+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4K
PiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pgo+ID4gLS0tCj4gPiDCoGRyaXZlcnMvbnZkaW1tL2NsYWltLmMgfCAzICstLQo+ID4gwqAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCj4gPiAKPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL252ZGltbS9jbGFpbS5jIGIvZHJpdmVycy9udmRpbW0vY2xhaW0uYwo+
ID4gaW5kZXggOGQyM2Y2OC4uZjhhZDkyYiAxMDA2NDQKPiA+IC0tLSBhL2RyaXZlcnMvbnZkaW1t
L2NsYWltLmMKPiA+ICsrKyBiL2RyaXZlcnMvbnZkaW1tL2NsYWltLmMKPiA+IEBAIC0yODksOCAr
Mjg5LDcgQEAgc3RhdGljIGludCBuc2lvX3J3X2J5dGVzKHN0cnVjdAo+ID4gbmRfbmFtZXNwYWNl
X2NvbW1vbiAqbmRucywKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqIHdv
cmsgYXJvdW5kIHRoaXMgY29sbGlzaW9uLgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCovCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChJU19BTElH
TkVEKG9mZnNldCwgNTEyKSAmJiBJU19BTElHTkVEKHNpemUsCj4gPiA1MTIpCj4gPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAm
JiAhKGZsYWdzICYgTlZESU1NX0lPX0FUT01JQykKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCYmICFuZG5zLT5jbGFpbSkg
ewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgJiYgIShmbGFncyAmIE5WRElNTV9JT19BVE9NSUMpKSB7Cj4gCj4gU2hvdWxk
IHRoaXMgYWxzbyBnbyB0byAtc3RhYmxlIG90aGVyd2lzZSB3ZSB3b24ndCBjbGVhciBlcnJvcnMg
b24KPiBwbWVtCj4gZGV2aWNlcyBjbGFpbWVkIGJ5ICdwZm4nIGluc3RhbmNlcywgcmlnaHQ/CgpZ
ZXMgSSB0aGluayBpdCBzaG91bGQuLgpTaG91bGQgSSBqdXN0IHJlc2VuZCB3aXRoIHN0YWJsZSBD
QydkPwoKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+
IExpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKPiBMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCj4g
aHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
