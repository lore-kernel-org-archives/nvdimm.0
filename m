Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 13 Apr 2017 00:29:25 +0200
From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412222925.r3izasv3yuyjy62e@pd.tnic>
References: <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
 <20170412211931.GA15771@intel.com>
 <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
 <20170412221639.5klmqk4mjbvy6btx@pd.tnic>
 <20170412222619.GA17839@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412222619.GA17839@intel.com>
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

T24gV2VkLCBBcHIgMTIsIDIwMTcgYXQgMDM6MjY6MTlQTSAtMDcwMCwgTHVjaywgVG9ueSB3cm90
ZToKPiBXZSBjYW4gZnV0eiB3aXRoIHRoYXQgYW5kIGhhdmUgdGhlbSBzcGVjaWZ5IHdoaWNoIGNo
YWluIChvciBib3RoKQo+IHRoYXQgdGhleSB3YW50IHRvIGJlIGFkZGVkIHRvLgoKV2VsbCwgSSBk
aWRuJ3Qgd2FudCB0aGUgYXRvbWljIGNoYWluIHRvIGJlIGEgbm90aWZpZXIgYmVjYXVzZSB3ZSBj
YW4Ka2VlcCBpdCBzaW1wbGUgYW5kIG5vbi1ibG9ja2luZy4gT25seSB0aGUgcHJvY2VzcyBjb250
ZXh0IG9uZSB3aWxsIGJlLgoKU28gdGhlIHF1ZXN0aW9uIGlzLCBkbyB3ZSBldmVuIGhhdmUgYSB1
c2UgY2FzZSBmb3Igb3V0c2lkZSBjb25zdW1lcnMKaGFuZ2luZyBvbiB0aGUgYXRvbWljIGNoYWlu
PyBCZWNhdXNlIGlmIG5vdCwgd2UncmUgZ29vZCB0byBnby4KCi0tIApSZWdhcmRzL0dydXNzLAog
ICAgQm9yaXMuCgpTVVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUg
U21pdGhhcmQsIEdyYWhhbSBOb3J0b24sIEhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQotLSAKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
