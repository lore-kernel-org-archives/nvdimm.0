Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 89F0A1A1DF3
 for <linux-nvdimm@lists.01.org>; Fri, 26 Feb 2016 06:27:52 -0800 (PST)
Message-ID: <1456496890.13244.146.camel@linux.intel.com>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 26 Feb 2016 16:28:10 +0200
In-Reply-To: <20160218110754.GG1742@lahna.fi.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
 <20160218110754.GG1742@lahna.fi.intel.com>
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
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-efi@vger.kernel.org, David Airlie <airlied@linux.ie>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, dri-devel@lists.freedesktop.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Lv Zheng <lv.zheng@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Mathias Nyman <mathias.nyman@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Mark Brown <broonie@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTAyLTE4IGF0IDEzOjA3ICswMjAwLCBNaWthIFdlc3RlcmJlcmcgd3JvdGU6
Cj4gT24gV2VkLCBGZWIgMTcsIDIwMTYgYXQgMDI6MTc6MjRQTSArMDIwMCwgQW5keSBTaGV2Y2hl
bmtvIHdyb3RlOgo+ID4gU3dpdGNoIHRvIHVzZSBhIGdlbmVyaWMgVVVJRCBBUEkgaW5zdGVhZCBv
ZiBjdXN0b20gYXBwcm9hY2guIEl0Cj4gPiBhbGxvd3MgdG8KPiA+IGRlZmluZSBVVUlEcywgY29t
cGFyZSB0aGVtLCBhbmQgdmFsaWRhdGUuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHkgU2hl
dmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPgo+ID4gLS0tCj4gPiDC
oGRyaXZlcnMvYWNwaS9wcm9wZXJ0eS5jIHwgMTggKysrKysrKystLS0tLS0tLS0tCj4gPiDCoDEg
ZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+ID4gCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3Byb3BlcnR5LmMgYi9kcml2ZXJzL2FjcGkvcHJvcGVy
dHkuYwo+ID4gaW5kZXggMmFlZTQxNi4uMWU3NTMwNSAxMDA2NDQKPiA+IC0tLSBhL2RyaXZlcnMv
YWNwaS9wcm9wZXJ0eS5jCj4gPiArKysgYi9kcml2ZXJzL2FjcGkvcHJvcGVydHkuYwo+ID4gQEAg
LTI1LDE1ICsyNSwxMyBAQCBzdGF0aWMgaW50IGFjcGlfZGF0YV9nZXRfcHJvcGVydHlfYXJyYXko
c3RydWN0Cj4gPiBhY3BpX2RldmljZV9kYXRhICpkYXRhLAo+ID4gwqAJCQkJCWNvbnN0IHVuaW9u
IGFjcGlfb2JqZWN0Cj4gPiAqKm9iaik7Cj4gPiDCoAo+ID4gwqAvKiBBQ1BJIF9EU0QgZGV2aWNl
IHByb3BlcnRpZXMgVVVJRDogZGFmZmQ4MTQtNmViYS00ZDhjLThhOTEtCj4gPiBiYzliYmY0YWEz
MDEgKi8KPiA+IC1zdGF0aWMgY29uc3QgdTggcHJwX3V1aWRbMTZdID0gewo+ID4gLQkweDE0LCAw
eGQ4LCAweGZmLCAweGRhLCAweGJhLCAweDZlLCAweDhjLCAweDRkLAo+ID4gLQkweDhhLCAweDkx
LCAweGJjLCAweDliLCAweGJmLCAweDRhLCAweGEzLCAweDAxCj4gPiAtfTsKPiA+ICtzdGF0aWMg
Y29uc3QgdXVpZF9sZSBwcnBfdXVpZCA9Cj4gPiArCVVVSURfTEUoMHhkYWZmZDgxNCwgMHg2ZWJh
LCAweDRkOGMsCj4gPiArCQkweDhhLCAweDkxLCAweGJjLCAweDliLCAweGJmLCAweDRhLCAweGEz
LCAweDAxKTsKPiA+IMKgLyogQUNQSSBfRFNEIGRhdGEgc3Vibm9kZXMgVVVJRDogZGJiOGUzZTYt
NTg4Ni00YmE2LTg3OTUtCj4gPiAxMzE5ZjUyYTk2NmIgKi8KPiA+IC1zdGF0aWMgY29uc3QgdTgg
YWRzX3V1aWRbMTZdID0gewo+ID4gLQkweGU2LCAweGUzLCAweGI4LCAweGRiLCAweDg2LCAweDU4
LCAweGE2LCAweDRiLAo+ID4gLQkweDg3LCAweDk1LCAweDEzLCAweDE5LCAweGY1LCAweDJhLCAw
eDk2LCAweDZiCj4gPiAtfTsKPiA+ICtzdGF0aWMgY29uc3QgdXVpZF9sZSBhZHNfdXVpZCA9Cj4g
PiArCVVVSURfTEUoMHhkYmI4ZTNlNiwgMHg1ODg2LCAweDRiYTYsCj4gPiArCQkweDg3LCAweDk1
LCAweDEzLCAweDE5LCAweGY1LCAweDJhLCAweDk2LCAweDZiKTsKPiAKPiBUaGlzIGxvb2tzIGJl
dHRlciB0aGFuIHRoZSBvcmlnaW5hbCBidXQgaXQgaXMgc3RpbGwgbm90IHRvbyByZWFkYWJsZS4K
PiAKPiBJIHRoaW5rIGl0IHdvdWxkIGJlIGJldHRlciB0byBoYXZlIHV1aWQgYXMgc3RyaW5nIGxp
a2U6Cj4gCj4gc3RhdGljIGNvbnN0IGNoYXIgKmFkc191dWlkID0gImRiYjhlM2U2LTU4ODYtNGJh
Ni04Nzk1LTEzMTlmNTJhOTY2YiI7Cj4gCj4gYW5kIHRoZW4gY29udmVydCB0aGF0IHRvIHRoZSBy
aWdodCBieXRlIHByZXNlbnRhdGlvbiB3aGVuIGZpcnN0IHRpbWUKPiB1c2VkLiBUaGF0IHdvdWxk
IG1hdGNoIHRoZSB1dWlkIGZvcm1hdCBpbiB0aGUgQUNQSSAoYW5kIGRldmljZQo+IHByb3BlcnRp
ZXMpIHNwZWMuIGFuZCB0aHVzIG1ha2UgaXQgZWFzaWVyIHRvIHJlYWQgYW5kIHVuZGVyc3RhbmQu
CgpZZXMgd2UgY2FuIGRvIHRoaXMgb24gc2xvdyBwYXRocy4gT3IgaW4gY2FzZXMgd2hlcmUgd2Ug
a25vdyB0aGF0CmNvbnZlcnNpb24gaGFwcGVucyBvbmx5IG9uY2UuCgoKLS0gCkFuZHkgU2hldmNo
ZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29tPgpJbnRlbCBGaW5sYW5kIE95
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
