From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v7 16/18] MAINTAINERS: add entry for KUnit the unit
 testing framework
Date: Tue, 9 Jul 2019 08:53:19 -0600
Message-ID: <7cc417dd-036f-7dc1-6814-b1fdac810f03@kernel.org>
References: <20190709063023.251446-1-brendanhiggins@google.com>
 <20190709063023.251446-17-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190709063023.251446-17-brendanhiggins@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Brendan Higgins <brendanhiggins@google.com>, frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, shuah <shuah@kernel.org>, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, rdunlap@infradead.org, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, linux-fsdevel@vger.kernel.org, logang@deltatee.com
List-Id: linux-nvdimm@lists.01.org

T24gNy85LzE5IDEyOjMwIEFNLCBCcmVuZGFuIEhpZ2dpbnMgd3JvdGU6Cj4gQWRkIG15c2VsZiBh
cyBtYWludGFpbmVyIG9mIEtVbml0LCB0aGUgTGludXgga2VybmVsJ3MgdW5pdCB0ZXN0aW5nCj4g
ZnJhbWV3b3JrLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEJyZW5kYW4gSGlnZ2lucyA8YnJlbmRhbmhp
Z2dpbnNAZ29vZ2xlLmNvbT4KPiBSZXZpZXdlZC1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZz4KPiBSZXZpZXdlZC1ieTogTG9nYW4gR3VudGhvcnBlIDxs
b2dhbmdAZGVsdGF0ZWUuY29tPgo+IC0tLQo+ICAgTUFJTlRBSU5FUlMgfCAxMSArKysrKysrKysr
Kwo+ICAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEv
TUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwo+IGluZGV4IDY3N2VmNDFjYjAxMmMuLjQ4ZDA0ZDE4
MGE5ODggMTAwNjQ0Cj4gLS0tIGEvTUFJTlRBSU5FUlMKPiArKysgYi9NQUlOVEFJTkVSUwo+IEBA
IC04NTk5LDYgKzg1OTksMTcgQEAgUzoJTWFpbnRhaW5lZAo+ICAgRjoJdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvCj4gICBGOglEb2N1bWVudGF0aW9uL2Rldi10b29scy9rc2VsZnRlc3QqCj4gICAK
PiArS0VSTkVMIFVOSVQgVEVTVElORyBGUkFNRVdPUksgKEtVbml0KQo+ICtNOglCcmVuZGFuIEhp
Z2dpbnMgPGJyZW5kYW5oaWdnaW5zQGdvb2dsZS5jb20+Cj4gK0w6CWxpbnV4LWtzZWxmdGVzdEB2
Z2VyLmtlcm5lbC5vcmcKPiArTDoJa3VuaXQtZGV2QGdvb2dsZWdyb3Vwcy5jb20KPiArVzoJaHR0
cHM6Ly9nb29nbGUuZ2l0aHViLmlvL2t1bml0LWRvY3MvdGhpcmRfcGFydHkva2VybmVsL2RvY3Mv
Cj4gK1M6CU1haW50YWluZWQKPiArRjoJRG9jdW1lbnRhdGlvbi9kZXYtdG9vbHMva3VuaXQvCj4g
K0Y6CWluY2x1ZGUva3VuaXQvCj4gK0Y6CWt1bml0Lwo+ICtGOgl0b29scy90ZXN0aW5nL2t1bml0
Lwo+ICsKPiAgIEtFUk5FTCBVU0VSTU9ERSBIRUxQRVIKPiAgIE06CUx1aXMgQ2hhbWJlcmxhaW4g
PG1jZ3JvZkBrZXJuZWwub3JnPgo+ICAgTDoJbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwo+
IAoKVGhhbmtzIEJyZW5kYW4uCgpJIGFtIGdvb2Qgd2l0aCB0aGlzLiBJIGNhbiB0YWtlIEtVbml0
IHBhdGNoZXMgdGhyb3VnaCBrc2VsZnRlc3QKd2l0aCB5b3VyIEFjay4KCnRoYW5rcywKLS0gU2h1
YWgKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRl
dmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
