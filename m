Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on070d.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::70d])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A34E31A1DFB
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 16:21:47 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Date: Thu, 8 Sep 2016 23:21:46 +0000
Message-ID: <1473376846.2092.69.camel@hpe.com>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
 <20160829204842.GA27286@node.shutemov.name>
 <1472506310.1532.47.camel@hpe.com> <1472508000.1532.59.camel@hpe.com>
 <20160908105707.GA17331@node> <1473342519.2092.42.camel@hpe.com>
In-Reply-To: <1473342519.2092.42.camel@hpe.com>
Content-Language: en-US
Content-ID: <9350D07B6CBB5D478100CA51D35240A4@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "kirill@shutemov.name" <kirill@shutemov.name>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "hughd@google.com" <hughd@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTA5LTA4IGF0IDA3OjQ4IC0wNjAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3Rl
Og0KPiBPbiBUaHUsIDIwMTYtMDktMDggYXQgMTM6NTcgKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1v
diB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIEF1ZyAyOSwgMjAxNiBhdCAxMDowMDo0M1BNICsw
MDAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3RlOg0KwqA6DQo+ID4gPiANCj4gPiA+IExvb2tpbmcg
ZnVydGhlciwgdGhlc2Ugc2htZW1faHVnZSBoYW5kbGluZ3Mgb25seSBjaGVjayBwcmUtDQo+ID4g
PiBjb25kaXRpb25zLsKgwqBTbyzCoHdlwqBzaG91bGTCoGJlwqBhYmxlwqB0b8KgbWFrZcKgc2ht
ZW1fZ2V0X3VubWFwcGVkX2FyZQ0KPiA+ID4gYSgpIGFzIGEgd3JhcHBlciwgd2hpY2ggY2hlY2tz
IHN1Y2ggc2htZW0tc3BlY2lmaWMgY29uaXRpb25zLCBhbmQNCj4gPiA+IHRoZW7CoGNhbGzCoF9f
dGhwX2dldF91bm1hcHBlZF9hcmVhKCkgZm9yIHRoZSBhY3R1YWwgd29yay4gwqBBbGwNCj4gPiA+
IERBWC1zcGVjaWZpYyBjaGVja3MgYXJlIHBlcmZvcm1lZCBpbiB0aHBfZ2V0X3VubWFwcGVkX2Fy
ZWEoKSBhcw0KPiA+ID4gd2VsbC4gwqBXZSBjYW4gbWFrZSDCoF9fdGhwX2dldF91bm1hcHBlZF9h
cmVhKCkgYXMgYSBjb21tb24NCj4gPiA+IGZ1bmN0aW9uLg0KPiA+ID4gDQo+ID4gPiBJJ2QgcHJl
ZmVyIHRvIG1ha2Ugc3VjaCBjaGFuZ2UgYXMgYSBzZXBhcmF0ZSBpdGVtLA0KPiA+IA0KPiA+IERv
IHlvdSBoYXZlIHBsYW4gdG8gc3VibWl0IHN1Y2ggY2hhbmdlPw0KPiANCj4gWWVzLCBJIHdpbGwg
c3VibWl0IHRoZSBjaGFuZ2Ugb25jZSBJIGZpbmlzaCB0ZXN0aW5nLg0KDQpJIGZvdW5kIGEgYnVn
IGluIHRoZSBjdXJyZW50IGNvZGUsIGFuZCBuZWVkIHNvbWUgY2xhcmlmaWNhdGlvbi4gwqBUaGUN
CmlmLXN0YXRlbWVudCBiZWxvdyBpcyByZXZlcnRlZC4NCg0KPT09DQpkaWZmIC0tZ2l0IGEvbW0v
c2htZW0uYyBiL21tL3NobWVtLmMNCmluZGV4IGZkOGIyYjUuLmFlYzViNDkgMTAwNjQ0DQotLS0g
YS9tbS9zaG1lbS5jDQorKysgYi9tbS9zaG1lbS5jDQpAQCAtMTk4MCw3ICsxOTgwLDcgQEAgdW5z
aWduZWQgbG9uZyBzaG1lbV9nZXRfdW5tYXBwZWRfYXJlYShzdHJ1Y3QgZmlsZQ0KKmZpbGUsDQrC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuIGFkZHI7DQrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBzYiA9IHNobV9tbnQtPm1udF9zYjsNCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgfQ0KLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChTSE1FTV9TQihz
YiktPmh1Z2UgIT0gU0hNRU1fSFVHRV9ORVZFUikNCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAoU0hNRU1fU0Ioc2IpLT5odWdlID09IFNITUVNX0hVR0VfTkVWRVIpDQrCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gYWRkcjsNCsKg
wqDCoMKgwqDCoMKgwqB9DQo9PT0NCg0KQmVjYXVzZSBvZiB0aGlzIGJ1ZywgbW91bnRpbmcgdG1w
ZnMgd2l0aCAiaHVnZT1uZXZlciIgZW5hYmxlcyBodWdlIHBhZ2UNCm1hcHBpbmdzLCBhbmQgImh1
Z2U9YWx3YXlzIiBvciBvdGhlcnMgZGlzYWJsZXMgaXQuLi4NCg0KVGhlIGFib3ZlIHNpbXBsZSBj
aGFuZ2Ugd2lsbCBjaGFuZ2UgdGhlIGRlZmF1bHQgYmVoYXZpb3IsIHRob3VnaC4gwqBXaGVuDQoi
aHVnZT0iIG9wdGlvbiBpcyBub3Qgc3BlY2lmaWVkLCBTSE1FTV9TQihzYiktPmh1Z2UgaXMgc2V0
IHRvIHplcm8sDQp3aGljaCBpcyBTSE1FTV9IVUdFX05FVkVSLiDCoFRoZXJlZm9yZSwgaHVnZSBw
YWdlIG1hcHBpbmdzIGFyZSBlbmFibGVkDQpieSBkZWZhdWx0IGJlY2F1c2Ugb2YgdGhpcyBidWcu
DQoNCldoYXQncyB0aGUgaW50ZW5kZWQgZGVmYXVsdCBiZWhhdmlvciBvZiB0aGlzIGZlYXR1cmU/
DQoNClRoYW5rcywNCi1Ub3NoaQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
