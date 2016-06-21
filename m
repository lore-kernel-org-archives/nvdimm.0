From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 16:35:56 +0000
Message-ID: <1466526342.3504.270.camel@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com>	<20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com>	<20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com>	<1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com>	<20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com>	<1466523280.3504.262.camel@hpe.com>
 <CAPcyv4gFREc94ANuFD_Lyddx3iqRTN2UDebgeJe3LqPL8xrVzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gFREc94ANuFD_Lyddx3iqRTN2UDebgeJe3LqPL8xrVzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <A279520FFE4C7243952CA7506F58F03C-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
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

T24gVHVlLCAyMDE2LTA2LTIxIGF0IDA5OjI1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDIxLCAyMDE2IGF0IDg6NDQgQU0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbT4NCj4gd3JvdGU6DQo+ID4gDQo+ID4gT24gVHVlLCAyMDE2LTA2LTIxIGF0
IDA5OjQxIC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9uIE1vbiwg
SnVuIDIwIDIwMTYgYXTCoMKgNjoyMnBtIC0wNDAwLA0KPiA+ID4gTWlrZSBTbml0emVyIDxzbml0
emVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gT24gTW9uLCBKdW4gMjAg
MjAxNiBhdMKgwqA1OjI4cG0gLTA0MDAsDQo+ID4gPiA+IEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbT4gd3JvdGU6DQo+ID4gwqA6DQo+ID4gPiA+IExvb2tzIGdvb2QsIEkgZm9s
ZGVkIGl0IGluIGFuZCB0ZXN0ZWQgaXQgdG8gd29yay7CoMKgUHVzaGVkIHRvIG15ICd3aXAnDQo+
ID4gPiA+IGJyYW5jaC4NCj4gPiA+ID4gDQo+ID4gPiA+IE5vIGxvbmdlciBzZWVpbmcgYW55IGNv
cnJ1cHRpb24gaW4gbXkgdGVzdCB0aGF0IHdhcyB1c2luZyBwYXJ0aXRpb25zDQo+ID4gPiA+IHRv
IHNwYW4gcG1lbSBkZXZpY2VzIHdpdGggYSBkbS1saW5lYXIgZGV2aWNlLg0KPiA+ID4gPiANCj4g
PiA+ID4gSmVucywgYW55IGNoYW5jZSB5b3UnZCBiZSBvcGVuIHRvIHBpY2tpbmcgdXAgdGhlIGZp
cnN0IDIgcGF0Y2hlcyBpbg0KPiA+ID4gPiB0aGlzIHNlcmllcz/CoMKgT3Igd291bGQgeW91IGxp
a2UgdG8gc2VlIHRoZW0gZm9sZGVkIG9yIHNvbWV0aGluZw0KPiA+ID4gPiBkaWZmZXJlbnQ/DQo+
ID4gPg0KPiA+ID4gSSdtIG5vdyB3b25kZXJpbmcgaWYgd2UnZCBiZSBiZXR0ZXIgb2ZmIHNldHRp
bmcgYSBuZXcgUVVFVUVfRkxBR19EQVgNCj4gPiA+IHJhdGhlciB0aGFuIGVzdGFibGlzaCBHRU5I
RF9GTF9EQVggb24gdGhlIGdlbmhkPw0KPiA+ID4gDQo+ID4gPiBJdCdkIGJlIHF1aXRlIGEgYml0
IGVhc2llciB0byBhbGxvdyB1cHBlciBsYXllcnMgKGUuZy4gWEZTIGFuZCBleHQ0KSB0bw0KPiA+
ID4gY2hlY2sgZm9yIGEgcXVldWUgZmxhZy4NCj4gPg0KPiA+IEkgdGhpbmsgR0VOSERfRkxfREFY
IGlzIG1vcmUgYXBwcm9wcmlhdGUgc2luY2UgREFYIGRvZXMgbm90IHVzZSBhIHJlcXVlc3QNCj4g
PiBxdWV1ZSwgZXhjZXB0IGZvciBwcm90ZWN0aW5nIHRoZSB1bmRlcmxpbmluZyBkZXZpY2UgYmVp
bmcgZGlzYWJsZWQgd2hpbGUNCj4gPiBkaXJlY3RfYWNjZXNzKCkgaXMgY2FsbGVkIChiMmUwZDE2
MjVlMTkpLg0KPiA+IA0KPiA+IEFib3V0IHByb3RlY3RpbmcgZGlyZWN0X2FjY2VzcywgdGhpcyBw
YXRjaCBhc3N1bWVzIHRoYXQgdGhlIHVuZGVybGluaW5nDQo+ID4gZGV2aWNlIGNhbm5vdCBiZSBk
aXNhYmxlZCB1bnRpbCBkdHIoKSBpcyBjYWxsZWQuwqDCoElzIHRoaXMgY29ycmVjdD/CoMKgSWYN
Cj4gPiBub3QsIEkgd2lsbCBuZWVkIHRvIGNhbGwgZGF4X21hcF9hdG9taWMoKS4NCj4NCj4gS2Vy
bmVsIGludGVybmFsIHVzYWdlcyBvZiBkYXggc2hvdWxkIGJlIHVzaW5nIGRheF9tYXBfYXRvbWlj
KCkgdG8NCj4gc2FmZWx5IHJlc29sdmUgZGV2aWNlIHJlbW92YWwgcmFjZXMuDQoNCldpbGwgZG8u
IMKgSW4gc3VjaCBjYXNlLCBzaGFsbCBJIG1vdmXCoGRheF9bdW5dbWFwX2F0b21pYygpIHRvIGJs
b2NrX2Rldi5jIGFuZA0KcmVuYW1lIHRoZW0gdG8gYmRldl9kYXhfW3VuXW1hcF9hdG9taWMoKT8N
Cg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAx
Lm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
