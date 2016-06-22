From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Wed, 22 Jun 2016 22:59:10 +0000
Message-ID: <1466635735.3504.344.camel@hpe.com>
References: <20160620195217.GB21657@redhat.com>
 <1466452883.3504.244.camel@hpe.com> <1466457467.3504.249.camel@hpe.com>
 <20160620222236.GA22461@redhat.com> <20160621134147.GA26392@redhat.com>
 <1466523280.3504.262.camel@hpe.com> <20160621181728.GA27821@redhat.com>
 <1466616868.3504.320.camel@hpe.com>
 <CAPcyv4gqiNQ-FRqCV3WxBzjUBZNY6eZVA9ioc0q+Lm=oG8bWAg@mail.gmail.com>
 <1466625958.3504.340.camel@hpe.com> <20160622223842.GA34512@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160622223842.GA34512-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <7375D22EC77408429172735B74BB16D5-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gV2VkLCAyMDE2LTA2LTIyIGF0IDE4OjM4IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFdlZCwgSnVuIDIyIDIwMTYgYXTCoMKgNDoxNlAgLTA0MDAsDQo+IEthbmksIFRvc2hpbWl0
c3UgPHRvc2hpLmthbmlAaHBlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gV2VkLCAyMDE2LTA2
LTIyIGF0IDEyOjE1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9u
IFdlZCwgSnVuIDIyLCAyMDE2IGF0IDEwOjQ0IEFNLCBLYW5pLCBUb3NoaW1pdHN1IDx0b3NoaS5r
YW5pQGhwZS5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IE9uIFR1ZSwgMjAx
Ni0wNi0yMSBhdCAxNDoxNyAtMDQwMCwgTWlrZSBTbml0emVyIHdyb3RlOg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IE9uIFR1ZSwgSnVuIDIxIDIwMTYgYXQgMTE6NDRhbSAtMDQwMCwNCj4gPiA+ID4g
PiBLYW5pLCBUb3NoaW1pdHN1IDx0b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gPiBPbiBUdWUsIDIwMTYtMDYtMjEgYXQgMDk6NDEgLTA0MDAsIE1pa2Ug
U25pdHplciB3cm90ZToNCj4gPiA+ID4gPiA+ID7CoA0KPiA+ID4gPiA+IFRoZSBkZXZpY2VzIGlu
IHF1ZXN0aW9uIGhhdmUgYSByZXF1ZXN0X3F1ZXVlLsKgwqBBbGwgYmlvLWJhc2VkIGRldmljZQ0K
PiA+ID4gPiA+IGhhdmUgYSByZXF1ZXN0X3F1ZXVlLg0KPiA+ID4gPsKgDQo+ID4gPiA+IERBWC1j
YXBhYmxlIGRldmljZXMgaGF2ZSB0d28gb3BlcmF0aW9uIG1vZGVzLCBiaW8tYmFzZWQgYW5kIERB
WC7CoMKgSQ0KPiA+ID4gPiBhZ3JlZSB0aGF0IGJpby1iYXNlZCBvcGVyYXRpb24gaXMgYXNzb2Np
YXRlZCB3aXRoIGEgcmVxdWVzdCBxdWV1ZSwgYW5kDQo+ID4gPiA+IGl0cyBjYXBhYmlsaXRpZXMg
c2hvdWxkIGJlIHNldCB0byBpdC7CoMKgREFYLCBvbiB0aGUgb3RoZXIgaGFuZCwgaXMNCj4gPiA+
ID4gcmF0aGVyIGluZGVwZW5kZW50IGZyb20gYSByZXF1ZXN0IHF1ZXVlLg0KPiA+ID4gPiANCj4g
PiA+ID4gPiANCj4gPiA+ID4gPiBJIGRvbid0IGhhdmUgYSBiaWcgcHJvYmxlbSB3aXRoIEdFTkhE
X0ZMX0RBWC7CoMKgSnVzdCB3YW50ZWQgdG8gcG9pbnQNCj4gPiA+ID4gPiBvdXQgdGhhdCBzdWNo
IGJsb2NrIGRldmljZSBjYXBhYmlsaXRpZXMgYXJlIGdlbmVyYWxseSBhZHZlcnRpc2VkIGluDQo+
ID4gPiA+ID4gdGVybXMgb2YgYSBRVUVVRV9GTEFHLg0KPiA+ID4gPsKgDQo+ID4gPiA+IEkgZG8g
bm90IGhhdmUgYSBzdHJvbmcgb3BpbmlvbiwgYnV0IGZlZWwgYSBiaXQgb2RkIHRvIGFzc29jaWF0
ZSBEQVggdG8NCj4gPiA+ID4gYSByZXF1ZXN0IHF1ZXVlLg0KPiA+ID4NCj4gPiA+IEdpdmVuIHRo
YXQgd2UgZG8gbm90IHN1cHBvcnQgZGF4IHRvIGEgcmF3IGJsb2NrIGRldmljZSBbMV0gaXQgc2Vl
bXMgYQ0KPiA+ID4gZ2VuZGlzayBmbGFnIGlzIG1vcmUgbWlzbGVhZGluZyB0aGFuIHJlcXVlc3Rf
cXVldWUgZmxhZyB0aGF0IHNwZWNpZmllcw0KPiA+ID4gd2hhdCByZXF1ZXN0cyBjYW4gYmUgbWFk
ZSBvZiB0aGUgZGV2aWNlLg0KPiA+ID4gDQo+ID4gPiBbMV06IGFjYzkzZDMwZDdkNCBSZXZlcnQg
ImJsb2NrOiBlbmFibGUgZGF4IGZvciByYXcgYmxvY2sgZGV2aWNlcyINCj4gPg0KPiA+IE9oLCBJ
IHNlZS4gwqBJIHdpbGwgY2hhbmdlIHRvIHVzZSByZXF1ZXN0X3F1ZXVlIGZsYWcuDQo+DQo+IEkg
aW1wbGVtZW50ZWQgdGhlIGJsb2NrIHBhdGNoIGZvciB0aGlzIHllc3RlcmRheSBidXQgYmFzZWQg
b24geW91cg0KPiBmZWVkYmFjayBJIHN0b3BwZWQgdGhlcmUgKGRpZG4ndCBjYXJyeSB0aGUgY2hh
bmdlIHRocm91Z2ggdG8gdGhlIERNIGNvcmUNCj4gYW5kIERNIGxpbmVhciAtLSBjYW4gZWFzaWx5
IGRvIHNvIHRvbW9ycm93IHRob3VnaCkuDQo+IA0KPiBGZWVsIGZyZWUgdG8gdXNlIHRoaXMgYXMg
YSBzdGFydGluZyBwb2ludCBhbmQgZml4L2V4dGVuZCBhbmQgYWRkIGENCj4gcHJvcGVyIGhlYWRl
cjoNCg0KVGhhbmtzIE1pa2UhIEkgbWFkZSBzaW1pbGFyIGNoYW5nZXMgYXMgd2VsbC4gSSB3aWxs
IHRha2UgeW91cnMgYW5kIGZpbmlzaCB1cA0KdGhlIHJlc3QuIDopDQotVG9zaGkKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
