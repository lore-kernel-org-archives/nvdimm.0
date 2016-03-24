Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 339B61A1E94
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:22:38 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id d205so64643004oia.0
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:22:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2448247.bv1n5rEkZ3@c203>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <44211312.XSqkvMyyJm@c203>
 <CAPcyv4gXw+a5uuZ_hwmb6n=P2x9fGfD_5TxAKZ+sB8=XePoJVA@mail.gmail.com>
 <2448247.bv1n5rEkZ3@c203>
Date: Thu, 24 Mar 2016 08:21:52 -0700
Message-ID: <CAPcyv4h6x3uePr0Srr_nQDeWyO2u1nhZeUE_2jpAePsBFmUdCQ@mail.gmail.com>
Subject: Re: [PATCH 05/13] libnvdimm,
 blk: use devm_add_action to release bdev resources
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBNYXIgMjQsIDIwMTYgYXQgODoxNSBBTSwgSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1
bXNoaXJuQHN1c2UuZGU+IHdyb3RlOgo+IE9uIERvbm5lcnN0YWcsIDI0LiBNw6RyeiAyMDE2IDA4
OjE0OjEwIENFVCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4+IE9uIFRodSwgTWFyIDI0LCAyMDE2IGF0
IDQ6NDggQU0sIEpvaGFubmVzIFRodW1zaGlybiA8anRodW1zaGlybkBzdXNlLmRlPgo+IHdyb3Rl
Ogo+PiA+IE9uIE1pdHR3b2NoLCAyMy4gTcOkcnogMjAxNiAxODoyNTo0NyBDRVQgRGFuIFdpbGxp
YW1zIHdyb3RlOgo+PiA+PiBSZWdpc3RlciBhIGNhbGxiYWNrIHRvIGNsZWFuIHVwIHRoZSByZXF1
ZXN0X3F1ZXVlIGFuZCBwdXQgdGhlIGdlbmRpc2sgYXQKPj4gPj4gZHJpdmVyIGRpc2FibGUgdGlt
ZS4KPj4gPj4KPj4gPj4gQ2M6IFJvc3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVs
LmNvbT4KPj4gPj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+Cj4+ID4KPj4gPiBbLi4uXQo+PiA+Cj4+ID4+ICBzdGF0aWMgaW50IG5kX2Jsa19y
ZW1vdmUoc3RydWN0IGRldmljZSAqZGV2KQo+PiA+PiAgewo+PiA+Pgo+PiA+PiAtICAgICBzdHJ1
Y3QgbmRfYmxrX2RldmljZSAqYmxrX2RldiA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOwo+PiA+PiAt
Cj4+ID4+Cj4+ID4+ICAgICAgIGlmIChpc19uZF9idHQoZGV2KSkKPj4gPj4KPj4gPj4gICAgICAg
ICAgICAgICBudmRpbW1fbmFtZXNwYWNlX2RldGFjaF9idHQodG9fbmRfYnR0KGRldikpOwo+PiA+
Pgo+PiA+PiAtICAgICBlbHNlCj4+ID4+IC0gICAgICAgICAgICAgbmRfYmxrX2RldGFjaF9kaXNr
KGJsa19kZXYpOwo+PiA+PiAtICAgICBrZnJlZShibGtfZGV2KTsKPj4gPj4gLQo+PiA+Pgo+PiA+
PiAgICAgICByZXR1cm4gMDsKPj4gPj4KPj4gPj4gIH0KPj4gPgo+PiA+IENhbid0IHRoaXMgYmUg
dm9pZD8KPj4KPj4gVGhhdCdzIG5vdCBob3cgdGhlIGNvcmUgZGVmaW5lcyB0aGlzOgo+Pgo+PiBz
dHJ1Y3QgZGV2aWNlX2RyaXZlciB7Cj4+IC4uLgo+PiAgICAgICAgIGludCAoKnJlbW92ZSkgKHN0
cnVjdCBkZXZpY2UgKmRldik7Cj4+IC4uLgo+PiB9Owo+Cj4gQWggT0ssIGRpZG4ndCBzZWUgdGhp
cywgc29ycnkKCk5vIHdvcnJpZXMuICBUaGFua3MgZm9yIHRoZSByZXZpZXchCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
