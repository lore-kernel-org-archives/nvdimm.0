Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB0131A1E5D
 for <linux-nvdimm@lists.01.org>; Tue,  1 Mar 2016 11:38:51 -0800 (PST)
Message-ID: <1456861992.15454.90.camel@hpe.com>
Subject: Re: [PATCH v2 1/3] ACPI/NFIT: Update Control Region Structure to
 comply ACPI 6.1
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 01 Mar 2016 12:53:12 -0700
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
ZSwgUm9iZXJ0IHdyb3RlOgrCoDoKPiBJIHRoaW5rIHRoZSAiQUNQSSB0YWJsZXMgYXJlIGxpdHRs
ZS1lbmRpYW4iIGFzc3VtcHRpb24gaXMgcGVydmFzaXZlCj4gdGhyb3VnaG91dCB0aGUgaW1wbGVt
ZW50YXRpb24uCj4gCj4gVG9zaGksIGl0IHNlZW1zIGFsbCB3ZSBuZWVkIGlzIGNvbnZlcnNpb25z
IGxpa2U6Cj4gCj4gLSBzcHJpbnRmKGJ1ZiwgIiUjeFxuIiwgZGNyLT52ZW5kb3JfaWQpOwo+ICsg
c3ByaW50ZihidWYsICIlI3hcbiIsIGxlMTZfdG9fY3B1KGRjci0+dmVuZG9yX2lkKSk7CgpuaXQg
LSBJIHRoaW5rIGl0IG5lZWRzIHRvIGJlIGJlMTZfdG9fY3B1KCkgaWYgSSB1bmRlcnN0YW5kIHRo
aXMgbWFjcm8KY29ycmVjdGx5LgotVG9zaGkKCj4gCj4gLi4uZm9yIHRoZSB2YWx1ZXMgZXhwb3J0
ZWQgdG8gdXNlcnNwYWNlIHRocm91Z2ggc3lzZnMsIGJ1dCBvdGhlcndpc2UKPiBsZWF2ZSB0aGUg
YmFzZSB0YWJsZSBkZWZpbml0aW9ucyBhcyBpcy7CoMKgV2lsbCB0aGlzIHN1ZmZpY2U/Cl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
