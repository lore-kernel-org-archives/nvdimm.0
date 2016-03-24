Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x232.google.com (mail-ob0-x232.google.com
 [IPv6:2607:f8b0:4003:c01::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7A931A1E94
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:21:46 -0700 (PDT)
Received: by mail-ob0-x232.google.com with SMTP id kf9so34750574obc.1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 08:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7155730.1PoRE68eiN@c203>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012603.21436.60864.stgit@dwillia2-desk3.jf.intel.com>
 <7155730.1PoRE68eiN@c203>
Date: Thu, 24 Mar 2016 08:21:20 -0700
Message-ID: <CAPcyv4jVtFtvPZkW3N8uevOfRPvs6nL=F8TWgw2tE15Xhf3RyA@mail.gmail.com>
Subject: Re: [PATCH 08/13] libnvdimm,
 blk: move i/o infrastructure to nd_namespace_blk
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

T24gVGh1LCBNYXIgMjQsIDIwMTYgYXQgNToyMiBBTSwgSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1
bXNoaXJuQHN1c2UuZGU+IHdyb3RlOgo+IE9uIE1pdHR3b2NoLCAyMy4gTcOkcnogMjAxNiAxODoy
NjowMyBDRVQgRGFuIFdpbGxpYW1zIHdyb3RlOgo+PiBDb25zb2xpZGF0ZSB0aGUgaW5mb3JtYXRp
b24gZm9yIGlzc3VpbmcgaS9vIHRvIGEgYmxrLW5hbWVzcGFjZSwgYW5kCj4+IGVsaW1pbmF0ZSBz
b21lIHBvaW50ZXIgY2hhc2luZy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+Cj4+IC0tLQo+IFsuLi5dCj4+ICAgICAgICAgICAgICAg
QlVHX09OKGxlbiA+IFBBR0VfU0laRSk7Cj4+IC0gICAgICAgICAgICAgZXJyID0gbmRfYmxrX2Rv
X2J2ZWMoYmxrX2RldiwgYmlwLCBidmVjLmJ2X3BhZ2UsIGxlbiwKPj4gLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBidmVjLmJ2X29mZnNldCwgcncsIGl0ZXIuYmlfc2VjdG9y
KTsKPj4gKyAgICAgICAgICAgICBlcnIgPSBuc2Jsa19kb19idmVjKG5zYmxrLCBiaXAsIGJ2ZWMu
YnZfcGFnZSwgbGVuLAo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidmVjLmJ2X29m
ZnNldCwgcncsIGl0ZXIuYmlfc2VjdG9yKTsKPj4gICAgICAgICAgICAgICBpZiAoZXJyKSB7Cj4+
IC0gICAgICAgICAgICAgICAgICAgICBkZXZfaW5mbygmYmxrX2Rldi0+bnNibGstPmNvbW1vbi5k
ZXYsCj4+ICsgICAgICAgICAgICAgICAgICAgICBkZXZfZGJnKCZuc2Jsay0+Y29tbW9uLmRldiwK
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaW8gZXJyb3IgaW4gJXMg
c2VjdG9yICVsbGQsIGxlbiAlZCxcbiIsCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKHJ3ID09IFJFQUQpID8gIlJFQUQiIDogIldSSVRFIiwKPj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAodW5zaWduZWQgbG9uZyBsb25nKSBpdGVyLmJpX3Nl
Y3RvciwgbGVuKTsKPgo+IFdoeSBpcyBhbiBJL08gZXJyb3Igc3VkZGVudGx5IGEgZGVidWcgbWVz
c2FnZSBpbnN0ZWFkIG9mIGFuIGVycm9yPwoKVHJ1ZSwgdGhhdCdzIGEgamFycmluZyBjaGFuZ2Ug
bm90IGRlc2NyaWJlZCBpbiB0aGUgbG9nLCBzaG91bGQKcHJvYmFibHkgYmUgaXRzIG93biBwYXRj
aC4gIFRoZSByYXRpb25hbGUgaXMgdGhhdCB1cHBlciBsYXllcnMgYWxyZWFkeQpoYXZlIGVycm9y
IHByaW50cyBmb3IgZmFpbGVkIGNvbW1hbmRzIGFuZCB0aGlzIG9uZSBpcyByZWR1bmRhbnQuCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGlt
bSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAx
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
