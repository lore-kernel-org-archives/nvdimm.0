Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 799021A1ED5
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 15:19:32 -0800 (PST)
Message-ID: <1457050323.15454.131.camel@hpe.com>
Subject: Re: [PATCH v2 4/4] ACPI: Change NFIT driver to insert new resource
From: Toshi Kani <toshi.kani@hpe.com>
Date: Thu, 03 Mar 2016 17:12:03 -0700
In-Reply-To: <CAPcyv4ibLoKSe06P4WTHiQ6x=hoTfEmCvVKGv9hJ4Z7++2PN-w@mail.gmail.com>
References: <1456959056-12316-1-git-send-email-toshi.kani@hpe.com>
 <1456959056-12316-5-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4ibLoKSe06P4WTHiQ6x=hoTfEmCvVKGv9hJ4Z7++2PN-w@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki  <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTAzLTAzIGF0IDE0OjQ5IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gV2VkLCBNYXIgMiwgMjAxNiBhdCAyOjUwIFBNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhw
ZS5jb20+IHdyb3RlOgrCoDoKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvbmZpdC5jIGIv
ZHJpdmVycy9hY3BpL25maXQuYwo+ID4gaW5kZXggZmI1M2RiMS4uZDk3YjUzZiAxMDA2NDQKPiA+
IC0tLSBhL2RyaXZlcnMvYWNwaS9uZml0LmMKPiA+ICsrKyBiL2RyaXZlcnMvYWNwaS9uZml0LmMK
PiA+IEBAIC0xNTcxLDYgKzE1NzEsMzAgQEAgc3RhdGljIGludCBhcnNfc3RhdHVzX3Byb2Nlc3Nf
cmVjb3JkcyhzdHJ1Y3QKPiA+IG52ZGltbV9idXMgKm52ZGltbV9idXMsCj4gPiDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuIDA7Cj4gPiDCoH0KPiA+IAo+ID4gK3N0YXRpYyBpbnQgYWNwaV9uZml0X2lu
c2VydF9yZXNvdXJjZShzdHJ1Y3QgYWNwaV9uZml0X2Rlc2MgKmFjcGlfZGVzYywKPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbmRfcmVnaW9uX2Rlc2MgKm5kcl9kZXNj
KQo+ID4gK3sKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCByZXNvdXJjZSAqcmVzLCAqbmRfcmVz
ID0gbmRyX2Rlc2MtPnJlczsKPiA+ICvCoMKgwqDCoMKgwqDCoHNpemVfdCBzaXplID0gbmRfcmVz
LT5lbmQgLSBuZF9yZXMtPnN0YXJ0ICsgMTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoC8qIE5v
IG9wZXJhdGlvbiBpZiB0aGUgcmVnaW9uIGlzIGFscmVhZHkgcmVnaXN0ZXJlZCBhcyBQTUVNICov
Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAocmVnaW9uX2ludGVyc2VjdHMobmRfcmVzLT5zdGFydCwg
c2l6ZSwgSU9SRVNPVVJDRV9NRU0sCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoElPUkVTX0RFU0NfUEVSU0lTVEVOVF9NRU1PUlkpID09Cj4gPiBSRUdJ
T05fSU5URVJTRUNUUykKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
MDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoHJlcyA9IGRldm1fa3phbGxvYyhhY3BpX2Rlc2Mt
PmRldiwgc2l6ZW9mKCpyZXMpLCBHRlBfS0VSTkVMKTsKPiAKPiBIb3cgYWJvdXQgYWxsb2NhdGlu
ZyB0aGlzIHJlc291cmNlIG9uIHRoZSBzdGFjayBhbmQgdGhlbiBoYXZlCj4gZGV2bV9pbnNlcnRf
cmVzb3VyY2UgaGFuZGxlIHRoZSBkeW5hbWljIGFsbG9jYXRpb24gKG1lbWR1cCkgc28gd2UgaGF2
ZQo+IG9uZSBsZXNzIGZhaWx1cmUgcG9pbnQgdG8gaGFuZGxlIGluIHRoZSBkcml2ZXIuCgpJIGxp
a2UgdGhlIGlkZWEsIGJ1dCBleGlzdGluZyBjYWxsZXJzIG9mIGluc2VydF9yZXNvdXJjZSgpIGFs
bG9jYXRlIGEKcmVzb3VyY2UgZWl0aGVyIHN0YXRpY2FsbHkgb3IgZHluYW1pY2FsbHkuIMKgSXQg
bWF5IGJlIGNvbnRhaW5lZCBieSBvdGhlcgpzdHJ1Y3R1cmUgYXMgd2VsbC4gwqBTbywgSSB0aGlu
ayBkZXZtX2luc2VydF9yZXNvdXJjZSgpIHNob3VsZCBiZSBjb25zaXN0ZW50CndpdGggaW5zZXJ0
X3Jlc291cmNlKCkgb24gdGhpcyByZWdhcmQuwqAKClRoYW5rcywKLVRvc2hpCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
