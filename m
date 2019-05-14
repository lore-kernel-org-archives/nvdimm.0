From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v3 08/18] objtool: add kunit_try_catch_throw to the
 noreturn list
Date: Tue, 14 May 2019 01:12:23 -0700
Message-ID: <20190514081223.GA230665@google.com>
References: <20190514054251.186196-1-brendanhiggins@google.com>
 <20190514054251.186196-9-brendanhiggins@google.com>
 <20190514065643.GC2589@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190514065643.GC2589@hirez.programming.kicks-ass.net>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, yamada.masahiro@socionext.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, shuah@kernel.org, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, frowand.list@gmail.com, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, Josh Poimboeuf <jpoimboe@redhat.com>, dan.j.williams@intel.com, kunit-dev@googlegroups.com, tytso@mit.edu, richard@nod.at, sboyd@kernel.org, gregkh@linuxfoundation.org, rdunlap@infradead.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, keescook@google.
List-Id: linux-nvdimm@lists.01.org

T24gVHVlLCBNYXkgMTQsIDIwMTkgYXQgMDg6NTY6NDNBTSArMDIwMCwgUGV0ZXIgWmlqbHN0cmEg
d3JvdGU6Cj4gT24gTW9uLCBNYXkgMTMsIDIwMTkgYXQgMTA6NDI6NDJQTSAtMDcwMCwgQnJlbmRh
biBIaWdnaW5zIHdyb3RlOgo+ID4gVGhpcyBmaXhlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgc2Vl
biBvbiBHQ0MgNy4zOgo+ID4gICBrdW5pdC90ZXN0LXRlc3Qubzogd2FybmluZzogb2JqdG9vbDog
a3VuaXRfdGVzdF91bnN1Y2Nlc3NmdWxfdHJ5KCkgZmFsbHMgdGhyb3VnaCB0byBuZXh0IGZ1bmN0
aW9uIGt1bml0X3Rlc3RfY2F0Y2goKQo+ID4gCj4gCj4gV2hhdCBpcyB0aGF0IGZpbGUgYW5kIGZ1
bmN0aW9uOyBubyBrZXJuZWwgdHJlZSBuZWFyIG1lIHNlZW1zIHRvIGhhdmUKPiB0aGF0LgoKT2gs
IHNvcnJ5IGFib3V0IHRoYXQuIFRoZSBmdW5jdGlvbiBpcyBhZGRlZCBpbiB0aGUgZm9sbG93aW5n
IHBhdGNoLAoiW1BBVENIIHYzIDA5LzE4XSBrdW5pdDogdGVzdDogYWRkIHN1cHBvcnQgZm9yIHRl
c3QgYWJvcnQiWzFdLgoKTXkgYXBvbG9naWVzIGlmIHRoaXMgcGF0Y2ggaXMgc3VwcG9zZWQgdG8g
Y29tZSBhZnRlciBpdCBpbiBzZXF1ZW5jZSwgYnV0CkkgYXNzdW1lZCBpdCBzaG91bGQgY29tZSBi
ZWZvcmUgb3RoZXJ3aXNlIG9ianRvb2wgd291bGQgY29tcGxhaW4gYWJvdXQKdGhlIHN5bWJvbCB3
aGVuIGl0IGlzIGludHJvZHVjZWQuCgpUaGFua3MhCgpbMV0gaHR0cHM6Ly9sa21sLm9yZy9sa21s
LzIwMTkvNS8xNC80NApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2
ZWw=
