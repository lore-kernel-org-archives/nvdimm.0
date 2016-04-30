Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23BEB1A1F8C
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 17:03:22 -0700 (PDT)
Message-ID: <1461974599.11211.6.camel@kernel.org>
Subject: Re: acpi_nfit_query_poison() broken on non-ARS systems
From: Vishal Verma <vishal@kernel.org>
Date: Fri, 29 Apr 2016 18:03:19 -0600
In-Reply-To: <5723EFEE.9060200@hpe.com>
References: <5723EFEE.9060200@hpe.com>
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
To: Linda Knippers <linda.knippers@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTA0LTI5IGF0IDE5OjM2IC0wNDAwLCBMaW5kYSBLbmlwcGVycyB3cm90ZToK
CltzbmlwXQo+wqAKPiA+IHN0YXRpYyBpbnQgYWNwaV9uZml0X3F1ZXJ5X3BvaXNvbihzdHJ1Y3Qg
YWNwaV9uZml0X2Rlc2MgKmFjcGlfZGVzYywKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IG5maXRfc3BhICpuZml0X3NwYSkKPiA+IHsKPiA+IMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgYWNwaV9uZml0X3N5c3RlbV9hZGRyZXNzICpzcGEgPSBuZml0X3NwYS0+c3BhOwo+
ID4gwqDCoMKgwqDCoMKgwqDCoGludCByYzsKPiA+IAo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmICgh
bmZpdF9zcGEtPm1heF9hcnMpIHsKPiBPbiBhIHBsYXRmb3JtIHRoYXQgZG9lc24ndCBzdXBwb3J0
IEFSUywgbWF4X2FycyB3aWxsIGFsd2F5cyBiZSB6ZXJvCj4gc28geW91J2xsIGtlZXAgZXhlY3V0
aW5nIHRoaXMgY29kZSB3aGVuIGl0IHNlZW1zIGxpa2UgeW91J3JlIHRyeWluZwo+IHRvIGF2b2lk
IHRoYXQuCj4gCj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0
IG5kX2NtZF9hcnNfY2FwIGFyc19jYXA7Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgbWVtc2V0KCZhcnNfY2FwLCAwLCBzaXplb2YoYXJzX2NhcCkpOwo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByYyA9IGFyc19nZXRfY2FwKGFjcGlfZGVzYywgJmFy
c19jYXAsIG5maXRfc3BhKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYg
KHJjIDwgMCkKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiByYzsKPiBUaGUgY2FsbCBzdWNjZWVkcyBzbyB0aGlzIHJldHVybiBpc24ndCB0
YWtlbiwgYnV0IHRoZW4gdGhlIGNvZGUKPiBhc3N1bWVzCj4gZXZlcnl0aGluZyBpcyBnb29kLsKg
wqBJdCBzaG91bGQgY2hlY2sgYXJzX2NhcC5zdGF0dXMgc28gc2VlIGlmIHRoZQo+IGZ1bmN0aW9u
Cj4gaXMgc3VwcG9ydGVkIG9yIGlmIHRoZXJlIHdhcyBhbiBlcnJvciBhbmQgcmV0dXJuIHNvbWV0
aGluZwo+IGFwcHJvcHJpYXRlLgo+IEluIHByZXZpb3VzIHZlcnNpb24gb2YgdGhlIGNvZGUsIHRo
YXQncyB3aGF0IGFjcGlfbmZpdF9maW5kX3BvaXNvbigpCj4gZGlkLgo+IEluc3RlYWQsIHRoaXMg
ZnVuY3Rpb24gY29udGludWVzLCB1c2luZyBkYXRhIHRoYXQncyBub3QgcmlnaHQgYW5kCj4gbWFr
aW5nCj4gbW9yZSBjYWxscyB0aGF0IGFsc28gYXJlbid0IHN1cHBvcnRlZC4KCkdvb2QgcG9pbnQg
LSBJIHRoaW5rIHdlIHNob3VsZCBhZGQgYSBjaGVjayBoZXJlIGFuZCBtYWtlIHN1cmUgQVJTIGlz
CnN1cHBvcnRlZCB1c2luZyB0aGUgc3RhdHVzIGZpZWxkLiBJIGNhbiB3b3JrIG9uIGEgcGF0Y2gu
IFRoYW5rcyBmb3IgdGhlCnJlcG9ydCEKCgktVmlzaGFsCgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
