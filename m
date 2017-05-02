Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 973F721A134A4
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 14:21:42 -0700 (PDT)
Received: from G9W8453.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.216.160.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2354.austin.hpe.com (Postfix) with ESMTPS id BCC0258
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 21:21:41 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v5] ndctl: add clear error support for ndctl
Date: Tue, 2 May 2017 21:21:37 +0000
Message-ID: <1493760092.30303.42.camel@hpe.com>
References: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jYsPCvp5_kgVvGxGy-YT84ADM2QdCRSwGh3kLB+pzeqQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jYsPCvp5_kgVvGxGy-YT84ADM2QdCRSwGh3kLB+pzeqQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <B482D0490FA8C245A212A5431FB44107@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVHVlLCAyMDE3LTA1LTAyIGF0IDEzOjU0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgTWF5IDIsIDIwMTcgYXQgMToyNiBQTSwgRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0Bp
bnRlbC5jb20+DQo+IHdyb3RlOg0KIDoNCj4gPiArcmVhZCBzZWN0b3IgbGVuIDwNCj4gPiAvc3lz
L2J1cy9wbGF0Zm9ybS9kZXZpY2VzL25maXRfdGVzdC4wLyRkZXYvJHJlZ2lvbi9iYWRibG9ja3MN
Cj4gPiArZWNobyAic2VjdG9yOiAkc2VjdG9yIGxlbjogJGxlbiINCj4gPiArDQo+ID4gKyMgY2xl
YXJpbmcgdXNpbmcgbmRjdGwNCj4gPiArJE5EQ1RMIGNsZWFyLWVycm9yIC1mIC9kZXYvJGNoYXJk
ZXYgLXMgJHNlY3RvciAtbCAkbGVuDQo+IA0KPiBPaywgc28gSSdtIGdsYWQgeW91IHdyb3RlIHRo
aXMgdGVzdCBpdCBoaWdobGlnaHRzIG9uZSBtaXNtYXRjaGVkDQo+IGFzc3VtcHRpb24uwqDCoFRo
ZSAibmRjdGwgY2xlYXItZXJyb3IiIG9wdGlvbnMgc2hvdWxkIGJlIGRldmljZS0NCj4gcmVsYXRp
dmUgInNlY3RvciIgb2Zmc2V0cyBub3QgcmVnaW9uIG9mZnNldHMuIFNvLCAibmRjdGwgY2xlYXIt
ZXJyb3INCj4gL2Rldi9kZXYwLjAgLXMgMCIgc2hvdWxkIGNsZWFyIGRldmljZS1kYXggaW5zdGFu
Y2Ugb2Zmc2V0IDAsIG5vdA0KPiByZWdpb24gb2Zmc2V0IDAgQSBkZXZpY2UtZGF4IGluc3RhbmNl
IHN0YXJ0cyBhdCBhbiBvZmZzZXQgZnJvbSB0aGUNCj4gbmFtZXNwYWNlLCBhbmQgdGhlIG5hbWVz
cGFjZSBtYXkgc3RhcnQgYW55d2hlcmUgd2l0aGluIGEgcmVnaW9uLiBTbw0KPiB0aGUgY2xlYXIt
ZXJyb3IgY29tbWFuZCBuZWVkcyB0byB0cmFuc2xhdGUgdGhhdCBkZXZpY2UtZGF4IHNlY3Rvcg0K
PiBvZmZzZXQgdG8gdGhlIHJlZ2lvbiBvZmZzZXQuIGRldmljZS1kYXggb2Zmc2V0IHRvIG5hbWVz
cGFjZSBvZmZzZXQNCj4gY2FuIGJlIGNhbGN1bGF0ZWQgYnkgc3VidHJhY3RpbmcgdGhlIGRldmlj
ZS1kYXggaW5zdGFuY2Ugc2l6ZSBmcm9tDQo+IHRoZSBuYW1lc3BhY2Ugc2l6ZSwgdGhlIG5hbWVz
cGFjZSBvZmZzZXQgY2FuIGJlIGNhbGN1bGF0ZWQgYnkNCj4gc3VidHJhY3RpbmcgdGhlIHJlZ2lv
biByZXNvdXJjZSBiYXNlIGZyb20gdGhlIG5hbWVzcGFjZSByZXNvdXJjZQ0KPiBiYXNlLiBOb3cs
IHRoZSBkaWZmaWN1bHR5IHdpbGwgYmUgdGhhdCB0aGUgcmVzb3VyY2UgdmFsdWVzIGZvcg0KPiBu
Zml0X3Rlc3QgYXJlIGdhcmJhZ2UgYmVjYXVzZSB0aGV5IGFyZSB2bWFsbG9jJ2QgYmFzZWQsIEkg
bmVlZCB0bw0KPiBnaXZlIHRoYXQgc29tZSB0aG91Z2h0Li4uDQoNClVzaW5nIGRldmljZS1yZWxh
dGl2ZSBzZWN0b3IgbWFrZXMgc2Vuc2UsIGJ1dCBob3cgZG9lcyB1c2VyIGNvbWUgdXANCndpdGgg
dGhpcyBzZWN0b3IgbnVtYmVyIHdoZW4gc3lzZnMgb25seSBwcm92aWRlcyByZWdpb25OL2JhZGJs
b2Nrcz8NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
