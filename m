From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Thu, 28 Feb 2019 16:54:03 +0300
Message-ID: <20190228135403.GD9806@kadam>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <155121334527.260864.5324117081460979741@swboyd.mtv.corp.google.com>
 <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com>
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
Cc: brakmo@fb.com, Petr Mladek <pmladek@suse.com>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, "Bird, Timothy" <Tim.Bird@sony.com>, devicetree <devicetree@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Dan Williams <dan.j.williams@intel.com>, kunit-dev@googlegroups.com, Stephen Boyd <sboyd@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Linux
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCBGZWIgMjgsIDIwMTkgYXQgMDE6MDM6MjRBTSAtMDgwMCwgQnJlbmRhbiBIaWdnaW5z
IHdyb3RlOgo+IHlvdSBjb3VsZCBkbzoKPiAKPiBpZiAoSVNfRVJSX09SX05VTEwocHRyKSkgewo+
ICAgICAgICAgS1VOSVRfRkFJTCh0ZXN0LCAicHRyIGlzIGFuIGVycm5vIG9yIG51bGw6ICVsZCIs
IHB0cik7Cj4gICAgICAgICByZXR1cm47Cj4gfQoKSXQncyBiZXN0IHRvIG5vdCBtaXggZXJyb3Ig
cG9pbnRlcnMgYW5kIE5VTEwgYnV0IHdoZW4gd2UgZG8gbWl4IHRoZW0sCml0IG1lYW5zIHRoYXQg
TlVMTCBpcyBhIHNwZWNpYWwga2luZCBvZiBzdWNjZXNzLiAgTGlrZSB3ZSB0cnkgdG8gbG9hZAph
IGZlYXR1cmUgYW5kIHdlIGdldCBiYWNrOgoKICAgIHZhbGlkIHBvaW50ZXIgPC0tIHN1Y2Nlc3MK
ICAgIG51bGwgICAgICAgICAgPC0tIGZlYXR1cmUgaXMgZGlzYWJsZWQuICBub3QgYW4gZXJyb3Iu
CiAgICBlcnJvciBwb2ludGVyIDwtLSBmZWF0dXJlIGlzIGJyb2tlbi4gIGZhaWwuCgpyZWdhcmRz
LApkYW4gY2FycGVudGVyCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9w
Lm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1k
ZXZlbA==
