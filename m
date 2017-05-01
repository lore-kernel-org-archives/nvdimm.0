Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F3A921A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 14:12:21 -0700 (PDT)
Received: from G2W6310.americas.hpqcorp.net (g2w6310.austin.hp.com
 [16.197.64.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3426.houston.hpe.com (Postfix) with ESMTPS id ACCFC4F
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 21:12:20 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2] ndctl: add clear error support for ndctl
Date: Mon, 1 May 2017 21:12:18 +0000
Message-ID: <1493673137.30303.26.camel@hpe.com>
References: <149333241780.23371.243937948027874332.stgit@djiang5-desk3.ch.intel.com>
 <1493670342.30303.24.camel@hpe.com>
 <20170501210241.GA11607@djiang5-desk3.ch.intel.com>
In-Reply-To: <20170501210241.GA11607@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <670F6E44FA1D5C4C89D3C62010683428@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA1LTAxIGF0IDE0OjAyIC0wNzAwLCBKaWFuZywgRGF2ZSB3cm90ZToNCj4g
T24gTW9uLCBNYXkgMDEsIDIwMTcgYXQgMDE6MjU6NDVQTSAtMDcwMCwgS2FuaSwgVG9zaGltaXRz
dSB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMTctMDQtMjcgYXQgMTU6MzggLTA3MDAsIERhdmUgSmlh
bmcgd3JvdGU6DQogOg0KPiANCj4gVG9zaGksDQo+IENhbiB5b3UgcGxlYXNlIHRyeSB0aGlzIGFu
ZCBzZWUgaWYgdGhhdCBmaXhlcyB0aGUgaXNzdWU/IFRoYW5rcyENCj4gDQo+IGRpZmYgLS1naXQg
YS9uZGN0bC9saWIvbGlibmRjdGwuYyBiL25kY3RsL2xpYi9saWJuZGN0bC5jDQo+IGluZGV4IDcz
OTk3MjkuLjQ0ZmMyZjMgMTAwNjQ0DQo+IC0tLSBhL25kY3RsL2xpYi9saWJuZGN0bC5jDQo+ICsr
KyBiL25kY3RsL2xpYi9saWJuZGN0bC5jDQo+IEBAIC0xODgyLDEwICsxODgyLDggQEAgc3RhdGlj
IGludCByZWdpb25zX2JhZGJsb2Nrc19pbml0KHN0cnVjdA0KPiBuZGN0bF9yZWdpb24gKnJlZ2lv
bikNCj4gwqAJCXJlZ2lvbi0+YmFkYmxvY2tzID0gTlVMTDsNCj4gwqAJfQ0KPiDCoA0KPiAtCWlm
IChhc3ByaW50ZigmYmJfcGF0aCwNCj4gIi9zeXMvZGV2aWNlcy9wbGF0Zm9ybS8lcy8lcy8lcy9i
YWRibG9ja3MiLA0KPiAtCQkJCW5kY3RsX2J1c19nZXRfcHJvdmlkZXIoYnVzKSwNCj4gLQkJCQlu
ZGN0bF9idXNfZ2V0X2Rldm5hbWUoYnVzKSwNCj4gLQkJCQluZGN0bF9yZWdpb25fZ2V0X2Rldm5h
bWUocmVnaW9uKSkgPA0KPiAwKSB7DQo+ICsJaWYgKGFzcHJpbnRmKCZiYl9wYXRoLCAiJXMvYmFk
YmxvY2tzIiwNCj4gKwkJCQlyZWdpb24tPnJlZ2lvbl9wYXRoKSA8IDApIHsNCj4gwqAJCXJjID0g
LWVycm5vOw0KPiDCoAkJZXJyKGN0eCwgInJlZ2lvbiBiYWRibG9ja3MgcGF0aCBhbGxvY2F0aW9u
DQo+IGZhaWx1cmVcbiIpOw0KPiDCoAkJcmV0dXJuIHJjOw0KDQpZZXMsIHRoaXMgZml4ZXMgdGhl
IGlzc3VlLiA6LSkgIE5vdGljZWQgdGhhdCB0aGVyZSBpcyBhIHdhcm5pbmcuDQoNCsKgIENDwqDC
oMKgwqDCoMKgwqBsaWJuZGN0bC5sbw0KbGlibmRjdGwuYzogSW4gZnVuY3Rpb24gJ3JlZ2lvbnNf
YmFkYmxvY2tzX2luaXQnOg0KbGlibmRjdGwuYzoxODc1OjIwOiB3YXJuaW5nOiB1bnVzZWQgdmFy
aWFibGUgJ2J1cycgWy1XdW51c2VkLXZhcmlhYmxlXQ0KwqAgc3RydWN0IG5kY3RsX2J1cyAqYnVz
ID0gbmRjdGxfcmVnaW9uX2dldF9idXMocmVnaW9uKTsNCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBeDQpUaGFua3MhIQ0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
