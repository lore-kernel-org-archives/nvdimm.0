Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D17F21A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 11:25:22 -0700 (PDT)
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com
 [16.197.64.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 704565F
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 18:25:21 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6] ndctl: add list --media-errors support
Date: Thu, 11 May 2017 18:25:19 +0000
Message-ID: <1494527106.30303.94.camel@hpe.com>
References: <149452561607.28242.9327540807726189144.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149452561607.28242.9327540807726189144.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <6AFC1D088B2FF2438B2C7EC53974FF79@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE3LTA1LTExIGF0IDExOjAxIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
Q1BJIE5GSVQgZW5hYmxlZCBwbGF0Zm9ybXMgcHJvdmlkZSBtZWRpYSBlcnJvcnMgYXMgYWJzb2x1
dGUgcGh5aXNjYWwNCj4gYWRkcmVzcyBvZmZzZXRzLiBBZGQgYW4gb3B0aW9uIHRvIG5kY3RsIHRv
IGRpc3BsYXkgdGhvc2UgbWVkaWEgZXJyb3JzDQo+IHRyYW5sc2F0ZWQgdG8gcmVnaW9uIGFuZCBu
YW1lc3BhY2UgZGV2aWNlIGxldmVsIG9mZnNldHMgaW4gYW4gIm5kY3RsDQo+IGxpc3QiIGxpc3Rp
bmcuIEJUVCBiYWRibG9ja3Mgc2hvdyBpcyBub3Qgc3VwcG9ydGVkIGluIHRoaXMgaXRlcmF0aW9u
DQo+IGFuZCB3aWxsIGNvbWUgbGF0ZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5n
IDxkYXZlLmppYW5nQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlz
aGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiAtLS0NCj4gDQo+IHYyOiBhZGRlZCBmaXggdG8gYmFk
YmxvY2tzIGRpc3BsYXkgZnJvbSBUb3NoaSdzIHRlc3RpbmcgcmVzdWx0Lg0KPiB2MzogZml4ZWQg
bmFtaW5nIGlzc3VlcyBmcm9tIERhbidzIGNvbW1lbnRzLg0KPiDCoMKgwqDCoGZpeGVkIGJhZGJs
b2NrcyBib3VuZGFyeSBvZmZzZXQgY2FsY3VsYXRpb25zIGZyb20gVG9zaGkncw0KPiB0ZXN0aW5n
Lg0KPiB2NDogQWRkIGluZGljYXRvciB0byBzaG93IGJhZGJsb2NrcyBleGlzdCBvciBub3QsIHBl
ciBUb3NoaSdzDQo+IGNvbW1lbnRzLg0KPiB2NTogQWRkIEJUVCBiYWRibG9ja19jb3VudCBmcm9t
IFRvc2hpIGFuZCBEYW4ncyBjb21tZW50cy4NCj4gdjY6IEZpeCBiYWRibG9ja19jb3VudCB0byB0
b3RhbCBudW1iZXIgb2YgYmJzIGFuZCBub3QgcmFuZ2UgcGVyDQo+IFRvc2hpLg0KDQpDbG9zZSwg
YnV0IHRoZXJlIGlzIGEgY29ybmVyIGNhc2UgaXNzdWUuICBUaGUgMXN0IGJhZGJsb2NrcyBlbnRy
eQ0KbGlzdGVkIGJlbG93IGhhcyAiNTI4Mzc2IDMzIiBpbiB0aGUgcmVnaW9uLCB3aGljaCBzcGFu
cyBib3RoIG1ldGFkYXRhDQphbmQgZGF0YSBhcmVhcyAtLSA4IHNlY3RvcnMgaW4gdGhlIG1ldGFk
YXRhIGFuZCByZW1haW5pbmcgMjUgc2VjdG9ycyBpbg0KdGhlIGRhdGEuICBUaGUgdG90YWwgbnVt
YmVyIG9mIHNlY3RvcnMgbGlzdGVkIGFyZSA2MCwgd2hpbGUNCiJiYWRibG9ja19jb3VudCIgc2hv
d3MgNjguDQoNCiMgbmRjdGwgbGlzdCAtTSAtbiAwLjANCnsNCsKgICJkZXYiOiJuYW1lc3BhY2Uw
LjAiLA0KwqAgIm1vZGUiOiJkYXgiLA0KwqAgInNpemUiOjE2OTA5MzM2NTc2LA0KwqAgInV1aWQi
OiIyMTM1YmRiYS05YjY2LTRjNmUtYmE2MS0yYTZhYzRiYmQ3OGYiLA0KwqAgImJhZGJsb2NrX2Nv
dW50Ijo2OCwNCsKgICJiYWRibG9ja3MiOlsNCsKgwqDCoMKgew0KwqDCoMKgwqDCoMKgIm9mZnNl
dCI6MCwNCsKgwqDCoMKgwqDCoCJsZW5ndGgiOjI1DQrCoMKgwqDCoH0sDQrCoMKgwqDCoHsNCsKg
wqDCoMKgwqDCoCJvZmZzZXQiOjI4NjcyLA0KwqDCoMKgwqDCoMKgImxlbmd0aCI6MQ0KwqDCoMKg
wqB9LA0KwqDCoMKgwqB7DQrCoMKgwqDCoMKgwqAib2Zmc2V0Ijo1MjAxOTIsDQrCoMKgwqDCoMKg
wqAibGVuZ3RoIjozMw0KwqDCoMKgwqB9LA0KwqDCoMKgwqB7DQrCoMKgwqDCoMKgwqAib2Zmc2V0
IjoxMDQ0NDgwLA0KwqDCoMKgwqDCoMKgImxlbmd0aCI6MQ0KwqDCoMKgwqB9DQrCoCBdDQp9DQoN
ClRoYW5rcywNCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
