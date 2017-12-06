Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id 1E54E20352A87
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 16:23:14 -0800 (PST)
Date: Wed, 6 Dec 2017 11:27:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfsprogs PATCH v2 1/3] xfs_io: fix compiler warnings in
 getfsmap code
Message-ID: <20171206002743.GC5858@dastard>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171205235651.17102-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCBEZWMgMDUsIDIwMTcgYXQgMDQ6NTY6NDlQTSAtMDcwMCwgUm9zcyBad2lzbGVyIHdy
b3RlOgo+IEkgcmVjZW50bHkgdXBncmFkZWQgbXkgY29tcGlsZXIgZnJvbQo+IAlnY2MgKEdDQykg
Ni40LjEgMjAxNzA3MjcgKFJlZCBIYXQgNi40LjEtMSkKPiB0bwo+IAlnY2MgKEdDQykgNy4yLjEg
MjAxNzA5MTUgKFJlZCBIYXQgNy4yLjEtMikKPiBhbmQgc3RhcnRlZCBnZXR0aW5nIGEgYnVuY2gg
b2YgY29tcGlsZXIgd2FybmluZ3MgaW4gaW8vZnNtYXAuYzoKPiAKPiAgIGZzbWFwLmM6IEluIGZ1
bmN0aW9uIOKAmGZzbWFwX2bigJk6Cj4gICBmc21hcC5jOjIyODo0MDogd2FybmluZzog4oCYJWxs
ZOKAmSBkaXJlY3RpdmUgb3V0cHV0IG1heSBiZSB0cnVuY2F0ZWQgd3JpdGluZwo+ICAgYmV0d2Vl
biAxIGFuZCAxNyBieXRlcyBpbnRvIGEgcmVnaW9uIG9mIHNpemUgYmV0d2VlbiAxMiBhbmQgMjgK
PiAgIFstV2Zvcm1hdC10cnVuY2F0aW9uPV0KPiAgICAgIHNucHJpbnRmKGJidWYsIHNpemVvZihi
YnVmKSwgIlslbGxkLi4lbGxkXToiLAo+ICAgXn5+fgo+ICAgZnNtYXAuYzoyMjg6MzI6IG5vdGU6
IGRpcmVjdGl2ZSBhcmd1bWVudCBpbiB0aGUgcmFuZ2UgWzAsIDM2MDI4Nzk3MDE4OTYzOTY3XQo+
ICAgICAgc25wcmludGYoYmJ1Ziwgc2l6ZW9mKGJidWYpLCAiWyVsbGQuLiVsbGRdOiIsCj4gICBe
fn5+fn5+fn5+fn5+fn4KPiAgIGZzbWFwLmM6MjI4OjM6IG5vdGU6IOKAmHNucHJpbnRm4oCZIG91
dHB1dCBiZXR3ZWVuIDggYW5kIDQwIGJ5dGVzIGludG8gYQo+ICAgZGVzdGluYXRpb24gb2Ygc2l6
ZSAzMgo+ICAgICAgc25wcmludGYoYmJ1Ziwgc2l6ZW9mKGJidWYpLCAiWyVsbGQuLiVsbGRdOiIs
Cj4gICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4KPiAg
IChsb25nIGxvbmcpQlRPQkJUKHAtPmZtcl9waHlzaWNhbCksCj4gICB+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+Cj4gICAobG9uZyBsb25nKUJUT0JCVChwLT5mbXJfcGh5c2ljYWwg
KyBwLT5mbXJfbGVuZ3RoIC0gMSkpOwo+ICAgfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Cj4gCj4gVGhlIGlzc3VlIGlzIHRoYXQgJ2JidWYnIGlz
IG9ubHkgZGVmaW5lZCB0byBiZSAzMiBjaGFyYWN0ZXJzIHdpZGUsIGJ1dCBlYWNoCj4gc2lnbmVk
IGxvbmcgbG9uZyBjYW4gcG90ZW50aWFsbHkgcHJpbnQgYXMgbWFueSBhcyAxOSBjaGFyYWN0ZXJz
Cj4gKDkyMjMzNzIwMzY4NTQ3NzU4MDcgaXMgdGhlIG1heCB2YWx1ZSkuICBUaGUgZm9ybWF0IHdl
J3JlIHVzaW5nIGZvciBiYnVmIGlzCj4gIlslbGxkLi4lbGxkXToiIHdoaWNoIGhhcyAyIHNpZ25l
ZCBsb25nIGxvbmdzIHBsdXMgNiBvdGhlciBjaGFyYWN0ZXJzCj4gIlsuLl06XDAiLCB3aGljaCBt
ZWFucyBpdCdzIHBvc3NpYmxlIHdlJ2xsIHByaW50IHVwIHRvIDQ0IGNoYXJhY3RlcnMsCj4gb3Zl
cmZsb3dpbmcgb3VyIDMyIGNoYXIgYnVmZmVyLgo+IAo+IEZpeCB0aGlzIGJ5IGJ1bXBpbmcgYWxs
IHRoZSBidWZmZXIgc2l6ZXMgaW4gZHVtcF9tYXBfdmVyYm9zZSgpIHRvIDY0Cj4gY2hhcmFjdGVy
cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBSb3NzIFp3aXNsZXIgPHJvc3Muendpc2xlckBsaW51eC5p
bnRlbC5jb20+Cj4gQ2M6IERhcnJpY2sgSi4gV29uZyA8ZGFycmljay53b25nQG9yYWNsZS5jb20+
Cj4gRml4ZXM6IDNmY2FiNTQ5YTIzNCAoInhmc19pbzogc3VwcG9ydCB0aGUgbmV3IGdldGZzbWFw
IGlvY3RsIikKCkZZSSwgSSBwb3N0ZWQgYSBmaXggZm9yIHRoaXMgd2Vla3MgYWdvLiBJIHRoaW5r
IEVyaWMgaGFzIGFscmVhZHkKcGlja2VkIGl0IHVwLCBidXQgaXQgaGFzbid0IGJlZW4gcHVzaGVk
IG91dCBpbnRvIHRoZSBmb3ItbmV4dCBicmFuY2gKeWV0LgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRh
dmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
