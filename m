From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 1/2] dm: update table type check for dax
Date: Tue, 28 Jun 2016 20:23:24 +0000
Message-ID: <1467145398.3504.439.camel@hpe.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
 <1467142636-21094-2-git-send-email-toshi.kani@hpe.com>
 <20160628200714.GC8300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160628200714.GC8300-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <CC3D77EC1505104AA4FE21289D8FF6E1-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
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
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCAyMDE2LTA2LTI4IGF0IDE2OjA3IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDI4IDIwMTYgYXTCoMKgMzozN3BtIC0wNDAwLA0KPiBUb3NoaSBLYW5pIDx0
b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOg0KwqA6DQo+IFlvdSBzYWlkIGluIHRoZSAwdGggaGVh
ZGVyOiAiUGF0Y2ggMSBzb2x2ZXMgYW4gZXJyb3Igd2hlbiBsdnJlbW92ZSBpcw0KPiBtYWRlIHRv
IGEgc25hcHNob3QgZGV2aWNlLiINCj4gDQo+IEknbSBub3Qgc2VlaW5nIHdoeSB0aGlzIHBhdGNo
IDEgZml4ZXMgYW55dGhpbmcgc3BlY2lmaWMgdG8gc25hcHNob3QNCj4gZGV2aWNlIHJlbW92YWwg
KGJ1dCBJIGNhbiBzZWUgd2h5IHBhdGNoIDIgbWFrZXMgc25hcHNob3QgY3JlYXRpb24NCj4gIndv
cmsiKS7CoMKgSSdsbCBhcHBseSB5b3VyIDJuZCBwYXRjaCBhbmQgc2VlIGlmIEkgY2FuIHNlZSB3
aGF0IHlvdSBtZWFuLg0KPiANCj4gSSBhY3R1YWxseSBzZWUgdGhpcyBlcnJvciwgd2l0aG91dCBl
aXRoZXIgb2YgeW91ciAyIHByb3Bvc2VkIHBhdGNoZXMNCj4gYXBwbGllZCwgd2hlbiBJIHRyeSB0
byBjcmVhdGUgYSBzbmFwc2hvdCBvZiBhIERBWCBjYXBhYmxlIExWOg0KPiANCj4gIyBsdmNyZWF0
ZSAtcyAtbiBzbmFwIC1MIDEwME0gcG1lbS9sdg0KPiDCoCBkZXZpY2UtbWFwcGVyOiByZWxvYWQg
aW9jdGwgb24gKDI1Mzo3KSBmYWlsZWQ6IEludmFsaWQgYXJndW1lbnQNCj4gwqAgRmFpbGVkIHRv
IGxvY2sgbG9naWNhbCB2b2x1bWUgcG1lbS9sdi4NCj4gwqAgQWJvcnRpbmcuIE1hbnVhbCBpbnRl
cnZlbnRpb24gcmVxdWlyZWQuDQo+IEp1biAyOCAxNTo1NzoyOCByaGVsLXN0b3JhZ2UtMDIga2Vy
bmVsOiBkZXZpY2UtbWFwcGVyOiBpb2N0bDogY2FuJ3QgY2hhbmdlDQo+IGRldmljZSB0eXBlIGFm
dGVyIGluaXRpYWwgdGFibGUgbG9hZC4NCg0KWWVzLCBwYXRjaCAyIGZpeGVzIHRoaXMgZXJyb3Iu
DQoNCkkgaGF2ZSBub3QgbG9va2VkIGludG8gd2h5IGx2cmVtb3ZlIGRvZXMgdGhpcywgYnV0IGx2
cmVtb3ZlIHRvIGEgc25hcHNob3QNCmRldmljZSBmYWlscyB0byByZWxvYWQgRE0gdGFibGUgb2Yg
IjxkZXY+LWx2c25hcCIgZGV2aWNlICh3aGljaCBpcyBtYXJrZWQgYXMNCkRNX1RZUEVfQklPX0JB
U0VEKSB3aXRoIERNX1RZUEVfREFYX0JJT19CQVNFRC4gwqBQYXRjaCAxIGZpeGVzIHRoaXMgZXJy
b3IuIMKgSQ0KdGhpbmsgaXQgYWxzbyBnZW5lcmFsbHkgbWFrZXMgc2Vuc2UgdG8gYWxsb3cgdGhp
cyBjYXNlLg0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
