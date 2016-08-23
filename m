From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
Date: Tue, 23 Aug 2016 21:25:09 +0000
Message-ID: <1471987482.32015.111.camel@hpe.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <20160823134216.8f8e8944581fe1ae202377d1@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160823134216.8f8e8944581fe1ae202377d1-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
Content-ID: <468C953341858449A80409F3E3CA0001-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Mulumudi, Abhilash
 Kumar" <m.abhilash-kumar-ZPxbGqLxI0U@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brian.starkey-5wv7dgnIgG8@public.gmane.org" <brian.starkey-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCAyMDE2LTA4LTIzIGF0IDEzOjQyIC0wNzAwLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0K
PiBPbiBUdWUsIDIzIEF1ZyAyMDE2IDEyOjQzOjIwIC0wNjAwIFRvc2hpIEthbmkgPHRvc2hpLmth
bmlAaHBlLmNvbT4NCj4gd3JvdGU6DQo+IA0KPiA+IA0KPiA+IFRoZSBmb2xsb3dpbmcgQlVHIHdh
cyBvYnNlcnZlZCB3aGlsZSBzdGFydGluZyB1cCBLVk0gd2l0aCBudmRpbW0NCj4gPiBkZXZpY2Ug
YXMgbWVtb3J5LWJhY2tlbmQtZmlsZSB0byAvZGV2L2RheC4NCj4gPiANCj4gPiDCoEJVRzogdW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0DQo+ID4gMDAw
MDAwMDAwMDAwMDAwOA0KPiA+IA0KPiA+IC4uLg0KPiA+IA0KPiA+IGRldm1fbWVtcmVtYXBfcGFn
ZXMoKSBjYWxscyBmb3JfZWFjaF9kZXZpY2VfcGZuKCkgdG8gd2FsayB0aHJvdWdoDQo+ID4gYWxs
IHBmbnMgaW4gcGFnZV9tYXAuwqDCoHBmbl9maXJzdCgpLCBob3dldmVyLCByZXR1cm5zIGEgd3Jv
bmcgcGZuDQo+ID4gdGhhdCBsZWF2ZXMgcGFnZS0+cGdtYXAgdW5pbml0aWFsaXplZC4NCj4gPiAN
Cj4gPiBTaW5jZSBhcmNoX2FkZF9tZW1vcnkoKSBoYXMgc2V0IHVwIGRpcmVjdCBtYXBwaW5ncyB0
byB0aGUgTlZESU1NDQo+ID4gcmFuZ2Ugd2l0aCBhbHRtYXAsIHBmbl9maXJzdCgpIHNob3VsZCBu
b3QgbW9kaWZ5IHRoZSBzdGFydCBwZm4uDQo+ID4gQ2hhbmdlIHBmbl9maXJzdCgpIHRvIHNpbXBs
eSByZXR1cm4gcGZuIG9mIHJlcy0+c3RhcnQuDQo+IA0KPiBXaGljaCBrZXJuZWwgdmVyc2lvbihz
KSBkbyB5b3UgdGhpbmsgbmVlZCBmaXhpbmc/DQoNClRoZSBmaXggYXBwbGllcyB0byB2NC41IGFu
ZCBuZXdlciB2ZXJzaW9ucy4NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
