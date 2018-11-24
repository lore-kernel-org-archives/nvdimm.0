Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB4B221191F51
 for <linux-nvdimm@lists.01.org>; Fri, 23 Nov 2018 21:16:19 -0800 (PST)
Message-ID: <1543036529.4680.655.camel@oracle.com>
Subject: Re: [RFC v2 00/14] kunit: introduce KUnit, the Linux kernel unit
 testing framework
From: Knut Omang <knut.omang@oracle.com>
Date: Sat, 24 Nov 2018 06:15:29 +0100
In-Reply-To: <20181023235750.103146-1-brendanhiggins@google.com>
References: <20181023235750.103146-1-brendanhiggins@google.com>
Mime-Version: 1.0
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
To: Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org
Cc: brakmo@fb.com, Hidenori Yamaji <hidenori.yamaji@sony.com>, linux-nvdimm@lists.01.org, richard@nod.at, Tim.Bird@sony.com, linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kieran.bingham@ideasonboard.com, julia.lawall@lip6.fr, jdike@addtoit.com, rostedt@goodmis.org, linux-kselftest@vger.kernel.org, mpe@ellerman.id.au, joe@perches.com, kunit-dev@googlegroups.com, Alan Maguire <alan.maguire@oracle.com>, khilman@baylibre.com, joel@jms.id.au
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-10-23 at 16:57 -0700, Brendan Higgins wrote:
> This patch set proposes KUnit, a lightweight unit testing and mocking
> framework for the Linux kernel.
> 
> Unlike Autotest and kselftest, KUnit is a true unit testing framework;

First thanks to Hidenori Yamaji for making me aware of these threads!

I'd like to kindly remind Brendan, and inform others who might have
missed out on it, about our (somewhat different approach) to this space
at Oracle: KTF (Kernel Test Framework). 

KTF is a product of our experience with driver testing within Oracle since 
2011, developed
as part of a project that was not made public until 2016.
During the project, we
experimented with multiple approaches to enable 
more test driven work with kernel code.
KTF is the "testing within the kernel" 
part of this. While we realize there are quite a
few testing frameworks out there, 
KTF makes it easy to run selected tests in kernel
context directly, 
and as such provides a valuable approach to unit testing.

Brendan, I regret you weren't at this year's testing and fuzzing workshop at 
LPC last week so we could have continued our discussions from last year there!

I hope we can work on this for a while longer before anything gets merged. 
Maybe it can be topic for a longer session in a future test related workshop?

Links to more info about KTF:
------
Git repo: https://github.com/oracle/ktf
Formatted docs: http://heim.ifi.uio.no/~knuto/ktf/

LWN mention from my presentation at LPC'17: https://lwn.net/Articles/735034/
Oracle blog post: https://blogs.oracle.com/linux/oracles-new-kernel-test-framework-for-linux-v2
OSS'18 presentation slides: https://events.linuxfoundation.org/wp-content/uploads/2017/12/Test-Driven-Kernel-Development-Knut-Omang-Oracle.pdf

In the documentation (see http://heim.ifi.uio.no/~knuto/ktf/introduction.html)
we present some more motivation for choices made with KTF. 
As described in that introduction, we believe in a more pragmatic approach 
to unit testing for the kernel than the classical "mock everything" approach, 
except for typical heavily algorithmic components that has interfaces simple to mock, 
such as container implementations, or components like page table traversal 
algorithms or memory allocators, where the benefit of being able to "listen" 
on the mock interfaces needed pays handsomely off.

We also used strategies to compile kernel code in user mode,
for parts of the code which seemed easy enough to mock interfaces for.
I also looked at UML back then, but dismissed it in favor of the
more lightweight approach of just compiling the code under test 
directly in user mode, with a minimal partly hand crafted, flat mock layer.

> KUnit is heavily inspired by JUnit, Python's unittest.mock, and
> Googletest/Googlemock for C++. KUnit provides facilities for defining
> unit test cases, grouping related test cases into test suites, providing
> common infrastructure for running tests, mocking, spying, and much more.

I am curious, with the intention of only running in user mode anyway, 
why not try to build upon Googletest/Googlemock (or a similar C unit 
test framework if C is desired), instead of "reinventing" 
specific kernel macros for the tests?

> A unit test is supposed to test a single unit of code in isolation,
> hence the name. There should be no dependencies outside the control of
> the test; this means no external dependencies, which makes tests orders
> of magnitudes faster. Likewise, since there are no external dependencies,
> there are no hoops to jump through to run the tests. Additionally, this
> makes unit tests deterministic: a failing unit test always indicates a
> problem. Finally, because unit tests necessarily have finer granularity,
> they are able to test all code paths easily solving the classic problem
> of difficulty in exercising error handling code.

I think it is clearly a trade-off here: Tests run in an isolated, mocked 
environment are subject to fewer external components. But the more complex
the mock environment gets, the more likely it also is to be a source of errors, 
nondeterminism and capacity limits itself, also the mock code would typically be 
less well tested than the mocked parts of the kernel, so it is by no means any 
silver bullet, precise testing with a real kernel on real hardware is still 
often necessary and desired. 

If the code under test is fairly standalone and complex enough, building a mock
environment for it and test it independently may be worth it, but pragmatically, 
if the same functionality can be relatively easily exercised within the kernel, 
that would be my first choice.

I like to think about all sorts of testing and assertion making as adding more 
redundancy. When errors surface you can never be sure whether it is a problem 
with the test, the test framework, the environment, or an actual error, and 
all places have to be fixed before the test can pass. 

Thanks,
Knut



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
