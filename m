Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 7535E1A1DF3
 for <linux-nvdimm@lists.01.org>; Fri, 26 Feb 2016 06:11:02 -0800 (PST)
Message-ID: <1456495897.13244.144.camel@linux.intel.com>
Subject: Re: [PATCH v1 06/10] device property: switch to use UUID API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Fri, 26 Feb 2016 16:11:37 +0200
In-Reply-To: <7544228.v4QPX4F7J7@vostro.rjw.lan>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1455711448-124103-7-git-send-email-andriy.shevchenko@linux.intel.com>
 <7544228.v4QPX4F7J7@vostro.rjw.lan>
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
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-efi@vger.kernel.org, David Airlie <airlied@linux.ie>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, dri-devel@lists.freedesktop.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Lv Zheng <lv.zheng@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Mathias Nyman <mathias.nyman@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Mark Brown <broonie@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTAyLTE4IGF0IDAxOjAzICswMTAwLCBSYWZhZWwgSi4gV3lzb2NraSB3cm90
ZToKPiBPbiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDE3LCAyMDE2IDAyOjE3OjI0IFBNIEFuZHkgU2hl
dmNoZW5rbyB3cm90ZToKPiA+IFN3aXRjaCB0byB1c2UgYSBnZW5lcmljIFVVSUQgQVBJIGluc3Rl
YWQgb2YgY3VzdG9tIGFwcHJvYWNoLiBJdAo+ID4gYWxsb3dzIHRvCj4gPiBkZWZpbmUgVVVJRHMs
IGNvbXBhcmUgdGhlbSwgYW5kIHZhbGlkYXRlLgoKW10KCj4gPiArc3RhdGljIGNvbnN0IHV1aWRf
bGUgYWRzX3V1aWQgPQo+ID4gKwlVVUlEX0xFKDB4ZGJiOGUzZTYsIDB4NTg4NiwgMHg0YmE2LAo+
ID4gKwkJMHg4NywgMHg5NSwgMHgxMywgMHgxOSwgMHhmNSwgMHgyYSwgMHg5NiwgMHg2Yik7Cj4g
PiDCoAo+ID4gwqBzdGF0aWMgYm9vbCBhY3BpX2VudW1lcmF0ZV9ub25kZXZfc3Vibm9kZXMoYWNw
aV9oYW5kbGUgc2NvcGUsCj4gPiDCoAkJCQkJwqDCoMKgY29uc3QgdW5pb24gYWNwaV9vYmplY3QK
PiA+ICpkZXNjLAo+ID4gQEAgLTEzOCw3ICsxMzYsNyBAQCBzdGF0aWMgYm9vbAo+ID4gYWNwaV9l
bnVtZXJhdGVfbm9uZGV2X3N1Ym5vZGVzKGFjcGlfaGFuZGxlIHNjb3BlLAo+ID4gwqAJCcKgwqDC
oMKgfHwgbGlua3MtPnR5cGUgIT0gQUNQSV9UWVBFX1BBQ0tBR0UpCj4gPiDCoAkJCWJyZWFrOwo+
ID4gwqAKPiA+IC0JCWlmIChtZW1jbXAodXVpZC0+YnVmZmVyLnBvaW50ZXIsIGFkc191dWlkLAo+
ID4gc2l6ZW9mKGFkc191dWlkKSkpCj4gPiArCQlpZiAodXVpZF9sZV9jbXAoKih1dWlkX2xlICop
dXVpZC0+YnVmZmVyLnBvaW50ZXIsCj4gPiBhZHNfdXVpZCkpCj4gCj4gTWF5YmUgaXQncyB0b28g
bGF0ZSwgYnV0IEkgZG9uJ3QgcXVpdGUgdW5kZXJzdGFuZCB0aGUgcG9pbnRlcgo+IG1hbmlwdWxh
dGlvbnMgaGVyZS4KPiAKPiBJIGNhbiBzZWUgd2h5IHlvdSBuZWVkIGEgdHlwZSBjb252ZXJzaW9u
IChhbHRob3VnaCBpdCBsb29rcyB1Z2x5KSwKPiBidXQgd2h5IGRvIHlvdQo+IG5lZWQgdG8gZGVy
ZWZlcmVuY2UgaXQgdG9vPwoKVGhlIGZ1bmN0aW9uIHRha2VzIHRoYXQga2luZCBvZiB0eXBlIG9u
IGlucHV0LiBUaGUgb3RoZXIgdmFyaWFudHMgYXJlCm5vdCBjb21waWxlZC4KUGVyaGFwcyB3ZSBi
ZXR0ZXIgY2hhbmdlIHV1aWRfe2xifWVfY21wKCkgZmlyc3QgdG8gdGFrZSBub3JtYWwKcG9pbnRl
cnMsIHRob3VnaCBJIHRoaW5rIHRoZSBpbml0aWFsIGlkZWEgd2FzIHRvIGdldCB0eXBlIGNoZWNr
aW5nIGF0CmNvbXBpbGUgdGltZS4KCi0tIApBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hl
bmtvQGxpbnV4LmludGVsLmNvbT4KSW50ZWwgRmlubGFuZCBPeQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
