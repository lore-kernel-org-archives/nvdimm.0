Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5794D1A1E54
 for <linux-nvdimm@lists.01.org>; Tue,  1 Mar 2016 07:58:38 -0800 (PST)
Message-ID: <1456850284.15454.23.camel@hpe.com>
Subject: Re: [PATCH v2 1/3] ACPI/NFIT: Update Control Region Structure to
 comply ACPI 6.1
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 01 Mar 2016 09:38:04 -0700
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D64B@ORSMSX110.amr.corp.intel.com>
References: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
 <1456178130-26468-2-git-send-email-toshi.kani@hpe.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D64B@ORSMSX110.amr.corp.intel.com>
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
To: "Moore, Robert" <robert.moore@intel.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Zheng," Lv" <lv.zheng@intel.com>, "devel@acpica.org,  <devel@acpica.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTAzLTAxIGF0IDE1OjEzICswMDAwLCBNb29yZSwgUm9iZXJ0IHdyb3RlOgo+
IAo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0KPiA+IEZyb206IFRvc2hpIEthbmkgW21h
aWx0bzp0b3NoaS5rYW5pQGhwZS5jb21dCj4gPiBTZW50OiBNb25kYXksIEZlYnJ1YXJ5IDIyLCAy
MDE2IDE6NTUgUE0KPiA+IFRvOiByandAcmp3eXNvY2tpLm5ldDsgV2lsbGlhbXMsIERhbiBKCj4g
PiBDYzogTW9vcmUsIFJvYmVydDsgWmhlbmcsIEx2OyBlbGxpb3R0QGhwZS5jb207IGxpbnV4LW52
ZGltbUBsaXN0cy4wMS5vcgo+ID4gZzsKPiA+IGxpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOwo+ID4gZGV2ZWxAYWNwaWNhLm9yZzsgVG9zaGkg
S2FuaQo+ID4gU3ViamVjdDogW1BBVENIIHYyIDEvM10gQUNQSS9ORklUOiBVcGRhdGUgQ29udHJv
bCBSZWdpb24gU3RydWN0dXJlIHRvCj4gPiBjb21wbHkgQUNQSSA2LjEKPiA+IAo+ID4gQUNQSSA2
LjEsIFRhYmxlIDUtMTMzLCB1cGRhdGVzIE5WRElNTSBDb250cm9sIFJlZ2lvbiBTdHJ1Y3R1cmUg
YXMKPiA+IGZvbGxvd3MuCj4gPiDCoC0gVmFsaWQgRmllbGRzLCBNYW51ZmFjdHVyaW5nIExvY2F0
aW9uLCBhbmQgTWFudWZhY3R1cmluZyBEYXRlCj4gPiDCoMKgwqBhcmUgYWRkZWQgZnJvbSByZXNl
cnZlZCByYW5nZS7CoMKgTm8gY2hhbmdlIGluIHRoZSBzdHJ1Y3R1cmUgc2l6ZS4KPiA+IMKgLSBJ
RHMgZGVmaW5lZCBhcyBTUEQgdmFsdWVzIGFyZSBhcnJheXMgb2YgYnl0ZXMuwqDCoFRoZSBzcGVj
Cj4gPiDCoMKgwqBjbGFyaWZpZWQgdGhhdCB0aGV5IG5lZWQgdG8gYmUgcmVwcmVzZW50ZWQgYXMg
YXJyYXlzIG9mIGJ5dGVzCj4gPiDCoMKgwqBhcyB3ZWxsLgo+ID4gCj4gPiBUaGlzIHBhdGNoIG1h
a2VzIHRoZSBmb2xsb3dpbmcgY2hhbmdlcyB0byBzdXBwb3J0IHRoaXMgdXBkYXRlLgo+ID4gwqAt
IENoYW5nZSAnc3RydWN0IGFjcGlfbmZpdF9jb250cm9sX3JlZ2lvbicgdG8gcmVmbGVjdCB0aGUg
dXBkYXRlLgo+ID4gwqDCoMKgU1BEIElEcyBhcmUgZGVmaW5lZCBhcyBhcnJheXMgb2YgYnl0ZXMs
IHNvIHRoYXQgdGhleSBjYW4gYmUKPiA+IMKgwqDCoHRyZWF0ZWQgaW4gdGhlIHNhbWUgd2F5IHJl
Z2FyZGxlc3Mgb2YgQ1BVIGVuZGlhbm5lc3MgYW5kIGFyZQo+ID4gwqDCoMKgbm90IG1pc3MtdHJl
YXRlZCBhcyBsaXR0bGUtZW5kaWFuIG51bWVyaWMgdmFsdWVzLgo+IAo+IAo+IEkgZG9uJ3QgdGhp
bmsgd2UgYXJlIGdvaW5nIHRvIHN0YXJ0IGNoYW5naW5nIHRoZSBBQ1BJIHRhYmxlcyBkZWZpbmVk
IGluCj4gdGhlIEFDUElDQSBoZWFkZXJzIGJlY2F1c2Ugb2YgdGhpcy4gV2UgZG8gaW4gZmFjdCBo
YXZlIG1hY3JvcyBmb3IgdGhpcwo+IHB1cnBvc2UuCgpDYW4geW91IGVsYWJvcmF0ZSB3aGF0IG1h
Y3JvcyB5b3Ugc3VnZ2VzdCB0byB1c2UgZm9yIHRoaXMgcHVycG9zZT8KClRoYW5rcywKLVRvc2hp
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
