Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 13 Apr 2017 00:16:39 +0200
From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412221639.5klmqk4mjbvy6btx@pd.tnic>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
 <20170412211931.GA15771@intel.com>
 <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
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

T24gV2VkLCBBcHIgMTIsIDIwMTcgYXQgMTE6NDc6NDlQTSArMDIwMCwgQm9yaXNsYXYgUGV0a292
IHdyb3RlOgo+IHNvIHdlIG5lZWQgdG8gdGhpbmsgYWJvdXQgc29tZXRoaW5nIGJldHRlciB0byBo
YW5kbGUgZXZlbnRzIGRvd24gdGhlCj4gd2hvbGUgY2hhaW4uIE1heWJlIHJvdXRlIGV2ZW50cyBm
cm9tIHRoZSBhdG9taWMgcGF0aCB0byB0aGUgYmxvY2tpbmcKPiBwYXRoIHdoZXJlIHRoZSBzbGVl
cGluZyBub3RpZmllciBjYWxsYmFja3MgY2FuIHNsZWVwIGFzIG11Y2ggYXMgdGhleQo+IHdhbnQg
dG8uLi4KCi4uLiBhbmQgaXQgaXMgbWlkbmlnaHQgaGVyZSBzbyBJIGNvdWxkIGJlIHRhbGtpbmcg
Y3JhcCBidXQgd2UgcHJvYmFibHkKc2hvdWxkIHJlYWxseSBzcGxpdCB0aGUgcmVwb3J0aW5nICJj
aGFpbiIgaW50byB0d286CgoxLiBhdG9taWMgY29udGV4dCB3aGljaCBkb2Vzbid0IGRvIGFueSBu
b3RpZmllciB3YW5rZXJ5LiBXZSBzaW1wbHkgY2FsbApub24tc2xlZXBpbmcgZnVuY3Rpb25zIG9u
ZSBhZnRlciB0aGUgb3RoZXIuIEFuZCB0aG9zZSBzaG91bGQgYmUgZmFzdCBhbmQKbm90IHRha2lu
ZyBhbnkgbG9ja3MuCgpGb3IgZXhhbXBsZSwgSSdtIHRoaW5raW5nIHlvdSB3YW50IHRvIGRlY29k
ZSB0aGUgZXJyb3IgYW5kIHRoYXQncyBpdC4gU28Kd2UgY2FuIHJlcGxhY2UgdGhlIG5vdGlmaWVy
IGNhbGwgaW4gcHJpbnRfbWNlKCkgd2l0aCBvdXIgYXRvbWljIGNvbnRleHQKZnVuY3Rpb24uCgpU
aGVuOgoKMi4gbW92ZSB0aGUgbm90aWZpZXIgY29tcGxldGVseSBpbiBwcm9jZXNzIGNvbnRleHQs
IGNvbnZlcnQgaXQgdG8gYQpibG9ja2luZyBvbmUgYW5kIGNvbm5lY3QgdGhlcmUgYWxsIHRoZSBu
b29kbGluZyBzdHVmZiBsaWtlIEVEQUMsIE5GSVQsCm1jZWxvZywgRVhUTE9HLCAuLi4gSS5lLiwg
YWxsIHRoZSBsb2dnaW5nIG1hY2hpbmVyeS4KClByb2JsZW0gc29sdmVkLgoKQW5kIGhlcmUncyB3
aGVyZSB5b3UgY29tZSBpbiBhbmQgc2F5LCAiQm9yaXMsIHlvdSdyZSB0YWxraW5nIGNyYXAuLiIg
Oi0pCgpMZW1tZSBzbGVlcCBvbiBpdC4KCi0tIApSZWdhcmRzL0dydXNzLAogICAgQm9yaXMuCgpT
VVNFIExpbnV4IEdtYkgsIEdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdy
YWhhbSBOb3J0b24sIEhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQotLSAKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlz
dApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4v
bGlzdGluZm8vbGludXgtbnZkaW1tCg==
