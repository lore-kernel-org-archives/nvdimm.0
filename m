Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CC6E20D7B8F7
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 22:44:27 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id s22so11437658pfh.4
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 22:44:27 -0800 (PST)
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <da1995fa-a362-dfe6-8184-7fcdf2b923e8@gmail.com>
 <CAFd5g467OV8wTB7zEshgZw8g8=zoq0dLVfwx3wDH-8UA+9GWFA@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <0124ed28-466c-e954-ddde-495419630a9f@gmail.com>
Date: Tue, 19 Feb 2019 22:44:23 -0800
MIME-Version: 1.0
In-Reply-To: <CAFd5g467OV8wTB7zEshgZw8g8=zoq0dLVfwx3wDH-8UA+9GWFA@mail.gmail.com>
Content-Language: en-US
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
Cc: brakmo@fb.com, Petr Mladek <pmladek@suse.com>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, dan.carpenter@oracle.com, devicetree <devicetree@vger.kernel.org>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On 2/19/19 7:39 PM, Brendan Higgins wrote:
> On Mon, Feb 18, 2019 at 11:52 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>
>> On 2/14/19 1:37 PM, Brendan Higgins wrote:
>>> Add support for aborting/bailing out of test cases. Needed for
>>> implementing assertions.
>>>
>>> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
>>> ---
>>> Changes Since Last Version
>>>  - This patch is new introducing a new cross-architecture way to abort
>>>    out of a test case (needed for KUNIT_ASSERT_*, see next patch for
>>>    details).
>>>  - On a side note, this is not a complete replacement for the UML abort
>>>    mechanism, but covers the majority of necessary functionality. UML
>>>    architecture specific featurs have been dropped from the initial
>>>    patchset.
>>> ---
>>>  include/kunit/test.h |  24 +++++
>>>  kunit/Makefile       |   3 +-
>>>  kunit/test-test.c    | 127 ++++++++++++++++++++++++++
>>>  kunit/test.c         | 208 +++++++++++++++++++++++++++++++++++++++++--
>>>  4 files changed, 353 insertions(+), 9 deletions(-)
>>>  create mode 100644 kunit/test-test.c
>>
>> < snip >
>>
>>> diff --git a/kunit/test.c b/kunit/test.c
>>> index d18c50d5ed671..6e5244642ab07 100644
>>> --- a/kunit/test.c
>>> +++ b/kunit/test.c
>>> @@ -6,9 +6,9 @@
>>>   * Author: Brendan Higgins <brendanhiggins@google.com>
>>>   */
>>>
>>> -#include <linux/sched.h>
>>>  #include <linux/sched/debug.h>
>>> -#include <os.h>
>>> +#include <linux/completion.h>
>>> +#include <linux/kthread.h>
>>>  #include <kunit/test.h>
>>>
>>>  static bool kunit_get_success(struct kunit *test)
>>> @@ -32,6 +32,27 @@ static void kunit_set_success(struct kunit *test, bool success)
>>>       spin_unlock_irqrestore(&test->lock, flags);
>>>  }
>>>
>>> +static bool kunit_get_death_test(struct kunit *test)
>>> +{
>>> +     unsigned long flags;
>>> +     bool death_test;
>>> +
>>> +     spin_lock_irqsave(&test->lock, flags);
>>> +     death_test = test->death_test;
>>> +     spin_unlock_irqrestore(&test->lock, flags);
>>> +
>>> +     return death_test;
>>> +}
>>> +
>>> +static void kunit_set_death_test(struct kunit *test, bool death_test)
>>> +{
>>> +     unsigned long flags;
>>> +
>>> +     spin_lock_irqsave(&test->lock, flags);
>>> +     test->death_test = death_test;
>>> +     spin_unlock_irqrestore(&test->lock, flags);
>>> +}
>>> +
>>>  static int kunit_vprintk_emit(const struct kunit *test,
>>>                             int level,
>>>                             const char *fmt,
>>> @@ -70,13 +91,29 @@ static void kunit_fail(struct kunit *test, struct kunit_stream *stream)
>>>       stream->commit(stream);
>>>  }
>>>
>>> +static void __noreturn kunit_abort(struct kunit *test)
>>> +{
>>> +     kunit_set_death_test(test, true);
>>> +
>>> +     test->try_catch.throw(&test->try_catch);
>>> +
>>> +     /*
>>> +      * Throw could not abort from test.
>>> +      */
>>> +     kunit_err(test, "Throw could not abort from test!");
>>> +     show_stack(NULL, NULL);
>>> +     BUG();
>>
>> kunit_abort() is what will be call as the result of an assert failure.
> 
> Yep. Does that need clarified somewhere.
>>
>> BUG(), which is a panic, which is crashing the system is not acceptable
>> in the Linux kernel.  You will just annoy Linus if you submit this.
> 
> Sorry, I thought this was an acceptable use case since, a) this should
> never be compiled in a production kernel, b) we are in a pretty bad,
> unpredictable state if we get here and keep going. I think you might
> have said elsewhere that you think "a" is not valid? In any case, I
> can replace this with a WARN, would that be acceptable?

A WARN may or may not make sense, depending on the context.  It may
be sufficient to simply report a test failure (as in the old version
of case (2) below.

Answers to "a)" and "b)":

a) it might be in a production kernel

a') it is not acceptable in my development kernel either

b) No.  You don't crash a developer's kernel either unless it is
required to avoid data corruption.

b') And you can not do replacements like:

(1) in of_unittest_check_tree_linkage()

-----  old  -----

        if (!of_root)
                return;

-----  new  -----

        KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_root);

(2) in of_unittest_property_string()

-----  old  -----

        /* of_property_read_string_index() tests */
        rc = of_property_read_string_index(np, "string-property", 0, strings);
        unittest(rc == 0 && !strcmp(strings[0], "foobar"), "of_property_read_string_index() failure; rc=%i\n", rc);

-----  new  -----

        /* of_property_read_string_index() tests */
        rc = of_property_read_string_index(np, "string-property", 0, strings);
        KUNIT_ASSERT_EQ(test, rc, 0);
        KUNIT_EXPECT_STREQ(test, strings[0], "foobar");


If a test fails, that is no reason to abort testing.  The remainder of the unit
tests can still run.  There may be cascading failures, but that is ok.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
