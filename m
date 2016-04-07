Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 867B21A1F40
 for <linux-nvdimm@lists.01.org>; Thu,  7 Apr 2016 09:40:33 -0700 (PDT)
Message-ID: <1460047286.6620.26.camel@linux.intel.com>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 07 Apr 2016 19:41:26 +0300
In-Reply-To: <1456495897.13244.144.camel@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
 <7544228.v4QPX4F7J7@vostro.rjw.lan>
 <1456495897.13244.144.camel@linux.intel.com>
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
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Huang Ying <ying.huang@intel.com>
Cc: linux-efi@vger.kernel.org, David Airlie <airlied@linux.ie>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, dri-devel@lists.freedesktop.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Lv Zheng <lv.zheng@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Mathias Nyman <mathias.nyman@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Mark Brown <broonie@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTAyLTI2IGF0IDE2OjExICswMjAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
Cj4gT24gVGh1LCAyMDE2LTAyLTE4IGF0IDAxOjAzICswMTAwLCBSYWZhZWwgSi4gV3lzb2NraSB3
cm90ZToKPiA+IAo+ID4gT24gV2VkbmVzZGF5LCBGZWJydWFyeSAxNywgMjAxNiAwMjoxNzoyNCBQ
TSBBbmR5IFNoZXZjaGVua28gd3JvdGU6Cj4gPiA+IAo+ID4gPiBTd2l0Y2ggdG8gdXNlIGEgZ2Vu
ZXJpYyBVVUlEIEFQSSBpbnN0ZWFkIG9mIGN1c3RvbSBhcHByb2FjaC4gSXQKPiA+ID4gYWxsb3dz
IHRvCj4gPiA+IGRlZmluZSBVVUlEcywgY29tcGFyZSB0aGVtLCBhbmQgdmFsaWRhdGUuCj4gW10K
PiAKClN1bW1vbiBpbml0aWFsIGF1dGhvciBvZiB0aGUgVVVJRCBsaWJyYXJ5LgoKU3VtbWFyeTog
dGhlIEFQSSBvZiBjb21wYXJpc29uIGZ1bmN0aW9ucyBpcyByYXRoZXIgc3RyYW5nZS4gV2hhdCB0
aGUKcG9pbnQgdG8gbm90IHRha2UgcG9pbnRlcnMgZGlyZWN0bHk/IChNb3Jlb3ZlciBJIGhvcGUg
Y29tcGlsZXIgdG9vCmNsZXZlciBub3QgdG8gbWFrZSBhIGNvcHkgb2YgY29uc3RhbnQgYXJndW1l
bnRzIHRoZXJlKQoKSSBjb3VsZCBvbmx5IGltYWdpbmUgdGhlIGNhc2UgeW91IGFyZSB0cnlpbmcg
dG8gYXZvaWQgdGVtcG9yYXJ5CnZhcmlhYmxlcyBmb3IgY29uc3RhbnRzIGxpa2UgTlVMTF9VVUlE
LgoKSXNzdWUgd2l0aCB0aGlzIGlzIHRoZSB1Z2xpbmVzcyBpbiB0aGUgdXNlcnMgb2YgdGhhdCwg
aW4gcGFydGljdWxhcmx5CnByZXNlbnQgaW4gQUNQSSAoZHJpdmVycy9hY3BpL2FwZWkvZ2hlcy5j
KS4KCkkgd291bGQgbGlrZSB0byBoYXZlIG1vcmUgY2xlYXIgaW50ZXJmYWNlIGZvciB0aGF0LiBQ
ZXJoYXBzIHdlIG1heSBhZGQKc29tZXRoaW5nIGxpa2UKCmNtcF9wKHBvaW50ZXIsIG5vbi1wb2lu
dGVyKTsKY21wX3BwKHBvaW50ZXIsIHBvaW50ZXIpOwoKdG8gbm90IGJyZWFrIGV4aXN0aW5nIEFQ
SSBmb3Igbm93LgoKSXQgd291bGQgYmUgdXNlZnVsIGZvciBtYW55IGNhc2VzIGluIHRoZSBrZXJu
ZWwuCgo+ID4gCj4gPiA+IAo+ID4gPiArc3RhdGljIGNvbnN0IHV1aWRfbGUgYWRzX3V1aWQgPQo+
ID4gPiArCVVVSURfTEUoMHhkYmI4ZTNlNiwgMHg1ODg2LCAweDRiYTYsCj4gPiA+ICsJCTB4ODcs
IDB4OTUsIDB4MTMsIDB4MTksIDB4ZjUsIDB4MmEsIDB4OTYsIDB4NmIpOwo+ID4gPiDCoAo+ID4g
PiDCoHN0YXRpYyBib29sIGFjcGlfZW51bWVyYXRlX25vbmRldl9zdWJub2RlcyhhY3BpX2hhbmRs
ZSBzY29wZSwKPiA+ID4gwqAJCQkJCcKgwqDCoGNvbnN0IHVuaW9uCj4gPiA+IGFjcGlfb2JqZWN0
Cj4gPiA+ICpkZXNjLAo+ID4gPiBAQCAtMTM4LDcgKzEzNiw3IEBAIHN0YXRpYyBib29sCj4gPiA+
IGFjcGlfZW51bWVyYXRlX25vbmRldl9zdWJub2RlcyhhY3BpX2hhbmRsZSBzY29wZSwKPiA+ID4g
wqAJCcKgwqDCoMKgfHwgbGlua3MtPnR5cGUgIT0gQUNQSV9UWVBFX1BBQ0tBR0UpCj4gPiA+IMKg
CQkJYnJlYWs7Cj4gPiA+IMKgCj4gPiA+IC0JCWlmIChtZW1jbXAodXVpZC0+YnVmZmVyLnBvaW50
ZXIsIGFkc191dWlkLAo+ID4gPiBzaXplb2YoYWRzX3V1aWQpKSkKPiA+ID4gKwkJaWYgKHV1aWRf
bGVfY21wKCoodXVpZF9sZSAqKXV1aWQtPmJ1ZmZlci5wb2ludGVyLAo+ID4gPiBhZHNfdXVpZCkp
Cj4gPiBNYXliZSBpdCdzIHRvbyBsYXRlLCBidXQgSSBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIHRo
ZSBwb2ludGVyCj4gPiBtYW5pcHVsYXRpb25zIGhlcmUuCj4gPiAKPiA+IEkgY2FuIHNlZSB3aHkg
eW91IG5lZWQgYSB0eXBlIGNvbnZlcnNpb24gKGFsdGhvdWdoIGl0IGxvb2tzIHVnbHkpLAo+ID4g
YnV0IHdoeSBkbyB5b3UKPiA+IG5lZWQgdG8gZGVyZWZlcmVuY2UgaXQgdG9vPwo+IFRoZSBmdW5j
dGlvbiB0YWtlcyB0aGF0IGtpbmQgb2YgdHlwZSBvbiBpbnB1dC4gVGhlIG90aGVyIHZhcmlhbnRz
IGFyZQo+IG5vdCBjb21waWxlZC4KPiBQZXJoYXBzIHdlIGJldHRlciBjaGFuZ2UgdXVpZF97bGJ9
ZV9jbXAoKSBmaXJzdCB0byB0YWtlIG5vcm1hbAo+IHBvaW50ZXJzLCB0aG91Z2ggSSB0aGluayB0
aGUgaW5pdGlhbCBpZGVhIHdhcyB0byBnZXQgdHlwZSBjaGVja2luZyBhdAo+IGNvbXBpbGUgdGlt
ZS4KPiAKCi0tIApBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVs
LmNvbT4KSW50ZWwgRmlubGFuZCBPeQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
