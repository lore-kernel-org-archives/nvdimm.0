From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Wed, 27 Feb 2019 23:42:33 -0800
Message-ID: <CAFd5g47EDmsBWKNiW0jpHW2VG_GWCfe8UO+=ofgM2_ru+_UBQA@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com> <da1995fa-a362-dfe6-8184-7fcdf2b923e8@gmail.com>
 <CAFd5g467OV8wTB7zEshgZw8g8=zoq0dLVfwx3wDH-8UA+9GWFA@mail.gmail.com> <0124ed28-466c-e954-ddde-495419630a9f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0124ed28-466c-e954-ddde-495419630a9f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Rowand <frowand.list@gmail.com>
Cc: Kees Cook <keescook@google.com>, Luis Chamberlain <mcgrof@kernel.org>, shuah@kernel.org, Rob Herring <robh@kernel.org>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Greg KH <gregkh@linuxfoundation.org>, Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, brakmo@fb.com, Steven Rostedt <rostedt@goodmis.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kevin Hilman <khilman@baylibre.com>, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel <dri-devel@lists.freedeskto>
List-Id: linux-nvdimm@lists.01.org

On Tue, Feb 19, 2019 at 10:44 PM Frank Rowand <frowand.list@gmail.com> wrote:
>
> On 2/19/19 7:39 PM, Brendan Higgins wrote:
> > On Mon, Feb 18, 2019 at 11:52 AM Frank Rowand <frowand.list@gmail.com> wrote:
> >>
> >> On 2/14/19 1:37 PM, Brendan Higgins wrote:
> >>> Add support for aborting/bailing out of test cases. Needed for
> >>> implementing assertions.
> >>>
> >>> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> >>> ---
> >>> Changes Since Last Version
> >>>  - This patch is new introducing a new cross-architecture way to abort
> >>>    out of a test case (needed for KUNIT_ASSERT_*, see next patch for
> >>>    details).
> >>>  - On a side note, this is not a complete replacement for the UML abort
> >>>    mechanism, but covers the majority of necessary functionality. UML
> >>>    architecture specific featurs have been dropped from the initial
> >>>    patchset.
> >>> ---
> >>>  include/kunit/test.h |  24 +++++
> >>>  kunit/Makefile       |   3 +-
> >>>  kunit/test-test.c    | 127 ++++++++++++++++++++++++++
> >>>  kunit/test.c         | 208 +++++++++++++++++++++++++++++++++++++++++--
> >>>  4 files changed, 353 insertions(+), 9 deletions(-)
> >>>  create mode 100644 kunit/test-test.c
> >>
> >> < snip >
> >>
> >>> diff --git a/kunit/test.c b/kunit/test.c
> >>> index d18c50d5ed671..6e5244642ab07 100644
> >>> --- a/kunit/test.c
> >>> +++ b/kunit/test.c
> >>> @@ -6,9 +6,9 @@
> >>>   * Author: Brendan Higgins <brendanhiggins@google.com>
> >>>   */
> >>>
> >>> -#include <linux/sched.h>
> >>>  #include <linux/sched/debug.h>
> >>> -#include <os.h>
> >>> +#include <linux/completion.h>
> >>> +#include <linux/kthread.h>
> >>>  #include <kunit/test.h>
> >>>
> >>>  static bool kunit_get_success(struct kunit *test)
> >>> @@ -32,6 +32,27 @@ static void kunit_set_success(struct kunit *test, bool success)
> >>>       spin_unlock_irqrestore(&test->lock, flags);
> >>>  }
> >>>
> >>> +static bool kunit_get_death_test(struct kunit *test)
> >>> +{
> >>> +     unsigned long flags;
> >>> +     bool death_test;
> >>> +
> >>> +     spin_lock_irqsave(&test->lock, flags);
> >>> +     death_test = test->death_test;
> >>> +     spin_unlock_irqrestore(&test->lock, flags);
> >>> +
> >>> +     return death_test;
> >>> +}
> >>> +
> >>> +static void kunit_set_death_test(struct kunit *test, bool death_test)
> >>> +{
> >>> +     unsigned long flags;
> >>> +
> >>> +     spin_lock_irqsave(&test->lock, flags);
> >>> +     test->death_test = death_test;
> >>> +     spin_unlock_irqrestore(&test->lock, flags);
> >>> +}
> >>> +
> >>>  static int kunit_vprintk_emit(const struct kunit *test,
> >>>                             int level,
> >>>                             const char *fmt,
> >>> @@ -70,13 +91,29 @@ static void kunit_fail(struct kunit *test, struct kunit_stream *stream)
> >>>       stream->commit(stream);
> >>>  }
> >>>
> >>> +static void __noreturn kunit_abort(struct kunit *test)
> >>> +{
> >>> +     kunit_set_death_test(test, true);
> >>> +
> >>> +     test->try_catch.throw(&test->try_catch);
> >>> +
> >>> +     /*
> >>> +      * Throw could not abort from test.
> >>> +      */
> >>> +     kunit_err(test, "Throw could not abort from test!");
> >>> +     show_stack(NULL, NULL);
> >>> +     BUG();
> >>
> >> kunit_abort() is what will be call as the result of an assert failure.
> >
> > Yep. Does that need clarified somewhere.
> >>
> >> BUG(), which is a panic, which is crashing the system is not acceptable
> >> in the Linux kernel.  You will just annoy Linus if you submit this.
> >
> > Sorry, I thought this was an acceptable use case since, a) this should
> > never be compiled in a production kernel, b) we are in a pretty bad,
> > unpredictable state if we get here and keep going. I think you might
> > have said elsewhere that you think "a" is not valid? In any case, I
> > can replace this with a WARN, would that be acceptable?
>
> A WARN may or may not make sense, depending on the context.  It may
> be sufficient to simply report a test failure (as in the old version
> of case (2) below.
>
> Answers to "a)" and "b)":
>
> a) it might be in a production kernel

Sorry for a possibly stupid question, how might it be so? Why would
someone intentionally build unit tests into a production kernel?

>
> a') it is not acceptable in my development kernel either

Fair enough.

>
> b) No.  You don't crash a developer's kernel either unless it is
> required to avoid data corruption.

Alright, I thought that was one of those cases, but I am not going to
push the point. Also, in case it wasn't clear, the path where BUG()
gets called only happens if there is a bug in KUnit itself, not just
because a test case fails catastrophically.

>
> b') And you can not do replacements like:
>
> (1) in of_unittest_check_tree_linkage()
>
> -----  old  -----
>
>         if (!of_root)
>                 return;
>
> -----  new  -----
>
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_root);
>
> (2) in of_unittest_property_string()
>
> -----  old  -----
>
>         /* of_property_read_string_index() tests */
>         rc = of_property_read_string_index(np, "string-property", 0, strings);
>         unittest(rc == 0 && !strcmp(strings[0], "foobar"), "of_property_read_string_index() failure; rc=%i\n", rc);
>
> -----  new  -----
>
>         /* of_property_read_string_index() tests */
>         rc = of_property_read_string_index(np, "string-property", 0, strings);
>         KUNIT_ASSERT_EQ(test, rc, 0);
>         KUNIT_EXPECT_STREQ(test, strings[0], "foobar");
>
>
> If a test fails, that is no reason to abort testing.  The remainder of the unit
> tests can still run.  There may be cascading failures, but that is ok.

Sure, that's what I am trying to do. I don't see how (1) changes
anything, a failed KUNIT_ASSERT_* only bails on the current test case,
it does not quit the entire test suite let alone crash the kernel.

In case it wasn't clear above,
> >>> +     test->try_catch.throw(&test->try_catch);
should never, ever return. The only time it would, would be if KUnit
was very broken. This should never actually happen, even if the
assertion that called it was violated. KUNIT_ASSERT_* just says, "this
is a prerequisite property for this test case"; if it is violated, the
test case should fail and bail because the preconditions for the test
case cannot be satisfied. Nevertheless, other tests cases will still
run.
