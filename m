Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 261652194D395
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 09:48:09 -0700 (PDT)
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com
 [16.197.64.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2352.austin.hpe.com (Postfix) with ESMTPS id 68DAF4D
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 16:48:08 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4] ndctl: add clear error support for ndctl
Date: Tue, 2 May 2017 16:48:05 +0000
Message-ID: <1493743683.30303.38.camel@hpe.com>
References: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
 <1493684163.30303.36.camel@hpe.com>
 <dc1d6252-9c8c-5298-2823-2609db70ceb6@intel.com>
In-Reply-To: <dc1d6252-9c8c-5298-2823-2609db70ceb6@intel.com>
Content-Language: en-US
Content-ID: <0651885D28C07D4FAE2C0F22F01409FF@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVHVlLCAyMDE3LTA1LTAyIGF0IDA5OjE4IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMDEvMjAxNyAwNToxNiBQTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMTctMDUtMDEgYXQgMTY6MzMgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
wqA6DQo+ID4gPiArRVhBTVBMRVMNCj4gPiA+ICstLS0tLS0tLQ0KPiA+ID4gKw0KPiA+ID4gK0Ns
ZWFyIHBvaXNvbiAoYmFkIGJsb2NrcykgZm9yIHRoZSBwcm92aWRlZCBkZXZpY2UNCj4gPiA+ICtb
dmVyc2VdDQo+ID4gPiArbmRjdGwgY2xlYXItZXJyb3IgLWYgL2Rldi9kYXgwLjAgLXMgMCAtbCA4
DQo+ID4gPiArDQo+ID4gPiArQ2xlYXIgcG9pc29uIChiYWQgYmxvY2tzKSBhdCBibG9jayBvZmZz
ZXQgMCBmb3IgOCBibG9ja3Mgb24NCj4gPiA+IGRldmljZQ0KPiA+ID4gL2Rldi9kYXgwLjANCj4g
PiA+ICsNCj4gPiA+ICtPUFRJT05TDQo+ID4gPiArLS0tLS0tLQ0KPiA+ID4gKy1mOjoNCj4gPiA+
ICstLWZpbGU6Og0KPiA+ID4gK1RoZSBkZXZpY2UvZmlsZSB0byBiZSBjbGVhcmVkIG9mIHBvaXNv
biAoYmFkIGJsb2NrcykuDQo+ID4gPiArDQo+ID4gPiArLXM6Og0KPiA+ID4gKy0tc3RhcnQ6Og0K
PiA+ID4gK1RoZSBvZmZzZXQgd2hlcmUgdGhlIHBvaXNvbiAoYmFkIGJsb2NrKSBzdGFydHMgZm9y
IHRoaXMNCj4gPiA+IGRldmljZS4NCj4gPiA+ICtUeXBpY2FsbHkgdGhpcyBpcyBhY3F1aXJlZCBm
cm9tIHRoZSBzeXNmcyBiYWRibG9ja3MgZmlsZS4NCj4gPiA+ICsNCj4gPiA+ICstbDo6DQo+ID4g
PiArLS1sZW46Og0KPiA+ID4gK1RoZSBudW1iZXIgb2YgYmFkYmxvY2tzIHRvIGNsZWFyIGluIHNp
emUgb2YgNTEyIGJ5dGVzDQo+ID4gPiBpbmNyZW1lbnRzLiBUaGUNCj4gPiA+ICtsZW5ndGggbXVz
dCBmaXQgd2l0aGluIHRoZSBiYWRibG9ja3MgcmFuZ2UuIElmIHRoZSBsZW5ndGgNCj4gPiA+IGV4
Y2VlZHMgdGhlDQo+ID4gPiArYmFkYmxvY2sgcmFuZ2Ugb3IgaXMgMCwgdGhlIGNvbW1hbmQgd2ls
bCBmYWlsLg0KPiA+IA0KPiA+IEFjdHVhbGx5LCBJIGFtIHNlZWluZyAnLWwgMCcgd29ya3MganVz
dCBsaWtlICctbCAxJy4NCj4gDQo+IE9oIG5vdyBJIHJlbWVtYmVyZWQgdGhhdCBWaXNoYWwgcmVx
dWVzdGVkIHRoYXQgbm8gbGVuZ3RoIGRvZXMgMSBibG9jaw0KPiBjbGVhci4gRG8geW91IHdhbnQg
bWUgdG8gY29ycmVjdCBkb2N1bWVudGF0aW9uIG9yIGJlaGF2aW9yPw0KDQpXaGF0IGlzIHRoZSBy
ZWFzb24gYmVoaW5kIG9mIGhpcyByZXF1ZXN0Pw0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
