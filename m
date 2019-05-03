From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v2 15/17] MAINTAINERS: add entry for KUnit the unit
 testing framework
Date: Fri, 3 May 2019 08:38:21 -0600
Message-ID: <68f88e1c-d40f-9dad-7296-ab2b2303c575@kernel.org>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-16-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190501230126.229218-16-brendanhiggins@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, frowand.list@gmail.com, gregkh@linuxfoundation.org, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, shuah <shuah@kernel.org>, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, Shuah Khan <skhan@linuxfoundation.org>, dan.j.williams@intel.com, kunit-dev@googlegroups.com, richard@nod.at, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, linux-fsdevel@vger.kernel.org, logang@deltatee.com
List-Id: linux-nvdimm@lists.01.org

T24gNS8xLzE5IDU6MDEgUE0sIEJyZW5kYW4gSGlnZ2lucyB3cm90ZToKPiBBZGQgbXlzZWxmIGFz
IG1haW50YWluZXIgb2YgS1VuaXQsIHRoZSBMaW51eCBrZXJuZWwncyB1bml0IHRlc3RpbmcKPiBm
cmFtZXdvcmsuCj4gCj4gU2lnbmVkLW9mZi1ieTogQnJlbmRhbiBIaWdnaW5zIDxicmVuZGFuaGln
Z2luc0Bnb29nbGUuY29tPgo+IC0tLQo+ICAgTUFJTlRBSU5FUlMgfCAxMCArKysrKysrKysrCj4g
ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9NQUlO
VEFJTkVSUyBiL01BSU5UQUlORVJTCj4gaW5kZXggNWMzOGYyMWFlZTc4Ny4uYzc4YWU5NWM1NmI4
MCAxMDA2NDQKPiAtLS0gYS9NQUlOVEFJTkVSUwo+ICsrKyBiL01BSU5UQUlORVJTCj4gQEAgLTg0
NDgsNiArODQ0OCwxNiBAQCBTOglNYWludGFpbmVkCj4gICBGOgl0b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy8KPiAgIEY6CURvY3VtZW50YXRpb24vZGV2LXRvb2xzL2tzZWxmdGVzdCoKPiAgIAo+ICtL
RVJORUwgVU5JVCBURVNUSU5HIEZSQU1FV09SSyAoS1VuaXQpCj4gK006CUJyZW5kYW4gSGlnZ2lu
cyA8YnJlbmRhbmhpZ2dpbnNAZ29vZ2xlLmNvbT4KPiArTDoJa3VuaXQtZGV2QGdvb2dsZWdyb3Vw
cy5jb20KPiArVzoJaHR0cHM6Ly9nb29nbGUuZ2l0aHViLmlvL2t1bml0LWRvY3MvdGhpcmRfcGFy
dHkva2VybmVsL2RvY3MvCj4gK1M6CU1haW50YWluZWQKPiArRjoJRG9jdW1lbnRhdGlvbi9rdW5p
dC8KPiArRjoJaW5jbHVkZS9rdW5pdC8KPiArRjoJa3VuaXQvCj4gK0Y6CXRvb2xzL3Rlc3Rpbmcv
a3VuaXQvCj4gKwoKUGxlYXNlIGFkZCBrc2VsZnRlc3QgbWFpbGluZyBsaXN0IHRvIHRoaXMgZW50
cnksIGJhc2VkIG9uIG91cgpjb252ZXJzYXRpb24gb24gdGFraW5nIHRoZXNlIHBhdGNoZXMgdGhy
b3VnaCBrc2VsZnRlc3QgdHJlZS4KCnRoYW5rcywKLS0gU2h1YWgKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmkt
ZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
L21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
