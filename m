Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FAD31A1E54
 for <linux-nvdimm@lists.01.org>; Tue,  1 Mar 2016 10:43:38 -0800 (PST)
Message-ID: <1456859933.15454.83.camel@hpe.com>
Subject: Re: [PATCH v2 1/3] ACPI/NFIT: Update Control Region Structure to
 comply ACPI 6.1
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 01 Mar 2016 12:18:53 -0700
In-Reply-To: <CAPcyv4hS44abMCs1sxdLW0YgMjP33Td0LbEWhXi9jqJ_ARU7CA@mail.gmail.com>
References: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
 <1456178130-26468-2-git-send-email-toshi.kani@hpe.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D64B@ORSMSX110.amr.corp.intel.com>
 <1456850284.15454.23.camel@hpe.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D6E1@ORSMSX110.amr.corp.intel.com>
 <1456853819.15454.45.camel@hpe.com>
 <CAPcyv4hS44abMCs1sxdLW0YgMjP33Td0LbEWhXi9jqJ_ARU7CA@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "Moore, Robert  <robert.moore@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Zheng," Lv" <lv.zheng@intel.com>, "devel@acpica.org,  <devel@acpica.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTAzLTAxIGF0IDEwOjE0IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gVHVlLCBNYXIgMSwgMjAxNiBhdCA5OjM2IEFNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhw
ZS5jb20+IHdyb3RlOgo+ID4gT24gVHVlLCAyMDE2LTAzLTAxIGF0IDE2OjAzICswMDAwLCBNb29y
ZSwgUm9iZXJ0IHdyb3RlOgo+ID4gPiBXZSBoYXZlIGEgYnVuY2ggb2YgbWFjcm9zIGluIGluY2x1
ZGUvYWNtYWNyb3MuaCAtLSBsaWtlIHRoaXM6Cj4gPiA+IAo+ID4gPiBBQ1BJX01PVkVfMTZfVE9f
MTYoZCwgcykKPiA+IAo+ID4gVGhlcmUgaXMgYSBwcm9ibGVtIGluIHVzaW5nIHRoZSBBQ1BJQ0Eg
Ynl0ZS1zd2FwIG1hY3Jvcy7CoMKgQUNQSSBpcwo+ID4gbGl0dGxlLQo+ID4gZW5kaWFuIGFyY2gs
IHNvIHRoZSBtYWNyb3MgYXJlIHNldCB0byBwZXJmb3JtIGJ5dGUtc3dhcHBpbmdzIHdoZW4gdGhl
Cj4gPiBDUFUKPiA+IGFyY2ggaXMgYmlnLWVuZGlhbi7CoMKgVGhpcyBjYXNlLCBob3dldmVyLCBp
cyB0aGUgb3RoZXIgd2F5IGFyb3VuZC7CoMKgVGhlCj4gPiBmaWVsZHMgaW4gcXVlc3Rpb24gYXJl
IGRlZmluZWQgJiBzdG9yZWQgYXMgYXJyYXlzIG9mIGJ5dGVzLsKgwqBJZiB5b3UKPiA+IHRyZWF0
Cj4gPiB0aGVtIGFzIG11bHRpLWJ5dGVzIG51bWVyaWMgdmFsdWVzLCB0aGVuIHlvdSBuZWVkIHRv
IGJ5dGUtc3dhcCB0aGVtCj4gPiB3aGVuCj4gPiB0aGUgQ1BVIGFyY2ggaXMgbGl0dGxlLWVuZGlh
biBiZWNhdXNlIGFycmF5cyBvZiBieXRlcyBoYXZlIHRoZSBzYW1lCj4gPiBhZGRyZXNzaW5nIGFz
IGJpZy1lbmRpYW4uCj4gPiAKPiA+IEFub3RoZXIgaXNzdWUgaXMgdGhhdCBpdCBpcyBub3QgY2xl
YXIgd2hvIG5lZWRzIHRvIHBlcmZvcm0gdGhlIGJ5dGUtCj4gPiBzd2FwcGluZyBhbW9uZyBBQ1BJ
Q0EgYW5kIGRyaXZlcnMuwqDCoElmIEFDUElDQSwgZHJpdmVycyBtdXN0IGFncmVlIHRoYXQKPiA+
IHRoZXNlIGZpZWxkcyBhcmUgYWx3YXlzIHRyZWF0ZWQgYXMgbXVsdGktYnl0ZXMgbnVtZXJpYyB2
YWx1ZXMgZGVzcGl0ZQo+ID4gb2YKPiA+IHRoZSBzcGVjLsKgwqBJZiBkcml2ZXJzLCB3ZSBuZWVk
IHRvIG1ha2Ugc3VyZSB0aGF0IG9ubHkgYSBzaW5nbGUgZHJpdmVyCj4gPiBwZXJmb3JtcyB0aGlz
IGJ5dGUtc3dhcHBpbmcgb25lIHRpbWUgYXMgQUNQSSB0YWJsZXMgYXJlIGdsb2JhbAo+ID4gc3Ry
dWN0dXJlcy4KPiA+IAo+ID4gSSB0aGluayBpdCBpcyBtdWNoIGNsZWFyZXIgdG8gZGVmaW5lIHRo
ZSBzdHJ1Y3R1cmUgYWNjb3JkaW5nIHRvIHRoZQo+ID4gQUNQSQo+ID4gc3BlYy4KPiAKPiBJIHRo
aW5rIHRoZSAiQUNQSSB0YWJsZXMgYXJlIGxpdHRsZS1lbmRpYW4iIGFzc3VtcHRpb24gaXMgcGVy
dmFzaXZlCj4gdGhyb3VnaG91dCB0aGUgaW1wbGVtZW50YXRpb24uCj4gCj4gVG9zaGksIGl0IHNl
ZW1zIGFsbCB3ZSBuZWVkIGlzIGNvbnZlcnNpb25zIGxpa2U6Cj4gCj4gLSBzcHJpbnRmKGJ1Ziwg
IiUjeFxuIiwgZGNyLT52ZW5kb3JfaWQpOwo+ICsgc3ByaW50ZihidWYsICIlI3hcbiIsIGxlMTZf
dG9fY3B1KGRjci0+dmVuZG9yX2lkKSk7Cj4gCj4gLi4uZm9yIHRoZSB2YWx1ZXMgZXhwb3J0ZWQg
dG8gdXNlcnNwYWNlIHRocm91Z2ggc3lzZnMsIGJ1dCBvdGhlcndpc2UKPiBsZWF2ZSB0aGUgYmFz
ZSB0YWJsZSBkZWZpbml0aW9ucyBhcyBpcy7CoMKgV2lsbCB0aGlzIHN1ZmZpY2U/CgpZZXMsIEkg
YW0gT0sgdG8gZ28gd2l0aCB0aGlzIG9wdGlvbiB0byBnZXQgaXQgZG9uZS4KCldlIHN0aWxsIG5l
ZWQgdG8gYWRkIG5ldyBmaWVsZHMgaW50byB0aGUgc3RydWN0dXJlLiDCoElzIGl0IE9LIHRvIG1h
a2UgdGhpcwpjaGFuZ2U/IMKgSWYgbm90LCB3ZSB3aWxsIG5lZWQgdG8gaGF2ZSBhIGxvY2FsIHN0
cnVjdHVyZSB0byBkZWZpbmUgdGhlIG5ldwpmaWVsZHMuLi4KClRoYW5rcywKLVRvc2hpCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
