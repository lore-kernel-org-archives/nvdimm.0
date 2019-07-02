From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v5 07/18] kunit: test: add initial tests
Date: Tue, 2 Jul 2019 10:52:50 -0700
Message-ID: <CAFd5g46=7OQDREdLDTiMgVWq-Xj2zfOw8cRhPJEihSbO89MDyA@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-8-brendanhiggins@google.com> <20190625232249.GS19023@42.do-not-panic.com>
 <CAFd5g46mnd=a0OqFCx0hOHX+DxW+5yA2LXH5Q0gEg8yUZK=4FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFd5g46mnd=a0OqFCx0hOHX+DxW+5yA2LXH5Q0gEg8yUZK=4FA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Peter Zijlstra <peterz@infradead.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah <shuah@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Masahiro Yamada <yamada.masahiro@socionext.com>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-ks>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 26, 2019 at 12:53 AM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> On Tue, Jun 25, 2019 at 4:22 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Mon, Jun 17, 2019 at 01:26:02AM -0700, Brendan Higgins wrote:
> > > diff --git a/kunit/example-test.c b/kunit/example-test.c
> > > new file mode 100644
> > > index 0000000000000..f44b8ece488bb
> > > --- /dev/null
> > > +++ b/kunit/example-test.c
> >
> > <-- snip -->
> >
> > > +/*
> > > + * This defines a suite or grouping of tests.
> > > + *
> > > + * Test cases are defined as belonging to the suite by adding them to
> > > + * `kunit_cases`.
> > > + *
> > > + * Often it is desirable to run some function which will set up things which
> > > + * will be used by every test; this is accomplished with an `init` function
> > > + * which runs before each test case is invoked. Similarly, an `exit` function
> > > + * may be specified which runs after every test case and can be used to for
> > > + * cleanup. For clarity, running tests in a test module would behave as follows:
> > > + *
> >
> > To be clear this is not the kernel module init, but rather the kunit
> > module init. I think using kmodule would make this clearer to a reader.
>
> Seems reasonable. Will fix in next revision.
>
> > > + * module.init(test);
> > > + * module.test_case[0](test);
> > > + * module.exit(test);
> > > + * module.init(test);
> > > + * module.test_case[1](test);
> > > + * module.exit(test);
> > > + * ...;
> > > + */

Do you think it might be clearer yet to rename `struct kunit_module
*module;` to `struct kunit_suite *suite;`?
