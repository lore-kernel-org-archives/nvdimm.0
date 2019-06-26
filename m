From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v5 01/18] kunit: test: add KUnit test runner core
Date: Wed, 26 Jun 2019 16:00:40 -0700
Message-ID: <CAFd5g46zHAupdUh3wDuqPJti2M+_=oje_5weFe7AVLQfkDDM6A@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-2-brendanhiggins@google.com> <20190620001526.93426218BE@mail.kernel.org>
 <CAFd5g46Jhxsz6_VXHEVYvTeDRwwzgKpr=aUWLL5b3S4kUukb8g@mail.gmail.com> <20190626034100.B238520883@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626034100.B238520883@mail.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rob Herring <robh@kernel.org>, shuah <shuah@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Masahiro Yamada <yamada.masahiro@socionext.com>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, open list:KERNEL SELFTEST FRAMEWORK
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 25, 2019 at 8:41 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Brendan Higgins (2019-06-25 13:28:25)
> > On Wed, Jun 19, 2019 at 5:15 PM Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > Quoting Brendan Higgins (2019-06-17 01:25:56)
> > > > diff --git a/kunit/test.c b/kunit/test.c
> > > > new file mode 100644
> > > > index 0000000000000..d05d254f1521f
> > > > --- /dev/null
> > > > +++ b/kunit/test.c
> > > > @@ -0,0 +1,210 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +/*
> > > > + * Base unit test (KUnit) API.
> > > > + *
> > > > + * Copyright (C) 2019, Google LLC.
> > > > + * Author: Brendan Higgins <brendanhiggins@google.com>
> > > > + */
> > > > +
> > > > +#include <linux/sched/debug.h>
> > > > +#include <kunit/test.h>
> > > > +
> > > > +static bool kunit_get_success(struct kunit *test)
> > > > +{
> > > > +       unsigned long flags;
> > > > +       bool success;
> > > > +
> > > > +       spin_lock_irqsave(&test->lock, flags);
> > > > +       success = test->success;
> > > > +       spin_unlock_irqrestore(&test->lock, flags);
> > >
> > > I still don't understand the locking scheme in this code. Is the
> > > intention to make getter and setter APIs that are "safe" by adding in a
> > > spinlock that is held around getting and setting various members in the
> > > kunit structure?
> >
> > Yes, your understanding is correct. It is possible for a user to write
> > a test such that certain elements may be updated in different threads;
> > this would most likely happen in the case where someone wants to make
> > an assertion or an expectation in a thread created by a piece of code
> > under test. Although this should generally be avoided, it is possible,
> > and there are occasionally good reasons to do so, so it is
> > functionality that we should support.
> >
> > Do you think I should add a comment to this effect?
>
> No, I think the locking should be removed.
>
> >
> > > In what situation is there more than one thread reading or writing the
> > > kunit struct? Isn't it only a single process that is going to be
> >
> > As I said above, it is possible that the code under test may spawn a
> > new thread that may make an expectation or an assertion. It is not a
> > super common use case, but it is possible.
>
> Sure, sounds super possible and OK.
>
> >
> > > operating on this structure? And why do we need to disable irqs? Are we
> > > expecting to be modifying the unit tests from irq contexts?
> >
> > There are instances where someone may want to test a driver which has
> > an interrupt handler in it. I actually have (not the greatest) example
> > here. Now in these cases, I expect someone to use a mock irqchip or
> > some other fake mechanism to trigger the interrupt handler and not
> > actual hardware; technically speaking in this case, it is not going to
> > be accessed from a "real" irq context; however, the code under test
> > should think that it is in an irq context; given that, I figured it is
> > best to just treat it as a real irq context. Does that make sense?
>
> Can you please describe the scenario in which grabbing the lock here,
> updating a single variable, and then releasing the lock right after
> does anything useful vs. not having the lock? I'm looking for a two CPU

Sure.

> scenario like below, but where it is a problem. There could be three
> CPUs, or even one CPU and three threads if you want to describe the
> extra thread scenario.
>
> Here's my scenario where it isn't needed:
>
>     CPU0                                      CPU1
>     ----                                      ----
>     kunit_run_test(&test)
>                                               test_case_func()
>                                                 ....
>                                               [mock hardirq]
>                                                 kunit_set_success(&test)
>                                               [hardirq ends]
>                                                 ...
>                                                 complete(&test_done)
>       wait_for_completion(&test_done)
>       kunit_get_success(&test)
>
> We don't need to care about having locking here because success or
> failure only happens in one place and it's synchronized with the
> completion.

Here is the scenario I am concerned about:

CPU0                      CPU1                       CPU2
----                      ----                       ----
kunit_run_test(&test)
                          test_case_func()
                            ....
                            schedule_work(foo_func)
                          [mock hardirq]             foo_func()
                            ...                        ...
                            kunit_set_success(false)   kunit_set_success(false)
                          [hardirq ends]               ...
                            ...
                            complete(&test_done)
  wait_for_completion(...)
  kunit_get_success(&test)

In my scenario, since both CPU1 and CPU2 update the success status of
the test simultaneously, even though they are setting it to the same
value. If my understanding is correct, this could result in a
write-tear on some architectures in some circumstances. I suppose we
could just make it an atomic boolean, but I figured locking is also
fine, and generally preferred.

Also, to be clear, I am onboard with dropping then IRQ stuff for now.
I am fine moving to a mutex for the time being.

>
> >
> > > > +
> > > > +       return success;
> > > > +}
> > > > +
> > > > +static void kunit_set_success(struct kunit *test, bool success)
> > > > +{
> > > > +       unsigned long flags;
> > > > +
> > > > +       spin_lock_irqsave(&test->lock, flags);
> > > > +       test->success = success;
> > > > +       spin_unlock_irqrestore(&test->lock, flags);
> > > > +}
