Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 524A42098EA8D
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 21:10:45 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1B4C7AC00C2
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 13:10:42 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 0/4] misc fixups for ndctl-monitor
Date: Fri, 20 Jul 2018 04:10:39 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA8CB80@g01jpexmbkw24>
References: <20180719225958.6814-1-vishal.l.verma@intel.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DA8C79D@g01jpexmbkw24>
 <aeac71e463836f82f5aa880e206b322d7b0a3dc8.camel@kernel.org>
In-Reply-To: <aeac71e463836f82f5aa880e206b322d7b0a3dc8.camel@kernel.org>
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
To: 'Vishal Verma' <vishal@kernel.org>, 'Vishal Verma' <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWaXNoYWwgVmVybWEgW21haWx0
bzp2aXNoYWxAa2VybmVsLm9yZ10NCj4gU2VudDogRnJpZGF5LCBKdWx5IDIwLCAyMDE4IDEyOjI2
IFBNDQo+IFRvOiBRaSwgRnVsaS/mlokg56aP5YipIDxxaS5mdWxpQGpwLmZ1aml0c3UuY29tPjsg
J1Zpc2hhbCBWZXJtYScNCj4gPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT47IGxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcNCj4gU3ViamVjdDogUmU6IFtuZGN0bCBQQVRDSCAwLzRdIG1pc2MgZml4
dXBzIGZvciBuZGN0bC1tb25pdG9yDQo+IA0KPiBPbiBUaHUsIDIwMTgtMDctMTkgYXQgMjM6NTkg
KzAwMDAsIFFpLCBGdWxpIHdyb3RlOg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gPiA+IEZyb206IFZpc2hhbCBWZXJtYSBbbWFpbHRvOnZpc2hhbC5sLnZlcm1hQGludGVsLmNv
bV0NCj4gPiA+IFNlbnQ6IEZyaWRheSwgSnVseSAyMCwgMjAxOCA4OjAwIEFNDQo+ID4gPiBUbzog
bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZw0KPiA+ID4gQ2M6IFFpLCBGdWxpL+aWiSDnpo/liKkg
PHFpLmZ1bGlAanAuZnVqaXRzdS5jb20+OyBWaXNoYWwgVmVybWENCj4gPiA+IDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBbbmRjdGwgUEFUQ0ggMC80XSBtaXNjIGZp
eHVwcyBmb3IgbmRjdGwtbW9uaXRvcg0KPiA+ID4NCj4gPiA+IEZpeCBhIGNvdXBsZSBvZiBpc3N1
ZXMgcmVwb3J0ZWQgYnkgc3RhdGljIGFuYWx5c2lzLCBpbXByb3ZlIHRoZQ0KPiA+ID4gZXJyb3Ig
cmVwb3J0aW5nLCBhbmQgYWRkIGEgbWlzc2luZyBvcHRpb24gdG8gdGhlIG1vbml0b3IgbWFuIHBh
Z2UNCj4gPiA+DQo+ID4gPiBWaXNoYWwgVmVybWEgKDQpOg0KPiA+ID4gICBuZGN0bCwgbW9uaXRv
cjogQWRkIGEgY29uZmlnLWZpbGUgc2VjdGlvbiB0byB0aGUgbWFuIHBhZ2UNCj4gPiA+ICAgbmRj
dGwsIG1vbml0b3I6IGZpeCBtZW1vcnkgbGVhayBpbiByZWFkX2NvbmZpZ19maWxlDQo+ID4gPiAg
IG5kY3RsLCBtb25pdG9yOiBGaXggbWVtb3J5IGxlYWsgaW4gbW9uaXRvcl9ldmVudA0KPiA+ID4g
ICBuZGN0bCwgbW9uaXRvcjogaW1wcm92ZSBlcnJvciByZXBvcnRpbmcgdGhyb3VnaG91dCBtb25p
dG9yLmMNCj4gPiA+DQo+ID4NCj4gPiBIaSBWaXNoYWwsDQo+ID4NCj4gPiBMb29rcyBnb29kIHRv
IG1lLg0KPiA+IFRoYW5rIHlvdSB2ZXJ5IG11Y2guDQo+IA0KPiBIaSBRaSwNCj4gDQo+IENhbiBJ
IGFkZCB5b3VyIFJldmlld2VkLWJ5IHRhZ3MgZm9yIHRoZSBzZXJpZXMgdGhlbj8NCj4gDQo+IFRo
YW5rcywNCj4gCS1WaXNoYWwNCj4gDQoNClllcywgcGxlYXNlLg0KDQpUaGFua3MsDQpRaQ0KDQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
