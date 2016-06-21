From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 15:44:54 +0000
Message-ID: <1466523280.3504.262.camel@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com> <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com> <20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com> <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com> <20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160621134147.GA26392-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <3237E4E187B56D43BE612A6598212E91-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCAyMDE2LTA2LTIxIGF0IDA5OjQxIC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIE1vbiwgSnVuIDIwIDIwMTYgYXTCoMKgNjoyMnBtIC0wNDAwLA0KPiBNaWtlIFNuaXR6ZXIg
PHNuaXR6ZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCBKdW4gMjAgMjAx
NiBhdMKgwqA1OjI4cG0gLTA0MDAsDQo+ID4gS2FuaSwgVG9zaGltaXRzdSA8dG9zaGkua2FuaUBo
cGUuY29tPiB3cm90ZToNCj4gPiANCsKgOg0KPiA+IExvb2tzIGdvb2QsIEkgZm9sZGVkIGl0IGlu
IGFuZCB0ZXN0ZWQgaXQgdG8gd29yay7CoMKgUHVzaGVkIHRvIG15ICd3aXAnDQo+ID4gYnJhbmNo
Lg0KPiA+IA0KPiA+IE5vIGxvbmdlciBzZWVpbmcgYW55IGNvcnJ1cHRpb24gaW4gbXkgdGVzdCB0
aGF0IHdhcyB1c2luZyBwYXJ0aXRpb25zIHRvDQo+ID4gc3BhbiBwbWVtIGRldmljZXMgd2l0aCBh
IGRtLWxpbmVhciBkZXZpY2UuDQo+ID4gDQo+ID4gSmVucywgYW55IGNoYW5jZSB5b3UnZCBiZSBv
cGVuIHRvIHBpY2tpbmcgdXAgdGhlIGZpcnN0IDIgcGF0Y2hlcyBpbiB0aGlzDQo+ID4gc2VyaWVz
P8KgwqBPciB3b3VsZCB5b3UgbGlrZSB0byBzZWUgdGhlbSBmb2xkZWQgb3Igc29tZXRoaW5nIGRp
ZmZlcmVudD8NCj4NCj4gSSdtIG5vdyB3b25kZXJpbmcgaWYgd2UnZCBiZSBiZXR0ZXIgb2ZmIHNl
dHRpbmcgYSBuZXcgUVVFVUVfRkxBR19EQVgNCj4gcmF0aGVyIHRoYW4gZXN0YWJsaXNoIEdFTkhE
X0ZMX0RBWCBvbiB0aGUgZ2VuaGQ/DQo+IA0KPiBJdCdkIGJlIHF1aXRlIGEgYml0IGVhc2llciB0
byBhbGxvdyB1cHBlciBsYXllcnMgKGUuZy4gWEZTIGFuZCBleHQ0KSB0bw0KPiBjaGVjayBmb3Ig
YSBxdWV1ZSBmbGFnLg0KDQpJIHRoaW5rIEdFTkhEX0ZMX0RBWCBpcyBtb3JlIGFwcHJvcHJpYXRl
IHNpbmNlIERBWCBkb2VzIG5vdCB1c2UgYSByZXF1ZXN0DQpxdWV1ZSwgZXhjZXB0IGZvciBwcm90
ZWN0aW5nIHRoZSB1bmRlcmxpbmluZyBkZXZpY2UgYmVpbmcgZGlzYWJsZWQgd2hpbGUNCmRpcmVj
dF9hY2Nlc3MoKSBpcyBjYWxsZWQgKGIyZTBkMTYyNWUxOSkuIMKgDQoNCkFib3V0IHByb3RlY3Rp
bmcgZGlyZWN0X2FjY2VzcywgdGhpcyBwYXRjaCBhc3N1bWVzIHRoYXQgdGhlIHVuZGVybGluaW5n
DQpkZXZpY2UgY2Fubm90IGJlIGRpc2FibGVkIHVudGlsIGR0cigpIGlzIGNhbGxlZC4gwqBJcyB0
aGlzIGNvcnJlY3Q/IMKgSWYgbm90LA0KSSB3aWxsIG5lZWQgdG8gY2FsbMKgZGF4X21hcF9hdG9t
aWMoKS4NCg0KVGhhbmtzLA0KLVRvc2hpwqAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
