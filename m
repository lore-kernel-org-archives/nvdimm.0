From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: dm stripe: add DAX support
Date: Fri, 24 Jun 2016 18:42:20 +0000
Message-ID: <1466793738.3504.404.camel@hpe.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
 <20160624182859.GD13898@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160624182859.GD13898-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <E7FC3B503B2A234A99F15AC02CB5A09F-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
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

T24gRnJpLCAyMDE2LTA2LTI0IGF0IDE0OjI5IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIEZyaSwgSnVuIDI0IDIwMTYgYXTCoMKgMjoyM3BtIC0wNDAwLA0KPiBUb3NoaSBLYW5pIDx0
b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOg0KwqA6DQo+IFRoYW5rcywgb25jZSBqZW5zIHF1ZXVl
cyB0aGUgYmxvY2sgY2hhbmdlcyBJJ2xsIGJlIGFibGUgdG8gcHVsbCB0aGlzIGluDQo+IHRvIGxp
bnV4LWRtLmdpdA0KPiANCj4gQlRXLCBpZiBpbiB5b3VyIHRlc3RpbmcgeW91IGNvdWxkIGV2YWx1
YXRlL3F1YW50aWZ5IGFueSBleHRyYSBvdmVyaGVhZA0KPiBmcm9tIERNIHRoYXQnZCBiZSB1c2Vm
dWwgdG8gc2hhcmUuwqDCoEl0IGNvdWxkIGJlIHRoZXJlIGFyZSBib3R0bGVuZWNrcw0KPiB0aGF0
IG5lZWQgdG8gYmUgZml4ZWQsIGV0Yy4NCg0KSSByYW4gc29tZSBwZXJmb3JtYW5jZSB0ZXN0cyBh
cyBzYW5pdHkgY2hlY2tzIChyZXN1bHRzIGFyZSBpbiBiYWxscGFyayksIGJ1dA0KaGF2ZSBub3Qg
dmVyaWZpZWQgdGhlbSBjYXJlZnVsbHkuIMKgWWVzLCBJIHdpbGwgY2hlY2sgdG8gc2VlIGlmIHRo
ZXJlIGFyZSBhbnkNCmJvdHRsZW5lY2tzLg0KDQpUaGFua3MhDQotVG9zaGkgwqAKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
