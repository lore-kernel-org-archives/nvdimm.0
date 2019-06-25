From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 01/18] kunit: test: add KUnit test runner core
Date: Tue, 25 Jun 2019 13:28:25 -0700
Message-ID: <CAFd5g46Jhxsz6_VXHEVYvTeDRwwzgKpr=aUWLL5b3S4kUukb8g@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-2-brendanhiggins@google.com>
 <20190620001526.93426218BE@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190620001526.93426218BE-+nuXSHJNwjE76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 19, 2019 at 5:15 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-06-17 01:25:56)
> > diff --git a/kunit/test.c b/kunit/test.c
> > new file mode 100644
> > index 0000000000000..d05d254f1521f
> > --- /dev/null
> > +++ b/kunit/test.c
> > @@ -0,0 +1,210 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Base unit test (KUnit) API.
> > + *
> > + * Copyright (C) 2019, Google LLC.
> > + * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > + */
> > +
> > +#include <linux/sched/debug.h>
> > +#include <kunit/test.h>
> > +
> > +static bool kunit_get_success(struct kunit *test)
> > +{
> > +       unsigned long flags;
> > +       bool success;
> > +
> > +       spin_lock_irqsave(&test->lock, flags);
> > +       success = test->success;
> > +       spin_unlock_irqrestore(&test->lock, flags);
>
> I still don't understand the locking scheme in this code. Is the
> intention to make getter and setter APIs that are "safe" by adding in a
> spinlock that is held around getting and setting various members in the
> kunit structure?

Yes, your understanding is correct. It is possible for a user to write
a test such that certain elements may be updated in different threads;
this would most likely happen in the case where someone wants to make
an assertion or an expectation in a thread created by a piece of code
under test. Although this should generally be avoided, it is possible,
and there are occasionally good reasons to do so, so it is
functionality that we should support.

Do you think I should add a comment to this effect?

> In what situation is there more than one thread reading or writing the
> kunit struct? Isn't it only a single process that is going to be

As I said above, it is possible that the code under test may spawn a
new thread that may make an expectation or an assertion. It is not a
super common use case, but it is possible.

> operating on this structure? And why do we need to disable irqs? Are we
> expecting to be modifying the unit tests from irq contexts?

There are instances where someone may want to test a driver which has
an interrupt handler in it. I actually have (not the greatest) example
here. Now in these cases, I expect someone to use a mock irqchip or
some other fake mechanism to trigger the interrupt handler and not
actual hardware; technically speaking in this case, it is not going to
be accessed from a "real" irq context; however, the code under test
should think that it is in an irq context; given that, I figured it is
best to just treat it as a real irq context. Does that make sense?

> > +
> > +       return success;
> > +}
> > +
> > +static void kunit_set_success(struct kunit *test, bool success)
> > +{
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&test->lock, flags);
> > +       test->success = success;
> > +       spin_unlock_irqrestore(&test->lock, flags);
> > +}
> > +
> > +static int kunit_vprintk_emit(int level, const char *fmt, va_list args)
> > +{
> > +       return vprintk_emit(0, level, NULL, 0, fmt, args);
> > +}
> > +
> > +static int kunit_printk_emit(int level, const char *fmt, ...)
> > +{
> > +       va_list args;
> > +       int ret;
> > +
> > +       va_start(args, fmt);
> > +       ret = kunit_vprintk_emit(level, fmt, args);
> > +       va_end(args);
> > +
> > +       return ret;
> > +}
> > +
> > +static void kunit_vprintk(const struct kunit *test,
> > +                         const char *level,
> > +                         struct va_format *vaf)
> > +{
> > +       kunit_printk_emit(level[1] - '0', "\t# %s: %pV", test->name, vaf);
> > +}
> > +
> > +static bool kunit_has_printed_tap_version;
>
> Can you please move this into function local scope in the function
> below?

Sure, that makes sense.

> > +
> > +static void kunit_print_tap_version(void)
> > +{
> > +       if (!kunit_has_printed_tap_version) {
> > +               kunit_printk_emit(LOGLEVEL_INFO, "TAP version 14\n");
> > +               kunit_has_printed_tap_version = true;
> > +       }
> > +}
> > +
> [...]
> > +
> > +static bool kunit_module_has_succeeded(struct kunit_module *module)
> > +{
> > +       const struct kunit_case *test_case;
> > +       bool success = true;
> > +
> > +       for (test_case = module->test_cases; test_case->run_case; test_case++)
> > +               if (!test_case->success) {
> > +                       success = false;
> > +                       break;
>
> Why not 'return false'?

Also a good point. Will fix.

> > +               }
> > +
> > +       return success;
>
> And 'return true'?

Will fix.

> > +}
> > +
> > +static size_t kunit_module_counter = 1;
> > +
> > +static void kunit_print_subtest_end(struct kunit_module *module)
> > +{
> > +       kunit_print_ok_not_ok(false,
> > +                             kunit_module_has_succeeded(module),
> > +                             kunit_module_counter++,
> > +                             module->name);
> > +}
> > +
> > +static void kunit_print_test_case_ok_not_ok(struct kunit_case *test_case,
> > +                                           size_t test_number)
> > +{
> > +       kunit_print_ok_not_ok(true,
> > +                             test_case->success,
> > +                             test_number,
> > +                             test_case->name);
> > +}
> > +
> > +void kunit_init_test(struct kunit *test, const char *name)
> > +{
> > +       spin_lock_init(&test->lock);
> > +       test->name = name;
> > +       test->success = true;
> > +}
> > +
> > +/*
> > + * Performs all logic to run a test case.
> > + */
> > +static void kunit_run_case(struct kunit_module *module,
> > +                          struct kunit_case *test_case)
> > +{
> > +       struct kunit test;
> > +       int ret = 0;
> > +
> > +       kunit_init_test(&test, test_case->name);
> > +
> > +       if (module->init) {
> > +               ret = module->init(&test);
> > +               if (ret) {
> > +                       kunit_err(&test, "failed to initialize: %d\n", ret);
> > +                       kunit_set_success(&test, false);
> > +                       return;
> > +               }
> > +       }
> > +
> > +       if (!ret)
> > +               test_case->run_case(&test);
>
> Do we need this if condition? ret can only be set to non-zero above but
> then we'll exit the function early so it seems unnecessary. Given that,
> ret should probably be moved into the module->init path.

Whoops. Sorry, another instance of how it evolved over time and I
forgot why I did the check. Will fix.

> > +
> > +       if (module->exit)
> > +               module->exit(&test);
> > +
> > +       test_case->success = kunit_get_success(&test);
> > +}
> > +

Thanks!
