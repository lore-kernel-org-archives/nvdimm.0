Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FFEF210F93F4
 for <linux-nvdimm@lists.01.org>; Tue, 21 Aug 2018 10:52:20 -0700 (PDT)
Subject: Re: dmaengine support for PMEM
References: <A88D23C5-46BD-462D-92D7-22BF284A905C@raithlin.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <8d55e740-8caf-1b4d-6507-d18f99a309e6@intel.com>
Date: Tue, 21 Aug 2018 10:52:01 -0700
MIME-Version: 1.0
In-Reply-To: <A88D23C5-46BD-462D-92D7-22BF284A905C@raithlin.com>
Content-Language: en-US
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
To: Stephen Bates <sbates@raithlin.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAwOC8yMS8yMDE4IDEwOjM3IEFNLCBTdGVwaGVuICBCYXRlcyB3cm90ZToKPiBIaSBEYXZl
Cj4gCj4gSSBob3BlIHlvdSBhcmUgd2VsbC4gTG9nYW4gYW5kIEkgd2VyZSBsb29raW5nIGF0IGFk
ZGluZyBETUEgc3VwcG9ydCB0byBQTUVNIGFuZCB0aGVuIHdlcmUgaW5mb3JtZWQgeW91IGhhdmUg
cHJvcG9zZWQgc29tZSBwYXRjaGVzIHRvIGRvIGp1c3QgdGhhdCBmb3IgdGhlIGlvYXQgRE1BIGVu
Z2luZS4gVGhlIGxhdGVzdCB2ZXJzaW9uIG9mIHRob3NlIEkgY2FuIHNlZSB3ZXJlIHRoZSB2NyBm
cm9tIEF1Z3VzdCAyMDE3LiBJcyB0aGVyZSBhIG1vcmUgcmVjZW50IHZlcnNpb24/IFdoYXQgaGFw
cGVuZWQgdG8gdGhhdCBzZXJpZXM/Cj4gCj4gaHR0cHM6Ly9saXN0cy4wMS5vcmcvcGlwZXJtYWls
L2xpbnV4LW52ZGltbS8yMDE3LUF1Z3VzdC8wMTIyMDguaHRtbO+7vwo+IAo+IENoZWVycwo+ICAK
PiBTdGVwaGVuCj4gIAo+IAoKSGkgR3V5cy4gTm90aGluZyBoYXMgaGFwcGVuZWQuLi55ZXQuLi4g
SXQncyBqdXN0IG9uIGhvbGQgZm9yIG5vdy4KCkhlcmUncyB3aGVyZSBJIGxlZnQgaXQgbGFzdApo
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kamlhbmcvbGlu
dXguZ2l0L2xvZy8/aD1wbWVtX2Jsa19kbWEKCkkgZG8gdGhpbmsgd2UgbmVlZCB0byBkbyBzb21l
IHJld29yayB3aXRoIHRoZSBkbWFlbmdpbmUgaW4gb3JkZXIgdG8gZ2V0CmJldHRlciBlZmZpY2ll
bmN5IGFzIHdlbGwuIEF0IHNvbWUgcG9pbnQgSSB3b3VsZCBsaWtlIHRvIHNlZSBhIGNhbGwgaW4K
ZG1hZW5naW5lIHRoYXQgd2lsbCB0YWtlIGEgcmVxdWVzdCAoc2ltaWxhciB0byBtcSkgYW5kIGp1
c3Qgb3BlcmF0ZSBvbgp0aGF0IGFuZCBzdWJtaXQgdGhlIGRlc2NyaXB0b3JzIGluIGEgc2luZ2xl
IGNhbGwuIEkgdGhpbmsgdGhhdCBjYW4KcG9zc2libHkgZGVwcmVjYXRlIGFsbCB0aGUgaG9zdCBv
ZiBmdW5jdGlvbiBwb2ludGVycyBmb3IgZG1hZW5naW5lLiBJJ20KaG9waW5nIHRvIGZpbmQgc29t
ZSB0aW1lIHRvIHRha2UgYSBsb29rIGF0IHNvbWUgb2YgdGhpcyB3b3JrIHRvd2FyZHMgdGhlCmVu
ZCBvZiB0aGUgeWVhci4gQnV0IEknZCBiZSBoaWdobHkgaW50ZXJlc3RlZCBpZiB5b3UgZ3V5cyBo
YXZlIGlkZWFzIGFuZAp0aG91Z2h0cyBvbiB0aGlzIHRvcGljLiBBbmQgeW91IGFyZSB3ZWxjb21l
IHRvIHRha2UgbXkgcGF0Y2hlcyBhbmQgcnVuCndpdGggaXQuCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
