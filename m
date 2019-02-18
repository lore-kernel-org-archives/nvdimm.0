Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com
 [IPv6:2607:f8b0:4864:20::441])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29D84208AE993
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 14:26:04 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id g6so9205153pfh.13
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 14:26:04 -0800 (PST)
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
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <d9f7e000-4cac-a35a-3ff9-60130e12ebea@gmail.com>
Date: Mon, 18 Feb 2019 14:25:59 -0800
MIME-Version: 1.0
In-Reply-To: <CAFd5g44NTZoSAJPMvXP2xvJgn7m5QoV-KJu2AMrr67+eL+CKrQ@mail.gmail.com>
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

On 2/15/19 2:56 AM, Brendan Higgins wrote:
> On Thu, Feb 14, 2019 at 6:05 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>
>> On 2/14/19 4:56 PM, Brendan Higgins wrote:
>>> On Thu, Feb 14, 2019 at 3:57 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>
>>>> On 12/5/18 3:54 PM, Brendan Higgins wrote:
>>>>> On Tue, Dec 4, 2018 at 2:58 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>>>
>>>>>> Hi Brendan,
>>>>>>
>>>>>> On 11/28/18 11:36 AM, Brendan Higgins wrote:
>>>>>>> Split out a couple of test cases that these features in base.c from the
>>>>>>> unittest.c monolith. The intention is that we will eventually split out
>>>>>>> all test cases and group them together based on what portion of device
>>>>>>> tree they test.
>>>>>>
>>>>>> Why does splitting this file apart improve the implementation?
>>>>>
>>>>> This is in preparation for patch 19/19 and other hypothetical future
>>>>> patches where test cases are split up and grouped together by what
>>>>> portion of DT they test (for example the parsing tests and the
>>>>> platform/device tests would probably go separate files as well). This
>>>>> patch by itself does not do anything useful, but I figured it made
>>>>> patch 19/19 (and, if you like what I am doing, subsequent patches)
>>>>> easier to review.
>>>>
>>>> I do not see any value in splitting the devicetree tests into
>>>> multiple files.
>>>>
>>>> Please help me understand what the benefits of such a split are.
>>
>> Note that my following comments are specific to the current devicetree
>> unittests, and may not apply to the general case of unit tests in other
>> subsystems.
>>
> Note taken.
>>
>>> Sorry, I thought it made sense in context of what I am doing in the
>>> following patch. All I am trying to do is to provide an effective way
>>> of grouping test cases. To be clear, the idea, assuming you agree, is
>>
>> Looking at _just_ the first few fragments of the following patch, the
>> change is to break down a moderate size function of related tests,
>> of_unittest_find_node_by_name(), into a lot of extremely small functions.
> 
> Hmm...I wouldn't call that a moderate function. By my standards those
> functions are pretty large. In any case, I want to limit the
> discussion to specifically what a test case should look like, and the
> general consensus outside of the kernel is that unit test cases should
> be very very small. The reason is that each test case is supposed to> test one specific property; it should be obvious what that property
> is; and it should be obvious what is needed to exercise that property.

That is a valid model and philosophy of unit test design.

It is not a model that the devicetree unit tests can be shoe horned
into.  Sort of...  In a sense, the existing devicetree unit tests
already to that, if you consider each unittest() (and sometime a few
lines of code that creates the result that unittest() checks) to be a separate
unit test.  But the kunit model does not consider the sort of
equivalent KUNIT_EXPECT_EQ(), etc, to be a unit test, the unit test
in kunit would be KUNIT_CASE().  Although it is a little confusing to
me that the initialization and clean up on exit occur one level
higher than KUNIT_CASE(), in struct kunit_module.  I think the
confusion is just a matter of slight conflict in the documentation
(btw, the documents where very helpful for me to understand the
overall concepts and model).


>> Then to find the execution order of the many small functions requires
>> finding the array of_test_find_node_by_name_cases[].  Then I have to
> 
> Execution order shouldn't matter. Each test case should be totally
> hermetic. Obviously in this case we depend on the preceeding test case
> to clean up properly, but that is something I am working on.

But the order _does_ matter for the devicetree unit tests.

That is one of the problems.  The devicetree unit tests are not small,
independent tests.  Some of the tests change state in a way that
following tests depend upon.

The design documents also mention that each unit test should have
a pre-test initialization, and a post-test cleanup to remove the
results of the initialization.

The devicetree unit tests have a large, intrusive initialization.
Once again, not a good fit for this model.

The devicetree unit tests also have an undocumented (and not at all
obvious) need to leave state changed in some cases after the test
completes.  There are cases where the way that I fully validate
the success of the tests is to examine the state of the live
devicetree via /proc/devicetree/. Ideally, this would be done by
a script or a program, but creating that is not near the top of
my todo list.


>> chase off into the kunit test runner core, where I find that the set
>> of tests in of_test_find_node_by_name_cases[] is processed by a
>> late_initcall().  So now the order of the various test groupings,
> 
> That's fair. You are not the only one to complain about that. The
> late_initcall is a hack which I plan on replacing shortly (and yes I
> know that me planning on doing something doesn't mean much in this
> discussion, but that's what I got); regardless, order shouldn't
> matter.

But again, it does.


>> declared via module_test(), are subject to the fragile orderings
>> of initcalls.
>>
>> There are ordering dependencies within the devicetree unittests.
> 
> There is now in the current devicetree unittests, but, if I may be so
> bold, that is something that I would like to fix.
> 
>>
>> I do not like breaking the test cases down into such small atoms.
>>
>> I do not see any value __for devicetree unittests__ of having
>> such small atoms.
> 
> I imagine it probably makes less sense in the context of a strict
> dependency order, but that is something that I want to do away with.
> Ideally, when you look at a test case you shouldn't need to think
> about anything other than the code under test and the test case
> itself; so in my universe, a smaller test case should mean less you
> need to think about.

For the general case, I think that is an excellent model.


> I don't want to get hung up on size too much because I don't think
> this is what it is really about. I think you and I can agree that a
> test should be as simple and complete as possible. The ideal test
> should cover all behavior, and should be obviously correct (since
> otherwise we would have to test the test too). Obviously, these two
> goals are at odds, so the compromise I attempt to make is to make a
> bunch of test cases which are separately simple enough to be obviously
> correct at first glance, and the sum total of all the tests provides
> the necessary coverage. Additionally, because each test case is
> independent of every other test case, they can be reasoned about
> individually, and it is not necessary to reason about them as a group.
> Hypothetically, this should give you the best of both worlds.
> 
> So even if I failed in execution, I think the principle is good.
> 
>>
>> It makes it harder for me to read the source of the tests and
>> understand the order they will execute.  It also makes it harder
>> for me to read through the actual tests (in this example the
>> tests that are currently grouped in of_unittest_find_node_by_name())
>> because of all the extra function headers injected into the
>> existing single function to break it apart into many smaller
>> functions.
> 
> Well now the same groups are expressed as test modules, it's just a
> collection of closely related test cases, but they are grouped
> together for just that reason. Nevertheless, I argue this is superior
> to grouping them together in a function, because a test module
> (elsewhere called a test suite) relates test cases together, but makes
> it clear that they are still logically independent, two test cases in
> a suite should run completely independently of each other.

That is missing my point.  Converting to the kunit format adds a
lot of boilerplate function declarations.  Compare that extra
boilerplate to a one line comment.  This is a clarity of source
code argument that I am making.

It may be a little hard to see my point given the current state of
unittest.c.  I could definitely make that much more readable using
the current model.


>>
>> Breaking the tests into separate chunks, each chunk invoked
>> independently as the result of module_test() of each chunk,
>> loses the summary result for the devicetree unittests of
>> how many tests are run and how many passed.  This is the
> 
> We still provide that. Well, we provide a total result of all tests
> run, but they are already grouped by test module, and we could provide
> module level summaries, that would be pretty trivial.

Providing the module level summary (assuming that all of the devicetree
tests were in a single module) would meet this need.


>> only statistic that I need to determine whether the
>> unittests have detected a new fault caused by a specific
>> patch or commit.  I don't need to look at any individual
>> test result unless the overall result reports a failure.
> 
> Yep, we do that too.

Well, when you add the module level summary...


>>
>>
>>> that we would follow up with several other patches like this one and
>>> the subsequent patch, one which would pull out a couple test
>>> functions, as I have done here, and another that splits those
>>> functions up into a bunch of proper test cases.
>>>
>>> I thought that having that many unrelated test cases in a single file
>>> would just be a pain to sort through deal with, review, whatever.
>>
>> Having all the test cases in a single file makes it easier for me to
>> read, understand, modify, and maintain the tests.
> 
> Alright, well that's a much harder thing to make a strong statement
> about. From my experience, I have usually seen one or two *maybe
> three* test suites in a single file, and you have a lot more than that
> in the file right now, but this sounds like a discussion for later
> anyway.

drivers/of/test-common.c is already split out by the patch series.


>>
>>> This is not something I feel particularly strongly about, it is just
>>> pretty atypical from my experience to have so many unrelated test
>>> cases in a single file.
>>>
>>> Maybe you would prefer that I break up the test cases first, and then
>>> we split up the file as appropriate?
>>
>> I prefer that the test cases not be broken up arbitrarily.  There _may_
> 
> I wasn't trying to break them up arbitrarily. I thought I was doing it
> according to a pattern (breaking up the file, that is), but maybe I
> just hadn't looked at enough examples.

This goes back to the kunit model of putting each test into a separate
function that can be a KUNIT_CASE().  That is a model that I do not agree
with for devicetree.


>> be cases where the devicetree unittests are currently not well grouped
>> and may benefit from change, but if so that should be handled independently
>> of any transformation into a KUnit framework.
> 
> I agree. I did this because I wanted to illustrate what I thought real
> world KUnit unit tests should look like (I also wanted to be able to
> show off KUnit test features that help you write these kinds of
> tests); I was not necessarily intending that all the of: unittest
> patches would get merged in with the whole RFC. I was mostly trying to
> create cause for discussion (which it seems like I succeeded at ;-) ).
> 
> So fair enough, I will propose these patches separately and later
> (except of course this one that splits up the file). Do you want the
> initial transformation to the KUnit framework in the main KUnit
> patchset, or do you want that to be done separately? If I recall, Rob
> suggested this as a good initial example that other people could refer
> to, and some people seemed to think that I needed one to help guide
> the discussion and provide direction for early users. I don't
> necessarily think that means the initial real world example needs to
> be a part of the initial patchset though.
> 
> Cheers
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
