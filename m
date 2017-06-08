Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 686342094552E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 11:25:30 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
Date: Thu, 8 Jun 2017 18:26:36 +0000
Message-ID: <1496946370.9288.7.camel@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
 <1496869051.9288.1.camel@hpe.com>
 <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
 <1496871186.9288.3.camel@hpe.com>
 <b91c4a7b-3e19-df5d-12e7-61cdf1bc2c84@hpe.com>
 <CAPcyv4hocL=1Mzqa+nJCdmRz7YgxUc3P1w-nn7F=uQG8wu94KA@mail.gmail.com>
 <1496943475.9288.5.camel@hpe.com>
In-Reply-To: <1496943475.9288.5.camel@hpe.com>
Content-Language: en-US
Content-ID: <EA02CCD3A76813468F1EC96C779BC808@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "Knippers, Linda" <linda.knippers@hpe.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA2LTA4IGF0IDExOjM3IC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiBP
biBUaHUsIDIwMTctMDYtMDggYXQgMTA6MzQgLTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4g
PiBPbiBUaHUsIEp1biA4LCAyMDE3IGF0IDEwOjMwIEFNLCBMaW5kYSBLbmlwcGVycyA8bGluZGEu
a25pcHBlcnNAaHBlDQo+ID4gLmMNCj4gPiBvbT4gd3JvdGU6DQo+ID4gWy4uXQ0KPiA+ID4gV2Fz
bid0IERhbiBjb25jZXJuZWQgYWJvdXQgaG93IHRoZSBPUyBjYW4ga25vdyB3aGV0aGVyIHRoZSBG
Vw0KPiA+ID4gc3VwcG9ydHMgdGhhdCBiaXQgaW4gdGhlIFN0YXJ0IEFSUz8NCj4gPiA+IA0KPiA+
ID4gVGhlIFF1ZXJ5IEFSUyBDYXBhYmlsaXRpZXMgRFNNIGhhcyBhIGJpdCB0aGF0IHRlbGxzIHRo
ZSBPUw0KPiA+ID4gd2hldGhlciB0aGUgcGxhdGZvcm0gc3VwcG9ydHMgdGhlIG5vdGlmaWNhdGlv
biBhbmQgdGhlIHBvaW50IG9mDQo+ID4gPiB0aGUgbm90aWZpY2F0aW9uIHdhcyB0byB0ZWxsIHRo
ZSBPUyBpdCBjb3VsZCBkbyBhIFN0YXJ0IEFSUyB3aXRoDQo+ID4gPiBiaXQgMSBzZXQuwqDCoE9m
IGNvdXJzZSwgaWYgeW91IGdldCB0aGUgbm90aWZpY2F0aW9uIHRoZW4gdGhhdA0KPiA+ID4gbWVh
bnMgdGhlIHBsYXRmb3JtIGhhcyB0aGUgY2FwYWJpbGl0eSB0byBkZWxpdmVyIGl0LCBidXQgaXQg
bWlnaHQNCj4gPiA+IG5vdCBodXJ0IHRvIGNoZWNrIHRoZSBmbGFnIGZyb20gdGhlIFF1ZXJ5IENh
cGFiaWxpdGllcyBiaXQuDQo+ID4gDQo+ID4gR29vZCBwb2ludCwgeWVzLCBJIHRoaW5rIGl0IGlz
IHNhZmUgdG8gYXNzdW1lIHRoYXQgYSBCSU9TIHRoYXQNCj4gPiBjbGFpbXMgdG8gc3VwcG9ydCB1
bi1jb3JyZWN0YWJsZSBlcnJvciBub3RpZmljYXRpb24gYWxzbyBzdXBwb3J0cw0KPiA+IHRoaXMg
U3RhcnQgQVJTIGZsYWcuDQo+IA0KPiBZZXMsIEFDUEkgNi4yLCBzZWN0aW9uIDkuMjAuNy4yLCBk
ZWZpbmVzIHRoYXQ6DQo+IA0KPiDCoMKgwqDCoMKgwqBVcG9uIHJlY2VpdmluZyB0aGUgbm90aWZp
Y2F0aW9uLCB0aGUgT1NQTSBtYXkgZGVjaWRlIHRvIGlzc3VlDQo+IMKgwqDCoMKgwqDCoGEgU3Rh
cnQgQVJTIHdpdGggRmxhZ3MgQml0IFsxXSBzZXQgdG8gcHJlcGFyZSBmb3IgdGhlIHJldHJpZXZh
bA0KPiDCoMKgwqDCoMKgwqBvZiBleGlzdGluZyByZWNvcmRzIGFuZCBpc3N1ZSB0aGUgUXVlcnkg
QVJTIFN0YXR1cyBmdW5jdGlvbiB0bw0KPiDCoMKgwqDCoMKgwqByZXRyaWV2ZSB0aGUgcmVjb3Jk
cy4NCj4gDQo+IFNvLMKgSSBiZWxpZXZlIGl0IGlzIHNhZmUgdG8gYXNzdW1lIHRoYXQgQklPUyBz
dXBwb3J0aW5nIDB4ODEgYWxzbw0KPiBzdXBwb3J0cyBmbGFncyBCaXQgWzFdLsKgwqBTb3JyeSwg
dGhpcyBpcyB3aGF0IEkgc2hvdWxkIGhhdmUgc2FpZCBpbiBteQ0KPiBwcmV2aW91cyBlbWFpbC4u
Lg0KDQpUbyByZWl0ZXJhdGUgbXkgdGhpbmtpbmcsIEkgYmVsaWV2ZSB0aGUgc3RhdGVtZW50IGFi
b3ZlIGNsYXJpZmllcyB0aGF0DQp0aGUgT1MgY2FuIGFzc3VtZSBCSU9TIHN1cHBvcnQgb2YgRmxh
Z3MgQml0WzFdIHVwb24gcmVjZWl2aW5nIGEgMHg4MQ0Kbm90aWZpY2F0aW9uLiAgU2luY2UgQklP
UyBtYXkgYWxzbyBzdXBwb3J0IEZsYWdzIEJpdFsxXSB3aXRob3V0DQpzdXBwb3J0aW5nIHRoaXMg
MHg4MSAoaW4gd2hpY2ggY2FzZSBJIGRvIG5vdCBrbm93IGhvdyB0byBkZXRlY3QgaXQsIGJ1dA0K
QklPUyBzaG91bGQgc2ltcGx5IGlnbm9yZSB0aGlzIGJpdCB3aGVuIG5vdCBzdXBwb3J0aW5nIGl0
KSwgSSBhbSBub3QNCmdvaW5nIHRvIGFkZCBhIGNoZWNrL3Jlc3RyaWN0aW9uIHRoYXQgMHg4MSBz
dXBwb3J0IGlzIG5lY2Vzc2FyeSB0byBzZXQNCkJpdFsxXSBpbiB0aGUgc2NhbiBmdW5jdGlvbi4N
Cg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAx
Lm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
