Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
 [209.85.210.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41657211A2DB2
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jul 2019 13:57:16 -0700 (PDT)
Received: by mail-pf1-f194.google.com with SMTP id d126so45374pfd.2
 for <linux-nvdimm@lists.01.org>; Tue, 02 Jul 2019 13:57:16 -0700 (PDT)
Date: Tue, 2 Jul 2019 20:57:12 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v5 07/18] kunit: test: add initial tests
Message-ID: <20190702205712.GS19023@42.do-not-panic.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-8-brendanhiggins@google.com>
 <20190625232249.GS19023@42.do-not-panic.com>
 <CAFd5g46mnd=a0OqFCx0hOHX+DxW+5yA2LXH5Q0gEg8yUZK=4FA@mail.gmail.com>
 <CAFd5g46=7OQDREdLDTiMgVWq-Xj2zfOw8cRhPJEihSbO89MDyA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFd5g46=7OQDREdLDTiMgVWq-Xj2zfOw8cRhPJEihSbO89MDyA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Poimboeuf <jpoimboe@redhat.com>, kunit-dev@googlegroups.com, Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Stephen Boyd <sboyd@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 02, 2019 at 10:52:50AM -0700, Brendan Higgins wrote:
> On Wed, Jun 26, 2019 at 12:53 AM Brendan Higgins
> <brendanhiggins@google.com> wrote:
> >
> > On Tue, Jun 25, 2019 at 4:22 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Mon, Jun 17, 2019 at 01:26:02AM -0700, Brendan Higgins wrote:
> > > > diff --git a/kunit/example-test.c b/kunit/example-test.c
> > > > new file mode 100644
> > > > index 0000000000000..f44b8ece488bb
> > > > --- /dev/null
> > > > +++ b/kunit/example-test.c
> > >
> > > <-- snip -->
> > >
> > > > +/*
> > > > + * This defines a suite or grouping of tests.
> > > > + *
> > > > + * Test cases are defined as belonging to the suite by adding them to
> > > > + * `kunit_cases`.
> > > > + *
> > > > + * Often it is desirable to run some function which will set up things which
> > > > + * will be used by every test; this is accomplished with an `init` function
> > > > + * which runs before each test case is invoked. Similarly, an `exit` function
> > > > + * may be specified which runs after every test case and can be used to for
> > > > + * cleanup. For clarity, running tests in a test module would behave as follows:
> > > > + *
> > >
> > > To be clear this is not the kernel module init, but rather the kunit
> > > module init. I think using kmodule would make this clearer to a reader.
> >
> > Seems reasonable. Will fix in next revision.
> >
> > > > + * module.init(test);
> > > > + * module.test_case[0](test);
> > > > + * module.exit(test);
> > > > + * module.init(test);
> > > > + * module.test_case[1](test);
> > > > + * module.exit(test);
> > > > + * ...;
> > > > + */
> 
> Do you think it might be clearer yet to rename `struct kunit_module
> *module;` to `struct kunit_suite *suite;`?

Yes. Definitely. Or struct kunit_test. Up to you.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
