Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 249C9203B85AA
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 19:44:47 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id DB0C7AC01E7
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 11:44:42 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v6 2/4] ndctl, monitor: add ndctl monitor daemon
Date: Wed, 16 May 2018 02:44:40 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222766C731@g01jpexmbkw01>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jaqbaKwAAoXd3C_VGRQCcWUXCA545AGyPPXd6D1eEByA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222766AB3C@g01jpexmbkw01>
 <CAPcyv4hCiPQX85Wd445g-vWzCRX_Z5-f4eOMVmxyTVhV+3oEjA@mail.gmail.com>
In-Reply-To: <CAPcyv4hCiPQX85Wd445g-vWzCRX_Z5-f4eOMVmxyTVhV+3oEjA@mail.gmail.com>
Content-Language: ja-JP
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
bzpkYW4uai53aWxsaWFtc0BpbnRlbC5jb21dDQo+IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDE2LCAy
MDE4IDI6MDcgQU0NCj4gVG86IFFpLCBGdWxpL+aWiSDnpo/liKkgPHFpLmZ1bGlAanAuZnVqaXRz
dS5jb20+DQo+IENjOiBsaW51eC1udmRpbW0gPGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmc+DQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgMi80XSBuZGN0bCwgbW9uaXRvcjogYWRkIG5kY3RsIG1v
bml0b3IgZGFlbW9uDQo+IA0KPiBPbiBUdWUsIE1heSAxNSwgMjAxOCBhdCAxOjMyIEFNLCBRaSwg
RnVsaSA8cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4gd3JvdGU6DQo+IFsuLl0NCj4gPj4gQWN0dWFs
bHksIEkgZG9uJ3Qgc2VlIGEgbmVlZCB0byBoYXZlIExPR19ERVNUSU5BVElPTl9GSUxFIGF0IGFs
bC4gV2h5DQo+ID4+IG5vdCBqdXN0DQo+ID4+IGRvOg0KPiA+Pg0KPiA+PiAgICAgbmRjdGwgbW9u
aXRvciAyPmZpbGUNCj4gPj4NCj4gPj4gLi4udG8gcmVkaXJlY3Qgc3RkZXJyIHRvIGEgZmlsZT8N
Cj4gPg0KPiA+IEluIG15IHVuZGVyc3RhbmRpbmcsIHRoaXMgc3RkZXJyIHJlZGlyZWN0aW9uIGRv
ZXMgbm90IG1ha2Ugc2Vuc2Ugd2hlbg0KPiA+IG5kY3RsIG1vbml0b3IgcnVucyBhcyBhIGRhZW1v
biwgZWc6DQo+ID4gICAgIyBuZGN0bCBtb25pdG9yIC0tbG9nZmlsZSBzdGRlcnIgLS1kYWVtb24g
Mj5maWxlIFdoYXQgZG8geW91IHRoaW5rPw0KPiANCj4gVHJ1ZSwgYW5kIG5vdyB0aGF0IEkgbG9v
ayBkbnNtYXNxIGFsbG93cyB0aGUgc2FtZSB3aXRoIGl0cyAtLWxvZy1mYWNpbGl0eSBvcHRpb24u
IE9rLA0KPiBsZXQncyBrZWVwIHRoaXMgZmVhdHVyZS4NCj4gDQo+IEkgYXBwcmVjaWF0ZSB0aGUg
Y29udGludWVkIGVmZm9ydCBhbmQgcGF0aWVuY2UuDQo+IA0KT2ssIEkgc2VlLg0KVGhhbmsgeW91
IHZlcnkgbXVjaC4NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpo
dHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
