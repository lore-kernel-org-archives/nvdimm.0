Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 23:47:49 +0200
From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412214749.jyt7cmyhovivtb2m@pd.tnic>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412205229.GA13659@intel.com>
 <CAPcyv4j1=Cs84nn6n-9vygSJ2Ei9Z3Gw7hCzyBzo+GyLKWaTUg@mail.gmail.com>
 <alpine.DEB.2.20.1704122259490.2548@nanos>
 <20170412211931.GA15771@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412211931.GA15771@intel.com>
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

T24gV2VkLCBBcHIgMTIsIDIwMTcgYXQgMDI6MTk6MzJQTSAtMDcwMCwgTHVjaywgVG9ueSB3cm90
ZToKPiBPbiBXZWQsIEFwciAxMiwgMjAxNyBhdCAxMToxMjoyMVBNICswMjAwLCBUaG9tYXMgR2xl
aXhuZXIgd3JvdGU6Cj4gPiBUaGVyZSBpcyBhbm90aGVyIHNvbHV0aW9uOgo+ID4gCj4gPiBDb252
ZXJ0IHRoZSBub3RpZmllciB0byBhIGJsb2NraW5nIG5vdGlmaWVyIGFuZCBpbiB0aGUgcGFuaWMg
Y2FzZSwgaWdub3JlCj4gPiB0aGUgbG9ja2luZyBhbmQgaW52b2tlIHRoZSBub3RpZmllciBjaGFp
biBkaXJlY3RseS4gVGhhdCBuZWVkcyBzb21lIG1pbmltYWwKPiA+IHN1cmdlcnkgaW4gdGhlIG5v
dGlmaWVyIGNvZGUgdG8gYWxsb3cgdGhhdCwgYnV0IHRoYXQncyBjZXJ0YWlubHkgbGVzcyB1Z2x5
Cj4gPiB0aGFuIHNwbGl0dGluZyBzdHVmZiB1cCBpbnRvIHR3byBjaGFpbnMuCj4gCj4gQnV0IEkg
d29uZGVyIHdoZXRoZXIgd2UgYWN0dWFsbHkgd2FudCB0d28gY2hhaW5zLiAgV2UndmUgYmVlbiBh
ZGRpbmcgYSBidW5jaAo+IG9mIGdlbmVyYWwgcnVuLXRpbWUgbG9nZ2luZyBhbmQgcmVjb3Zlcnkg
c3R1ZmYgdG8gdGhpcyBjaGFpbi4gU28gbm93IHdlIGhhdmUKPiB0aGluZ3MgdGhlcmUgdGhhdCBh
cmVuJ3QgbmVlZGVkIG9yIHVzZWZ1bCBpbiB0aGUgcGFuaWMgY2FzZS4gRS5nLgo+IHNyYW9fZGVj
b2RlX25vdGlmaWVyKCkgKHdoaWNoIHRyaWVzIHRvIG9mZmxpbmUgYSBwYWdlIHRoYXQgcmVwb3J0
ZWQgYW4KPiB1bmNvcnJlY3RlZCBlcnJvciBvdXQgb2YgdGhlIGV4ZWN1dGlvbiBwYXRoKSBhbmQg
Qm9yaXMncyBuZXcgQ0VDIGNvZGUuCgpJIGd1ZXNzIHdlJ2xsIGhhdmUgdG8uIFRoZSBDRUMgdGhp
bmcgZG9lcyBtdXRleF9sb2NrKCkgdG9vIGFuZCB0aGUKYXRvbWljIG5vdGlmaWVyIGRpc2FibGVz
IHByZWVtcHRpb246CgpfX2F0b21pY19ub3RpZmllcl9jYWxsX2NoYWluKCkKIHJjdV9yZWFkX2xv
Y2soKQogIF9fcmN1X3JlYWRfbG9jaygpCglpZiAoSVNfRU5BQkxFRChDT05GSUdfUFJFRU1QVF9D
T1VOVCkpCgkJcHJlZW1wdF9kaXNhYmxlKCk7CgpzbyB3ZSBuZWVkIHRvIHRoaW5rIGFib3V0IHNv
bWV0aGluZyBiZXR0ZXIgdG8gaGFuZGxlIGV2ZW50cyBkb3duIHRoZQp3aG9sZSBjaGFpbi4gTWF5
YmUgcm91dGUgZXZlbnRzIGZyb20gdGhlIGF0b21pYyBwYXRoIHRvIHRoZSBibG9ja2luZwpwYXRo
IHdoZXJlIHRoZSBzbGVlcGluZyBub3RpZmllciBjYWxsYmFja3MgY2FuIHNsZWVwIGFzIG11Y2gg
YXMgdGhleQp3YW50IHRvLi4uCgotLSAKUmVnYXJkcy9HcnVzcywKICAgIEJvcmlzLgoKU1VTRSBM
aW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0g
Tm9ydG9uLCBIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKLS0gCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
