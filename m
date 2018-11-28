Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 137CC21A02937
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 12:50:04 -0800 (PST)
Subject: Re: [RFC v2 00/14] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20181023235750.103146-1-brendanhiggins@google.com>
 <1543036529.4680.655.camel@oracle.com>
 <CAFd5g45oPSp870hJLDSHiMfU7Mh-EvpYcFdAaOQxecXNde5PSw@mail.gmail.com>
 <1543434888.4680.862.camel@oracle.com>
From: shuah <shuah@kernel.org>
Message-ID: <abf3aff0-dfb3-717e-f14f-02dbe5574f49@kernel.org>
Date: Wed, 28 Nov 2018 13:50:01 -0700
MIME-Version: 1.0
In-Reply-To: <1543434888.4680.862.camel@oracle.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Knut Omang <knut.omang@oracle.com>, Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, kieran.bingham@ideasonboard.com, khilman@baylibre.com, Tim.Bird@sony.com, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, richard@nod.at, hidenori.yamaji@sony.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mcgrof@kernel.org, Greg KH <gregkh@linuxfoundation.org>, joe@perches.com, alan.maguire@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On 11/28/18 12:54 PM, Knut Omang wrote:
> On Mon, 2018-11-26 at 17:41 -0800, Brendan Higgins wrote:
>> On Fri, Nov 23, 2018 at 9:15 PM Knut Omang <knut.omang@oracle.com> wrote:
>>>
>>> On Tue, 2018-10-23 at 16:57 -0700, Brendan Higgins wrote:
>> <snip>
>>>
>>> Brendan, I regret you weren't at this year's testing and fuzzing workshop at
>>> LPC last week so we could have continued our discussions from last year there!
>>
>> Likewise! Unfortunately, I could not make it. So it goes.
>>
>>>
>>> I hope we can work on this for a while longer before anything gets merged.
>>> Maybe it can be topic for a longer session in a future test related workshop?
>>
>> I don't see why we cannot just discuss it here as we are already
>> doing.
> 
> Yes, as long as we are not wasting all the Cc:'ed people's valuable time.
> 
>> Besides, you are mostly interested in out of tree testing,
>> right? I don't see how this precludes anything that you are trying to
>> do with KTF.
> 
> Both approaches provide assertion macros for running tests inside the kernel,
> I doubt the kernel community would like to see yet two such sets of macros,
> with differing syntax merged. One of the good reasons to have a *framework*
> is that it is widely used and understood, so that people coming from one part of the
> kernel can easily run, understand and relate to selected tests from another part.
> 
> The goal with KTF is to allow this for any kernel, old or new, not just kernels
> built specifically for testing purposes. We felt that providing it as a separate git
> module (still open source, for anyone to contribute to) is a more efficient approach
> until we have more examples and experience with using it in different parts
> of the kernel. We can definitely post the kernel side of KTF as a patch series fairly soon
> if the community wants us to. Except for hybrid tests, the ktf.ko module works fine
> independently of any user side support, just using the debugfs interface to run and
> examine tests.
> 

Having test framework in the kernel sources tree has benefits. It allows
us (kernel developers) to do co-development of kernel features and tests
for these features.

It encourages developers to write regression tests. More importantly,
kernel features and tests for these features are included in the same
release in most cases and/or allows us freedom to do so if test 
framework and tests are part of the kernel sources.

We have seen this with our experience with kselftest. It would not have
see the same level of attention and growth if it stayed outside the
kernel sources.

Most kernel developers would not want to include a externally maintained
module for testing. As a general rule, it has to be easy to run tests.

> I think there are good uses cases for having the ability to maintain a
> single source for tests that can be run against multiple kernels,
> also distro kernels that the test framework cannot expect to be able to modify,
> except from using the module interfaces.

Same reasons as above. Having the tests included in the kernel sources
makes it easier for distros to run those tests and include running them
during their qualification.

> 
> And there are good arguments for having (at least parts of)
> the test framework easily available within the kernel under test.
> 

When Kernel unit, functional, and regressions tests reside in the kernel
sources, they evolve quicker as kernel developers contribute tests as
part of their kernel work-flow. Maintaining tests and framework
separately will make it harder to maintain them and keep them updated
for us the kernel community.

thanks,
-- Shuah
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
