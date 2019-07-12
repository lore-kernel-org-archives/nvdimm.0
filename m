From: Brendan Higgins <brendanhiggins@google.com>
Subject: [PATCH v9 08/18] objtool: add kunit_try_catch_throw to the noreturn
 list
Date: Fri, 12 Jul 2019 01:17:34 -0700
Message-ID: <20190712081744.87097-9-brendanhiggins@google.com>
References: <20190712081744.87097-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190712081744.87097-1-brendanhiggins@google.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, rdunlap@infradead.org, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, linux-fsdevel@vger.kernel.org, logang@deltatee.com
List-Id: linux-nvdimm@lists.01.org

Rml4IHRoZSBmb2xsb3dpbmcgd2FybmluZyBzZWVuIG9uIEdDQyA3LjM6CiAga3VuaXQvdGVzdC10
ZXN0Lm86IHdhcm5pbmc6IG9ianRvb2w6IGt1bml0X3Rlc3RfdW5zdWNjZXNzZnVsX3RyeSgpIGZh
bGxzIHRocm91Z2ggdG8gbmV4dCBmdW5jdGlvbiBrdW5pdF90ZXN0X2NhdGNoKCkKCmt1bml0X3Ry
eV9jYXRjaF90aHJvdyBpcyBhIGZ1bmN0aW9uIGFkZGVkIGluIHRoZSBmb2xsb3dpbmcgcGF0Y2gg
aW4gdGhpcwpzZXJpZXM7IGl0IGFsbG93cyBLVW5pdCwgYSB1bml0IHRlc3RpbmcgZnJhbWV3b3Jr
IGZvciB0aGUga2VybmVsLCB0bwpiYWlsIG91dCBvZiBhIGJyb2tlbiB0ZXN0LiBBcyBhIGNvbnNl
cXVlbmNlLCBpdCBpcyBhIG5ldyBfX25vcmV0dXJuCmZ1bmN0aW9uIHRoYXQgb2JqdG9vbCB0aGlu
a3MgaXMgYnJva2VuIChhcyBzZWVuIGFib3ZlKS4gU28gZml4IHRoaXMKd2FybmluZyBieSBhZGRp
bmcga3VuaXRfdHJ5X2NhdGNoX3Rocm93IHRvIG9ianRvb2wncyBub3JldHVybiBsaXN0LgoKUmVw
b3J0ZWQtYnk6IGtidWlsZCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5
OiBCcmVuZGFuIEhpZ2dpbnMgPGJyZW5kYW5oaWdnaW5zQGdvb2dsZS5jb20+CkFja2VkLWJ5OiBK
b3NoIFBvaW1ib2V1ZiA8anBvaW1ib2VAcmVkaGF0LmNvbT4KTGluazogaHR0cHM6Ly93d3cuc3Bp
bmljcy5uZXQvbGlzdHMvbGludXgta2J1aWxkL21zZzIxNzA4Lmh0bWwKQ2M6IFBldGVyIFppamxz
dHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KLS0tCiB0b29scy9vYmp0b29sL2NoZWNrLmMgfCAx
ICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL29i
anRvb2wvY2hlY2suYyBiL3Rvb2xzL29ianRvb2wvY2hlY2suYwppbmRleCAxNzJmOTkxOTU3MjY5
Li45OGRiNWZlODVjNzk3IDEwMDY0NAotLS0gYS90b29scy9vYmp0b29sL2NoZWNrLmMKKysrIGIv
dG9vbHMvb2JqdG9vbC9jaGVjay5jCkBAIC0xMzQsNiArMTM0LDcgQEAgc3RhdGljIGludCBfX2Rl
YWRfZW5kX2Z1bmN0aW9uKHN0cnVjdCBvYmp0b29sX2ZpbGUgKmZpbGUsIHN0cnVjdCBzeW1ib2wg
KmZ1bmMsCiAJCSJ1c2VyY29weV9hYm9ydCIsCiAJCSJtYWNoaW5lX3JlYWxfcmVzdGFydCIsCiAJ
CSJyZXdpbmRfc3RhY2tfZG9fZXhpdCIsCisJCSJrdW5pdF90cnlfY2F0Y2hfdGhyb3ciLAogCX07
CiAKIAlpZiAoZnVuYy0+YmluZCA9PSBTVEJfV0VBSykKLS0gCjIuMjIuMC40MTAuZ2Q4ZmRiZTIx
YjUtZ29vZwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
ZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0
dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
