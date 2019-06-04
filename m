From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v4 02/18] kunit: test: add test resource management API
Date: Tue, 4 Jun 2019 16:34:58 -0700
Message-ID: <CAFd5g45taSVNXSQJrXnHLG_Rtum650vFw1zccqv1Tyru5A5d8w@mail.gmail.com>
References: <20190514221711.248228-1-brendanhiggins@google.com>
 <20190514221711.248228-3-brendanhiggins@google.com>
 <20190517003847.0962F2082E@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190517003847.0962F2082E@mail.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird,
 Timothy" <Tim.Bird>
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCBNYXkgMTYsIDIwMTkgYXQgNTozOCBQTSBTdGVwaGVuIEJveWQgPHNib3lkQGtlcm5l
bC5vcmc+IHdyb3RlOgo+Cj4gUXVvdGluZyBCcmVuZGFuIEhpZ2dpbnMgKDIwMTktMDUtMTQgMTU6
MTY6NTUpCj4gPiBkaWZmIC0tZ2l0IGEva3VuaXQvdGVzdC5jIGIva3VuaXQvdGVzdC5jCj4gPiBp
bmRleCA4NmY2NWJhMmJjZjkyLi5hMTVlNmY4YzQxNTgyIDEwMDY0NAo+ID4gLS0tIGEva3VuaXQv
dGVzdC5jCj4gPiArKysgYi9rdW5pdC90ZXN0LmMKPiBbLi5dCj4gPiArCj4gPiArdm9pZCAqa3Vu
aXRfa21hbGxvYyhzdHJ1Y3Qga3VuaXQgKnRlc3QsIHNpemVfdCBzaXplLCBnZnBfdCBnZnApCj4g
PiArewo+ID4gKyAgICAgICBzdHJ1Y3Qga3VuaXRfa21hbGxvY19wYXJhbXMgcGFyYW1zOwo+ID4g
KyAgICAgICBzdHJ1Y3Qga3VuaXRfcmVzb3VyY2UgKnJlczsKPiA+ICsKPiA+ICsgICAgICAgcGFy
YW1zLnNpemUgPSBzaXplOwo+ID4gKyAgICAgICBwYXJhbXMuZ2ZwID0gZ2ZwOwo+ID4gKwo+ID4g
KyAgICAgICByZXMgPSBrdW5pdF9hbGxvY19yZXNvdXJjZSh0ZXN0LAo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBrdW5pdF9rbWFsbG9jX2luaXQsCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGt1bml0X2ttYWxsb2NfZnJlZSwKPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgJnBhcmFtcyk7Cj4gPiArCj4gPiArICAgICAgIGlm
IChyZXMpCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIHJlcy0+YWxsb2NhdGlvbjsKPiA+ICsg
ICAgICAgZWxzZQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOwo+Cj4gQ2FuIGJlIHdy
aXR0ZW4gYXMKPgo+ICAgICAgICAgaWYgKHJlcykKPiAgICAgICAgICAgICAgICAgcmV0dXJuIC4u
Li4KPiAgICAgICAgIHJldHVybgo+Cj4gYW5kIHNvbWUgc3RhdGljIGFuYWx5c2lzIHRvb2xzIHBy
ZWZlciB0aGlzLgoKU291bmRzIHJlYXNvbmFibGUsIHdpbGwgZml4IGluIG5leHQgcmV2aXNpb24u
Cgo+ID4gK30KPiA+ICsKPiA+ICt2b2lkIGt1bml0X2NsZWFudXAoc3RydWN0IGt1bml0ICp0ZXN0
KQo+ID4gK3sKPiA+ICsgICAgICAgc3RydWN0IGt1bml0X3Jlc291cmNlICpyZXNvdXJjZSwgKnJl
c291cmNlX3NhZmU7Cj4gPiArICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4gPiArCj4gPiAr
ICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZ0ZXN0LT5sb2NrLCBmbGFncyk7Cj4KPiBBaCBvaywg
dGVzdC0+bG9jayBpcyBwcm90ZWN0aW5nIGV2ZXJ5dGhpbmcgbm93PyBEb2VzIGl0IG5lZWQgdG8g
YmUgYQo+IHNwaW5sb2NrLCBvciBjYW4gaXQgYmUgYSBtdXRleD8KCk5vIGl0IG5lZWRzIHRvIGJl
IGEgc3BpbiBsb2NrLiBUaGVyZSBhcmUgc29tZSBjb25jZWl2YWJsZQpjaXJjdW1zdGFuY2VzIHdo
ZXJlIHRoZSB0ZXN0IG9iamVjdCBjYW4gYmUgYWNjZXNzZWQgYnkgY29kZSBpbiB3aGljaAppdCBp
c24ndCBzYWZlIHRvIHNsZWVwLgoKPiA+ICsgICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZl
KHJlc291cmNlLAo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVzb3VyY2Vf
c2FmZSwKPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZ0ZXN0LT5yZXNvdXJj
ZXMsCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBub2RlKSB7Cj4gPiArICAg
ICAgICAgICAgICAga3VuaXRfZnJlZV9yZXNvdXJjZSh0ZXN0LCByZXNvdXJjZSk7Cj4gPiArICAg
ICAgIH0KPiA+ICsgICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmdGVzdC0+bG9jaywgZmxh
Z3MpOwo+ID4gK30KPiA+ICsKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0
b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJp
LWRldmVs
