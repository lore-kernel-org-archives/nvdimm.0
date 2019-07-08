From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v6 01/18] kunit: test: add KUnit test runner core
Date: Mon, 8 Jul 2019 11:12:55 -0700
Message-ID: <CAFd5g44_NoGHsMRfZJ-V42=8U6QYOYZV7zUmEdx-6V4xGarxHg@mail.gmail.com>
References: <20190704003615.204860-1-brendanhiggins@google.com>
 <20190704003615.204860-2-brendanhiggins@google.com>
 <20190705202051.GB19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190705202051.GB19023@42.do-not-panic.com>
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

T24gRnJpLCBKdWwgNSwgMjAxOSBhdCAxOjIwIFBNIEx1aXMgQ2hhbWJlcmxhaW4gPG1jZ3JvZkBr
ZXJuZWwub3JnPiB3cm90ZToKPgo+IE9uIFdlZCwgSnVsIDAzLCAyMDE5IGF0IDA1OjM1OjU4UE0g
LTA3MDAsIEJyZW5kYW4gSGlnZ2lucyB3cm90ZToKPiA+ICtzdHJ1Y3Qga3VuaXQgewo+ID4gKyAg
ICAgdm9pZCAqcHJpdjsKPiA+ICsKPiA+ICsgICAgIC8qIHByaXZhdGU6IGludGVybmFsIHVzZSBv
bmx5LiAqLwo+ID4gKyAgICAgY29uc3QgY2hhciAqbmFtZTsgLyogUmVhZCBvbmx5IGFmdGVyIGlu
aXRpYWxpemF0aW9uISAqLwo+ID4gKyAgICAgYm9vbCBzdWNjZXNzOyAvKiBSZWFkIG9ubHkgYWZ0
ZXIgdGVzdF9jYXNlIGZpbmlzaGVzISAqLwo+ID4gK307Cj4KPiBObyBsb2NrIGF0dHJpYnV0ZSBh
Ym92ZS4KPgo+ID4gK3ZvaWQga3VuaXRfaW5pdF90ZXN0KHN0cnVjdCBrdW5pdCAqdGVzdCwgY29u
c3QgY2hhciAqbmFtZSkKPiA+ICt7Cj4gPiArICAgICBzcGluX2xvY2tfaW5pdCgmdGVzdC0+bG9j
ayk7Cj4gPiArICAgICB0ZXN0LT5uYW1lID0gbmFtZTsKPiA+ICsgICAgIHRlc3QtPnN1Y2Nlc3Mg
PSB0cnVlOwo+ID4gK30KPgo+IEFuZCB5ZXQgaGVyZSB5b3UgaW5pdGlhbGl6ZSBhIHNwaW4gbG9j
ay4uLiBUaGlzIHdvbid0IGNvbXBpbGUuIFNlZW1zCj4geW91IGZvcmdvdCB0byByZW1vdmUgdGhp
cyBsaW5lLiBTbyBJIGd1ZXNzIGEgcmUtc3BpbiBpcyBiZXR0ZXIuCgpPaCBjcmFwLCBzb3JyeSBh
Ym91dCB0aGF0LiBZb3UgY2FuJ3QgY29tcGlsZSB0aGVzZSBwYXRjaGVzIHVudGlsIHRoZQprYnVp
bGQgcGF0Y2guIEkgd2lsbCBmaXggdGhpcyBhbmQgbWFrZSBzdXJlIEkgZGlkbid0IG1ha2UgYW55
IHNpbWlsYXIKbWlzdGFrZXMgb24gdGhlc2UgZWFybHkgcGF0Y2hlcy4KClRoYW5rcyEKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxp
bmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
