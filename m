From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v9 01/18] kunit: test: add KUnit test runner core
Date: Mon, 15 Jul 2019 14:25:45 -0700
Message-ID: <CAFd5g44kWHYceo85qxL98JKH2FYBwVLFuLzqNR+APpMC1aKWUQ@mail.gmail.com>
References: <20190712081744.87097-1-brendanhiggins@google.com>
 <20190712081744.87097-2-brendanhiggins@google.com> <20190715201054.C69AA2086C@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190715201054.C69AA2086C@mail.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rob Herring <robh@kernel.org>, shuah <shuah@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Masahiro Yamada <yamada.masahiro@socionext.com>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, open list:KERNEL SELFTEST FRAMEWORK
List-Id: linux-nvdimm@lists.01.org

On Mon, Jul 15, 2019 at 1:10 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Brendan Higgins (2019-07-12 01:17:27)
> > Add core facilities for defining unit tests; this provides a common way
> > to define test cases, functions that execute code which is under test
> > and determine whether the code under test behaves as expected; this also
> > provides a way to group together related test cases in test suites (here
> > we call them test_modules).
> >
> > Just define test cases and how to execute them for now; setting
> > expectations on code will be defined later.
> >
> > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>
> Reviewed-by: Stephen Boyd <sboyd@kernel.org>
>
> Minor nits below.
>
> > diff --git a/kunit/test.c b/kunit/test.c
> > new file mode 100644
> > index 0000000000000..571e4c65deb5c
> > --- /dev/null
> > +++ b/kunit/test.c
> > @@ -0,0 +1,189 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Base unit test (KUnit) API.
> > + *
> > + * Copyright (C) 2019, Google LLC.
> > + * Author: Brendan Higgins <brendanhiggins@google.com>
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <kunit/test.h>
> > +
> > +static void kunit_set_failure(struct kunit *test)
> > +{
> > +       WRITE_ONCE(test->success, false);
> > +}
> > +
> [...]
> > +
> > +void kunit_init_test(struct kunit *test, const char *name)
> > +{
> > +       test->name = name;
> > +       test->success = true;
> > +}
> > +
> > +/*
> > + * Performs all logic to run a test case.
> > + */
> > +static void kunit_run_case(struct kunit_suite *suite,
> > +                          struct kunit_case *test_case)
> > +{
> > +       struct kunit test;
> > +       int ret = 0;
> > +
> > +       kunit_init_test(&test, test_case->name);
> > +
> > +       if (suite->init) {
> > +               ret = suite->init(&test);
>
> Can you push the ret definition into this if scope? That way we can
> avoid default initialize to 0 for it.

Sure! I would actually prefer that from a cosmetic standpoint. I just
thought that mixing declarations and code was against the style guide.

> > +               if (ret) {
> > +                       kunit_err(&test, "failed to initialize: %d\n", ret);
> > +                       kunit_set_failure(&test);
>
> Do we need to 'test_case->success = test.success' here too? Or is the
> test failure extracted somewhere else?

Er, yes. That's kind of embarrassing. Good catch.

> > +                       return;
> > +               }
> > +       }
> > +
> > +       test_case->run_case(&test);
> > +
> > +       if (suite->exit)
> > +               suite->exit(&test);
> > +
> > +       test_case->success = test.success;

Thanks!
