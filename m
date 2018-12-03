From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v3 07/19] kunit: test: add initial tests
Date: Mon, 3 Dec 2018 15:26:26 -0800
Message-ID: <CAFd5g47CJnfE3Gqc03onidd5FiZSW43-6_dA5czb30-Rb3dyfg@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-8-brendanhiggins@google.com> <20181130034001.GM18410@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130034001.GM18410@garbanzo.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mcgrof@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Nov 29, 2018 at 7:40 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Nov 28, 2018 at 11:36:24AM -0800, Brendan Higgins wrote:
> > Add a test for string stream along with a simpler example.
> >
> > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > ---
> >  kunit/Kconfig              | 12 ++++++
> >  kunit/Makefile             |  4 ++
> >  kunit/example-test.c       | 88 ++++++++++++++++++++++++++++++++++++++
>
> BTW if you need another more concrete but very simple example I think it
> may be possible to port tools/testing/selftests/sysctl/sysctl.sh +
> lib/test_sysctl.c into a kunit test. Correct me if I'm wrong.

I think that is pretty doable. I don't know that I want to shoot for
that on the next revision. But I can definitely do it in a later
revision, or a later patchset, unless you would strongly prefer it
now, that is.

>
> I think that would show the differences clearly between selftests and
> kunit as well.

True. Maybe a good thing to shoot for once the DT tests are in order?
