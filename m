Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E2611A1F81
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 11:48:13 -0700 (PDT)
Message-ID: <1461955165.27137.0.camel@hpe.com>
Subject: Re: [PATCH] nfit: fix format interface code byte order per ACPI6.1
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 29 Apr 2016 12:39:25 -0600
In-Reply-To: <CAPcyv4jUkr-h+Wor9Pda35CS17VAKC8pAm4xkO7A0eRQWUSd2A@mail.gmail.com>
References: <146189587309.28821.2994135280775533869.stgit@dwillia2-desk3.amr.corp.intel.com>
 <5723676F.9000006@hpe.com>
 <CAPcyv4jUkr-h+Wor9Pda35CS17VAKC8pAm4xkO7A0eRQWUSd2A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTA0LTI5IGF0IDA4OjE4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gRnJpLCBBcHIgMjksIDIwMTYgYXQgNjo1MyBBTSwgTGluZGEgS25pcHBlcnMgPGxpbmRhLmtu
aXBwZXJzQGhwZS5jb20+Cj4gd3JvdGU6Cj4gPsKgCj4gPiBPbiA0LzI4LzIwMTYgMTA6MTEgUE0s
IERhbiBXaWxsaWFtcyB3cm90ZToKPiA+ID4gCj4gPiA+IEFDUEk2LjEgY2xhcmlmaWVzIHRoYXQg
RENSIGZpZWxkcyBhcmUgc3RvcmVkIGFzIGFuIGFycmF5IG9mIGJ5dGVzLAo+ID4gPiB1cGRhdGUg
dGhlIGZvcm1hdCBpbnRlcmZhY2UgY29kZSBjb25zdGFudHMgdG8gbWF0Y2guCj4gPiA+IAo+ID4g
PiBDYzogVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPgo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KPiA+ID4gLS0tCj4gPiA+
IMKgZHJpdmVycy9hY3BpL25maXQuaCB8wqDCoMKgMTIgKysrKysrKy0tLS0tCj4gPiA+IMKgMSBm
aWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPiA+ID4gCj4gPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvbmZpdC5oIGIvZHJpdmVycy9hY3BpL25maXQuaAo+
ID4gPiBpbmRleCBjNzU1NzZiMmQ1MGUuLjkyZWE1ZDA2YzdmZSAxMDA2NDQKPiA+ID4gLS0tIGEv
ZHJpdmVycy9hY3BpL25maXQuaAo+ID4gPiArKysgYi9kcml2ZXJzL2FjcGkvbmZpdC5oCj4gPiA+
IEBAIC00MSwxMSArNDEsMTMgQEAgZW51bSBuZml0X3V1aWRzIHsKPiA+ID4gwqDCoMKgwqDCoMKg
TkZJVF9VVUlEX01BWCwKPiA+ID4gwqB9Owo+ID4gPiAKPiA+ID4gLWVudW0gbmZpdF9maWMgewo+
ID4gPiAtwqDCoMKgwqDCoE5GSVRfRklDX0JZVEUgPSAweDEwMSwgLyogYnl0ZS1hZGRyZXNzYWJs
ZSBlbmVyZ3kgYmFja2VkICovCj4gPiA+IC3CoMKgwqDCoMKgTkZJVF9GSUNfQkxLID0gMHgyMDEs
IC8qIGJsb2NrLWFkZHJlc3NhYmxlIG5vbi1lbmVyZ3kgYmFja2VkICovCj4gPiA+IC3CoMKgwqDC
oMKgTkZJVF9GSUNfQllURU4gPSAweDMwMSwgLyogYnl0ZS1hZGRyZXNzYWJsZSBub24tZW5lcmd5
IGJhY2tlZAo+ID4gPiAqLwo+ID4gPiAtfTsKPiA+ID4gKy8qCj4gPiA+ICsgKiBSZWdpb24gZm9y
bWF0IGludGVyZmFjZSBjb2RlcyBhcmUgc3RvcmVkIGFzIGFuIGFycmF5IG9mIGJ5dGVzIGluCj4g
PiA+IHRoZQo+ID4gPiArICogTkZJVCBESU1NIENvbnRyb2wgUmVnaW9uIHN0cnVjdHVyZQo+ID4g
PiArICovCj4gPiA+ICsjZGVmaW5lIE5GSVRfRklDX0JZVEUgY3B1X3RvX2JlMTYoMHgxMDEpIC8q
IGJ5dGUtYWRkcmVzc2FibGUgZW5lcmd5Cj4gPiA+ICovCj4gPiBlbmVyZ3kgYmFja2VkPwo+Cj4g
WXVwLCB3aWxsIGZpeC4KCldpdGggdGhhdCBjaGFuZ2U6CgpSZXZpZXdlZC1ieTogVG9zaGkgS2Fu
aSA8dG9zaGkua2FuaUBocGUuY29tPgoKVGhhbmtzLAotVG9zaGkKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QK
TGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LW52ZGltbQo=
