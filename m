From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: dm stripe: add DAX support
Date: Wed, 13 Jul 2016 15:03:31 +0000
Message-ID: <1468422189.8908.53.camel@hpe.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
 <20160624182859.GD13898@redhat.com> <1468362104.8908.43.camel@hpe.com>
 <20160713020100.GA5872@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160713020100.GA5872-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <F7B5EE46DC71E74F88AE591FF8F4EAFF-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
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
Cc: "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCAyMDE2LTA3LTEyIGF0IDIyOjAxIC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVsIDEyIDIwMTYgYXTCoMKgNjoyMnBtIC0wNDAwLA0KPiBLYW5pLCBUb3NoaW1p
dHN1IDx0b3NoaS5rYW5pQGhwZS5jb20+IHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAxNi0wNi0yNCBh
dCAxNDoyOSAtMDQwMCwgTWlrZSBTbml0emVyIHdyb3RlOg0KPiA+ID4gwqANCsKgOg0KPiBUaGFu
a3MgZm9yIHB1dHRpbmcgdGhpcyBzdW1tYXJ5IHRvZ2V0aGVyLsKgwqBVbmZvcnR1bmF0ZWx5IG5v
bmUgb2YgdGhlIERNDQo+IGNoYW5nZXMgY2FuIGJlIHF1ZXVlZCBmb3IgNC44IHVudGlsIEplbnMg
dGFrZXMgdGhlIDIgYmxvY2sgY29yZSBwYXRjaGVzOg0KPiBodHRwczovL3BhdGNod29yay5rZXJu
ZWwub3JnL3BhdGNoLzkxOTYwMjEvDQo+IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0
Y2gvOTE5NjAxOS8NCj4gDQo+IE5vdCBzdXJlIHdoYXQgdGhlIGhvbGQgdXAgYW5kL29yIGlzc3Vl
IGlzIHdpdGggdGhlbS7CoMKgQnV0IEkndmUgYXNrZWQNCj4gdHdpY2UgKGFuZCBpbXBsaWNpbHR5
IGEgM3JkIHRpbWUgaGVyZSkuwqDCoEhvcGVmdWxseSB0aGV5IGxhbmQgaW4gdGltZSBmb3INCj4g
NC44Lg0KDQpIaSBKZW5zLA0KDQpDYW4geW91IHRha2UgdGhlIHR3byBwYXRjaGVzIGFib3ZlPyDC
oFRoZXNlIHBhdGNoZXMgYWRkIFFVRVVFX0ZMQUdfREFYIGFuZCBpdHMNCnN5c2ZzIHNob3cgZnVu
Yy4gwqBUaGV5IGFsbG93IGRldmljZS1tYXBwZXIgdG8gc2V0IGRheC1jYXBhYmlsaXR5IGJhc2Vk
IG9uIGl0cw0KY29uZmlndXJhdGlvbiwgYW5kIGFsc28gYWxsb3cgdXNlciBhcHBsaWNhdGlvbnMg
dG8gY2hlY2sgZGF4LWNhcGFiaWxpdHkgdmlhDQpzeXNmcy4NCg0KVGhhbmtzLA0KLVRvc2hpwqAN
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
