Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC05421ECCB33
 for <linux-nvdimm@lists.01.org>; Wed, 20 Sep 2017 14:01:06 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Date: Wed, 20 Sep 2017 21:04:09 +0000
Message-ID: <1505940825.29771.55.camel@hpe.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
 <20170726171101.GA15980@bombadil.infradead.org>
 <1501171371.2042.83.camel@hpe.com>
In-Reply-To: <1501171371.2042.83.camel@hpe.com>
Content-Language: en-US
Content-ID: <9817329D93C520438633661D3D8FFB15@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE3LTA3LTI3IGF0IDE2OjEyICswMDAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3Rl
Og0KPiBPbiBXZWQsIDIwMTctMDctMjYgYXQgMTA6MTEgLTA3MDAsIE1hdHRoZXcgV2lsY294IHdy
b3RlOg0KPiA+IE9uIFdlZCwgSnVsIDI2LCAyMDE3IGF0IDA2OjIzOjA4UE0gKzA5MDAsIE9HQVdB
IEhpcm9mdW1pIHdyb3RlOg0KPiA+ID4gVGhlIGxvY2tpbmcgb2YgdGhpcyBwYXRoIHNlZW1zIHRv
IGJlIGJyb2tlbi4gVGhlIGd1eSBmYW1pbGlhciB0bw0KPiA+ID4gYmRldl93cml0ZV9wYWdlKCkg
cGF0aCB3aWxsIG1hZGUgcmVhbCBmaXggdGhvdWdoLCBUaGUgZm9sbG93aW5nDQo+ID4gPiBwYXRj
aCBzaG91bGQgYmUgZXhwbGFpbmluZyBlbm91Z2ggd2hhdCBpcyB3cm9uZy4NCj4gPiA+IA0KPiA+
ID4gSW4gc2hvcnQsIGNsZWFuX2J1ZmZlcnMoKSBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgdW5sb2Nr
aW5nDQo+ID4gPiBsb2NrX3BhZ2UoKS4NCj4gPiANCj4gPiBUaGFua3MgZm9yIHRoYXQuwqDCoFRo
aXMgc2hvdWxkIGZpeCB0aGUgcHJvYmxlbSB3aGlsZSBub3QgbGVha2luZyB0aGUNCj4gPiB1bmxv
Y2tfcGFnZSBjYWxsIG91dHNpZGUgYmRldl93cml0ZV9wYWdlLg0KPiA+IA0KPiA+IC0tLSA4PCAt
LS0NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IFdpbGNveCA8bWF3aWxjb3hAbWlj
cm9zb2Z0LmNvbT4NCj4gDQo+IFRoYW5rcyBXaWxseSBhbmQgSGlyb2Z1bWkgZm9yIHRoZSBxdWlj
ayBmaXghICBJJ3ZlIHRlc3RlZCB0aGUgY2hhbmdlLA0KPiBhbmQgaXQgd29ya3MgZmluZS4NCj4g
DQo+IFRlc3RlZC1ieTogVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPg0KDQpTaW5jZSBy
ZW1vdmluZyByd19wYWdlIHdvdWxkIGhhdmUgdG8gd2FpdCB0aWxsIDQuMTUsIGNhbiB3ZSBnbyB3
aXRoIHRoaXMNCmZpeCBmb3IgNC4xND8gIEkgY29uZmlybWVkIHRoYXQgTWF0dGhldydzIHBhdGNo
IFsxXSBhcHBsaWVzIGNsZWFubHkgdG8NCjQuMTQtcmMxLiAgVGhpcyBwYXRjaCBjYW4gYWxzbyBi
ZSBhcHBsaWVkIHRvIHN0YWJsZSBrZXJuZWxzLg0KDQpNYXR0aGV3LCBjYW4geW91IHJlc2VuZCB0
aGlzIHBhdGNoIHdpdGggZGVzY3JpcHRpb24/DQoNClsxXSBodHRwczovL3d3dy5zcGluaWNzLm5l
dC9saXN0cy9saW51eC1mc2RldmVsL21zZzExMzgzNS5odG1sDQoNClRoYW5rcywNCi1Ub3NoaQ0K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
