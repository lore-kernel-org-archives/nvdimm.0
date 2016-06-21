From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 15:50:40 +0000
Message-ID: <1466523627.3504.266.camel@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com> <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com> <20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com> <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com> <20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com> <1466523280.3504.262.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466523280.3504.262.camel-ZPxbGqLxI0U@public.gmane.org>
Content-Language: en-US
Content-ID: <95537004090EDC409B06CD3DF3C92A4D-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
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

T24gVHVlLCAyMDE2LTA2LTIxIGF0IDA5OjM0IC0wNjAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3Rl
Og0KPiBPbiBUdWUsIDIwMTYtMDYtMjEgYXQgMDk6NDEgLTA0MDAsIE1pa2UgU25pdHplciB3cm90
ZToNCj4gPiANCj4gPiBPbiBNb24sIEp1biAyMCAyMDE2IGF0wqDCoDY6MjJwbSAtMDQwMCwNCj4g
PiBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4gPiANCj4gPiA+
IE9uIE1vbiwgSnVuIDIwIDIwMTYgYXTCoMKgNToyOHBtIC0wNDAwLA0KPiA+ID4gS2FuaSwgVG9z
aGltaXRzdSA8dG9zaGkua2FuaUBocGUuY29tPiB3cm90ZToNCj4gPiA+IA0KPiDCoDoNCj4gPiA+
IA0KPiA+ID4gTG9va3MgZ29vZCwgSSBmb2xkZWQgaXQgaW4gYW5kIHRlc3RlZCBpdCB0byB3b3Jr
LsKgwqBQdXNoZWQgdG8gbXkgJ3dpcCcNCj4gPiA+IGJyYW5jaC4NCj4gPiA+IA0KPiA+ID4gTm8g
bG9uZ2VyIHNlZWluZyBhbnkgY29ycnVwdGlvbiBpbiBteSB0ZXN0IHRoYXQgd2FzIHVzaW5nIHBh
cnRpdGlvbnMNCj4gPiA+IHRvIHNwYW4gcG1lbSBkZXZpY2VzIHdpdGggYSBkbS1saW5lYXIgZGV2
aWNlLg0KPiA+ID4gDQo+ID4gPiBKZW5zLCBhbnkgY2hhbmNlIHlvdSdkIGJlIG9wZW4gdG8gcGlj
a2luZyB1cCB0aGUgZmlyc3QgMiBwYXRjaGVzIGluDQo+ID4gPiB0aGlzIHNlcmllcz/CoMKgT3Ig
d291bGQgeW91IGxpa2UgdG8gc2VlIHRoZW0gZm9sZGVkIG9yIHNvbWV0aGluZw0KPiA+ID4gZGlm
ZmVyZW50Pw0KPiA+DQo+ID4gSSdtIG5vdyB3b25kZXJpbmcgaWYgd2UnZCBiZSBiZXR0ZXIgb2Zm
IHNldHRpbmcgYSBuZXcgUVVFVUVfRkxBR19EQVgNCj4gPiByYXRoZXIgdGhhbiBlc3RhYmxpc2gg
R0VOSERfRkxfREFYIG9uIHRoZSBnZW5oZD8NCj4gPiANCj4gPiBJdCdkIGJlIHF1aXRlIGEgYml0
IGVhc2llciB0byBhbGxvdyB1cHBlciBsYXllcnMgKGUuZy4gWEZTIGFuZCBleHQ0KSB0bw0KPiA+
IGNoZWNrIGZvciBhIHF1ZXVlIGZsYWcuDQo+DQo+IEkgdGhpbmsgR0VOSERfRkxfREFYIGlzIG1v
cmUgYXBwcm9wcmlhdGUgc2luY2UgREFYIGRvZXMgbm90IHVzZSBhIHJlcXVlc3QNCj4gcXVldWUs
IGV4Y2VwdCBmb3IgcHJvdGVjdGluZyB0aGUgdW5kZXJsaW5pbmcgZGV2aWNlIGJlaW5nIGRpc2Fi
bGVkIHdoaWxlDQo+IGRpcmVjdF9hY2Nlc3MoKSBpcyBjYWxsZWQgKGIyZTBkMTYyNWUxOSkuIMKg
DQoNCkZvcmdvdCB0byBtZW50aW9uIHRoYXQgdGhlcmUgYXJlIGJkZXZfZGF4X3N1cHBvcnRlZCgp
IGFuZCBiZGV2X2RheF9jYXBhYmxlKCkNCmludGVyZmFjZXMgdGhhdCBjYW4gYmUgY2FsbGVkIGZy
b20gdXBwZXIgbGF5ZXJzLsKgwqBUaGV5IGJvdGggY2FsbA0KYmRldl9kaXJlY3RfYWNjZXNzKCkg
d2hpY2ggY2hlY2tzIEdFTkhEX0ZMX0RBWC4NCg0KVGhhbmtzLA0KLVRvc2hpDQoNCj4gQWJvdXQg
cHJvdGVjdGluZyBkaXJlY3RfYWNjZXNzLCB0aGlzIHBhdGNoIGFzc3VtZXMgdGhhdCB0aGUgdW5k
ZXJsaW5pbmcNCj4gZGV2aWNlIGNhbm5vdCBiZSBkaXNhYmxlZCB1bnRpbCBkdHIoKSBpcyBjYWxs
ZWQuIMKgSXMgdGhpcyBjb3JyZWN0PyDCoElmDQo+IG5vdCwgSSB3aWxsIG5lZWQgdG8gY2FsbMKg
ZGF4X21hcF9hdG9taWMoKS4NCj4gDQo+IFRoYW5rcywNCj4gLVRvc2hpwqAKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
