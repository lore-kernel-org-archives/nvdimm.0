Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73BD01A1ECA
 for <linux-nvdimm@lists.01.org>; Mon,  9 May 2016 15:59:49 -0700 (PDT)
Message-ID: <1462834244.27137.117.camel@hpe.com>
Subject: Re: [PATCH v3 2/5] block: Add bdev_supports_dax() for dax mount checks
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 09 May 2016 16:50:44 -0600
In-Reply-To: <1462833254.27137.113.camel@hpe.com>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
 <1462494596-20938-3-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4hKpvF6uqBzV+1seUzFfxDZM-ApordAL_NecRLNcdNgwg@mail.gmail.com>
 <1462817565.27137.102.camel@hpe.com>
 <CAPcyv4g6mPsmHM6OSTi78n_KBKCZrb1ou90=xWuhc7eGyx0DPg@mail.gmail.com>
 <20160509211903.GW18496@dastard> <1462833254.27137.113.camel@hpe.com>
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
To: Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTA1LTA5IGF0IDE2OjM0IC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOgo+IE9u
IFR1ZSwgMjAxNi0wNS0xMCBhdCAwNzoxOSArMTAwMCwgRGF2ZSBDaGlubmVyIHdyb3RlOgrCoDoK
PiA+ID4gPiA+IAo+ID4gPiA+ID4gVGhpcyBwYXRjaCBzaG91bGQgcmVwbGFjZSBibGtkZXZfZGF4
X2NhcGFibGUoKSwgb3IganVzdCByZXVzZQo+ID4gPiA+ID4gdGhhdCBleGlzdGluZyByb3V0aW5l
LCBvciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPwo+ID4gPiA+Cj4gPiA+ID4gR29vZCBxdWVzdGlv
bi7CoMKgYmRldl9zdXBwb3J0c19kYXgoKSBpcyBhIGhlbHBlciBmdW5jdGlvbiB0YWlsb3JlZAo+
ID4gPiA+IGZvciB0aGUgZmlsZXN5c3RlbSdzIG1vdW50IC1vIGRheCBjYXNlLsKgwqBXaGlsZSBi
bGtkZXZfZGF4X2NhcGFibGUoKQo+ID4gPiA+IGlzIHNpbWlsYXIsIGl0IGRvZXMgbm90IG5lZWQg
ZXJyb3IgbWVzc2FnZXMgbGlrZSAiZGV2aWNlIGRvZXMgbm90Cj4gPiA+ID4gc3VwcG9ydCBkYXgi
IHNpbmNlIGl0IGltcGxpY2l0bHkgZW5hYmxlcyBkYXggd2hlbiBjYXBhYmxlLsKgwqBTbywgSQo+
ID4gPiA+IHRoaW5rIHdlIGNhbiBrZWVwIGJsa2Rldl9kYXhfY2FwYWJsZSgpLCBidXQgY2hhbmdl
IGl0IHRvIGNhbGwKPiA+ID4gPiBiZGV2X2RpcmVjdF9hY2Nlc3MoKSBzbyB0aGF0IGFjdHVhbCBj
aGVjayBpcyBwZXJmb3JtZWQgaW4gYSBzaW5nbGUKPiA+ID4gPiBwbGFjZS4KPiA+ID4KPiA+ID4g
U291bmRzIGdvb2QgdG8gbWUuCj4gPgo+ID4gQ2FuIHlvdSBuYW1lIHRoZW0gY29uc2lzdGVudGx5
IHRoZW4/IGkuZS4gYmxrZGV2X2RheF9zdXBwb3J0ZWQoKSBhbmQKPiA+IGJsa2Rldl9kYXhfY2Fw
YWJsZSgpPwo+Cj4gU3VyZS4gwqBXaWxsIGRvLgoKSSB3aWxsIGtlZXAgdGhlICJiZGV2XyIgcHJl
Zml4IHRvIGJlIGNvbnNpc3RlbnQgd2l0aCBiZGV2X2RpcmVjdF9hY2Nlc3MoKSwKaS5lLiBiZGV2
X2RheF9zdXBwb3J0ZWQoKSBhbmQgYmRldl9kYXhfY2FwYWJsZSgpLgoKLVRvc2hpCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWls
aW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
