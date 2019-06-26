From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v5 07/18] kunit: test: add initial tests
Date: Wed, 26 Jun 2019 00:53:18 -0700
Message-ID: <CAFd5g46mnd=a0OqFCx0hOHX+DxW+5yA2LXH5Q0gEg8yUZK=4FA@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-8-brendanhiggins@google.com>
 <20190625232249.GS19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190625232249.GS19023@42.do-not-panic.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird,
 Timothy" <Tim.Bird>
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCBKdW4gMjUsIDIwMTkgYXQgNDoyMiBQTSBMdWlzIENoYW1iZXJsYWluIDxtY2dyb2ZA
a2VybmVsLm9yZz4gd3JvdGU6Cj4KPiBPbiBNb24sIEp1biAxNywgMjAxOSBhdCAwMToyNjowMkFN
IC0wNzAwLCBCcmVuZGFuIEhpZ2dpbnMgd3JvdGU6Cj4gPiBkaWZmIC0tZ2l0IGEva3VuaXQvZXhh
bXBsZS10ZXN0LmMgYi9rdW5pdC9leGFtcGxlLXRlc3QuYwo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQKPiA+IGluZGV4IDAwMDAwMDAwMDAwMDAuLmY0NGI4ZWNlNDg4YmIKPiA+IC0tLSAvZGV2L251
bGwKPiA+ICsrKyBiL2t1bml0L2V4YW1wbGUtdGVzdC5jCj4KPiA8LS0gc25pcCAtLT4KPgo+ID4g
Ky8qCj4gPiArICogVGhpcyBkZWZpbmVzIGEgc3VpdGUgb3IgZ3JvdXBpbmcgb2YgdGVzdHMuCj4g
PiArICoKPiA+ICsgKiBUZXN0IGNhc2VzIGFyZSBkZWZpbmVkIGFzIGJlbG9uZ2luZyB0byB0aGUg
c3VpdGUgYnkgYWRkaW5nIHRoZW0gdG8KPiA+ICsgKiBga3VuaXRfY2FzZXNgLgo+ID4gKyAqCj4g
PiArICogT2Z0ZW4gaXQgaXMgZGVzaXJhYmxlIHRvIHJ1biBzb21lIGZ1bmN0aW9uIHdoaWNoIHdp
bGwgc2V0IHVwIHRoaW5ncyB3aGljaAo+ID4gKyAqIHdpbGwgYmUgdXNlZCBieSBldmVyeSB0ZXN0
OyB0aGlzIGlzIGFjY29tcGxpc2hlZCB3aXRoIGFuIGBpbml0YCBmdW5jdGlvbgo+ID4gKyAqIHdo
aWNoIHJ1bnMgYmVmb3JlIGVhY2ggdGVzdCBjYXNlIGlzIGludm9rZWQuIFNpbWlsYXJseSwgYW4g
YGV4aXRgIGZ1bmN0aW9uCj4gPiArICogbWF5IGJlIHNwZWNpZmllZCB3aGljaCBydW5zIGFmdGVy
IGV2ZXJ5IHRlc3QgY2FzZSBhbmQgY2FuIGJlIHVzZWQgdG8gZm9yCj4gPiArICogY2xlYW51cC4g
Rm9yIGNsYXJpdHksIHJ1bm5pbmcgdGVzdHMgaW4gYSB0ZXN0IG1vZHVsZSB3b3VsZCBiZWhhdmUg
YXMgZm9sbG93czoKPiA+ICsgKgo+Cj4gVG8gYmUgY2xlYXIgdGhpcyBpcyBub3QgdGhlIGtlcm5l
bCBtb2R1bGUgaW5pdCwgYnV0IHJhdGhlciB0aGUga3VuaXQKPiBtb2R1bGUgaW5pdC4gSSB0aGlu
ayB1c2luZyBrbW9kdWxlIHdvdWxkIG1ha2UgdGhpcyBjbGVhcmVyIHRvIGEgcmVhZGVyLgoKU2Vl
bXMgcmVhc29uYWJsZS4gV2lsbCBmaXggaW4gbmV4dCByZXZpc2lvbi4KCj4gPiArICogbW9kdWxl
LmluaXQodGVzdCk7Cj4gPiArICogbW9kdWxlLnRlc3RfY2FzZVswXSh0ZXN0KTsKPiA+ICsgKiBt
b2R1bGUuZXhpdCh0ZXN0KTsKPiA+ICsgKiBtb2R1bGUuaW5pdCh0ZXN0KTsKPiA+ICsgKiBtb2R1
bGUudGVzdF9jYXNlWzFdKHRlc3QpOwo+ID4gKyAqIG1vZHVsZS5leGl0KHRlc3QpOwo+ID4gKyAq
IC4uLjsKPiA+ICsgKi8KPgo+ICAgTHVpcwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9kcmktZGV2ZWw=
