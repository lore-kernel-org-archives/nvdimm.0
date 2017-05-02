Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D7C621A13484
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 11:57:20 -0700 (PDT)
Received: from G2W6310.americas.hpqcorp.net (g2w6310.austin.hp.com
 [16.197.64.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5008.houston.hpe.com (Postfix) with ESMTPS id A43664C
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 18:57:19 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4] ndctl: add clear error support for ndctl
Date: Tue, 2 May 2017 18:57:16 +0000
Message-ID: <1493751433.30303.40.camel@hpe.com>
References: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
 <1493684163.30303.36.camel@hpe.com>
 <dc1d6252-9c8c-5298-2823-2609db70ceb6@intel.com>
 <1493743683.30303.38.camel@hpe.com>
 <20170502184309.GA11414@omniknight.lm.intel.com>
In-Reply-To: <20170502184309.GA11414@omniknight.lm.intel.com>
Content-Language: en-US
Content-ID: <F5403E1CC42247468B2F7952726AF2E0@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE3LTA1LTAyIGF0IDEyOjQzIC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IE9uIDA1LzAyLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAxNy0wNS0w
MiBhdCAwOToxOCAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gPiA+ID4gKy1sOjoNCj4gPiA+
ID4gPiArLS1sZW46Og0KPiA+ID4gPiA+ICtUaGUgbnVtYmVyIG9mIGJhZGJsb2NrcyB0byBjbGVh
ciBpbiBzaXplIG9mIDUxMiBieXRlcw0KPiA+ID4gPiA+IGluY3JlbWVudHMuIFRoZQ0KPiA+ID4g
PiA+ICtsZW5ndGggbXVzdCBmaXQgd2l0aGluIHRoZSBiYWRibG9ja3MgcmFuZ2UuIElmIHRoZSBs
ZW5ndGgNCj4gPiA+ID4gPiBleGNlZWRzIHRoZQ0KPiA+ID4gPiA+ICtiYWRibG9jayByYW5nZSBv
ciBpcyAwLCB0aGUgY29tbWFuZCB3aWxsIGZhaWwuDQo+ID4gPiA+IA0KPiA+ID4gPiBBY3R1YWxs
eSwgSSBhbSBzZWVpbmcgJy1sIDAnIHdvcmtzIGp1c3QgbGlrZSAnLWwgMScuDQo+ID4gPiANCj4g
PiA+IE9oIG5vdyBJIHJlbWVtYmVyZWQgdGhhdCBWaXNoYWwgcmVxdWVzdGVkIHRoYXQgbm8gbGVu
Z3RoIGRvZXMgMQ0KPiA+ID4gYmxvY2sgY2xlYXIuIERvIHlvdSB3YW50IG1lIHRvIGNvcnJlY3Qg
ZG9jdW1lbnRhdGlvbiBvciBiZWhhdmlvcj8NCj4gPiANCj4gPiBXaGF0IGlzIHRoZSByZWFzb24g
YmVoaW5kIG9mIGhpcyByZXF1ZXN0Pw0KPiANCj4gQWgsIHNvIG15IGludGVudGlvbi9yZWFzb25p
bmcgd2FzIGlmIHNvbWVvbmUgZG9lcyBhIHNpbXBsZToNCj4gwqAgbmRjdGwgY2xlYXItZXJyb3Ig
LXMgJ1gnDQo+IHdpdGhvdXQgcHJvdmlkaW5nIGEgLWwgYXJndW1lbnQsIGl0IHNob3VsZCBkaW1w
bHkgY2xlYXIgdGhhdCBvbmUNCj4gYmxvY2suIEhvd2V2ZXIgSSB3b3VsZG4ndCB0aGluayAtbDAg
c2hvdWxkIGNsZWFyIG9uZSBibG9jaywgd2Ugc2hvdWxkDQo+IGVpdGhlciBlcnJvciBvdXQsIG9y
IHRyZWF0IGl0IGFzIGEgZHJ5LXJ1biAocGVyaGFwcyB0aGlzIGNvdWxkIGJlIGFuDQo+IGluZGly
ZWN0IHdheSB0byBjaGVjayBpZiBhIGNlcnRhaW4gYmxvY2sgaXMgaW4gdGhlIGJhZGJsb2NrcyBs
aXN0PykNCj4gDQo+IEFueXdheSwgSSdtIG5vdCB0b28gYXR0YWNoZWQgdG8gdGhlICJzaG91bGQg
d29yayB3aXRob3V0IHByb3ZpZGluZyBhDQo+IC1sIiB0aGluZywgYW5kIHdlIGNhbiBtYWtlIC1s
IG1hbmRhdG9yeSBhZ2FpbiBpZiB0aGF0IG1ha2VzIG1vc3QNCj4gc2Vuc2UuDQoNClRoYW5rcyBm
b3IgdGhlIGNsYXJpZmljYXRpb24uICBUaGF0IG1ha2VzIHNlbnNlLiAgSSBkbyBub3QgaGF2ZSBh
DQpzdHJvbmcgb3BpbmlvbsKgYW5kIGFtIGZpbmUgd2l0aCBlaXRoZXIgd2F5IFZpc2hhbCBwcm9w
b3NlZCBoZXJlLiAgSQ0KanVzdCBkaWQgbm90IGZlZWwgcmlnaHQgdG8gY2xlYXIgd2l0aCAtbCAw
Lg0KDQotVG9zaGkNCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
