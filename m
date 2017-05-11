Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 346CC21A04E19
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 12:57:25 -0700 (PDT)
Received: from G9W8456.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.216.161.95])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 6CE8C6C
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 19:57:24 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v7] ndctl: add list --media-errors support
Date: Thu, 11 May 2017 19:57:14 +0000
Message-ID: <1494532622.30303.97.camel@hpe.com>
References: <149453182672.35117.780578492054325470.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149453182672.35117.780578492054325470.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <60A2E4090D3E9F4781BE96F0287241C4@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE3LTA1LTExIGF0IDEyOjQ0IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
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
b3RhbCBudW1iZXIgb2YgYmJzIGFuZCBub3QgcmFuZ2UgcGVyDQo+IFRvc2hpLg0KPiB2NzogRml4
IGRldmljZXMgc2hvdyBhY3R1YWwgYmFkYmxvY2tzIGNvdW50IGluc3RlYWQgb2YgcmVnaW9uIGNv
dW50DQo+IHBlciBUb3NoaS4NCg0KVGhpcyB3b3JrcyBncmVhdC4gOi0pICBUaGFua3MgZm9yIGJl
YXJpbmcgd2l0aCBtZS4gIEZvciB0aGUgc2VyaWVzOg0KDQpUZXN0ZWQtYnk6IFRvc2hpIEthbmkg
PHRvc2hpLmthbmlAaHBlLmNvbT4NCg0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
