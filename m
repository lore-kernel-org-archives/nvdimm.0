Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 13 Apr 2017 14:12:16 +0200
From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170413121215.kzflalrar7hpxvjh@pd.tnic>
References: <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
 <20170412211931.GA15771@intel.com>
 <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
 <20170412221639.5klmqk4mjbvy6btx@pd.tnic>
 <20170412222619.GA17839@intel.com>
 <20170412222925.r3izasv3yuyjy62e@pd.tnic>
 <20170413113159.rc32ebiswn64nzrr@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170413113159.rc32ebiswn64nzrr@pd.tnic>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBBcHIgMTMsIDIwMTcgYXQgMDE6MzE6NTlQTSArMDIwMCwgQm9yaXNsYXYgUGV0a292
IHdyb3RlOgo+IEBAIC0zMjEsMTggKzMyMSw4IEBAIHN0YXRpYyB2b2lkIF9fcHJpbnRfbWNlKHN0
cnVjdCBtY2UgKm0pCj4gIAo+ICBzdGF0aWMgdm9pZCBwcmludF9tY2Uoc3RydWN0IG1jZSAqbSkK
PiAgewo+IC0JaW50IHJldCA9IDA7Cj4gLQo+ICAJX19wcmludF9tY2UobSk7Cj4gLQo+IC0JLyoK
PiAtCSAqIFByaW50IG91dCBodW1hbi1yZWFkYWJsZSBkZXRhaWxzIGFib3V0IHRoZSBNQ0UgZXJy
b3IsCj4gLQkgKiAoaWYgdGhlIENQVSBoYXMgYW4gaW1wbGVtZW50YXRpb24gZm9yIHRoYXQpCj4g
LQkgKi8KPiAtCXJldCA9IGF0b21pY19ub3RpZmllcl9jYWxsX2NoYWluKCZ4ODZfbWNlX2RlY29k
ZXJfY2hhaW4sIDAsIG0pOwo+IC0JaWYgKHJldCA9PSBOT1RJRllfU1RPUCkKPiAtCQlyZXR1cm47
Cj4gLQo+ICsJbWNlX2xvZyhtKTsKCkFjdHVhbGx5LCB3ZSBkb24ndCBuZWVkIHRoYXQgY2FsbCBo
ZXJlIGJlY2F1c2UgZG9fbWFjaGluZV9jaGVjaygpCmFscmVhZHkgZG9lcyBpdC4KCi0tIApSZWdh
cmRzL0dydXNzLAogICAgQm9yaXMuCgpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2
cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24sIEhSQiAyMTI4NCAoQUcgTsO8cm5i
ZXJnKQotLSAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
