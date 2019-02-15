Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B873B20886F3D
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 18:05:51 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id m2so1764561pgl.5
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 18:05:51 -0800 (PST)
Subject: Re: [RFC v3 18/19] of: unittest: split out a couple of test cases
 from unittest
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-19-brendanhiggins@google.com>
 <990bfc7d-dc5e-d8d3-c151-9b321ff2ac10@gmail.com>
 <CAFd5g45tOGgf_sKGYRC=fpnTBKGaG=8frbQdgZ3ZTkQFyTfP5A@mail.gmail.com>
 <88fe0546-7850-5bb4-9673-b1aef2dccb3e@gmail.com>
 <CAFd5g444f-FBq4x3U7BL-EY+bFxP0rsJhJ14=mjOi89PhMkURg@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <0e311e88-c4d4-e98d-1720-53a04bd526fc@gmail.com>
Date: Thu, 14 Feb 2019 18:05:47 -0800
MIME-Version: 1.0
In-Reply-To: <CAFd5g444f-FBq4x3U7BL-EY+bFxP0rsJhJ14=mjOi89PhMkURg@mail.gmail.com>
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

On 2/14/19 4:56 PM, Brendan Higgins wrote:
> On Thu, Feb 14, 2019 at 3:57 PM Frank Rowand <frowand.list@gmail.com> wrote:
>>
>> On 12/5/18 3:54 PM, Brendan Higgins wrote:
>>> On Tue, Dec 4, 2018 at 2:58 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>>>
>>>> Hi Brendan,
>>>>
>>>> On 11/28/18 11:36 AM, Brendan Higgins wrote:
>>>>> Split out a couple of test cases that these features in base.c from the
>>>>> unittest.c monolith. The intention is that we will eventually split out
>>>>> all test cases and group them together based on what portion of device
>>>>> tree they test.
>>>>
>>>> Why does splitting this file apart improve the implementation?
>>>
>>> This is in preparation for patch 19/19 and other hypothetical future
>>> patches where test cases are split up and grouped together by what
>>> portion of DT they test (for example the parsing tests and the
>>> platform/device tests would probably go separate files as well). This
>>> patch by itself does not do anything useful, but I figured it made
>>> patch 19/19 (and, if you like what I am doing, subsequent patches)
>>> easier to review.
>>
>> I do not see any value in splitting the devicetree tests into
>> multiple files.
>>
>> Please help me understand what the benefits of such a split are.

Note that my following comments are specific to the current devicetree
unittests, and may not apply to the general case of unit tests in other
subsystems.


> Sorry, I thought it made sense in context of what I am doing in the
> following patch. All I am trying to do is to provide an effective way
> of grouping test cases. To be clear, the idea, assuming you agree, is

Looking at _just_ the first few fragments of the following patch, the
change is to break down a moderate size function of related tests,
of_unittest_find_node_by_name(), into a lot of extremely small functions.
Then to find the execution order of the many small functions requires
finding the array of_test_find_node_by_name_cases[].  Then I have to
chase off into the kunit test runner core, where I find that the set
of tests in of_test_find_node_by_name_cases[] is processed by a
late_initcall().  So now the order of the various test groupings,
declared via module_test(), are subject to the fragile orderings
of initcalls.

There are ordering dependencies within the devicetree unittests.

I do not like breaking the test cases down into such small atoms.

I do not see any value __for devicetree unittests__ of having
such small atoms.

It makes it harder for me to read the source of the tests and
understand the order they will execute.  It also makes it harder
for me to read through the actual tests (in this example the
tests that are currently grouped in of_unittest_find_node_by_name())
because of all the extra function headers injected into the
existing single function to break it apart into many smaller
functions.

Breaking the tests into separate chunks, each chunk invoked
independently as the result of module_test() of each chunk,
loses the summary result for the devicetree unittests of
how many tests are run and how many passed.  This is the
only statistic that I need to determine whether the
unittests have detected a new fault caused by a specific
patch or commit.  I don't need to look at any individual
test result unless the overall result reports a failure.


> that we would follow up with several other patches like this one and
> the subsequent patch, one which would pull out a couple test
> functions, as I have done here, and another that splits those
> functions up into a bunch of proper test cases.
> 
> I thought that having that many unrelated test cases in a single file
> would just be a pain to sort through deal with, review, whatever.

Having all the test cases in a single file makes it easier for me to
read, understand, modify, and maintain the tests.


> This is not something I feel particularly strongly about, it is just
> pretty atypical from my experience to have so many unrelated test
> cases in a single file.
> 
> Maybe you would prefer that I break up the test cases first, and then
> we split up the file as appropriate?

I prefer that the test cases not be broken up arbitrarily.  There _may_
be cases where the devicetree unittests are currently not well grouped
and may benefit from change, but if so that should be handled independently
of any transformation into a KUnit framework.


> I just assumed that we would agree it would be way too much stuff for
> a single file, so I went ahead and broke it up first, because I
> thought it would make it easier to review in that order rather than
> the other way around.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
