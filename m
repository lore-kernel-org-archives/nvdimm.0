Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 2C8C71A1E1A
 for <linux-nvdimm@lists.01.org>; Fri, 26 Feb 2016 05:45:57 -0800 (PST)
Message-ID: <1456494391.13244.137.camel@linux.intel.com>
Subject: Re: [PATCH v1 05/10] ACPI: switch to use generic UUID API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 26 Feb 2016 15:46:31 +0200
In-Reply-To: <CAPcyv4inMjmt8eH_=bNE_=NMeYGmS75B5LxB=f7Cd762=3UKyQ@mail.gmail.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1455711448-124103-6-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAPcyv4inMjmt8eH_=bNE_=NMeYGmS75B5LxB=f7Cd762=3UKyQ@mail.gmail.com>
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
Cc: linux-efi@vger.kernel.org, David Airlie <airlied@linux.ie>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Lv Zheng <lv.zheng@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mathias Nyman <mathias.nyman@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Mark Brown <broonie@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE2LTAyLTE3IGF0IDA5OjQ5IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gV2VkLCBGZWIgMTcsIDIwMTYgYXQgNDoxNyBBTSwgQW5keSBTaGV2Y2hlbmtvCj4gPGFuZHJp
eS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4gd3JvdGU6Cj4gPiBJbnN0ZWFkIG9mIG9wZW5j
b2RpbmcgdGhlIGV4aXN0aW5nIGxpYnJhcnkgZnVuY3Rpb25zIGxldCdzIHVzZSB0aGVtCj4gPiBk
aXJlY3RseS4KPiA+IAo+ID4gVGhlIGNvbnZlcnNpb24gZml4ZXMgYSBwb3RlbnRpYWwgYnVnIGlu
IGludDM0MHhfdGhlcm1hbCBhcyB3ZWxsCj4gPiBzaW5jZSB3ZSBoYXZlCj4gPiB0byB1c2UgbWVt
Y21wKCkgb24gYmluYXJ5IGRhdGEuCgpbLi5dCgo+ID4gK8KgwqDCoMKgwqDCoMKgdXVpZF9sZV90
b19iaW4oVVVJRF9ORklUX0JVUywgJm5maXRfdXVpZFtORklUX0RFVl9CVVNdKTsKPiA+ICvCoMKg
wqDCoMKgwqDCoHV1aWRfbGVfdG9fYmluKFVVSURfTkZJVF9ESU1NLCAmbmZpdF91dWlkW05GSVRf
REVWX0RJTU1dKTsKPiAKPiBJIGRvbid0IHNlZSB0aGUgYmVuZWZpdCBvZiB0aGlzIGNoYW5nZS4K
ClRoZSBiZW5lZml0IGlzIHRvIGhhdmUgbGVzcyBwbGFjZXMgKGlkZWFsbHkgb25lKSB3aGljaCBw
cm92aWRlcyBVVUlECmhlbHBlciByb3V0aW5lcyBmb3Iga2VybmVsLgoKPiDCoMKgRm9yIHRoZSBO
RklUIGRyaXZlciB3ZSB3ZW50Cj4gdGhyb3VnaCBhIGZpcmUgZHJpbGwgdHJ5aW5nIHRvIG1ha2Ug
c3VyZSB0aGUgQUNQSSBzcGVjIGZvcm1hdCBvZiBhCj4gVVVJRCBtYXRjaGVkIHRoZSBMaW51eCBp
bnRlcnByZXRhdGlvbiwgYW5kIHRoaXMgY2hhbmdlIG1ha2VzIHRoYXQKPiBoYXJkZXIgdG8gZGV0
ZXJtaW5lLsKgwqAKCkhvdyBoYXJkZXI/IEF0IGxlYXN0IHlvdSBsb29rIGludG8gb25lIHBsYWNl
IGFuZCBzZWUgZXhhY3RseSBhbGwKZnVuY3Rpb25zIHJlbGF0ZWQuIEJlc2lkZXMgdGhpcyBzZXJp
ZXMgYWN0dWFsbHkgdXNlcyB0aGUgc2FtZSBhcHByb2FjaAp0aGF0IHdhcyB1c2VkIGluIEFDUEku
Cgo+IEFDUEkgZHJpdmVycyBzaG91bGQgdXNlIEFDUElDQSB1dWlkIGhlbHBlcgo+IHJvdXRpbmVz
IGluIG15IG9waW5pb24uCgpBcyBmYXIgYXMgSSBjYW4gc2VlIEFDUElDQSBsYWNrcyBvZiBuZWVk
ZWQgQVBJLgoKLS0gCkFuZHkgU2hldmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50
ZWwuY29tPgpJbnRlbCBGaW5sYW5kIE95CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBs
aXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1u
dmRpbW0K
