Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2C9F21951C80
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 16:41:39 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] pmem: fix a NULL pointer BUG in nd_pmem_notify
Date: Tue, 25 Apr 2017 23:40:25 +0000
Message-ID: <1493163594.26622.11.camel@hpe.com>
References: <20170425230413.363-1-toshi.kani@hpe.com>
 <CAPcyv4jNpCc=qCsRM0-U3Ov=iFn2e_n53_ZgPdDV3pttS0P9Ew@mail.gmail.com>
In-Reply-To: <CAPcyv4jNpCc=qCsRM0-U3Ov=iFn2e_n53_ZgPdDV3pttS0P9Ew@mail.gmail.com>
Content-Language: en-US
Content-ID: <422EFD1008114F4188A3DDD6B8349DE6@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVHVlLCAyMDE3LTA0LTI1IGF0IDE2OjA3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXByIDI1LCAyMDE3IGF0IDQ6MDQgUE0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4NCj4gd3JvdGU6DQo+ID4gVGhlIGZvbGxvd2luZyBCVUcgd2FzIG9ic2VydmVkIHdo
ZW4gbmRfcG1lbV9ub3RpZnkoKSB3YXMgY2FsbGVkDQo+ID4gZm9yIGEgQlRUIGRldmljZS7CoMKg
VGhlIHVzZSBvZiBhIHBtZW1fZGV2aWNlIHBvaW50ZXIgaXMgbm90IHZhbGlkDQo+ID4gd2l0aCBC
VFQuDQo+ID4gDQo+ID4gwqBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRl
ciBkZXJlZmVyZW5jZSBhdA0KPiA+IDAwMDAwMDAwMDAwMDAwMzANCj4gPiDCoElQOiBuZF9wbWVt
X25vdGlmeSsweDMwLzB4ZjAgW25kX3BtZW1dDQo+ID4gwqBDYWxsIFRyYWNlOg0KPiA+IMKgIG5k
X2RldmljZV9ub3RpZnkrMHg0MC8weDUwDQo+ID4gwqAgY2hpbGRfbm90aWZ5KzB4MTAvMHgyMA0K
PiA+IMKgIGRldmljZV9mb3JfZWFjaF9jaGlsZCsweDUwLzB4OTANCj4gPiDCoCBuZF9yZWdpb25f
bm90aWZ5KzB4MjAvMHgzMA0KPiA+IMKgIG5kX2RldmljZV9ub3RpZnkrMHg0MC8weDUwDQo+ID4g
wqAgbnZkaW1tX3JlZ2lvbl9ub3RpZnkrMHgyNy8weDMwDQo+ID4gwqAgYWNwaV9uZml0X3NjcnVi
KzB4MzQxLzB4NTkwIFtuZml0XQ0KPiA+IMKgIHByb2Nlc3Nfb25lX3dvcmsrMHgxOTcvMHg0NTAN
Cj4gPiDCoCB3b3JrZXJfdGhyZWFkKzB4NGUvMHg0YTANCj4gPiDCoCBrdGhyZWFkKzB4MTA5LzB4
MTQwDQo+ID4gDQo+ID4gRml4IG5kX3BtZW1fbm90aWZ5KCkgYnkgc2V0dGluZyBuZF9yZWdpb24g
YW5kIGJhZGJsb2NrcyBwb2ludGVycw0KPiA+IHByb3Blcmx5IGZvciBCVFQuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPg0KPiA+IENjOiBE
YW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiBDYzogVmlzaGFsIFZl
cm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IA0KPiANCj4gSGkgVG9zaGksIGhvdyBk
aWQgeW91IHRyaWdnZXIgdGhpcz8gSSdkIGxpa2UgdG8gZ2V0IHlvdXIgdGVzdCBpbnRvDQo+IHRo
ZSByZWdyZXNzaW9uIHN1aXRlLg0KDQpIaSBEYW4sDQoNCkkgaW5qZWN0ZWQgYW4gZXJyb3IgYW5k
IHN0YXJ0ZWQgYW4gQVJTIHNjYW4uICBVbmZvcnR1bmF0ZWx5LCBteSB0ZXN0DQpzdGVwcyBuZWVk
IHRvIHJ1biBvbiBvdXIgcGxhdGZvcm1zLiAgSSB0aGluayB0aGVzZSBlcnJvciBpbmplY3Rpb24N
CmZlYXR1cmVzIGNhbiBiZSBlbXVsYXRlZCwgdGhvdWdoLg0KDQpUaGFua3MsDQotVG9zaGkKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
