From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 16:56:03 +0000
Message-ID: <1466527550.3504.273.camel@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com>	<20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com>	<20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com>	<1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com>	<20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com>	<1466523280.3504.262.camel@hpe.com>
 <CAPcyv4gFREc94ANuFD_Lyddx3iqRTN2UDebgeJe3LqPL8xrVzg@mail.gmail.com>
 <1466526342.3504.270.camel@hpe.com>
 <CAPcyv4ht8B7dHe1ckv5d=bOrRzCy3=ZDVSTD0rRsak_LYD8r8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4ht8B7dHe1ckv5d=bOrRzCy3=ZDVSTD0rRsak_LYD8r8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <FC54D2231064034B8A04E1242C3B3E7A-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCAyMDE2LTA2LTIxIGF0IDA5OjQ1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDIxLCAyMDE2IGF0IDk6MzUgQU0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbT4NCj4gd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE2LTA2LTIxIGF0IDA5OjI1
IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIEp1biAyMSwgMjAxNiBh
dCA4OjQ0IEFNLCBLYW5pLCBUb3NoaW1pdHN1IDx0b3NoaS5rYW5pQGhwZS5jb20+DQo+ID4gPiB3
cm90ZToNCj4gPiA+ID4gDQrCoDoNCj4gPiA+ID4gSSB0aGluayBHRU5IRF9GTF9EQVggaXMgbW9y
ZSBhcHByb3ByaWF0ZSBzaW5jZSBEQVggZG9lcyBub3QgdXNlIGENCj4gPiA+ID4gcmVxdWVzdCBx
dWV1ZSwgZXhjZXB0IGZvciBwcm90ZWN0aW5nIHRoZSB1bmRlcmxpbmluZyBkZXZpY2UgYmVpbmcN
Cj4gPiA+ID4gZGlzYWJsZWQgd2hpbGUgZGlyZWN0X2FjY2VzcygpIGlzIGNhbGxlZCAoYjJlMGQx
NjI1ZTE5KS4NCj4gPiA+ID4gDQo+ID4gPiA+IEFib3V0IHByb3RlY3RpbmcgZGlyZWN0X2FjY2Vz
cywgdGhpcyBwYXRjaCBhc3N1bWVzIHRoYXQgdGhlDQo+ID4gPiA+IHVuZGVybGluaW5nIGRldmlj
ZSBjYW5ub3QgYmUgZGlzYWJsZWQgdW50aWwgZHRyKCkgaXMgY2FsbGVkLsKgwqBJcyB0aGlzDQo+
ID4gPiA+IGNvcnJlY3Q/wqDCoElmIG5vdCwgSSB3aWxsIG5lZWQgdG8gY2FsbCBkYXhfbWFwX2F0
b21pYygpLg0KPiA+ID4NCj4gPiA+IEtlcm5lbCBpbnRlcm5hbCB1c2FnZXMgb2YgZGF4IHNob3Vs
ZCBiZSB1c2luZyBkYXhfbWFwX2F0b21pYygpIHRvDQo+ID4gPiBzYWZlbHkgcmVzb2x2ZSBkZXZp
Y2UgcmVtb3ZhbCByYWNlcy4NCj4gPg0KPiA+IFdpbGwgZG8uwqDCoEluIHN1Y2ggY2FzZSwgc2hh
bGwgSSBtb3ZlIGRheF9bdW5dbWFwX2F0b21pYygpIHRvIGJsb2NrX2Rldi5jDQo+ID4gYW5kIHJl
bmFtZSB0aGVtIHRvIGJkZXZfZGF4X1t1bl1tYXBfYXRvbWljKCk/DQo+DQo+IFNvdW5kcyBnb29k
IHRvIG1lLsKgwqBJIGtub3cgSmVmZiBhbmQgQ2hyaXN0b3BoIGRvbid0IGxpa2UgdGhlIGN1cnJl
bnQNCj4gY2FsbGluZyBjb252ZW50aW9uIG9mIHBhc3NpbmcgaW4gYSBzdHJ1Y3R1cmUuwqDCoEp1
c3Qgbm90ZSB0aGF0IHRoZXkNCj4gbWlnaHQgYXNrIHlvdSB0byBjaGFuZ2UgaXQgYmFjayB0byBh
IGxpc3Qgb2YgcGFyYW1ldGVycyBpZiBpdCBtb3ZlcyB0bw0KPiBiZGV2X2RheF9tYXBfYXRvbWlj
KCkuDQoNCk9LLCBJIHdpbGwgY2hhbmdlIGl0IGJhY2sgdG8gYSBsaXN0IG9mIHBhcmFtZXRlcnMg
YXMgd2VsbC4NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4
LW52ZGltbQo=
