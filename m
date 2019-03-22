From: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Thu, 21 Mar 2019 18:09:55 -0700
Message-ID: <118d89b7-d468-6d68-a48d-4d6d9cefd106@gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <da1995fa-a362-dfe6-8184-7fcdf2b923e8@gmail.com>
 <CAFd5g467OV8wTB7zEshgZw8g8=zoq0dLVfwx3wDH-8UA+9GWFA@mail.gmail.com>
 <0124ed28-466c-e954-ddde-495419630a9f@gmail.com>
 <CAFd5g47EDmsBWKNiW0jpHW2VG_GWCfe8UO+=ofgM2_ru+_UBQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g47EDmsBWKNiW0jpHW2VG_GWCfe8UO+=ofgM2_ru+_UBQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>Linux Kernel Mailing List <lin>
List-Id: linux-nvdimm@lists.01.org

On 2/27/19 11:42 PM, Brendan Higgins wrote:
> On Tue, Feb 19, 2019 at 10:44 PM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On 2/19/19 7:39 PM, Brendan Higgins wrote:
>>> On Mon, Feb 18, 2019 at 11:52 AM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>> On 2/14/19 1:37 PM, Brendan Higgins wrote:
>>>>> Add support for aborting/bailing out of test cases. Needed for
>>>>> implementing assertions.
>>>>>
>>>>> Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>> ---
>>>>> Changes Since Last Version
>>>>>  - This patch is new introducing a new cross-architecture way to abort
>>>>>    out of a test case (needed for KUNIT_ASSERT_*, see next patch for
>>>>>    details).
>>>>>  - On a side note, this is not a complete replacement for the UML abort
>>>>>    mechanism, but covers the majority of necessary functionality. UML
>>>>>    architecture specific featurs have been dropped from the initial
>>>>>    patchset.
>>>>> ---
>>>>>  include/kunit/test.h |  24 +++++
>>>>>  kunit/Makefile       |   3 +-
>>>>>  kunit/test-test.c    | 127 ++++++++++++++++++++++++++
>>>>>  kunit/test.c         | 208 +++++++++++++++++++++++++++++++++++++++++--
>>>>>  4 files changed, 353 insertions(+), 9 deletions(-)
>>>>>  create mode 100644 kunit/test-test.c
>>>>
>>>> < snip >
>>>>
>>>>> diff --git a/kunit/test.c b/kunit/test.c
>>>>> index d18c50d5ed671..6e5244642ab07 100644
>>>>> --- a/kunit/test.c
>>>>> +++ b/kunit/test.c
>>>>> @@ -6,9 +6,9 @@
>>>>>   * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>>>   */
>>>>>
>>>>> -#include <linux/sched.h>
>>>>>  #include <linux/sched/debug.h>
>>>>> -#include <os.h>
>>>>> +#include <linux/completion.h>
>>>>> +#include <linux/kthread.h>
>>>>>  #include <kunit/test.h>
>>>>>
>>>>>  static bool kunit_get_success(struct kunit *test)
>>>>> @@ -32,6 +32,27 @@ static void kunit_set_success(struct kunit *test, bool success)
>>>>>       spin_unlock_irqrestore(&test->lock, flags);
>>>>>  }
>>>>>
>>>>> +static bool kunit_get_death_test(struct kunit *test)
>>>>> +{
>>>>> +     unsigned long flags;
>>>>> +     bool death_test;
>>>>> +
>>>>> +     spin_lock_irqsave(&test->lock, flags);
>>>>> +     death_test = test->death_test;
>>>>> +     spin_unlock_irqrestore(&test->lock, flags);
>>>>> +
>>>>> +     return death_test;
>>>>> +}
>>>>> +
>>>>> +static void kunit_set_death_test(struct kunit *test, bool death_test)
>>>>> +{
>>>>> +     unsigned long flags;
>>>>> +
>>>>> +     spin_lock_irqsave(&test->lock, flags);
>>>>> +     test->death_test = death_test;
>>>>> +     spin_unlock_irqrestore(&test->lock, flags);
>>>>> +}
>>>>> +
>>>>>  static int kunit_vprintk_emit(const struct kunit *test,
>>>>>                             int level,
>>>>>                             const char *fmt,
>>>>> @@ -70,13 +91,29 @@ static void kunit_fail(struct kunit *test, struct kunit_stream *stream)
>>>>>       stream->commit(stream);
>>>>>  }
>>>>>
>>>>> +static void __noreturn kunit_abort(struct kunit *test)
>>>>> +{
>>>>> +     kunit_set_death_test(test, true);
>>>>> +
>>>>> +     test->try_catch.throw(&test->try_catch);
>>>>> +
>>>>> +     /*
>>>>> +      * Throw could not abort from test.
>>>>> +      */
>>>>> +     kunit_err(test, "Throw could not abort from test!");
>>>>> +     show_stack(NULL, NULL);
>>>>> +     BUG();
>>>>
>>>> kunit_abort() is what will be call as the result of an assert failure.
>>>
>>> Yep. Does that need clarified somewhere.
>>>>
>>>> BUG(), which is a panic, which is crashing the system is not acceptable
>>>> in the Linux kernel.  You will just annoy Linus if you submit this.
>>>
>>> Sorry, I thought this was an acceptable use case since, a) this should
>>> never be compiled in a production kernel, b) we are in a pretty bad,
>>> unpredictable state if we get here and keep going. I think you might
>>> have said elsewhere that you think "a" is not valid? In any case, I
>>> can replace this with a WARN, would that be acceptable?
>>
>> A WARN may or may not make sense, depending on the context.  It may
>> be sufficient to simply report a test failure (as in the old version
>> of case (2) below.
>>
>> Answers to "a)" and "b)":
>>
>> a) it might be in a production kernel
> 
> Sorry for a possibly stupid question, how might it be so? Why would
> someone intentionally build unit tests into a production kernel?

People do things.  Just expect it.


>>
>> a') it is not acceptable in my development kernel either
> 
> Fair enough.
> 
>>
>> b) No.  You don't crash a developer's kernel either unless it is
>> required to avoid data corruption.
> 
> Alright, I thought that was one of those cases, but I am not going to
> push the point. Also, in case it wasn't clear, the path where BUG()
> gets called only happens if there is a bug in KUnit itself, not just
> because a test case fails catastrophically.

Still not out of the woods.  Still facing Lions and Tigers and Bears,
Oh my!

So kunit_abort() is normally called as the result of an assert
failure (as written many lines further above).

kunit_abort()
   test->try_catch.throw(&test->try_catch)
   // this is really kunit_generic_throw(), yes?
      complete_and_exit()
         if (comp)
            // comp is test_case_completion?
            complete(comp)
         do_exit()
            // void __noreturn do_exit(long code)
            // depending on the task, either panic
            // or the task dies

I did not read through enough of the code to understand what is going
on here.  Is each kunit_module executed in a newly created thread?
And if kunit_abort() is called then that thread dies?  Or something
else?


>>
>> b') And you can not do replacements like:
>>
>> (1) in of_unittest_check_tree_linkage()
>>
>> -----  old  -----
>>
>>         if (!of_root)
>>                 return;
>>
>> -----  new  -----
>>
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_root);
>>
>> (2) in of_unittest_property_string()
>>
>> -----  old  -----
>>
>>         /* of_property_read_string_index() tests */
>>         rc = of_property_read_string_index(np, "string-property", 0, strings);
>>         unittest(rc == 0 && !strcmp(strings[0], "foobar"), "of_property_read_string_index() failure; rc=%i\n", rc);
>>
>> -----  new  -----
>>
>>         /* of_property_read_string_index() tests */
>>         rc = of_property_read_string_index(np, "string-property", 0, strings);
>>         KUNIT_ASSERT_EQ(test, rc, 0);
>>         KUNIT_EXPECT_STREQ(test, strings[0], "foobar");
>>
>>
>> If a test fails, that is no reason to abort testing.  The remainder of the unit
>> tests can still run.  There may be cascading failures, but that is ok.
> 
> Sure, that's what I am trying to do. I don't see how (1) changes
> anything, a failed KUNIT_ASSERT_* only bails on the current test case,
> it does not quit the entire test suite let alone crash the kernel.

This may be another case of whether a kunit_module is approximately a
single KUNIT_EXPECT_*() or a larger number of them.

I still want, for example, of_unittest_property_string() to include a large
number of KUNIT_EXPECT_*() instances.  In that case I still want the rest of
the tests in the kunit_module to be executed even after a KUNIT_ASSERT_*()
fails.  The existing test code has that property.


> 
> In case it wasn't clear above,
>>>>> +     test->try_catch.throw(&test->try_catch);
> should never, ever return. The only time it would, would be if KUnit
> was very broken. This should never actually happen, even if the
> assertion that called it was violated. KUNIT_ASSERT_* just says, "this
> is a prerequisite property for this test case"; if it is violated, the
> test case should fail and bail because the preconditions for the test
> case cannot be satisfied. Nevertheless, other tests cases will still
> run.
> 
