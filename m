Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D83051A1EFE
 for <linux-nvdimm@lists.01.org>; Mon,  9 May 2016 15:43:14 -0700 (PDT)
Message-ID: <1462833254.27137.113.camel@hpe.com>
Subject: Re: [PATCH v3 2/5] block: Add bdev_supports_dax() for dax mount checks
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 09 May 2016 16:34:14 -0600
In-Reply-To: <20160509211903.GW18496@dastard>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
 <1462494596-20938-3-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4hKpvF6uqBzV+1seUzFfxDZM-ApordAL_NecRLNcdNgwg@mail.gmail.com>
 <1462817565.27137.102.camel@hpe.com>
 <CAPcyv4g6mPsmHM6OSTi78n_KBKCZrb1ou90=xWuhc7eGyx0DPg@mail.gmail.com>
 <20160509211903.GW18496@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, Jens Axboe <axboe@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA1LTEwIGF0IDA3OjE5ICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
T24gTW9uLCBNYXkgMDksIDIwMTYgYXQgMTE6MjM6MDNBTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+ID4gCj4gPiBPbiBNb24sIE1heSA5LCAyMDE2IGF0IDExOjEyIEFNLCBUb3NoaSBLYW5p
IDx0b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOgo+ID4gPiAKPiA+ID4gT24gU3VuLCAyMDE2LTA1
LTA4IGF0IDEyOjE0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4gPiA+ID4gCj4gPiA+ID4g
T24gVGh1LCBNYXkgNSwgMjAxNiBhdCA1OjI5IFBNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhw
ZS5jb20+Cj4gPiA+ID4gd3JvdGU6CsKgOgo+ID4gPiA+IFRoaXMgcGF0Y2ggc2hvdWxkIHJlcGxh
Y2UgYmxrZGV2X2RheF9jYXBhYmxlKCksIG9yIGp1c3QgcmV1c2UgdGhhdAo+ID4gPiA+IGV4aXN0
aW5nIHJvdXRpbmUsIG9yIGFtIEkgbWlzc2luZyBzb21ldGhpbmc/Cj4gPiA+Cj4gPiA+IEdvb2Qg
cXVlc3Rpb24uwqDCoGJkZXZfc3VwcG9ydHNfZGF4KCkgaXMgYSBoZWxwZXIgZnVuY3Rpb24gdGFp
bG9yZWQgZm9yCj4gPiA+IHRoZSBmaWxlc3lzdGVtJ3MgbW91bnQgLW8gZGF4IGNhc2UuwqDCoFdo
aWxlIGJsa2Rldl9kYXhfY2FwYWJsZSgpIGlzCj4gPiA+IHNpbWlsYXIsIGl0IGRvZXMgbm90IG5l
ZWQgZXJyb3IgbWVzc2FnZXMgbGlrZSAiZGV2aWNlIGRvZXMgbm90Cj4gPiA+IHN1cHBvcnQgZGF4
IiBzaW5jZSBpdCBpbXBsaWNpdGx5IGVuYWJsZXMgZGF4IHdoZW4gY2FwYWJsZS7CoMKgU28sIEkK
PiA+ID4gdGhpbmsgd2UgY2FuIGtlZXAgYmxrZGV2X2RheF9jYXBhYmxlKCksIGJ1dCBjaGFuZ2Ug
aXQgdG8gY2FsbAo+ID4gPiBiZGV2X2RpcmVjdF9hY2Nlc3MoKSBzbyB0aGF0IGFjdHVhbCBjaGVj
ayBpcyBwZXJmb3JtZWQgaW4gYSBzaW5nbGUKPiA+ID4gcGxhY2UuCj4gPgo+ID4gU291bmRzIGdv
b2QgdG8gbWUuCj4KPiBDYW4geW91IG5hbWUgdGhlbSBjb25zaXN0ZW50bHkgdGhlbj8gaS5lLiBi
bGtkZXZfZGF4X3N1cHBvcnRlZCgpIGFuZAo+IGJsa2Rldl9kYXhfY2FwYWJsZSgpPwoKU3VyZS4g
wqBXaWxsIGRvLgoKVGhhbmtzLAotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
