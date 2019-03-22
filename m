Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com
 [IPv6:2607:f8b0:4864:20::530])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 695F3211E2F07
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 17:22:09 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id i2so186610pgj.11
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 17:22:09 -0700 (PDT)
Subject: Re: [RFC v3 18/19] of: unittest: split out a couple of test cases
 from unittest
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-19-brendanhiggins@google.com>
 <990bfc7d-dc5e-d8d3-c151-9b321ff2ac10@gmail.com>
 <CAFd5g45tOGgf_sKGYRC=fpnTBKGaG=8frbQdgZ3ZTkQFyTfP5A@mail.gmail.com>
 <88fe0546-7850-5bb4-9673-b1aef2dccb3e@gmail.com>
 <CAFd5g444f-FBq4x3U7BL-EY+bFxP0rsJhJ14=mjOi89PhMkURg@mail.gmail.com>
 <0e311e88-c4d4-e98d-1720-53a04bd526fc@gmail.com>
 <CAFd5g44NTZoSAJPMvXP2xvJgn7m5QoV-KJu2AMrr67+eL+CKrQ@mail.gmail.com>
 <d9f7e000-4cac-a35a-3ff9-60130e12ebea@gmail.com>
 <72cd1c5b-6f68-73ad-c8fd-f3a3268a0529@gmail.com>
 <CAFd5g46UU9wk+F6A5wnKYYtYKmmtv__SaY8eg6v-T9xUjsoxhA@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <bb5bcd3d-a09a-cfbe-c7fa-16e5eb75b0e4@gmail.com>
Date: Thu, 21 Mar 2019 17:22:05 -0700
MIME-Version: 1.0
In-Reply-To: <CAFd5g46UU9wk+F6A5wnKYYtYKmmtv__SaY8eg6v-T9xUjsoxhA@mail.gmail.com>
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
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On 2/27/19 7:52 PM, Brendan Higgins wrote:
> On Wed, Feb 20, 2019 at 12:45 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>
>> On 2/18/19 2:25 PM, Frank Rowand wrote:
>>> On 2/15/19 2:56 AM, Brendan Higgins wrote:
>>>> On Thu, Feb 14, 2019 at 6:05 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>
>>>>> On 2/14/19 4:56 PM, Brendan Higgins wrote:
>>>>>> On Thu, Feb 14, 2019 at 3:57 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>>>
>>>>>>> On 12/5/18 3:54 PM, Brendan Higgins wrote:
>>>>>>>> On Tue, Dec 4, 2018 at 2:58 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>>>>>
>>
>> < snip >
>>
>>>
>>> It makes it harder for me to read the source of the tests and
>>> understand the order they will execute.  It also makes it harder
>>> for me to read through the actual tests (in this example the
>>> tests that are currently grouped in of_unittest_find_node_by_name())
>>> because of all the extra function headers injected into the
>>> existing single function to break it apart into many smaller
>>> functions.
>>
>> < snip >
>>
>>>>>> This is not something I feel particularly strongly about, it is just
>>>>>> pretty atypical from my experience to have so many unrelated test
>>>>>> cases in a single file.
>>>>>>
>>>>>> Maybe you would prefer that I break up the test cases first, and then
>>>>>> we split up the file as appropriate?
>>>>>
>>>>> I prefer that the test cases not be broken up arbitrarily.  There _may_
>>
>> I expect that I created confusion by putting this in a reply to patch 18/19.
>> It is actually a comment about patch 19/19.  Sorry about that.
>>
> 
> No worries.
> 
>>
>>>>
>>>> I wasn't trying to break them up arbitrarily. I thought I was doing it
>>>> according to a pattern (breaking up the file, that is), but maybe I
>>>> just hadn't looked at enough examples.
>>>
>>> This goes back to the kunit model of putting each test into a separate
>>> function that can be a KUNIT_CASE().  That is a model that I do not agree
>>> with for devicetree.
>>
>> So now that I am actually talking about patch 19/19, let me give a concrete
>> example.  I will cut and paste (after my comments), the beginning portion
>> of base-test.c, after applying patch 19/19 (the "base version".  Then I
>> will cut and paste my alternative version which does not break the tests
>> down into individual functions (the "frank version").
> 
> Awesome, thanks for putting the comparison together!
> 
>>
>> I will also reply to this email with the base version and the frank version
>> as attachments, which will make it easier to save as separate versions
>> for easier viewing.  I'm not sure if an email with attachments will make
>> it through the list servers, but I am cautiously optimistic.
>>
>> I am using v4 of the patch series because I never got v3 to cleanly apply
>> and it is not a constructive use of my time to do so since I have v4 applied.
>>
>> One of the points I was trying to make is that readability suffers from the
>> approach taken by patches 18/19 and 19/19.
> 
> I understood that point.
> 
>>
>> The base version contains the extra text of a function header for each
>> unit test.  This is visual noise and makes the file larger.  It is also
>> one more possible location of an error (although not likely).
> 
> I don't see how it is much more visual noise than a comment.
> Admittedly, a space versus an underscore might be nice, but I think it
> is also more likely that a function name is more likely to be kept up
> to date than a comment even if they are both informational. It also
> forces the user to actually name all the tests. Even then, I am not
> married to doing it this exact way. The thing I really care about is
> isolating the code in each test case so that it can be executed
> separately.
> 
> A side thought, when I was proofreading this, it occurred to me that
> you might not like the function name over comment partly because you
> think about them differently. You aren't used to seeing a function
> used to frame things or communicate information in this way. Is this

No.  It is more visual clutter and it is more functional clutter that
potentially has to be validated.


> true? Admittedly, I have gotten used to a lot of unit test frameworks
> that break up test cases by function, so I wondering if part of the
> difference in comfortability with this framing might come from the
> fact that I am really used to seeing it this way and you are not? If
> this is the case, maybe it would be better if we had something like:
> 
> KUNIT_DECLARE_CASE(case_id, "Test case description")
> {
>         KUNIT_EXPECT_EQ(kunit, ...);
>         ...
> }
> 
> Just a thought.
> 
>>
>> The frank version has converted each of the new function headers into
>> a comment, using the function name with '_' converted to ' '.  The
>> comments are more readable than the function headers.  Note that I added
>> an extra blank line before each comment, which violates the kernel
>> coding standards, but I feel this makes the code more readable.
> 
> I agree that the extra space is an improvement, but I think any
> sufficient visual separation would work.
> 
>>
>> The base version needs to declare each of the individual test functions
>> in of_test_find_node_by_name_cases[]. It is possible that a test function
>> could be left out of of_test_find_node_by_name_cases[], in error.  This
>> will result in a compile warning (I think warning instead of error, but
>> I have not verified that) so the error might be caught or it might be
>> overlooked.
> 
> It's a warning, but that can be fixed.
> 
>>
>> In the base version, the order of execution of the test code requires
>> bouncing back and forth between the test functions and the coding of
>> of_test_find_node_by_name_cases[].
> 
> You shouldn't need to bounce back and forth because the order in which
> the tests run shouldn't matter.

If one can't guarantee total independence of all of the tests, with no
side effects, then yes.  But that is not my world.  To make that
guarantee, I would need to be able to run just a single test in an
entire test run.

I actually want to make side effects possible.  Whether from other
tests or from live kernel code that is accessing the live devicetree.
Any extra stress makes me happier.

I forget the exact term that has been tossed around, but to me the
devicetree unittests are more like system validation, release tests,
acceptance tests, and stress tests.  Not unit tests in the philosophy
of KUnit.

I do see the value of pure unit tests, and there are rare times that
my devicetree use case might be better served by that approach.  But
if so, it is very easy for me to add a simple pure test when debugging.
My general use case does not map onto this model.


>>
>> In the frank version the order of execution of the test code is obvious.
> 
> So I know we were arguing before over whether order *does* matter in
> some of the other test cases (none in the example that you or I
> posted), but wouldn't it be better if the order of execution didn't
> matter? If you don't allow a user to depend on the execution of test
> cases, then arguably these test case dependencies would never form and
> the order wouldn't matter.

Reality intrudes.  Order does matter.


>>
>> It is possible that a test function could be left out of
>> of_test_find_node_by_name_cases[], in error.  This will result in a compile
>> warning (I think warning instead of error, but I have not verified that)
>> so it might be caught or it might be overlooked.
>>
>> The base version is 265 lines.  The frank version is 208 lines, 57 lines
>> less.  Less is better.
> 
> I agree that less is better, but there are different kinds of less to
> consider. I prefer less logic in a function to fewer lines overall.
> 
> It seems we are in agreement that test cases should be small and
> simple, so I won't dwell on that point any longer. I agree that the

As a general guide for simple unit tests, sure.

For my case, no.  Reality intrudes.

KUnit has a nice architectural view of what a unit test should be.

The existing devicetree "unittests" are not such unit tests.  They
simply share the same name.

The devicetree unittests do not fit into a clean:
  - initialize
  - do one test
  - clean up
model.

Trying to force them into that model will not work.  The initialize
is not a simple, easy to decompose thing.  And trying to decompose
it can actually make the code more complex and messier.

Clean up can NOT occur, because part of my test validation is looking
at the state of the device tree after the tests complete, viewed
through the /proc/device-tree/ interface.


> test cases themselves when taken in isolation in base version and
> frank version are equally simple (obviously, they are the same).
> 
> If I am correct, we are only debating whether it is best to put each
> test case in its own function or not. That being said, I honestly
> still think my version (base version) is easier to understand. The
> reason I think mine is easier to read is entirely because of the code
> isolation provided by each test case running it its own function. I
> can look at a test case by itself and know that it doesn't depend on
> anything that happened in a preceding test case. It is true that I
> have to look in different places in the file, but I think that is more
> than made up for by the fact that in order to understand a test case,
> I only have to look at two functions: init, and the test case itself
> (well, also exit if you care about how things are cleaned up). I don't
> have to look through every single test case that proceeds it.
> 
> It might not be immediately obvious what isolation my version provides
> over your version at first glance, and that is exactly the point. We
> know that they are the same because you pulled the test cases out of
> my version, but what about the other test suite in 19/19,
> of_test_dynamic? If you notice, I did not just break each test case by
> wrapping it in a function; that didn't work because there was a
> dependency between some of the test cases. I removed that dependency,
> so that each test case is actually isolated:
> 
> ## ============== single function (18/19) version ===========
> static void of_unittest_dynamic(struct kunit *test)
> {
>         struct device_node *np;
>         struct property *prop;
> 
>         np = of_find_node_by_path("/testcase-data");
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> 
>         /* Array of 4 properties for the purpose of testing */
>         prop = kcalloc(4, sizeof(*prop), GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop);
> 
>         /* Add a new property - should pass*/
>         prop->name = "new-property";
>         prop->value = "new-property-data";
>         prop->length = strlen(prop->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
>                             "Adding a new property failed\n");
> 
>         /* Try to add an existing property - should fail */
>         prop++;
>         prop->name = "new-property";
>         prop->value = "new-property-data-should-fail";
>         prop->length = strlen(prop->value) + 1;
>         KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop), 0,
>                             "Adding an existing property should have failed\n");
> 
>         /* Try to modify an existing property - should pass */
>         prop->value = "modify-property-data-should-pass";
>         prop->length = strlen(prop->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(
>                 test, of_update_property(np, prop), 0,
>                 "Updating an existing property should have passed\n");
> 
>         /* Try to modify non-existent property - should pass*/
>         prop++;
>         prop->name = "modify-property";
>         prop->value = "modify-missing-property-data-should-pass";
>         prop->length = strlen(prop->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
>                             "Updating a missing property should have passed\n");
> 
>         /* Remove property - should pass */
>         KUNIT_EXPECT_EQ_MSG(test, of_remove_property(np, prop), 0,
>                             "Removing a property should have passed\n");
> 
>         /* Adding very large property - should pass */
>         prop++;
>         prop->name = "large-property-PAGE_SIZEx8";
>         prop->length = PAGE_SIZE * 8;
>         prop->value = kzalloc(prop->length, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop->value);
>         KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
>                             "Adding a large property should have passed\n");
> }
> 
> ## ============== multi function (19/19) version ===========
> struct of_test_dynamic_context {
>         struct device_node *np;
>         struct property *prop0;
>         struct property *prop1;
> };
> 
> static void of_test_dynamic_basic(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx = test->priv;
>         struct device_node *np = ctx->np;
>         struct property *prop0 = ctx->prop0;
> 
>         /* Add a new property - should pass*/
>         prop0->name = "new-property";
>         prop0->value = "new-property-data";
>         prop0->length = strlen(prop0->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
>                             "Adding a new property failed\n");
> 
>         /* Test that we can remove a property */
>         KUNIT_EXPECT_EQ(test, of_remove_property(np, prop0), 0);
> }
> 
> static void of_test_dynamic_add_existing_property(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx = test->priv;
>         struct device_node *np = ctx->np;
>         struct property *prop0 = ctx->prop0, *prop1 = ctx->prop1;
> 
>         /* Add a new property - should pass*/
>         prop0->name = "new-property";
>         prop0->value = "new-property-data";
>         prop0->length = strlen(prop0->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
>                             "Adding a new property failed\n");
> 
>         /* Try to add an existing property - should fail */
>         prop1->name = "new-property";
>         prop1->value = "new-property-data-should-fail";
>         prop1->length = strlen(prop1->value) + 1;
>         KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop1), 0,
>                             "Adding an existing property should have failed\n");
> }
> 
> static void of_test_dynamic_modify_existing_property(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx = test->priv;
>         struct device_node *np = ctx->np;
>         struct property *prop0 = ctx->prop0, *prop1 = ctx->prop1;
> 
>         /* Add a new property - should pass*/
>         prop0->name = "new-property";
>         prop0->value = "new-property-data";
>         prop0->length = strlen(prop0->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
>                             "Adding a new property failed\n");
> 
>         /* Try to modify an existing property - should pass */
>         prop1->name = "new-property";
>         prop1->value = "modify-property-data-should-pass";
>         prop1->length = strlen(prop1->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop1), 0,
>                             "Updating an existing property should have
> passed\n");
> }
> 
> static void of_test_dynamic_modify_non_existent_property(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx = test->priv;
>         struct device_node *np = ctx->np;
>         struct property *prop0 = ctx->prop0;
> 
>         /* Try to modify non-existent property - should pass*/
>         prop0->name = "modify-property";
>         prop0->value = "modify-missing-property-data-should-pass";
>         prop0->length = strlen(prop0->value) + 1;
>         KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop0), 0,
>                             "Updating a missing property should have passed\n");
> }
> 
> static void of_test_dynamic_large_property(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx = test->priv;
>         struct device_node *np = ctx->np;
>         struct property *prop0 = ctx->prop0;
> 
>         /* Adding very large property - should pass */
>         prop0->name = "large-property-PAGE_SIZEx8";
>         prop0->length = PAGE_SIZE * 8;
>         prop0->value = kunit_kzalloc(test, prop0->length, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop0->value);
> 
>         KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
>                             "Adding a large property should have passed\n");
> }
> 
> static int of_test_dynamic_init(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx;
> 
>         KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
> 
>         if (!of_aliases)
>                 of_aliases = of_find_node_by_path("/aliases");
> 
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
>                         "/testcase-data/phandle-tests/consumer-a"));
> 
>         ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
>         test->priv = ctx;
> 
>         ctx->np = of_find_node_by_path("/testcase-data");
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->np);
> 
>         ctx->prop0 = kunit_kzalloc(test, sizeof(*ctx->prop0), GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->prop0);
> 
>         ctx->prop1 = kunit_kzalloc(test, sizeof(*ctx->prop1), GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->prop1);
> 
>         return 0;
> }
> 
> static void of_test_dynamic_exit(struct kunit *test)
> {
>         struct of_test_dynamic_context *ctx = test->priv;
>         struct device_node *np = ctx->np;
> 
>         of_remove_property(np, ctx->prop0);
>         of_remove_property(np, ctx->prop1);
>         of_node_put(np);
> }
> 
> static struct kunit_case of_test_dynamic_cases[] = {
>         KUNIT_CASE(of_test_dynamic_basic),
>         KUNIT_CASE(of_test_dynamic_add_existing_property),
>         KUNIT_CASE(of_test_dynamic_modify_existing_property),
>         KUNIT_CASE(of_test_dynamic_modify_non_existent_property),
>         KUNIT_CASE(of_test_dynamic_large_property),
>         {},
> };
> 
> static struct kunit_module of_test_dynamic_module = {
>         .name = "of-dynamic-test",
>         .init = of_test_dynamic_init,
>         .exit = of_test_dynamic_exit,
>         .test_cases = of_test_dynamic_cases,
> };
> module_test(of_test_dynamic_module);
> 
> Compare the test cases for adding of_test_dynamic_basic,
> of_test_dynamic_add_existing_property,
> of_test_dynamic_modify_existing_property, and
> of_test_dynamic_modify_non_existent_property to the originals. My
> version is much longer overall, but I think is still much easier to
> understand. I can say from when I was trying to split this up in the
> first place, it was not obvious what properties were expected to be
> populated as a precondition for a given test case (except the first
> one of course). Whereas, in my version, it is immediately obvious what
> the preconditions are for a test case. I think you can apply this same
> logic to the examples you provided, in frank version, I don't
> immediately know if one test cases does something that is a
> precondition for another test case.

Yes, that is a real problem in the current code, but easily fixed
with comments.


> My version also makes it easier to run a test case entirely by itself
> which is really valuable for debugging purposes. A common thing that
> happens when you have lots of unit tests is something breaks and lots
> of tests fail. If the test cases are good, there should be just a
> couple (ideally one) test cases that directly assert the violated
> property; those are the test cases you actually want to focus on, the
> rest are noise for the purposes of that breakage. In my version, it is
> much easier to turn off the test cases that you don't care about and
> then focus in on the ones that exercise the violated property.
> 
> Now I know that, hermeticity especially, but other features as well
> (test suite summary, error on unused test case function, etc) are not
> actually in KUnit as it is under consideration here. Maybe it would be
> best to save these last two patches (18/19, and 19/19) until I have
> these other features checked in and reconsider them then?

Thanks for leaving 18/19 and 19/19 off in v4.

-Frank

> 
>>
>> ## ==========  base version  ====================================
>>
>> // SPDX-License-Identifier: GPL-2.0
>> /*
>>  * Unit tests for functions defined in base.c.
>>  */
>> #include <linux/of.h>
>>
>> #include <kunit/test.h>
>>
>> #include "test-common.h"
>>
>> static void of_test_find_node_by_name_basic(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *name;
>>
>>         np = of_find_node_by_path("/testcase-data");
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
>>                                "find /testcase-data failed\n");
>>         of_node_put(np);
>>         kfree(name);
>> }
>>
>> static void of_test_find_node_by_name_trailing_slash(struct kunit *test)
>> {
>>         /* Test if trailing '/' works */
>>         KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
>>                             "trailing '/' on /testcase-data/ should fail\n");
>>
>> }
>>
>> static void of_test_find_node_by_name_multiple_components(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *name;
>>
>>         np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_EXPECT_STREQ_MSG(
>>                 test, "/testcase-data/phandle-tests/consumer-a", name,
>>                 "find /testcase-data/phandle-tests/consumer-a failed\n");
>>         of_node_put(np);
>>         kfree(name);
>> }
>>
>> static void of_test_find_node_by_name_with_alias(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *name;
>>
>>         np = of_find_node_by_path("testcase-alias");
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
>>                                "find testcase-alias failed\n");
>>         of_node_put(np);
>>         kfree(name);
>> }
>>
>> static void of_test_find_node_by_name_with_alias_and_slash(struct kunit *test)
>> {
>>         /* Test if trailing '/' works on aliases */
>>         KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
>>                            "trailing '/' on testcase-alias/ should fail\n");
>> }
>>
>> /*
>>  * TODO(brendanhiggins@google.com): This looks like a duplicate of
>>  * of_test_find_node_by_name_multiple_components
>>  */
>> static void of_test_find_node_by_name_multiple_components_2(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *name;
>>
>>         np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_EXPECT_STREQ_MSG(
>>                 test, "/testcase-data/phandle-tests/consumer-a", name,
>>                 "find testcase-alias/phandle-tests/consumer-a failed\n");
>>         of_node_put(np);
>>         kfree(name);
>> }
>>
>> static void of_test_find_node_by_name_missing_path(struct kunit *test)
>> {
>>         struct device_node *np;
>>
>>         KUNIT_EXPECT_EQ_MSG(
>>                 test,
>>                 np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
>>                 "non-existent path returned node %pOF\n", np);
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_missing_alias(struct kunit *test)
>> {
>>         struct device_node *np;
>>
>>         KUNIT_EXPECT_EQ_MSG(
>>                 test, np = of_find_node_by_path("missing-alias"), NULL,
>>                 "non-existent alias returned node %pOF\n", np);
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_missing_alias_with_relative_path(
>>                 struct kunit *test)
>> {
>>         struct device_node *np;
>>
>>         KUNIT_EXPECT_EQ_MSG(
>>                 test,
>>                 np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
>>                 "non-existent alias with relative path returned node %pOF\n",
>>                 np);
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_with_option(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options;
>>
>>         np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
>>                                "option path test failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_with_option_and_slash(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options;
>>
>>         np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
>>                                "option path test, subcase #1 failed\n");
>>         of_node_put(np);
>>
>>         np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
>>                                "option path test, subcase #2 failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_with_null_option(struct kunit *test)
>> {
>>         struct device_node *np;
>>
>>         np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
>>         KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
>>                                          "NULL option path test failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_with_option_alias(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options;
>>
>>         np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
>>                                        &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
>>                                "option alias path test failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_with_option_alias_and_slash(
>>                 struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options;
>>
>>         np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
>>                                        &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
>>                                "option alias path test, subcase #1 failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_with_null_option_alias(struct kunit *test)
>> {
>>         struct device_node *np;
>>
>>         np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
>>         KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
>>                         test, np, "NULL option alias path test failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_option_clearing(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options;
>>
>>         options = "testoption";
>>         np = of_find_node_opts_by_path("testcase-alias", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_EQ_MSG(test, options, NULL,
>>                             "option clearing test failed\n");
>>         of_node_put(np);
>> }
>>
>> static void of_test_find_node_by_name_option_clearing_root(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options;
>>
>>         options = "testoption";
>>         np = of_find_node_opts_by_path("/", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_EQ_MSG(test, options, NULL,
>>                             "option clearing root node test failed\n");
>>         of_node_put(np);
>> }
>>
>> static int of_test_find_node_by_name_init(struct kunit *test)
>> {
>>         /* adding data for unittest */
>>         KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
>>
>>         if (!of_aliases)
>>                 of_aliases = of_find_node_by_path("/aliases");
>>
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
>>                         "/testcase-data/phandle-tests/consumer-a"));
>>
>>         return 0;
>> }
>>
>> static struct kunit_case of_test_find_node_by_name_cases[] = {
>>         KUNIT_CASE(of_test_find_node_by_name_basic),
>>         KUNIT_CASE(of_test_find_node_by_name_trailing_slash),
>>         KUNIT_CASE(of_test_find_node_by_name_multiple_components),
>>         KUNIT_CASE(of_test_find_node_by_name_with_alias),
>>         KUNIT_CASE(of_test_find_node_by_name_with_alias_and_slash),
>>         KUNIT_CASE(of_test_find_node_by_name_multiple_components_2),
>>         KUNIT_CASE(of_test_find_node_by_name_missing_path),
>>         KUNIT_CASE(of_test_find_node_by_name_missing_alias),
>>         KUNIT_CASE(of_test_find_node_by_name_missing_alias_with_relative_path),
>>         KUNIT_CASE(of_test_find_node_by_name_with_option),
>>         KUNIT_CASE(of_test_find_node_by_name_with_option_and_slash),
>>         KUNIT_CASE(of_test_find_node_by_name_with_null_option),
>>         KUNIT_CASE(of_test_find_node_by_name_with_option_alias),
>>         KUNIT_CASE(of_test_find_node_by_name_with_option_alias_and_slash),
>>         KUNIT_CASE(of_test_find_node_by_name_with_null_option_alias),
>>         KUNIT_CASE(of_test_find_node_by_name_option_clearing),
>>         KUNIT_CASE(of_test_find_node_by_name_option_clearing_root),
>>         {},
>> };
>>
>> static struct kunit_module of_test_find_node_by_name_module = {
>>         .name = "of-test-find-node-by-name",
>>         .init = of_test_find_node_by_name_init,
>>         .test_cases = of_test_find_node_by_name_cases,
>> };
>> module_test(of_test_find_node_by_name_module);
>>
>>
>> ## ==========  frank version  ===================================
>>
>>         // SPDX-License-Identifier: GPL-2.0
>> /*
>>  * Unit tests for functions defined in base.c.
>>  */
>> #include <linux/of.h>
>>
>> #include <kunit/test.h>
>>
>> #include "test-common.h"
>>
>> static void of_unittest_find_node_by_name(struct kunit *test)
>> {
>>         struct device_node *np;
>>         const char *options, *name;
>>
>>
>>         // find node by name basic
>>
>>         np = of_find_node_by_path("/testcase-data");
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
>>                                "find /testcase-data failed\n");
>>         of_node_put(np);
>>         kfree(name);
>>
>>
>>         // find node by name trailing slash
>>
>>         /* Test if trailing '/' works */
>>         KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
>>                             "trailing '/' on /testcase-data/ should fail\n");
>>
>>
>>         // find node by name multiple components
>>
>>         np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_EXPECT_STREQ_MSG(
>>                 test, "/testcase-data/phandle-tests/consumer-a", name,
>>                 "find /testcase-data/phandle-tests/consumer-a failed\n");
>>         of_node_put(np);
>>         kfree(name);
>>
>>
>>         // find node by name with alias
>>
>>         np = of_find_node_by_path("testcase-alias");
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
>>                                "find testcase-alias failed\n");
>>         of_node_put(np);
>>         kfree(name);
>>
>>
>>         // find node by name with alias and slash
>>
>>         /* Test if trailing '/' works on aliases */
>>         KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
>>                             "trailing '/' on testcase-alias/ should fail\n");
>>
>>
>>         // find node by name multiple components 2
>>
>>         np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         name = kasprintf(GFP_KERNEL, "%pOF", np);
>>         KUNIT_EXPECT_STREQ_MSG(
>>                 test, "/testcase-data/phandle-tests/consumer-a", name,
>>                 "find testcase-alias/phandle-tests/consumer-a failed\n");
>>         of_node_put(np);
>>         kfree(name);
>>
>>
>>         // find node by name missing path
>>
>>         KUNIT_EXPECT_EQ_MSG(
>>                 test,
>>                 np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
>>                 "non-existent path returned node %pOF\n", np);
>>         of_node_put(np);
>>
>>
>>         // find node by name missing alias
>>
>>         KUNIT_EXPECT_EQ_MSG(
>>                 test, np = of_find_node_by_path("missing-alias"), NULL,
>>                 "non-existent alias returned node %pOF\n", np);
>>         of_node_put(np);
>>
>>
>>         //  find node by name missing alias with relative path
>>
>>         KUNIT_EXPECT_EQ_MSG(
>>                 test,
>>                 np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
>>                 "non-existent alias with relative path returned node %pOF\n",
>>                 np);
>>         of_node_put(np);
>>
>>
>>         // find node by name with option
>>
>>         np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
>>                                "option path test failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name with option and slash
>>
>>         np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
>>                                "option path test, subcase #1 failed\n");
>>         of_node_put(np);
>>
>>         np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
>>                                "option path test, subcase #2 failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name with null option
>>
>>         np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
>>         KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
>>                                          "NULL option path test failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name with option alias
>>
>>         np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
>>                                        &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
>>                                "option alias path test failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name with option alias and slash
>>
>>         np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
>>                                        &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
>>                                "option alias path test, subcase #1 failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name with null option alias
>>
>>         np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
>>         KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
>>                         test, np, "NULL option alias path test failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name option clearing
>>
>>         options = "testoption";
>>         np = of_find_node_opts_by_path("testcase-alias", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_EQ_MSG(test, options, NULL,
>>                             "option clearing test failed\n");
>>         of_node_put(np);
>>
>>
>>         // find node by name option clearing root
>>
>>         options = "testoption";
>>         np = of_find_node_opts_by_path("/", &options);
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>>         KUNIT_EXPECT_EQ_MSG(test, options, NULL,
>>                             "option clearing root node test failed\n");
>>         of_node_put(np);
>> }
>>
>> static int of_test_init(struct kunit *test)
>> {
>>         /* adding data for unittest */
>>         KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
>>
>>         if (!of_aliases)
>>                 of_aliases = of_find_node_by_path("/aliases");
>>
>>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
>>                         "/testcase-data/phandle-tests/consumer-a"));
>>
>>         return 0;
>> }
>>
>> static struct kunit_case of_test_cases[] = {
>>         KUNIT_CASE(of_unittest_find_node_by_name),
>>         {},
>> };
>>
>> static struct kunit_module of_test_module = {
>>         .name = "of-base-test",
>>         .init = of_test_init,
>>         .test_cases = of_test_cases,
>> };
>> module_test(of_test_module);
>>
>>
>>>
>>>
>>>>> be cases where the devicetree unittests are currently not well grouped
>>>>> and may benefit from change, but if so that should be handled independently
>>>>> of any transformation into a KUnit framework.
>>>>
>>>> I agree. I did this because I wanted to illustrate what I thought real
>>>> world KUnit unit tests should look like (I also wanted to be able to
>>>> show off KUnit test features that help you write these kinds of
>>>> tests); I was not necessarily intending that all the of: unittest
>>>> patches would get merged in with the whole RFC. I was mostly trying to
>>>> create cause for discussion (which it seems like I succeeded at ;-) ).
>>>>
>>>> So fair enough, I will propose these patches separately and later
>>>> (except of course this one that splits up the file). Do you want the
>>>> initial transformation to the KUnit framework in the main KUnit
>>>> patchset, or do you want that to be done separately? If I recall, Rob
>>>> suggested this as a good initial example that other people could refer
>>>> to, and some people seemed to think that I needed one to help guide
>>>> the discussion and provide direction for early users. I don't
>>>> necessarily think that means the initial real world example needs to
>>>> be a part of the initial patchset though.
> 
> I really appreciate you taking the time to discuss these difficult points :-)
> 
> If the way I want to express test cases here is really that difficult
> to read, then it means that I have some work to do to make it better,
> because I plan on constructing other test cases in a very similar way.
> So, if you think that these test cases have real readability issues,
> then there is something I either need to improve with the framework,
> or the documentation.
> 
> So if you would rather discuss these patches later once I added those
> features that would make the notion of hermeticity stronger, or would
> make summaries better, or anything else I mentioned, that's fine with
> me, but if you think there is something fundamentally wrong with my
> approach, I would rather figured out the right way to handle it sooner
> rather than later.
> 
> Looking forward to hear what you think!
> 
> Cheers
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
