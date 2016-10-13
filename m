Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam03on0714.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe4a::714])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 414AE1A1E8D
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 11:16:32 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] pmem: report error on clear poison failure
Date: Thu, 13 Oct 2016 18:16:29 +0000
Message-ID: <1476382494.20881.58.camel@hpe.com>
References: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jdRhM8r1Ut4Ls4a4_PTroiXXZVcvruJ9TEj_SifenBCw@mail.gmail.com>
 <1476374787.20881.34.camel@hpe.com>
 <CAPcyv4jvi0N1qbUeEy5qvxp5uctv9sW4oNZLcO5Vt2TsuuQh-A@mail.gmail.com>
In-Reply-To: <CAPcyv4jvi0N1qbUeEy5qvxp5uctv9sW4oNZLcO5Vt2TsuuQh-A@mail.gmail.com>
Content-Language: en-US
Content-ID: <8910E7B4E99B154AB36F80C2DE8D7354@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTEwLTEzIGF0IDEwOjIyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDEzLCAyMDE2IGF0IDk6MDggQU0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbQ0KPiA+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFRodSwgMjAxNi0xMC0xMyBh
dCAwOTowMSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiBUaHUs
IE9jdCAxMywgMjAxNiBhdCA4OjU0IEFNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5jb20+
DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBBQ1BJIENsZWFyIFVu
Y29ycmVjdGFibGUgRXJyb3IgRFNNIGZ1bmN0aW9uIG1heSBmYWlsIG9yIG1heSBiZQ0KPiA+ID4g
PiB1bnN1cHBvcnRlZCBvbiBhIHBsYXRmb3JtLsKgwqBwbWVtX2NsZWFyX3BvaXNvbigpIHJldHVy
bnMgd2l0aG91dA0KPiA+ID4gPiBjbGVhcmluZyBiYWRibG9ja3MgaW4gc3VjaCBjYXNlcywgd2hp
Y2ggbGVhZHMgdG8gYSBzaWxlbnQgZGF0YQ0KPiA+ID4gPiBjb3JydXB0aW9uLg0KPiA+ID4gPiAN
Cj4gPiA+ID4gQ2hhbmdlIHBtZW1fZG9fYnZlYygpIGFuZCBwbWVtX2NsZWFyX3BvaXNvbigpIHRv
IHJldHVybiAtRUlPDQo+ID4gPiA+IHNvIHRoYXQgZmlsZXN5c3RlbSBjYW4gbG9nIGFuIGVycm9y
IG1lc3NhZ2UuDQo+ID4gPiANCj4gPiA+IFdoYXQncyB0aGUgc2lsZW50IGRhdGEgY29ycnVwdGlv
biBzY2VuYXJpbz/CoMKgSWYgdGhlIGNsZWFyIHBvaXNvbg0KPiA+ID4gZmFpbHMgSSdtIGFzc3Vt
aW5nIHRoYXQgdGhlIHBvaXNvbiB3aWxsIHN0aWxsIGJlIG5vdGlmaWVkIG9uIHRoZQ0KPiA+ID4g
bmV4dA0KPiA+ID4gcmVhZC4NCj4gPiANCj4gPiBJIGFncmVlIHRoYXQgdGhlIGRhdGEgaXMgZXZl
bnR1YWxseSByZWFkLCBidXQgdGhlcmUgaXMgbm8gZ3VyYW50ZWVkDQo+ID4gdGhhdCB3aGVuIGl0
IGlzIHJlYWQgc29vbiBlbm91Z2gsIGkuZS4gdXNlciBtaWdodCBub3QgYWNjZXNzIHRvIHRoZQ0K
PiA+IGRhdGEgZm9yIGEgbG9uZyB0aW1lLg0KPiANCj4gLi4uYnV0IHRoYXQncyB0aGUgc2FtZSBi
ZWhhdmlvciBmb3IgZXJyb3JzIHRoYXQgd2UgZG9uJ3QgeWV0IGtub3cNCj4gYWJvdXQuwqDCoFRo
YXQgc2FpZCwgd2UgaW5kZWVkIGtub3cgdGhhdCB0aGUgd3JpdGUgZmFpbGVkLsKgwqBJJ2QgZmVl
bA0KPiBiZXR0ZXIgYWJvdXQgdGhpcyBwYXRjaCBpZiB0aGUganVzdGlmaWNhdGlvbiAvIGltcGFj
dCB3YXMgY2xlYXJlciBpbg0KPiB0aGUgY2hhbmdlbG9nLCBiZWNhdXNlICJzaWxlbnQgZGF0YSBj
b3JydXB0aW9uIiBpcyBub3QgdGhlIGltcGFjdC4NCg0KQWdyZWVkLiDCoEhvdyBhYm91dCB0aGUg
Zm9sbG93aW5nIGRlc2NyaXRwaW9uPw0KDQo9PT0NCkFDUEkgQ2xlYXIgVW5jb3JyZWN0YWJsZSBF
cnJvciBEU00gZnVuY3Rpb24gbWF5IGZhaWwgb3IgbWF5IGJlDQp1bnN1cHBvcnRlZCBvbiBhIHBs
YXRmb3JtLsKgwqBwbWVtX2NsZWFyX3BvaXNvbigpIHJldHVybnMgd2l0aG91dA0KY2xlYXJpbmcg
YmFkYmxvY2tzIGluIHN1Y2ggY2FzZXMuIMKgVGhpcyBmYWlsdXJlIGlzIGRldGVjdGVkIGF0DQp0
aGUgbmV4dCByZWFkICgtRUlPKS4NCg0KVGhpcyBiZWhhdmlvciBjYW4gbGVhZCB0byBhbiBpc3N1
ZSB3aGVuIHVzZXIga2VlcHMgd3JpdGluZyBidXQNCmRvZXMgbm90IHJlYWQgaW1tZWRpY2F0ZWx5
LiDCoEZvciBpbnN0YW5jZSwgZmxpZ2h0IHJlY29yZGVyIGZpbGUNCm1heSBiZSBvbmx5IHJlYWQg
d2hlbiBpdCBpcyBuZWNlc3NhcnkgZm9yIHRyb3VibGVzaG9vdGluZy4NCg0KQ2hhbmdlIHBtZW1f
ZG9fYnZlYygpIGFuZCBwbWVtX2NsZWFyX3BvaXNvbigpIHRvIHJldHVybiAtRUlPDQpzbyB0aGF0
IGZpbGVzeXN0ZW0gY2FuIGxvZyBhbiBlcnJvciBtZXNzYWdlIG9uIGEgd3JpdGUgZXJyb3IuDQo9
PT0NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGlt
bQo=
