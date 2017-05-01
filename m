Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAF5B21A6F107
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 15:28:21 -0700 (PDT)
Received: from G4W9120.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.21.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 10CE254
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 22:28:21 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3] ndctl: add clear error support for ndctl
Date: Mon, 1 May 2017 22:28:18 +0000
Message-ID: <1493677696.30303.32.camel@hpe.com>
References: <149367376823.14721.16804310177322088175.stgit@djiang5-desk3.ch.intel.com>
 <1493676369.30303.30.camel@hpe.com>
 <ebf0cdd5-106c-9fb4-8272-589466423e9c@intel.com>
In-Reply-To: <ebf0cdd5-106c-9fb4-8272-589466423e9c@intel.com>
Content-Language: en-US
Content-ID: <41E34E477179A84C93239F918BCF704E@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gTW9uLCAyMDE3LTA1LTAxIGF0IDE1OjE2IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMDEvMjAxNyAwMzowNiBQTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMTctMDUtMDEgYXQgMTQ6MjMgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
wqA6DQo+ID4gPiArKysgYi9Eb2N1bWVudGF0aW9uL25kY3RsLWNsZWFyLWVycm9yLnR4dA0KPiA+
ID4gQEAgLTAsMCArMSwzNyBAQA0KPiA+ID4gK25kY3RsLWNsZWFyLWVycm9yKDEpDQo+ID4gPiAr
PT09PT09PT09PT09PT09PT09PT0NCj4gPiA+ICsNCj4gPiA+ICtOQU1FDQo+ID4gPiArLS0tLQ0K
PiA+ID4gK25kY3RsLWNsZWFyLWVycm9yIC0gY2xlYXIgYmFkYmxvY2tzIGZvciBhIGRldmljZQ0K
PiA+ID4gKw0KPiA+ID4gK1NZTk9QU0lTDQo+ID4gPiArLS0tLS0tLS0NCj4gPiA+ICtbdmVyc2Vd
DQo+ID4gPiArJ25kY3RsIGNsZWFyLWVycm9yJyBbPG9wdGlvbnM+XQ0KPiA+ID4gKw0KPiA+ID4g
K0VYQU1QTEVTDQo+ID4gPiArLS0tLS0tLS0NCj4gPiA+ICsNCj4gPiA+ICtDbGVhciBwb2lzb24g
KGJhZCBibG9ja3MpIGZvciB0aGUgcHJvdmlkZWQgZGV2aWNlDQo+ID4gPiArW3ZlcnNlXQ0KPiA+
ID4gK25kY3RsIGNsZWFyLWVycm9yIC1mIC9kZXYvZGF4MC4wIC1zIDAgLWwgOA0KPiA+ID4gKw0K
PiA+ID4gK0NsZWFyIHBvaXNvbiAoYmFkIGJsb2NrcykgYXQgYmxvY2sgb2Zmc2V0IDAgZm9yIDgg
YmxvY2tzIG9uDQo+ID4gPiBkZXZpY2UNCj4gPiA+IC9kZXYvZGF4MC4wDQo+ID4gPiArDQo+ID4g
PiArT1BUSU9OUw0KPiA+ID4gKy0tLS0tLS0NCj4gPiA+ICstZjo6DQo+ID4gPiArLS1maWxlOjoN
Cj4gPiA+ICtUaGUgZGV2aWNlL2ZpbGUgdG8gYmUgY2xlYXJlZCBvZiBwb2lzb24gKGJhZCBibG9j
a3MpLg0KPiA+ID4gKw0KPiA+ID4gKy1zOjoNCj4gPiA+ICstLXN0YXJ0OjoNCj4gPiA+ICtUaGUg
b2Zmc2V0IHdoZXJlIHRoZSBwb2lzb24gKGJhZCBibG9jaykgc3RhcnRzIGZvciB0aGlzDQo+ID4g
PiBkZXZpY2UuDQo+ID4gPiArVHlwaWNhbGx5IHRoaXMgaXMgYWNxdWlyZWQgZnJvbSB0aGUgc3lz
ZnMgYmFkYmxvY2tzIGZpbGUuDQo+ID4gPiArDQo+ID4gPiArLWw6Og0KPiA+ID4gKy0tbGVuOjoN
Cj4gPiA+ICtUaGUgbnVtYmVyIG9mIGJhZGJsb2NrcyB0byBjbGVhciBpbiBzaXplIG9mIDUxMiBi
eXRlcw0KPiA+ID4gaW5jcmVtZW50cy4NCj4gPiA+ICsNCj4gPiANCj4gPiBXaGVuIGEgc3BlY2lm
aWVkIHJhbmdlIGlzIGxhcmdlciB0aGFuIGEgYmFkYmxvY2sgcmFuZ2UsIHRoZSBjb21tYW5kDQo+
ID4gY29tcGxldGVzIHdpdGggbm8tb3Agd2l0aG91dCBhbnkgbWVzc2FnZS7CoMKgSSB0aGluayBp
dCBzaG91bGQgZWl0aGVyDQo+ID4gZmFpbCB3aXRoIGFuIGVycm9yIG1lc3NhZ2Ugb3IgY2xlYXIg
YW4gaW5jbHVzaXZlIGJhZGJsb2NrLg0KPiANCj4gSXQncyBzdXBwb3NlIHRvIGp1c3QgZmFpbC4g
TG9va3MgbGlrZSBJIGp1c3QgZm9yZ290IHRvIGluc2VydCBhbg0KPiBlcnJvciBwcmludCBvdXQu
DQoNClllcywgSSBhbSBmaW5lIHdpdGggdGhlIGJlaGF2aW9yIHdpdGggYSBwcm9wZXIgZXJyb3Ig
bWVzc2FnZS4gSXQnZCBiZQ0KZ29vZCB0byBjbGFyaWZ5IGl0IGluIHRoZSBkb2N1bWVudCBhcyB3
ZWxsLg0KDQpUaGFua3MsIA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
