Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DECF1A1E94
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:15:10 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id i21so16055598oig.1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:14:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44211312.XSqkvMyyJm@c203>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012547.21436.51123.stgit@dwillia2-desk3.jf.intel.com>
 <44211312.XSqkvMyyJm@c203>
Date: Thu, 24 Mar 2016 08:14:10 -0700
Message-ID: <CAPcyv4gXw+a5uuZ_hwmb6n=P2x9fGfD_5TxAKZ+sB8=XePoJVA@mail.gmail.com>
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

T24gVGh1LCBNYXIgMjQsIDIwMTYgYXQgNDo0OCBBTSwgSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1
bXNoaXJuQHN1c2UuZGU+IHdyb3RlOgo+IE9uIE1pdHR3b2NoLCAyMy4gTcOkcnogMjAxNiAxODoy
NTo0NyBDRVQgRGFuIFdpbGxpYW1zIHdyb3RlOgo+PiBSZWdpc3RlciBhIGNhbGxiYWNrIHRvIGNs
ZWFuIHVwIHRoZSByZXF1ZXN0X3F1ZXVlIGFuZCBwdXQgdGhlIGdlbmRpc2sgYXQKPj4gZHJpdmVy
IGRpc2FibGUgdGltZS4KPj4KPj4gQ2M6IFJvc3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxpbnV4
LmludGVsLmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFt
c0BpbnRlbC5jb20+Cj4KPiBbLi4uXQo+Cj4+Cj4+ICBzdGF0aWMgaW50IG5kX2Jsa19yZW1vdmUo
c3RydWN0IGRldmljZSAqZGV2KQo+PiAgewo+PiAtICAgICBzdHJ1Y3QgbmRfYmxrX2RldmljZSAq
YmxrX2RldiA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOwo+PiAtCj4+ICAgICAgIGlmIChpc19uZF9i
dHQoZGV2KSkKPj4gICAgICAgICAgICAgICBudmRpbW1fbmFtZXNwYWNlX2RldGFjaF9idHQodG9f
bmRfYnR0KGRldikpOwo+PiAtICAgICBlbHNlCj4+IC0gICAgICAgICAgICAgbmRfYmxrX2RldGFj
aF9kaXNrKGJsa19kZXYpOwo+PiAtICAgICBrZnJlZShibGtfZGV2KTsKPj4gLQo+PiAgICAgICBy
ZXR1cm4gMDsKPj4gIH0KPj4KPgo+IENhbid0IHRoaXMgYmUgdm9pZD8KPgoKVGhhdCdzIG5vdCBo
b3cgdGhlIGNvcmUgZGVmaW5lcyB0aGlzOgoKc3RydWN0IGRldmljZV9kcml2ZXIgewouLi4KICAg
ICAgICBpbnQgKCpyZW1vdmUpIChzdHJ1Y3QgZGV2aWNlICpkZXYpOwouLi4KfTsKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
