Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 6FC081A1E54
 for <linux-nvdimm@lists.01.org>; Tue,  1 Mar 2016 08:05:48 -0800 (PST)
From: "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH v2 1/3] ACPI/NFIT: Update Control Region Structure to
 comply ACPI 6.1
Date: Tue, 1 Mar 2016 16:03:07 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D6E1@ORSMSX110.amr.corp.intel.com>
References: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
 <1456178130-26468-2-git-send-email-toshi.kani@hpe.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D64B@ORSMSX110.amr.corp.intel.com>
 <1456850284.15454.23.camel@hpe.com>
In-Reply-To: <1456850284.15454.23.camel@hpe.com>
Content-Language: en-US
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
To: Toshi Kani <toshi.kani@hpe.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Zheng," Lv" <lv.zheng@intel.com>, "devel@acpica.org,  <devel@acpica.org>
List-ID: <linux-nvdimm@lists.01.org>

V2UgaGF2ZSBhIGJ1bmNoIG9mIG1hY3JvcyBpbiBpbmNsdWRlL2FjbWFjcm9zLmggLS0gbGlrZSB0
aGlzOg0KDQpBQ1BJX01PVkVfMTZfVE9fMTYoZCwgcykNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+IEZyb206IFRvc2hpIEthbmkgW21haWx0bzp0b3NoaS5rYW5pQGhwZS5jb21d
DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDAxLCAyMDE2IDg6MzggQU0NCj4gVG86IE1vb3JlLCBS
b2JlcnQ7IHJqd0Byand5c29ja2kubmV0OyBXaWxsaWFtcywgRGFuIEoNCj4gQ2M6IFpoZW5nLCBM
djsgZWxsaW90dEBocGUuY29tOyBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnOyBsaW51eC0NCj4g
YWNwaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRldmVs
QGFjcGljYS5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAxLzNdIEFDUEkvTkZJVDogVXBk
YXRlIENvbnRyb2wgUmVnaW9uIFN0cnVjdHVyZSB0bw0KPiBjb21wbHkgQUNQSSA2LjENCj4gDQo+
IE9uIFR1ZSwgMjAxNi0wMy0wMSBhdCAxNToxMyArMDAwMCwgTW9vcmUsIFJvYmVydCB3cm90ZToN
Cj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IFRvc2hp
IEthbmkgW21haWx0bzp0b3NoaS5rYW5pQGhwZS5jb21dDQo+ID4gPiBTZW50OiBNb25kYXksIEZl
YnJ1YXJ5IDIyLCAyMDE2IDE6NTUgUE0NCj4gPiA+IFRvOiByandAcmp3eXNvY2tpLm5ldDsgV2ls
bGlhbXMsIERhbiBKDQo+ID4gPiBDYzogTW9vcmUsIFJvYmVydDsgWmhlbmcsIEx2OyBlbGxpb3R0
QGhwZS5jb207DQo+ID4gPiBsaW51eC1udmRpbW1AbGlzdHMuMDEub3IgZzsgbGludXgtYWNwaUB2
Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkZXZl
bEBhY3BpY2Eub3JnOyBUb3NoaSBLYW5pDQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggdjIgMS8zXSBB
Q1BJL05GSVQ6IFVwZGF0ZSBDb250cm9sIFJlZ2lvbiBTdHJ1Y3R1cmUNCj4gPiA+IHRvIGNvbXBs
eSBBQ1BJIDYuMQ0KPiA+ID4NCj4gPiA+IEFDUEkgNi4xLCBUYWJsZSA1LTEzMywgdXBkYXRlcyBO
VkRJTU0gQ29udHJvbCBSZWdpb24gU3RydWN0dXJlIGFzDQo+ID4gPiBmb2xsb3dzLg0KPiA+ID4g
wqAtIFZhbGlkIEZpZWxkcywgTWFudWZhY3R1cmluZyBMb2NhdGlvbiwgYW5kIE1hbnVmYWN0dXJp
bmcgRGF0ZQ0KPiA+ID4gwqDCoMKgYXJlIGFkZGVkIGZyb20gcmVzZXJ2ZWQgcmFuZ2UuwqDCoE5v
IGNoYW5nZSBpbiB0aGUgc3RydWN0dXJlIHNpemUuDQo+ID4gPiDCoC0gSURzIGRlZmluZWQgYXMg
U1BEIHZhbHVlcyBhcmUgYXJyYXlzIG9mIGJ5dGVzLsKgwqBUaGUgc3BlYw0KPiA+ID4gwqDCoMKg
Y2xhcmlmaWVkIHRoYXQgdGhleSBuZWVkIHRvIGJlIHJlcHJlc2VudGVkIGFzIGFycmF5cyBvZiBi
eXRlcw0KPiA+ID4gwqDCoMKgYXMgd2VsbC4NCj4gPiA+DQo+ID4gPiBUaGlzIHBhdGNoIG1ha2Vz
IHRoZSBmb2xsb3dpbmcgY2hhbmdlcyB0byBzdXBwb3J0IHRoaXMgdXBkYXRlLg0KPiA+ID4gwqAt
IENoYW5nZSAnc3RydWN0IGFjcGlfbmZpdF9jb250cm9sX3JlZ2lvbicgdG8gcmVmbGVjdCB0aGUg
dXBkYXRlLg0KPiA+ID4gwqDCoMKgU1BEIElEcyBhcmUgZGVmaW5lZCBhcyBhcnJheXMgb2YgYnl0
ZXMsIHNvIHRoYXQgdGhleSBjYW4gYmUNCj4gPiA+IMKgwqDCoHRyZWF0ZWQgaW4gdGhlIHNhbWUg
d2F5IHJlZ2FyZGxlc3Mgb2YgQ1BVIGVuZGlhbm5lc3MgYW5kIGFyZQ0KPiA+ID4gwqDCoMKgbm90
IG1pc3MtdHJlYXRlZCBhcyBsaXR0bGUtZW5kaWFuIG51bWVyaWMgdmFsdWVzLg0KPiA+DQo+ID4N
Cj4gPiBJIGRvbid0IHRoaW5rIHdlIGFyZSBnb2luZyB0byBzdGFydCBjaGFuZ2luZyB0aGUgQUNQ
SSB0YWJsZXMgZGVmaW5lZA0KPiA+IGluIHRoZSBBQ1BJQ0EgaGVhZGVycyBiZWNhdXNlIG9mIHRo
aXMuIFdlIGRvIGluIGZhY3QgaGF2ZSBtYWNyb3MgZm9yDQo+ID4gdGhpcyBwdXJwb3NlLg0KPiAN
Cj4gQ2FuIHlvdSBlbGFib3JhdGUgd2hhdCBtYWNyb3MgeW91IHN1Z2dlc3QgdG8gdXNlIGZvciB0
aGlzIHB1cnBvc2U/DQo+IA0KPiBUaGFua3MsDQo+IC1Ub3NoaQ0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
