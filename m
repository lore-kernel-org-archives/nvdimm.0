Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A414D21DF9680
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 11:18:59 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Date: Thu, 27 Jul 2017 18:20:33 +0000
Message-ID: <1501179065.2042.85.camel@hpe.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
 <20170726171101.GA15980@bombadil.infradead.org>
 <1501171371.2042.83.camel@hpe.com> <20170727180355.GB26633@linux.intel.com>
In-Reply-To: <20170727180355.GB26633@linux.intel.com>
Content-Language: en-US
Content-ID: <069D1B15F2FE834AADE7FD27526BC783@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA3LTI3IGF0IDEyOjAzIC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIFRodSwgSnVsIDI3LCAyMDE3IGF0IDA0OjEyOjE4UE0gKzAwMDAsIEthbmksIFRvc2hpbWl0
c3Ugd3JvdGU6DQo+ID4gT24gV2VkLCAyMDE3LTA3LTI2IGF0IDEwOjExIC0wNzAwLCBNYXR0aGV3
IFdpbGNveCB3cm90ZToNCj4gPiA+IE9uIFdlZCwgSnVsIDI2LCAyMDE3IGF0IDA2OjIzOjA4UE0g
KzA5MDAsIE9HQVdBIEhpcm9mdW1pIHdyb3RlOg0KPiA+ID4gPiBUaGUgbG9ja2luZyBvZiB0aGlz
IHBhdGggc2VlbXMgdG8gYmUgYnJva2VuLiBUaGUgZ3V5IGZhbWlsaWFyDQo+ID4gPiA+IHRvIGJk
ZXZfd3JpdGVfcGFnZSgpIHBhdGggd2lsbCBtYWRlIHJlYWwgZml4IHRob3VnaCwgVGhlDQo+ID4g
PiA+IGZvbGxvd2luZyBwYXRjaCBzaG91bGQgYmUgZXhwbGFpbmluZyBlbm91Z2ggd2hhdCBpcyB3
cm9uZy4NCj4gPiA+ID4gDQo+ID4gPiA+IEluIHNob3J0LCBjbGVhbl9idWZmZXJzKCkgbXVzdCBi
ZSBjYWxsZWQgYmVmb3JlIHVubG9ja2luZw0KPiA+ID4gPiBsb2NrX3BhZ2UoKS4NCj4gPiA+IA0K
PiA+ID4gVGhhbmtzIGZvciB0aGF0LsKgwqBUaGlzIHNob3VsZCBmaXggdGhlIHByb2JsZW0gd2hp
bGUgbm90IGxlYWtpbmcNCj4gPiA+IHRoZSB1bmxvY2tfcGFnZSBjYWxsIG91dHNpZGUgYmRldl93
cml0ZV9wYWdlLg0KPiA+ID4gDQo+ID4gPiAtLS0gODwgLS0tDQo+ID4gPiANCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IE1hdHRoZXcgV2lsY294IDxtYXdpbGNveEBtaWNyb3NvZnQuY29tPg0KPiA+IA0K
PiA+IFRoYW5rcyBXaWxseSBhbmQgSGlyb2Z1bWkgZm9yIHRoZSBxdWljayBmaXghwqDCoEkndmUg
dGVzdGVkIHRoZQ0KPiA+IGNoYW5nZSwgYW5kIGl0IHdvcmtzIGZpbmUuDQo+ID4gDQo+ID4gVGVz
dGVkLWJ5OiBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5jb20+DQo+ID4gDQo+ID4gT3V0IG9m
IGN1cmlvc2l0eSwgSSBhbSBzdGlsbCB3b25kZXJpbmcgYWJvdXQgdGhlIGZvbGxvd2luZzrCoA0K
PiA+IMKgLSBXaHkgaXMgdGhpcyBpc3N1ZSBleHBvc2VkIHdpdGggRkFUIEZTLCBidXQgbm90IHdp
dGggb3RoZXIgRlNzPw0KPiA+IMKgLSBXaHkgZGlkIEkgbm90IHNlZSB0aGlzIGlzc3VlIHdpdGgg
QlRUPw0KPiANCj4gSSBhbHNvIGRpZG4ndCBzZWUgaXQgd2l0aCBGQVQgKyBCUkQsIHNvIEkgdGhp
bmsgdGhlIGFuc3dlciB0byBib3RoIG9mDQo+IHRoZSBhYm92ZSBpcyBqdXN0IHRoYXQgdGhlIHRp
bWluZ3Mgd2VyZSBkaWZmZXJlbnQuDQoNClllYWgsIHRoYXQgbWF5IHdlbGwgYmUgdGhlIGNhc2Uu
ICBKdXN0IGEgdG91Z2ggbmF0dXJlIGZvciB0ZXN0aW5nLg0KDQpUaGFua3MhDQotVG9zaGkNCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGlt
bSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAx
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
