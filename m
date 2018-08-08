Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1745210C2D6F
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 17:54:58 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 4AC0AAC00ED
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 09:54:53 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 3/4] ndctl, monitor: add timestamp and pid to log
 messages in log_file()
Date: Wed, 8 Aug 2018 00:54:50 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA9DCE5@g01jpexmbkw24>
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
 <20180807131756.23673-4-qi.fuli@jp.fujitsu.com>
 <bed6c181-1316-4506-c2b6-113eea1f13ce@gmail.com>
In-Reply-To: <bed6c181-1316-4506-c2b6-113eea1f13ce@gmail.com>
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
To: 'Masayoshi Mizuma' <msys.mizuma@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXNheW9zaGkgTWl6dW1hIFtt
YWlsdG86bXN5cy5taXp1bWFAZ21haWwuY29tXQ0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCA4
LCAyMDE4IDM6NDAgQU0NCj4gVG86IFFpLCBGdWxpL+aWiSDnpo/liKkgPHFpLmZ1bGlAanAuZnVq
aXRzdS5jb20+OyBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnDQo+IFN1YmplY3Q6IFJlOiBbbmRj
dGwgUEFUQ0ggMy80XSBuZGN0bCwgbW9uaXRvcjogYWRkIHRpbWVzdGFtcCBhbmQgcGlkIHRvIGxv
ZyBtZXNzYWdlcw0KPiBpbiBsb2dfZmlsZSgpDQo+IA0KPiBIaSBRaSwNCj4gDQo+IE9uIDA4LzA3
LzIwMTggMDk6MTcgQU0sIFFJIEZ1bGkgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBpcyB1c2VkIHRv
IGFkZCB0aW1lc3RhbXAgYW5kIHByb2Nlc3MgaWQgdG8gbG9nIG1lc3NhZ2VzDQo+ID4gd2hlbiBs
b2dnaW5nIG1lc3NhZ2VzIHRvIGEgZmlsZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFFJIEZ1
bGkgPHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+DQo+ID4gLS0tDQo+ID4gIG5kY3RsL21vbml0b3Iu
YyB8IDExICsrKysrKysrKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbmRjdGwvbW9uaXRvci5jIGIv
bmRjdGwvbW9uaXRvci5jIGluZGV4IDJmM2Q3NTEuLmQyOWUzNzgNCj4gPiAxMDA2NDQNCj4gPiAt
LS0gYS9uZGN0bC9tb25pdG9yLmMNCj4gPiArKysgYi9uZGN0bC9tb25pdG9yLmMNCj4gPiBAQCAt
ODQsNiArODQsOCBAQCBzdGF0aWMgdm9pZCBsb2dfZmlsZShzdHJ1Y3QgbmRjdGxfY3R4ICpjdHgs
IGludA0KPiA+IHByaW9yaXR5LCBjb25zdCBjaGFyICpmaWxlLCAgew0KPiA+ICAJRklMRSAqZjsN
Cj4gPiAgCWNoYXIgKmJ1ZjsNCj4gPiArCXN0cnVjdCB0aW1lc3BlYyB0czsNCj4gPiArCWNoYXIg
dGltZXN0YW1wWzMyXTsNCj4gPg0KPiA+ICAJaWYgKHZhc3ByaW50ZigmYnVmLCBmb3JtYXQsIGFy
Z3MpIDwgMCkgew0KPiA+ICAJCWZhaWwoInZhc3ByaW50ZiBlcnJvclxuIik7DQo+ID4gQEAgLTk5
LDcgKzEwMSwxNCBAQCBzdGF0aWMgdm9pZCBsb2dfZmlsZShzdHJ1Y3QgbmRjdGxfY3R4ICpjdHgs
IGludCBwcmlvcml0eSwgY29uc3QNCj4gY2hhciAqZmlsZSwNCj4gPiAgCQlub3RpY2UoY3R4LCAi
JXNcbiIsIGJ1Zik7DQo+ID4gIAkJZ290byBlbmQ7DQo+ID4gIAl9DQo+ID4gLQlmcHJpbnRmKGYs
ICIlcyIsIGJ1Zik7DQo+ID4gKw0KPiA+ICsJaWYgKHByaW9yaXR5ICE9IExPR19OT1RJQ0UpIHsN
Cj4gDQpIaSBNYXNhLA0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuDQoNCj4gV2h5IGlzIHRo
ZSB0aW1lc3RhbXAgbm90IG5lZWRlZCBpbiBjYXNlIG9mIExPR19OT1RJQ0UuLi4/DQoNCkJlY2F1
c2UgTE9HX05PVElDRSBsZXZlbCBpcyBvbmx5IHVzZWQgZm9yIHNtYXJ0IGV2ZW50IG5vdGlmaWNh
dGlvbiBpbiBtb25pdG9yLg0KU2luY2UgdGhlIHRpbWVzdGFtcCBhbmQgcGlkIGFyZSBhbHJlYWR5
IGFkZGVkIHRvIGpzb24gZm9ybWF0IG1lc3NhZ2VzIGJ5IG5vdGlmeV9kaW1tX2V2ZW50KCksDQpz
byB0aGVyZSBpcyBubyBuZWVkIHRvIGFkZCB0aGVtIGFnYWluLg0KDQo+IA0KPiA+ICsJCWNsb2Nr
X2dldHRpbWUoQ0xPQ0tfUkVBTFRJTUUsICZ0cyk7DQo+ID4gKwkJc3ByaW50Zih0aW1lc3RhbXAs
ICIlMTBsZC4lMDlsZCIsIHRzLnR2X3NlYywgdHMudHZfbnNlYyk7DQo+ID4gKwkJZnByaW50Zihm
LCAiWyVzXSBbJWRdICVzIiwgdGltZXN0YW1wLCBnZXRwaWQoKSwgYnVmKTsNCj4gDQo+IFdoYXQg
aXMgdGhlIHBpZCBmb3IuLi4/DQo+IA0KTXVsdGlwbGUgbW9uaXRvciBjYW4gYmUgcnVuIGF0IHRo
ZSBzYW1lIHRpbWUgYW5kIHRoZXkgbWF5IHNlbmQgbWVzc2FnZXMgdG8gYSBjb21tb24gbG9nIGZp
bGUuDQpJbiB0aGlzIGNhc2UsIHRoZSBwaWQgY291bGQgaGVscCB1c2VycyB0byBrbm93IHRoZSBt
b25pdG9yIHdoZXJlIGVhY2ggbWVzc2FnZSBjYW1lIGZyb20uDQoNClRoYW5rcywNClFJDQoNCj4g
VGhhbmtzLA0KPiBNYXNhDQo+IA0KPiA+ICsJfSBlbHNlDQo+ID4gKwkJZnByaW50ZihmLCAiJXMi
LCBidWYpOw0KPiA+ICs+ICAJZmZsdXNoKGYpOw0KPiA+ICAJZmNsb3NlKGYpOw0KPiA+ICBlbmQ6
DQo+ID4NCj4gDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpo
dHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
