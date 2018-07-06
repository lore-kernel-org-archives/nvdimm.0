Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE630203369D9
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 21:10:44 -0700 (PDT)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local
 (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 69392AC00FA
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 13:10:37 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl, test: add a new unit test for monitor
Date: Fri, 6 Jul 2018 04:10:34 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA751DA@g01jpexmbkw24>
References: <20180705112304.2656-1-qi.fuli@jp.fujitsu.com>
 <df891d44-5b43-3aef-da9a-df63a4b46aae@gmail.com>
 <CAPcyv4iW-oZ+BGzfb8L5pB2+BvD6fG6jB5ibSOt5a9XeuazxhA@mail.gmail.com>
In-Reply-To: <CAPcyv4iW-oZ+BGzfb8L5pB2+BvD6fG6jB5ibSOt5a9XeuazxhA@mail.gmail.com>
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
To: 'Dan Williams' <dan.j.williams@intel.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgW21haWx0
bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgSnVseSA2LCAyMDE4
IDY6MjYgQU0NCj4gVG86IE1hc2F5b3NoaSBNaXp1bWEgPG1zeXMubWl6dW1hQGdtYWlsLmNvbT4N
Cj4gQ2M6IFFpLCBGdWxpL+aWiSDnpo/liKkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+OyBsaW51
eC1udmRpbW0NCj4gPGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmc+DQo+IFN1YmplY3Q6IFJlOiBb
bmRjdGwgUEFUQ0hdIG5kY3RsLCB0ZXN0OiBhZGQgYSBuZXcgdW5pdCB0ZXN0IGZvciBtb25pdG9y
DQo+IA0KPiBPbiBUaHUsIEp1bCA1LCAyMDE4IGF0IDI6MDYgUE0sIE1hc2F5b3NoaSBNaXp1bWEg
PG1zeXMubWl6dW1hQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gSGkgUWksDQo+ID4NCj4gPiBJIHRy
aWVkIHRoaXMgdGVzdCBhZnRlciBJIGFwcGxpZWQgeW91ciBsYXRlc3QgbW9uaXRvciBwYXRjaGVz
IFsxXS4NCj4gPiBJIGZvdW5kIHNvbWUgcG9pbnRzLiBDb3VsZCB5b3UgY2hlY2sgdGhlIGZvbGxv
d2luZz8NCj4gPg0KPiA+IFsxXSBodHRwczovL2xpc3RzLjAxLm9yZy9waXBlcm1haWwvbGludXgt
bnZkaW1tLzIwMTgtSnVuZS8wMTY1NjIuaHRtbA0KPiA+DQo+ID4gT24gMDcvMDUvMjAxOCAwNzoy
MyBBTSwgUUkgRnVsaSB3cm90ZToNCj4gWy4uXQ0KPiA+IElzIHRoaXMgIm5tZW0wOm5tZW0xOm5t
ZW0yOm5tZW0zIj8NCj4gPiBPciB3aHkgZG9uJ3QgeW91IGdldHRpbmcgdGhlIGRpbW1zIGJ5IG5k
Y3RsIGxpc3QgY29tbWFuZCBpbnN0ZWFkIG9mIGhhcmQtY29yZGluZz8NCj4gDQo+IFllcywgdGhp
cyBpcyBuZWVkZWQuIFRoZSB0ZXN0IGZhaWxzIGZvciBtZSBiZWNhdXNlIEkgaGF2ZSBhbiBlODIw
IGRlZmluZWQgYnVzIGFuZA0KPiBhIHR5cGljYWwgQUNQSSBORklUIGJ1cyBhbG9uZyB3aXRoIHRo
ZSBuZml0X3Rlc3QgYnVzZXMgb24gbXkgdGVzdCBzeXN0ZW0uDQoNCk1hc2EsIERhbiwNCg0KVGhh
bmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciBjb21tZW50cy4NCkkgd2lsbCBmaXggaXQgaW4gbmV4
dCB2ZXJzaW9uLg0KDQpRSQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
