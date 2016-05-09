Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB0761A1EF1
 for <linux-nvdimm@lists.01.org>; Mon,  9 May 2016 11:21:45 -0700 (PDT)
Message-ID: <1462817565.27137.102.camel@hpe.com>
Subject: Re: [PATCH v3 2/5] block: Add bdev_supports_dax() for dax mount checks
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 09 May 2016 12:12:45 -0600
In-Reply-To: <CAPcyv4hKpvF6uqBzV+1seUzFfxDZM-ApordAL_NecRLNcdNgwg@mail.gmail.com>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
 <1462494596-20938-3-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4hKpvF6uqBzV+1seUzFfxDZM-ApordAL_NecRLNcdNgwg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, Jens Axboe <axboe@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

T24gU3VuLCAyMDE2LTA1LTA4IGF0IDEyOjE0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gVGh1LCBNYXkgNSwgMjAxNiBhdCA1OjI5IFBNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhw
ZS5jb20+IHdyb3RlOgrCoDoKPiA+ICtpbnQgYmRldl9zdXBwb3J0c19kYXgoc3RydWN0IHN1cGVy
X2Jsb2NrICpzYiwgaW50IGJsb2Nrc2l6ZSkKPiA+ICt7Cj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgYmxrX2RheF9jdGwgZGF4ID0gewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oC5zZWN0b3IgPSAwLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5zaXplID0g
UEFHRV9TSVpFLAo+ID4gK8KgwqDCoMKgwqDCoMKgfTsKPiA+ICvCoMKgwqDCoMKgwqDCoGludCBl
cnI7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoYmxvY2tzaXplICE9IFBBR0VfU0laRSkg
ewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZmc19tc2coc2IsIEtFUk5fRVJS
LCAiZXJyb3I6IHVuc3VwcG9ydGVkIGJsb2Nrc2l6ZSBmb3IKPiA+IGRheCIpOwo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFMOwo+ID4gK8KgwqDCoMKgwqDC
oMKgfQo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgZXJyID0gYmRldl9kaXJlY3RfYWNjZXNzKHNi
LT5zX2JkZXYsICZkYXgpOwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGVyciA8IDApIHsKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzd2l0Y2ggKGVycikgewo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNhc2UgLUVPUE5PVFNVUFA6Cj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZmc19tc2coc2IsIEtFUk5fRVJSLAo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgImVycm9yOiBkZXZpY2UgZG9lcyBub3Qgc3VwcG9ydCBkYXgiKTsKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7Cj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY2FzZSAtRUlOVkFMOgo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2ZnNfbXNnKHNiLCBLRVJOX0VSUiwK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCJlcnJvcjogdW5hbGlnbmVkIHBhcnRpdGlvbiBmb3IgZGF4Iik7Cj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRlZmF1bHQ6Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZmc19tc2coc2IsIEtFUk5fRVJSLAo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgImVycm9yOiBkYXggYWNjZXNzIGZhaWxlZCAoJWQpIiwgZXJyKTsKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIGVycjsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiA+ICsKPiA+ICvCoMKgwqDCoMKg
wqDCoHJldHVybiAwOwo+ID4gK30KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChiZGV2X3N1cHBvcnRz
X2RheCk7Cj4KPiBUaGlzIHBhdGNoIHNob3VsZCByZXBsYWNlIGJsa2Rldl9kYXhfY2FwYWJsZSgp
LCBvciBqdXN0IHJldXNlIHRoYXQKPiBleGlzdGluZyByb3V0aW5lLCBvciBhbSBJIG1pc3Npbmcg
c29tZXRoaW5nPwoKR29vZCBxdWVzdGlvbi4gwqBiZGV2X3N1cHBvcnRzX2RheCgpIGlzIGEgaGVs
cGVyIGZ1bmN0aW9uIHRhaWxvcmVkIGZvciB0aGUKZmlsZXN5c3RlbSdzIG1vdW50IC1vIGRheCBj
YXNlLiDCoFdoaWxlIGJsa2Rldl9kYXhfY2FwYWJsZSgpIGlzIHNpbWlsYXIsIGl0CmRvZXMgbm90
IG5lZWQgZXJyb3IgbWVzc2FnZXMgbGlrZSAiZGV2aWNlIGRvZXMgbm90IHN1cHBvcnQgZGF4IiBz
aW5jZSBpdAppbXBsaWNpdGx5IGVuYWJsZXMgZGF4IHdoZW4gY2FwYWJsZS4gwqBTbywgSSB0aGlu
ayB3ZSBjYW4ga2VlcApibGtkZXZfZGF4X2NhcGFibGUoKSwgYnV0IGNoYW5nZSBpdCB0byBjYWxs
wqBiZGV2X2RpcmVjdF9hY2Nlc3MoKSBzbyB0aGF0CmFjdHVhbCBjaGVjayBpcyBwZXJmb3JtZWQg
aW4gYSBzaW5nbGUgcGxhY2UuCgpUaGFua3MsCi1Ub3NoaQoKCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
