Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 173C821A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 09:12:17 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm: rework region badblocks clearing
Date: Mon, 1 May 2017 16:12:13 +0000
Message-ID: <1493655131.30303.17.camel@hpe.com>
References: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493652871.30303.15.camel@hpe.com>
 <CAPcyv4g4G_fJf6OOGpWbpyMdNioPWEFoJ2eO7+dSTcep+OerFw@mail.gmail.com>
 <CAPcyv4gxuez8BvtWwwcTXCKpzKp+oGQrRQG8+2iQ6XqRAfT_3g@mail.gmail.com>
In-Reply-To: <CAPcyv4gxuez8BvtWwwcTXCKpzKp+oGQrRQG8+2iQ6XqRAfT_3g@mail.gmail.com>
Content-Language: en-US
Content-ID: <E2A9F09B0D78024C86D0F9EAE6E67E73@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA1LTAxIGF0IDA4OjUyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgTWF5IDEsIDIwMTcgYXQgODo0MyBBTSwgRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jbw0KPiBtPiB3cm90ZToNCj4gPiBPbiBNb24sIE1heSAxLCAyMDE3IGF0IDg6
MzQgQU0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hpLmthbmlAaHBlLmNvDQo+ID4gbT4gd3JvdGU6
DQo+ID4gPiBPbiBTdW4sIDIwMTctMDQtMzAgYXQgMDU6MzkgLTA3MDAsIERhbiBXaWxsaWFtcyB3
cm90ZToNCiA6DQo+ID4gPiANCj4gPiA+IEhpIERhbiwNCj4gPiA+IA0KPiA+ID4gSSB3YXMgdGVz
dGluZyB0aGUgY2hhbmdlIHdpdGggQ09ORklHX0RFQlVHX0FUT01JQ19TTEVFUCBzZXQgdGhpcw0K
PiA+ID4gdGltZSwgYW5kIGhpdCB0aGUgZm9sbG93aW5nIEJVRyB3aXRoIEJUVC7CoMKgVGhpcyBp
cyBhIHNlcGFyYXRlDQo+ID4gPiBpc3N1ZSAobm90IGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaCks
IGJ1dCBpdCBzaG93cyB0aGF0IHdlIGhhdmUNCj4gPiA+IGFuIGlzc3VlIHdpdGggdGhlIERTTSBj
YWxsIHBhdGggYXMgd2VsbC4NCj4gPiANCj4gPiBBaCwgZ3JlYXQgZmluZCwgdGhhbmtzISBXZSBk
b24ndCBzZWUgdGhpcyBpbiB0aGUgdW5pdCB0ZXN0cyBiZWNhdXNlDQo+ID4gdGhlIG5maXRfdGVz
dCBpbmZyYXN0cnVjdHVyZSB0YWtlcyBubyBzbGVlcGluZyBhY3Rpb25zIGluIGl0cw0KPiA+IHNp
bXVsYXRlZCBEU00gcGF0aC4gT3V0c2lkZSBvZiBjb252ZXJ0aW5nIGJ0dCB0byB1c2Ugc2xlZXBp
bmcgbG9ja3MNCj4gPiBJJ20gbm90IHN1cmUgSSBzZWUgYSBwYXRoIGZvcndhcmQuIEkgd29uZGVy
IGhvdyBiYWQgdGhlIHBlcmZvcm1hbmNlDQo+ID4gaW1wYWN0IG9mIHRoYXQgd291bGQgYmU/IFBl
cmhhcHMgd2l0aCBvcHBvcnR1bmlzdGljIHNwaW5uaW5nIGl0DQo+ID4gd29uJ3QgYmUgc28gYmFk
LCBidXQgSSBkb24ndCBzZWUgYW5vdGhlciBjaG9pY2UuDQo+IA0KPiBJdCdzIHdvcnNlIHRoYW4g
dGhhdC4gUGFydCBvZiB0aGUgcGVyZm9ybWFuY2Ugb3B0aW1pemF0aW9uIG9mIEJUVCBJL08NCj4g
d2FzIHRvIGF2b2lkIGxvY2tpbmcgYWx0b2dldGhlciB3aGVuIHdlIGNvdWxkIHJlbHkgb24gYSBC
VFQgbGFuZQ0KPiBwZXJjcHUsIHNvIHRoYXQgd291bGQgYWxzbyBuZWVkIHRvIGJlIHJlbW92ZWQu
DQoNCkkgZG8gbm90IGhhdmUgYSBnb29kIGlkZWEgZWl0aGVyLCBidXQgSSdkIHJhdGhlciBkaXNh
YmxlIHRoaXMgY2xlYXJpbmcNCmluIHRoZSByZWd1bGFyIEJUVCB3cml0ZSBwYXRoIHRoYW4gYWRk
aW5nIHNsZWVwaW5nIGxvY2tzIHRvIEJUVC4gDQpDbGVhcmluZyBhIGJhZCBibG9jayBpbiB0aGUg
QlRUIHdyaXRlIHBhdGggaXMgZGlmZmljdWx0L2NoYWxsZW5naW5nDQpzaW5jZSBpdCBhbGxvY2F0
ZXMgYSBuZXcgYmxvY2suDQoNClRoYW5rcywNCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1udmRpbW0K
