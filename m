Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B09221191F29
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 12:15:35 -0800 (PST)
Subject: Re: [PATCH 01/11] keys-encrypted: add nvdimm key format type to
 encrypted keys
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163107.70506.6894134402057805078.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4iKQW+zG1mS-vdbXuU1BE0bQ-zDJt1uQBo6EHkvMF5Y_Q@mail.gmail.com>
 <5c0d66c2-d628-54eb-b16e-8a6a8eb990c1@intel.com>
 <1543343054.3902.192.camel@linux.ibm.com>
 <CAPcyv4i5=tAx6=W44Vva7=0GO9A=j0w5vEEYMMv3NnC9_fMz6g@mail.gmail.com>
 <1543347302.3902.202.camel@linux.ibm.com>
 <CAPcyv4gXYDye7VhyL4yRpPATaZciJrZxLXZqSVx47on8Ag2KpA@mail.gmail.com>
 <1543349435.3902.208.camel@linux.ibm.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <cee6f86f-1ac1-9ff8-0a98-13a864300d5a@intel.com>
Date: Tue, 27 Nov 2018 13:15:34 -0700
MIME-Version: 1.0
In-Reply-To: <1543349435.3902.208.camel@linux.ibm.com>
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
To: Mimi Zohar <zohar@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>
Cc: keyrings@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAxMS8yNy8xOCAxOjEwIFBNLCBNaW1pIFpvaGFyIHdyb3RlOgo+IE9uIFR1ZSwgMjAxOC0x
MS0yNyBhdCAxMTo0OCAtMDgwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+IAo+PiBJIHdhcyB0aGlu
a2luZyB0aGF0IHRoZSBnZW5lcmljLWxlbmd0aCAqaXMqIHRoZSBmb3JtYXQuIFRoaXMgZG9lcyBu
b3QKPj4gd29yayBmb3IgZWN5cHRmcyBiZWNhdXNlIGl0IGhhcyB0aGF0Ogo+Pgo+PiAgICAgcGF5
bG9hZF9kYXRhbGVuID0gc2l6ZW9mKHN0cnVjdCBlY3J5cHRmc19hdXRoX3Rvayk7Cj4+Cj4+IC4u
LmRldGFpbCB0aGF0IGlzIGVjcnlwdGZzIHNwZWNpZmljLiBGb3IgbnZkaW1tIHRoZSBvbmx5IGRl
dGFpbCBvZiB0aGUKPj4gZm9ybWF0IGlzIHRoZSBkZWNyeXB0ZWQtZGF0YS1sZW5ndGguICBIb3dl
dmVyLCBJIGdldCB0aGUgZmVlbGluZyBJJ20KPj4gcHJvcG9zaW5nIGEgc29sdXRpb24gdG8gYSBw
cm9ibGVtIHRoYXQgZG9lcyBub3QgZXhpc3QgeWV0LiBMZXQncyBqdXN0Cj4+IGdvIHdpdGggdGhl
ICJudmRpbW0iIGZvcm1hdCBmb3Igbm93Lgo+IAo+IEFoLCB0aGF0IG1ha2VzIG1vcmUgc2Vuc2Ug
bm93LiDCoERlZmluaW5nICJPcHRfbnZkaW1tIiBvciB0aGUgZ2VuZXJpYwo+ICJPcHRfZW5jMzIi
IGlzIGZpbmUuIMKgTWlzc2luZyBmcm9tIHRoaXMgcGF0Y2ggaXMgdGhlIHVwZGF0ZSB0bwo+IERv
Y3VtZW50YXRpb24vc2VjdXJpdHkva2V5cy90cnVzdGVkLWVuY3J5cHRlZC5yc3QuIMKgT3RoZXJ3
aXNlIHRoaXMKPiBwYXRjaCBsb29rcyBmaW5lLgoKSSdsbCBnbyB3aXRoIGVuYzMyIGFuZCB1cGRh
dGUgdGhlIGRvYyBhbmQgcmVzdWJtaXQgd2l0aCB0aGUgc2VyaWVzLgpUaGFua3MgTWltaS4KCj4g
Cj4gTWltaQo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0
cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
