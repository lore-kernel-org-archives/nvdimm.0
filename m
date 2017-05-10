Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29EB721A0BAA8
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 07:50:18 -0700 (PDT)
Received: from G9W8455.americas.hpqcorp.net (g9w8455.houston.hp.com
 [16.216.161.94])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 6830E6B
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 14:50:16 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 2/2] ndctl: add list --media-errors support
Date: Wed, 10 May 2017 14:50:08 +0000
Message-ID: <1494427797.30303.75.camel@hpe.com>
References: <149437257526.67960.3751792583137095911.stgit@djiang5-desk3.ch.intel.com>
 <149437264268.67960.7347964981686229026.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149437264268.67960.7347964981686229026.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <9757ACFD2A240A4E89F338C689B3E50B@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVHVlLCAyMDE3LTA1LTA5IGF0IDE2OjMxIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGRpbmcgb3B0aW9uIGZvciBuZGN0bCBsaXN0IGNvbW1hbmQgdG8gc2hvdyBiYWRibG9ja3MgZm9y
IHJlZ2lvbiBhbmQNCj4gZGV2aWNlLiBUaGUgZGV2aWNlIGJhZGJsb2NrcyBhcmUgY2FsY3VsYXRl
ZCBmcm9tIHRoZSByZWdpb24NCj4gYmFkYmxvY2tzLg0KPiBUaGlzIGFsbG93cyB0aGUgdXNlciB0
byBwcm92aWRlIHRoZSBwcm9wZXIgYmFkYmxvY2sgb2Zmc2V0IGFuZCBsZW5ndGgNCj4gZm9yIGNs
ZWFyaW5nIGxhdGVyIG9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5q
aWFuZ0BpbnRlbC5jb20+DQoNCkhpIERhdmUsDQoNCkEgYmFkYmxvY2sgaW4gbWV0YWRhdGEgaXMg
c2hvd24gYXMgb2Zmc2V0IDAgd2l0aCBhIG5lZ2F0aXZlIGxlbmd0aC4gDQpQZXJoYXBzLCB5b3Ug
bWF5IHdhbnQgdG8gYWRkIG1vcmUgdGVzdCBjYXNlcy4NCg0KIyBjYXQgL3N5cy9idXMvbmQvZGV2
aWNlcy9yZWdpb24wL2JhZGJsb2Nrcw0KMjA0OCAxDQoxMDQ4NTc2IDENCjE1NzI4NjQgMQ0KDQoj
IG5kY3RsIGxpc3QgLS1tZWRpYS1lcnJvcnMgLS1tb2RlPWRheA0Kew0KwqAgImRldiI6Im5hbWVz
cGFjZTAuMCIsDQrCoCAibW9kZSI6ImRheCIsDQrCoCAic2l6ZSI6MTY5MDkzMzY1NzYsDQrCoCAi
dXVpZCI6IjhjNzE4MTFmLTI2MGQtNDc4OC04NDg3LWRiODhkODI5ZDM5MyIsDQrCoCAiYmFkYmxv
Y2tzIjpbDQrCoMKgwqDCoHsNCsKgwqDCoMKgwqDCoCJvZmZzZXQiOjAsDQrCoMKgwqDCoMKgwqAi
bGVuZ3RoIjotNTI2MzM1DQrCoMKgwqDCoH0sDQrCoMKgwqDCoHsNCsKgwqDCoMKgwqDCoCJvZmZz
ZXQiOjUyMDE5MiwNCsKgwqDCoMKgwqDCoCJsZW5ndGgiOjENCsKgwqDCoMKgfSwNCsKgwqDCoMKg
ew0KwqDCoMKgwqDCoMKgIm9mZnNldCI6MTA0NDQ4MCwNCsKgwqDCoMKgwqDCoCJsZW5ndGgiOjEN
CsKgwqDCoMKgfQ0KwqAgXQ0KfQ0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
