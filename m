Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC471202E53DC
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 21:05:25 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A324EAC00E4
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jun 2018 13:05:18 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v8 1/3] ndctl, monitor: add ndctl monitor
Date: Thu, 28 Jun 2018 04:05:15 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E32237E95BA5@g01jpexmbkw01>
References: <20180627052426.26020-1-qi.fuli@jp.fujitsu.com>
 <20180627052426.26020-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPrEYbwORjjkQa8M+ryzp4sNY=tvhJbxiKFazQdcJOmQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E32237E95B86@g01jpexmbkw01>
 <CAPcyv4imzXawV769=-z1-_GHpbvLFFox12-SDB2GEchSkPWTdQ@mail.gmail.com>
In-Reply-To: <CAPcyv4imzXawV769=-z1-_GHpbvLFFox12-SDB2GEchSkPWTdQ@mail.gmail.com>
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgW21haWx0
bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDI4LCAy
MDE4IDEyOjUzIFBNDQo+IFRvOiBRaSwgRnVsaS/mlokg56aP5YipIDxxaS5mdWxpQGpwLmZ1aml0
c3UuY29tPg0KPiBDYzogbGludXgtbnZkaW1tIDxsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnPg0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIHY4IDEvM10gbmRjdGwsIG1vbml0b3I6IGFkZCBuZGN0bCBt
b25pdG9yDQo+IA0KPiBPbiBXZWQsIEp1biAyNywgMjAxOCBhdCA4OjAyIFBNLCBRaSwgRnVsaSA8
cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4gd3JvdGU6DQo+ID4gVGhhbmtzIGZvciB5b3VyIGNvbW1l
bnRzLg0KPiA+DQo+IA0KPiBUaGFua3MgZm9yIGNvbnRpbnVpbmcgdG8gd29yayB0aHJvdWdoIHRo
ZSBmZWVkYmFjay4NCj4gDQo+ID4+ID4gK3N0YXRpYyBzdHJ1Y3QgbW9uaXRvcl9kaW1tICp1dGls
X2RpbW1fZXZlbnRfZmlsdGVyKHN0cnVjdCBtb25pdG9yX2RpbW0NCj4gKm1kaW1tLA0KPiA+PiA+
ICsgICAgICAgICAgICAgICBjb25zdCBjaGFyICpfX2lkZW50KSB7DQo+ID4+ID4gKyAgICAgICBj
aGFyICppZGVudCwgKnNhdmU7DQo+ID4+ID4gKyAgICAgICBjb25zdCBjaGFyICpuYW1lOw0KPiA+
PiA+ICsgICAgICAgc3RydWN0IG1vbml0b3JfZGltbSAqX19tZGltbTsNCj4gPj4gPiArICAgICAg
IHN0cnVjdCBuZGN0bF9jdHggKmN0eCA9IG5kY3RsX2RpbW1fZ2V0X2N0eChtZGltbS0+ZGltbSk7
DQo+ID4+ID4gKw0KPiA+PiA+ICsgICAgICAgX19tZGltbSA9IGNhbGxvYygxLCBzaXplb2Yoc3Ry
dWN0IG1vbml0b3JfZGltbSkpOw0KPiA+PiA+ICsgICAgICAgaWYgKCFfX21kaW1tKSB7DQo+ID4+
ID4gKyAgICAgICAgICAgICAgIGZhaWwoIlxuIik7DQo+ID4+ID4gKyAgICAgICAgICAgICAgIHJl
dHVybiBOVUxMOw0KPiA+PiA+ICsgICAgICAgfQ0KPiA+Pg0KPiA+PiBXaHkgZG8gd2UgbmVlZCBh
IGR5bmFtaWMgYWxsb2NhdGlvbj8gQ2FuJ3QgdGhpcyBqdXN0IGxpdmUgb24gdGhlIHN0YWNrPw0K
PiA+Pg0KPiA+IEFjdHVhbGx5LCBJIGp1c3QgdXNlIHRoZSBfX2RpbW0gdG8gY29tcGFyZSBjdXJy
ZW50IGRpbW0gaGVhbHRoIHdpdGggdGhlIGRpbW0gaGVhbHRoDQo+IHdoZW4gdGhlIG1vbml0b3Ig
c3RhcnRlZC4NCj4gPiBXaGVuIHRoZSBkaW1tIGNoYW5nZWQsIHRoZSBfX2RpbW0gc2hvdWxkIGJl
IGluaXRpYWxpemVkLiBJIHRoaW5rIGEgZHluYW1pYyBhbGxvY2F0aW9uDQo+IGlzIHNtYXJ0ZXIg
dGhhbiBsaXZlIG9uIHRoZSBzdGFjay4NCj4gDQo+IEFsbG9jYXRpbmcgbWVtb3J5IHNob3VsZCBh
bHdheXMgYmUgYXZvaWRlZCB3aGVuIG5vdCBuZWNlc3NhcnkgYmVjYXVzZSBpdCdzIHNvIGVycm9y
DQo+IHByb25lIGluIEMuIE5vbmUgb2YgdGhlIG90aGVyIHV0aWxfWF9maWx0ZXIoKSByb3V0aW5l
cyBuZWVkIHRvIGFsbG9jYXRlIG1lbW9yeSwgaW4NCj4gZmFjdCB0aGUgcG9pbnQgaXMgdG8gdmFs
aWRhdGUgdGhhdCB0aGUgcGFzc2VkIGluIG9iamVjdCBwYXNzZXMgdGhlIGZpbHRlciwgbm90IHRv
DQo+IHN3YXAgdGhlIHBhc3NlZCBpbiBvYmplY3Qgd2l0aCBhIG5ldyBvbmUuDQo+IA0KDQpPSywg
SSBzZWUuIA0KDQpUaGFuayB5b3UgdmVyeSBtdWNoLg0KUWkNCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
