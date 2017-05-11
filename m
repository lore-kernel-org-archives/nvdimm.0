Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3FB521A04E1D
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 08:31:38 -0700 (PDT)
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com
 [16.197.64.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2352.austin.hpe.com (Postfix) with ESMTPS id 24A0E3F
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:31:38 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 2/2] ndctl: add list --media-errors support
Date: Thu, 11 May 2017 15:31:35 +0000
Message-ID: <1494516683.30303.88.camel@hpe.com>
References: <149446050265.19998.6594654322891878230.stgit@djiang5-desk3.ch.intel.com>
 <149446059426.19998.8536490603388756669.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149446059426.19998.8536490603388756669.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <800B2294D919474C8C2449073C9D02DE@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDE2OjU3IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
Q1BJIE5GSVQgZW5hYmxlZCBwbGF0Zm9ybXMgcHJvdmlkZSBtZWRpYSBlcnJvcnMgYXMgYWJzb2x1
dGUgcGh5aXNjYWwNCj4gYWRkcmVzcyBvZmZzZXRzLiBBZGQgYW4gb3B0aW9uIHRvIG5kY3RsIHRv
IGRpc3BsYXkgdGhvc2UgbWVkaWEgZXJyb3JzDQo+IHRyYW5sc2F0ZWQgdG8gcmVnaW9uIGFuZCBu
YW1lc3BhY2UgZGV2aWNlIGxldmVsIG9mZnNldHMgaW4gYW4gIm5kY3RsDQo+IGxpc3QiIGxpc3Rp
bmcuIEJUVCBiYWRibG9ja3Mgc2hvdyBpcyBub3Qgc3VwcG9ydGVkIGluIHRoaXMgaXRlcmF0aW9u
DQo+IGFuZCB3aWxsIGNvbWUgbGF0ZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5n
IDxkYXZlLmppYW5nQGludGVsLmNvbT4NCj4gLS0tDQo+IA0KPiB2MjogYWRkZWQgZml4IHRvIGJh
ZGJsb2NrcyBkaXNwbGF5IGZyb20gVG9zaGkncyB0ZXN0aW5nIHJlc3VsdC4NCj4gdjM6IGZpeGVk
IG5hbWluZyBpc3N1ZXMgZnJvbSBEYW4ncyBjb21tZW50cy4NCj4gwqDCoMKgwqBmaXhlZCBiYWRi
bG9ja3MgYm91bmRhcnkgb2Zmc2V0IGNhbGN1bGF0aW9ucyBmcm9tIFRvc2hpJ3MNCj4gdGVzdGlu
Zy4NCj4gdjQ6IEFkZCBpbmRpY2F0b3IgdG8gc2hvdyBiYWRibG9ja3MgZXhpc3Qgb3Igbm90LCBw
ZXIgVG9zaGkncw0KPiBjb21tZW50cy4NCg0KVGhpcyB2ZXJzaW9uIHdvcmtzIHByZXR0eSBnb29k
LCBleGNlcHQgdGhhdCBpdCBkb2VzIG5vdCBzaG93DQoiaGFzX2JhZGJsb2NrcyIgZm9yIHNlY3Rv
ciBtb2RlLg0KDQojIG5kY3RsIGxpc3QgLU0gLW0gc2VjdG9yDQp7DQrCoCAiZGV2IjoibmFtZXNw
YWNlMC4wIiwNCsKgICJtb2RlIjoic2VjdG9yIiwNCsKgICJzaXplIjoxNzE2MjAyNzAwOCwNCsKg
ICJ1dWlkIjoiNzc0MmRmZjMtM2VkZC00YTI4LTg5NGQtOWFjMWFlZGU2YjJjIiwNCsKgICJzZWN0
b3Jfc2l6ZSI6NDA5NiwNCsKgICJibG9ja2RldiI6InBtZW0wcyINCn0NCg0KVGhhbmtzLA0KLVRv
c2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
