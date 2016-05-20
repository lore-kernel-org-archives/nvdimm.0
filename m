Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bon0725.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc10::1:725])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 505641A1E30
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 10:50:01 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 0/6] Add alignment check for DAX mount
Date: Fri, 20 May 2016 17:49:51 +0000
Message-ID: <1463766042.32042.34.camel@hpe.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <f265e4ce-9271-1d83-35bc-794f2e2129df@sandeen.net>
 <1463755257.32042.15.camel@hpe.com> <1463765696.3005.2.camel@intel.com>
In-Reply-To: <1463765696.3005.2.camel@intel.com>
Content-Language: en-US
Content-ID: <7C0572B86745F0408E89AD7E9B9D7224@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.cz" <jack@suse.cz>, "david@fromorbit.com" <david@fromorbit.com>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Parrish, Micah \\ linux-block@vger.kernel.org (HP Servers Linux R&D)\" <micah.parrish@hpe.com>,)" <linux-block@vger.kernel.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTA1LTIwIGF0IDE3OjM0ICswMDAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
DQo+IE9uIEZyaSwgMjAxNi0wNS0yMCBhdCAxNDo1MCArMDAwMCwgS2FuaSwgVG9zaGltaXRzdSB3
cm90ZToNCj4gPiBPbiBUaHUsIDIwMTYtMDUtMTkgYXQgMTg6MzcgLTA1MDAsIEVyaWMgU2FuZGVl
biB3cm90ZToNCj4gPiA+IE9uIDUvMTAvMTYgMTE6MjMgQU0sIFRvc2hpIEthbmkgd3JvdGU6DQo+
ID4gPiA+wqANCj4gPiA+ID4gV2hlbiBhIHBhcnRpdGlvbiBpcyBub3QgYWxpZ25lZCBieSA0S0Is
IG1vdW50IC1vIGRheCBzdWNjZWVkcywNCj4gPiA+DQo+ID4gPiBTb3JyeSBmb3IgYmVpbmcgbGF0
ZSwgYnV0IC0NCj4gPiA+IA0KPiA+ID4gU2hvdWxkbid0IHRoaXMgYW5kIGFsbCBzdWJzZXF1ZW50
IHBhdGNoIGNvbW1pdHMgcmVmZXIgdG8NCj4gPiA+IFBBR0VfU0laRSwgcmF0aGVyIHRoYW4gIjRr
Qj8iDQo+ID4NCj4gPiBSaWdodCwgdGhlIHBhdGNoIGNvbW1pdHMgc2hvdWxkIHJlZmVyIHRvIFBB
R0VfU0laRSB0byBtYXRjaCB3aXRoIHRoZQ0KPiA+IGNvZGUgY2hhbmdlcy7CoMKgSSBhbSBhZnJh
aWQgaXQgbWF5IGJlIGEgYml0IHRvbyBsYXRlIHRvIHVwZGF0ZSwNCj4gPiB0aG91Z2guLi4NCj4g
PiANCj4gPiBWaXNoYWwsIGRvIHlvdSB0aGluayB5b3UgY2FuIHR3ZWFrIHRoZSBsb2dzLCAiNEtC
IiB0byAiUEFHRV9TSVpFIj8NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gLVRvc2hpDQo+DQo+IEhp
IFRvc2hpLA0KPiANCj4gSXMgaXQganVzdCBjb21taXQgbWVzc2FnZSBjaGFuZ2VzPyBJZiBzbyBJ
J20gbm90IHN1cmUgaXQgaXMgd29ydGh3aGlsZQ0KPiB0byByZWJhc2UgZXZlcnl0aGluZyBmb3Ig
dGhhdCAtIGkuZS4gbXkgZGF4IGVycm9yIGhhbmRsaW5nIHNlcmllcyBhbmQNCj4gUm9zcycgZGF4
LWxvY2tpbmcgYnJhbmNoIHdvdWxkIGJvdGggaGF2ZSB0byBiZSByZWJhc2VkLi4NCj4gDQo+IElm
IHRoZXJlIGFyZSBhbmQgZml4ZXMgZm9yIGNvZGUsIHdlIGNhbiBkbyB0aGVtIGFzIGFuIGFkZC1v
biBwYXRjaA0KPiB0aG91Z2guDQoNCkhpIFZpc2hhbCwNCg0KWWVzLCBpdCBpcyBqdXN0IGNvbW1p
dCBtZXNzYWdlcywgYW5kIGl0J3MgT0sgbm90IHRvIG1ha2UgdGhpcyBjaGFuZ2UuDQoNClRoYW5r
cywNCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0
cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
