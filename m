Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F8801A1E8C
 for <linux-nvdimm@lists.01.org>; Mon,  2 May 2016 13:03:18 -0700 (PDT)
Message-ID: <1462218865.27137.18.camel@hpe.com>
Subject: Re: [PATCH v2 3/3] xfs: Add alignment check for DAX mount
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 02 May 2016 13:54:25 -0600
In-Reply-To: <20160502195027.GC14421@linux.intel.com>
References: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
 <1462214578-27122-4-git-send-email-toshi.kani@hpe.com>
 <20160502195027.GC14421@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTA1LTAyIGF0IDEzOjUwIC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6Cj4g
T24gTW9uLCBNYXkgMDIsIDIwMTYgYXQgMTI6NDI6NThQTSAtMDYwMCwgVG9zaGkgS2FuaSB3cm90
ZToKwqA6Cj4gPiDCoAkJeGZzX3dhcm4obXAsCj4gPiAtCSJEQVggZW5hYmxlZC4gV2FybmluZzog
RVhQRVJJTUVOVEFMLCB1c2UgYXQgeW91ciBvd24gcmlzayIpOwo+ID4gKwkJIkRBWCBlbmFibGVk
LiBXYXJuaW5nOiBFWFBFUklNRU5UQUwsIHVzZSBhdCB5b3VyIG93bgo+ID4gcmlzayIpOwo+ID4g
wqAJCWlmIChzYi0+c19ibG9ja3NpemUgIT0gUEFHRV9TSVpFKSB7Cj4gPiDCoAkJCXhmc19hbGVy
dChtcCwKPiA+IMKgCQkiRmlsZXN5c3RlbSBibG9jayBzaXplIGludmFsaWQgZm9yIERBWCBUdXJu
aW5nIERBWAo+ID4gb2ZmLiIpOwo+ID4gwqAJCQltcC0+bV9mbGFncyAmPSB+WEZTX01PVU5UX0RB
WDsKPiA+IC0JCX0gZWxzZSBpZiAoIXNiLT5zX2JkZXYtPmJkX2Rpc2stPmZvcHMtPmRpcmVjdF9h
Y2Nlc3MpCj4gPiB7Cj4gPiAtCQkJeGZzX2FsZXJ0KG1wLAo+ID4gLQkJIkJsb2NrIGRldmljZSBk
b2VzIG5vdCBzdXBwb3J0IERBWCBUdXJuaW5nIERBWCBvZmYuIik7Cj4gPiArCQl9IGVsc2UgaWYg
KChlcnJvciA9IGJkZXZfZGlyZWN0X2FjY2VzcyhzYi0+c19iZGV2LAo+ID4gJmRheCkpIDwgMCkg
ewo+ID4gKwkJCXN3aXRjaCAoZXJyb3IpIHsKPiA+ICsJCQljYXNlIC1FT1BOT1RTVVBQOgo+ID4g
KwkJCQl4ZnNfYWxlcnQobXAsCj4gPiArCQkJIkJsb2NrIGRldmljZSBkb2VzIG5vdCBzdXBwb3J0
IERBWCBUdXJuaW5nIERBWAo+ID4gb2ZmLiIpOwo+Cj4gU2luY2UgeW91J3JlIGFscmVhZHkgaW4g
aGVyZSBlZGl0aW5nIGFsbCB0aGUgc3RyaW5ncywgY2FuIHlvdSBhZGQgYQo+IHBlcmlvZCB0byBt
YWtlIGl0IG1vcmUgcmVhZGFibGU/wqDCoMKgQXBwbGllcyB0byBhbGwgc3RyaW5ncy4KClJpZ2h0
LiBXaWxsIGRvLgoKPiA+IAo+ID4gKwkJCSJCbG9jayBkZXZpY2UgZG9lcyBub3Qgc3VwcG9ydCBE
QVguIFR1cm5pbmcKPiA+IERBWCBvZmYuIik7Cj4gCQkJCQkJCcKgwqBeCj4gCj4gPiAKPiA+ICsJ
CQkJYnJlYWs7Cj4gPiArCQkJY2FzZSAtRUlOVkFMOgo+ID4gKwkJCQl4ZnNfYWxlcnQobXAsCj4g
PiArCQkJIlBhcnRpdGlvbiBhbGlnbm1lbnQgaW52YWxpZCBmb3IgREFYIFR1cm5pbmcKPiA+IERB
WCBvZmYuIik7Cj4gPiArCQkJCWJyZWFrOwo+ID4gKwkJCWRlZmF1bHQ6Cj4gPiArCQkJCXhmc19h
bGVydChtcCwKPiA+ICsJCQkiREFYIGFjY2VzcyBmYWlsZWQgKCVkKSBEQVggVHVybmluZyBEQVgg
b2ZmLiIsCj4gPiBlcnJvcik7Cj4KPiBJIERBWCB0aGluayB5b3UgbWlnaHQgREFYIGhhdmUgdG9v
IG1hbnkgREFYZXMgaW4gaGVyZS4gOikKCk9vcHMhIDopCgo+ID4gCj4gPiArCQkJfQo+ID4gwqAJ
CQltcC0+bV9mbGFncyAmPSB+WEZTX01PVU5UX0RBWDsKPiA+IMKgCQl9Cj4gPiDCoAl9Cj4KPiBP
dGhlciB0aGFuIHRoZSBuaXQtcGlja2luZyBhYm91dCB0aGUgc3RyaW5ncywgdGhpcyBzZWVtcyBm
aW5lLgo+IAo+IFlvdSBjYW4gYWRkIHRoaXMgZm9yIHRoZSBzZXJpZXM6Cj4gUmV2aWV3ZWQtYnk6
IFJvc3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVsLmNvbT4KClRoYW5rcyEKLVRv
c2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
