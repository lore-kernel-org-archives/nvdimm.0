From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 03/19] kunit: test: add string_stream a std::stream like
 string builder
Date: Fri, 30 Nov 2018 19:12:28 -0800
Message-ID: <20181201031228.GM28501@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-4-brendanhiggins@google.com>
 <20181130032924.GH18410@garbanzo.do-not-panic.com>
 <CAFd5g46AXpnoWpm+aFNfvNm2-As5RCO7QdMPhcOMXWRPwHqrGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CAFd5g46AXpnoWpm+aFNfvNm2-As5RCO7QdMPhcOMXWRPwHqrGg@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm@lists.01.org, richard@nod.at, Knut Omang <knut.omang@oracle.com>, kieran.bingham@ideasonboard.com, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, pmladek@suse.com, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, dan.j.williams@intel.com, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-Id: linux-nvdimm@lists.01.org

T24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMDY6MTQ6MTdQTSAtMDgwMCwgQnJlbmRhbiBIaWdnaW5z
IHdyb3RlOgo+IE9uIFRodSwgTm92IDI5LCAyMDE4IGF0IDc6MjkgUE0gTHVpcyBDaGFtYmVybGFp
biA8bWNncm9mQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4KPiA+IE9uIFdlZCwgTm92IDI4LCAyMDE4
IGF0IDExOjM2OjIwQU0gLTA4MDAsIEJyZW5kYW4gSGlnZ2lucyB3cm90ZToKPiA+ID4gQSBudW1i
ZXIgb2YgdGVzdCBmZWF0dXJlcyBuZWVkIHRvIGRvIHByZXR0eSBjb21wbGljYXRlZCBzdHJpbmcg
cHJpbnRpbmcKPiA+ID4gd2hlcmUgaXQgbWF5IG5vdCBiZSBwb3NzaWJsZSB0byByZWx5IG9uIGEg
c2luZ2xlIHByZWFsbG9jYXRlZCBzdHJpbmcKPiA+ID4gd2l0aCBwYXJhbWV0ZXJzLgo+ID4gPgo+
ID4gPiBTbyBwcm92aWRlIGEgbGlicmFyeSBmb3IgY29uc3RydWN0aW5nIHRoZSBzdHJpbmcgYXMg
eW91IGdvIHNpbWlsYXIgdG8KPiA+ID4gQysrJ3Mgc3RkOjpzdHJpbmcuCj4gPgo+ID4gSHJtLCB3
aGF0J3MgdGhlIHBvdGVudGlhbCBmb3Igc3VjaCB0aGluZyBhY3R1YWxseSBiZWluZyBldmVudHVh
bGx5Cj4gPiBnZW5lcmljYWxseSB1c2VmdWwgZm9yIHByaW50ayBmb2xrcywgSSB3b25kZXI/IFBl
dHI/Cj4gCj4gQXJlIHlvdSBzYXlpbmcgeW91IHRoaW5rIHRoaXMgaXMgYXBwbGljYWJsZSBmb3Ig
b3RoZXIgdGhpbmdzPyAKClllcy4KCj4gVGhpcyBkb2Vzbid0IGJlbG9uZyBoZXJlLgoKICBMdWlz
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZl
bCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
