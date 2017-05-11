Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A06821A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 10:48:11 -0700 (PDT)
Received: from G4W9120.americas.hpqcorp.net (g4w9120.houston.hp.com
 [16.210.21.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 66ED54D
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 17:48:10 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v5 2/2] ndctl: add list --media-errors support
Date: Thu, 11 May 2017 17:48:07 +0000
Message-ID: <1494524875.30303.92.camel@hpe.com>
References: <149452421176.25868.9410889126303443053.stgit@djiang5-desk3.ch.intel.com>
 <149452423401.25868.12072221454250478213.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149452423401.25868.12072221454250478213.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <B12C2AAB00BFDC41A892F52EC16F795F@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE3LTA1LTExIGF0IDEwOjM3IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
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
ZXIgVG9zaGkncw0KPiBjb21tZW50cy4NCj4gdjU6IEFkZCBCVFQgYmFkYmxvY2tfY291bnQgZnJv
bSBUb3NoaSBhbmQgRGFuJ3MgY29tbWVudHMuDQoNClRoYW5rcyBEYXZlIGZvciB0aGUgcXVpY2sg
dXBkYXRlLiAgU29ycnksIGJ1dCBJIGV4cGVjdGVkDQoiYmFkYmxvY2tfY291bnQiIHRvIGJlIGEg
bnVtYmVyIG9mIGJhZGJsb2NrIHNlY3RvcnMsIG5vdCBhIG51bWJlciBvZg0KYmFkYmxvY2sgcmFu
Z2VzLg0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
