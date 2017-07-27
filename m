Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 763A321D491AB
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 09:10:24 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Date: Thu, 27 Jul 2017 16:12:18 +0000
Message-ID: <1501171371.2042.83.camel@hpe.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
 <20170726171101.GA15980@bombadil.infradead.org>
In-Reply-To: <20170726171101.GA15980@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <18D462E7FD1C964D81AA91720D1B3825@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>, "willy@infradead.org" <willy@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA3LTI2IGF0IDEwOjExIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gT24gV2VkLCBKdWwgMjYsIDIwMTcgYXQgMDY6MjM6MDhQTSArMDkwMCwgT0dBV0EgSGlyb2Z1
bWkgd3JvdGU6DQo+ID4gVGhlIGxvY2tpbmcgb2YgdGhpcyBwYXRoIHNlZW1zIHRvIGJlIGJyb2tl
bi4gVGhlIGd1eSBmYW1pbGlhciB0bw0KPiA+IGJkZXZfd3JpdGVfcGFnZSgpIHBhdGggd2lsbCBt
YWRlIHJlYWwgZml4IHRob3VnaCwgVGhlIGZvbGxvd2luZw0KPiA+IHBhdGNoIHNob3VsZCBiZSBl
eHBsYWluaW5nIGVub3VnaCB3aGF0IGlzIHdyb25nLg0KPiA+IA0KPiA+IEluIHNob3J0LCBjbGVh
bl9idWZmZXJzKCkgbXVzdCBiZSBjYWxsZWQgYmVmb3JlIHVubG9ja2luZw0KPiA+IGxvY2tfcGFn
ZSgpLg0KPiANCj4gVGhhbmtzIGZvciB0aGF0LsKgwqBUaGlzIHNob3VsZCBmaXggdGhlIHByb2Js
ZW0gd2hpbGUgbm90IGxlYWtpbmcgdGhlDQo+IHVubG9ja19wYWdlIGNhbGwgb3V0c2lkZSBiZGV2
X3dyaXRlX3BhZ2UuDQo+IA0KPiAtLS0gODwgLS0tDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXR0
aGV3IFdpbGNveCA8bWF3aWxjb3hAbWljcm9zb2Z0LmNvbT4NCg0KVGhhbmtzIFdpbGx5IGFuZCBI
aXJvZnVtaSBmb3IgdGhlIHF1aWNrIGZpeCEgIEkndmUgdGVzdGVkIHRoZSBjaGFuZ2UsDQphbmQg
aXQgd29ya3MgZmluZS4NCg0KVGVzdGVkLWJ5OiBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5j
b20+DQoNCk91dCBvZiBjdXJpb3NpdHksIEkgYW0gc3RpbGwgd29uZGVyaW5nIGFib3V0IHRoZSBm
b2xsb3dpbmc6wqANCiAtIFdoeSBpcyB0aGlzIGlzc3VlIGV4cG9zZWQgd2l0aCBGQVQgRlMsIGJ1
dCBub3Qgd2l0aCBvdGhlciBGU3M/DQogLSBXaHkgZGlkIEkgbm90IHNlZSB0aGlzIGlzc3VlIHdp
dGggQlRUPw0KDQpUaGFua3MsDQotVG9zaGkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4
LW52ZGltbQo=
