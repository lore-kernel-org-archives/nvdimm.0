Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 339091A1EF8
 for <linux-nvdimm@lists.01.org>; Tue, 17 May 2016 10:09:53 -0700 (PDT)
Message-ID: <1463504440.27137.170.camel@hpe.com>
Subject: Re: Legacy NVDIMM-F over EFI
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 17 May 2016 11:00:40 -0600
In-Reply-To: <1463503627.27137.167.camel@hpe.com>
References: <CACTTzNZJyFZkGq-6sSTOzGBG3kc7E9c-Rp6Z8fdi9LRgExQPnQ@mail.gmail.com>
 <CAPcyv4ioeGGe3ujkpytzJKZHDVawX95KtrFEmBvO2oaB_j_RqA@mail.gmail.com>
 <1463503627.27137.167.camel@hpe.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Yigal Korman <yigal@plexistor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA1LTE3IGF0IDEwOjQ3IC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOgo+IE9u
IFR1ZSwgMjAxNi0wNS0xNyBhdCAwODo1NyAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+ID4g
Cj4gPiBPbiBUdWUsIE1heSAxNywgMjAxNiBhdCA4OjM2IEFNLCBZaWdhbCBLb3JtYW4gPHlpZ2Fs
QHBsZXhpc3Rvci5jb20+Cj4gPiB3cm90ZToKPiA+ID4gCj4gPiA+IAo+ID4gPiBIaSBhbGwsCj4g
PiA+IEkndmUgZ290IGEgY291cGxlIG9mIGxlZ2FjeSAndHlwZSAxMicgTlZESU1NLUYgbW9kdWxl
cyBpbiBvdXIgbGFiCj4gPiA+IEkndmUgYmVlbiBzdWNjZXNzZnVsbHkgdGVzdGluZy4KPiA+ID4g
UmVjZW50bHkgSSBtb3ZlZCB0aGVtIHRvIGEgbmV3IHN5c3RlbSB3aGVyZSBFRkkgYm9vdGxvYWRl
ciBpcyB1c2VkCj4gPiA+IChDZW50T1MgNyBpbnN0YWxsZWQgd2l0aCBFRkkpIGFuZMKgwqB3YXMg
c3VycHJpc2VkIHRvIHNlZSB0aGF0IHRoZXkncmUKPiA+ID4gbm90IGlkZW50aWZpZWQgYXMgbGVn
YWN5ICd0eXBlIDEyJyBwZXJzaXN0ZW50IG1lbW9yeSwgYXJlIG5vdCBjYXVnaHQKPiA+ID4gYnkg
dGhlICduZF9wbWVtJyBkcml2ZXIgYW5kIEkgZG9uJ3QgZ2V0IC9kZXYvcG1lbVggZGV2aWNlcy4K
PiA+ID4gVGhleSBzaG93IGFzICd0eXBlIDcnIGluIHRoZSBFODIwIG1hcCBhbmQgJ1BlcnNpc3Rl
bnQgbWVtb3J5JyBpbgo+ID4gPiAvcHJvYy9pb21lbS4KPiA+ID4gSXMgdGhpcyB0aGUgaW50ZW5k
ZWQgYmVoYXZpb3I/IHNob3VsZG4ndCB0aGV5IGJlIGlkZW50aWZpZWQgYXMgbGVnYWN5Cj4gPiA+
IGlmIHRoZXkgZG9uJ3QgaGF2ZSBORklUPwo+ID4KPiA+IElmIHRoZSBCSU9TIGlkZW50aWZpZXMg
aXQgYXMgdHlwZS03IGl0IGlzIGJyb2tlbiwgYXMgZmFyIGFzIExpbnV4IGlzCj4gPiBjb25jZXJu
ZWQsIGlmIGRvZXMgbm90IGFsc28gZXhwb3J0IGFuIE5GSVQgd2l0aCBhbiBBQ1BJMDAxMiBkZXZp
Y2UuCj4gPiBPbmUgd291bGQgaG9wZSB0aGVyZSBhcmUgbm8gbmV3IEJJT1MgaW1hZ2VzIGJlaW5n
IHByb2R1Y2VkIHRoYXQgdXNlCj4gPiB0eXBlLTEyLi4uCj4gT24gYW4gRUZJIHN5c3RlbSBhbmQg
YSBrZXJuZWwgd2l0aMKgQ09ORklHX0VGSV9TVFVCIHNldCwgdGhlIGtlcm5lbCB1c2VzCj4gRUZJ
IG1lbW9yeSB0YWJsZSwgaW5zdGVhZCBvZiBlODIwLiDCoFNvLCBlODIwIHR5cGUtMTIgY2Fubm90
IGJlIGNvbnZleWVkCj4gdG8gdGhlIGtlcm5lbC4KPiAKPiBTaW5jZSB0aGlzIEVGSSBCSU9TIGlz
IGJyb2tlbiBhcyBEYW4gcG9pbnRlZCBvdXQsIHlvdSBtaWdodCB3YW50IHRvIHRyeQo+IGJvb3Rp
bmcgZnJvbSBhIGtlcm5lbCB3aXRoIENPTkZJR19FRklfU1RVQiB1bnNldCB0byBzZWUgaWYgdGhl
IGtlcm5lbAo+IGdldHMgZTgyMCB0eXBlLTEyLiDCoChOb3RlLCBpZiBlODIwIGlzIHNldCB0byB0
eXBlLTcsIHRoaXMgd291bGQgbGVhZCB0aGUKPiBrZXJuZWwgdG8gb3ZlcndyaXRlIGRhdGEgaW4g
TlZESU1NIGR1ZSB0byBhIGJ1ZyBpbiBncnViLikKClRoaW5raW5nIGZ1cnRoZXIsIEkgZG8gbm90
IHRoaW5rIGl0IHdpbGwgd29yay4gwqBZb3Ugd2lsbCBuZWVkIHRvIHN3aXRjaCB0bwpsZWdhY3kg
QklPUyBtb2RlIChhc3N1bWluZyBpdCBoYXMgc3VjaCBhIHN3aXRjaCkgaW4gb3JkZXIgdG8gdXNl
IGU4MjAuCgotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3Jn
Cmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
