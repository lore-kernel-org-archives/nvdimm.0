From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v2 00/14] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Mon, 26 Nov 2018 17:41:19 -0800
Message-ID: <CAFd5g45oPSp870hJLDSHiMfU7Mh-EvpYcFdAaOQxecXNde5PSw@mail.gmail.com>
References: <20181023235750.103146-1-brendanhiggins@google.com>
 <1543036529.4680.655.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1543036529.4680.655.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hidenori.yamaji-7U/KSKJipcs@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, alan.maguire-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Nov 23, 2018 at 9:15 PM Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, 2018-10-23 at 16:57 -0700, Brendan Higgins wrote:
<snip>
>
> Brendan, I regret you weren't at this year's testing and fuzzing workshop at
> LPC last week so we could have continued our discussions from last year there!

Likewise! Unfortunately, I could not make it. So it goes.

>
> I hope we can work on this for a while longer before anything gets merged.
> Maybe it can be topic for a longer session in a future test related workshop?

I don't see why we cannot just discuss it here as we are already
doing. Besides, you are mostly interested in out of tree testing,
right? I don't see how this precludes anything that you are trying to
do with KTF.

I think the best way to develop something like what I am trying to do
with KUnit is gradually, in tree, and with the active input and
participation of the Linux kernel community.

>
> Links to more info about KTF:
> ------
> Git repo: https://github.com/oracle/ktf
> Formatted docs: http://heim.ifi.uio.no/~knuto/ktf/
>
> LWN mention from my presentation at LPC'17: https://lwn.net/Articles/735034/
> Oracle blog post: https://blogs.oracle.com/linux/oracles-new-kernel-test-framework-for-linux-v2
> OSS'18 presentation slides: https://events.linuxfoundation.org/wp-content/uploads/2017/12/Test-Driven-Kernel-Development-Knut-Omang-Oracle.pdf
>
> In the documentation (see http://heim.ifi.uio.no/~knuto/ktf/introduction.html)
> we present some more motivation for choices made with KTF.
> As described in that introduction, we believe in a more pragmatic approach
> to unit testing for the kernel than the classical "mock everything" approach,
> except for typical heavily algorithmic components that has interfaces simple to mock,
> such as container implementations, or components like page table traversal
> algorithms or memory allocators, where the benefit of being able to "listen"
> on the mock interfaces needed pays handsomely off.

I am not advocating that we mock everything. Using as much real code
dependencies as possible for code under test is a pretty common
position, and one which I adhere to myself.

>
> We also used strategies to compile kernel code in user mode,
> for parts of the code which seemed easy enough to mock interfaces for.
> I also looked at UML back then, but dismissed it in favor of the
> more lightweight approach of just compiling the code under test
> directly in user mode, with a minimal partly hand crafted, flat mock layer.

Is this new? When I tried your code out, I had to install the kernel
objects into my host kernel. Indeed, your documentation references
having to install kernel modules on the host:
http://heim.ifi.uio.no/~knuto/ktf/installation.html

>
> > KUnit is heavily inspired by JUnit, Python's unittest.mock, and
> > Googletest/Googlemock for C++. KUnit provides facilities for defining
> > unit test cases, grouping related test cases into test suites, providing
> > common infrastructure for running tests, mocking, spying, and much more.
>
> I am curious, with the intention of only running in user mode anyway,

I made it possible to "port" KUnit to other architectures.
Nevertheless, I believe all unit tests should be able to run without
depending on hardware or some special test harness. If I see a unit
test, I should not need to know anything about it just to run it.
Since there is no way to have all possible hardware configurations a
priori, all tests must be able to be run in a place that doesn't
depend in hardware; hence they should all be runnable as just normal
plane old user space programs with no dependency on a host kernel or
host hardware.

> why not try to build upon Googletest/Googlemock (or a similar C unit
> test framework if C is desired), instead of "reinventing"
> specific kernel macros for the tests?

I would love to reuse Googletest/Googlemock if it were possible; I
have used it a lot on other projects that I have worked on and think
it is great, but I need something I can check into the Linux kernel;
this requirement rules out Googletest/Googlemock since it depends on
C++. There are existing frameworks for C, true, but we then need to
check that into the Linux kernel or have the kernel depend on that; to
me that seemed like a lot more work than just reimplementing what we
need, which isn't much. Most of the hard parts are specific to the
kernel anyway.

>
> > A unit test is supposed to test a single unit of code in isolation,
> > hence the name. There should be no dependencies outside the control of
> > the test; this means no external dependencies, which makes tests orders
> > of magnitudes faster. Likewise, since there are no external dependencies,
> > there are no hoops to jump through to run the tests. Additionally, this
> > makes unit tests deterministic: a failing unit test always indicates a
> > problem. Finally, because unit tests necessarily have finer granularity,
> > they are able to test all code paths easily solving the classic problem
> > of difficulty in exercising error handling code.
>
> I think it is clearly a trade-off here: Tests run in an isolated, mocked
> environment are subject to fewer external components. But the more complex
> the mock environment gets, the more likely it also is to be a source of errors,
> nondeterminism and capacity limits itself, also the mock code would typically be
> less well tested than the mocked parts of the kernel, so it is by no means any
> silver bullet, precise testing with a real kernel on real hardware is still
> often necessary and desired.

I think you are misunderstand me. By isolation, I just mean no code
under test should depend on anything outside of the control of the
test environment. As I mention above, reusing real code for test
dependencies is highly encouraged.

As for running against hardware, yes, we need tests for that too, but
that falls under integration testing; it is possible to use what I
have here as a basis for that, but for right now, I just want to focus
on the problem of unit testing: I think this patchset is large enough
as it is.

>
> If the code under test is fairly standalone and complex enough, building a mock
> environment for it and test it independently may be worth it, but pragmatically,
> if the same functionality can be relatively easily exercised within the kernel,
> that would be my first choice.
>
> I like to think about all sorts of testing and assertion making as adding more
> redundancy. When errors surface you can never be sure whether it is a problem
> with the test, the test framework, the environment, or an actual error, and
> all places have to be fixed before the test can pass.

Yep, I totally agree, but this is why I think test isolation is so
important. If one test, or one piece of code is running that doesn't
need to be, it makes debugging tests that much more complicated.

Cheers!
