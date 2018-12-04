Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [RFC v3 00/19] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20181128193636.254378-1-brendanhiggins@google.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <f34ee937-83d6-3ff6-12b3-c6cd9acbfc38@gmail.com>
Date: Tue, 4 Dec 2018 03:40:37 -0800
MIME-Version: 1.0
In-Reply-To: <20181128193636.254378-1-brendanhiggins@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, julia.lawall@lip6.fr, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, robh@kernel.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, knut.omang@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Brendan, Rob,

On 11/28/18 11:36 AM, Brendan Higgins wrote:
> This patch set proposes KUnit, a lightweight unit testing and mocking
> framework for the Linux kernel.
> 
> Unlike Autotest and kselftest, KUnit is a true unit testing framework;
> it does not require installing the kernel on a test machine or in a VM
> and does not require tests to be written in userspace running on a host
> kernel. Additionally, KUnit is fast: From invocation to completion KUnit
> can run several dozen tests in under a second. Currently, the entire
> KUnit test suite for KUnit runs in under a second from the initial
> invocation (build time excluded).
> 
> KUnit is heavily inspired by JUnit, Python's unittest.mock, and
> Googletest/Googlemock for C++. KUnit provides facilities for defining
> unit test cases, grouping related test cases into test suites, providing
> common infrastructure for running tests, mocking, spying, and much more.
> 
> ## What's so special about unit testing?
> 
> A unit test is supposed to test a single unit of code in isolation,
> hence the name. There should be no dependencies outside the control of
> the test; this means no external dependencies, which makes tests orders
> of magnitudes faster. Likewise, since there are no external dependencies,
> there are no hoops to jump through to run the tests. Additionally, this
> makes unit tests deterministic: a failing unit test always indicates a
> problem. Finally, because unit tests necessarily have finer granularity,
> they are able to test all code paths easily solving the classic problem
> of difficulty in exercising error handling code.
> 
> ## Is KUnit trying to replace other testing frameworks for the kernel?
> 
> No. Most existing tests for the Linux kernel are end-to-end tests, which
> have their place. A well tested system has lots of unit tests, a
> reasonable number of integration tests, and some end-to-end tests. KUnit
> is just trying to address the unit test space which is currently not
> being addressed.
> 
> ## More information on KUnit
> 
> There is a bunch of documentation near the end of this patch set that
> describes how to use KUnit and best practices for writing unit tests.
> For convenience I am hosting the compiled docs here:
> https://google.github.io/kunit-docs/third_party/kernel/docs/
> Additionally for convenience, I have applied these patches to a branch:
> https://kunit.googlesource.com/linux/+/kunit/rfc/4.19/v3
> The repo may be cloned with:
> git clone https://kunit.googlesource.com/linux
> This patchset is on the kunit/rfc/4.19/v3 branch.
> 
> ## Changes Since Last Version
> 
>  - Changed namespace prefix from `test_*` to `kunit_*` as requested by
>    Shuah.


>  - Started converting/cleaning up the device tree unittest to use KUnit.
>  - Started adding KUnit expectations with custom messages.
> 

Sorry I missed your reply to me in the v1 patch thread.  I've been
traveling a lot the last few weeks.  I'm starting to read messages
that occurred late in the v1 patch thread and the v2 patch thread,
so I'm just coming up to speed on this.

My comments below are motivated by adding the devicetree unittest to
this version of the patch series.

Pulling a comment from way back in the v1 patch thread:

On 10/17/18 3:22 PM, Brendan Higgins wrote:
> On Wed, Oct 17, 2018 at 10:49 AM <Tim.Bird@sony.com> wrote:

< snip >

> The test and the code under test are linked together in the same
> binary and are compiled under Kbuild. Right now I am linking
> everything into a UML kernel, but I would ultimately like to make
> tests compile into completely independent test binaries. So each test
> file would get compiled into its own test binary and would link
> against only the code needed to run the test, but we are a bit of a
> ways off from that.

I have never used UML, so you should expect naive questions from me,
exhibiting my lack of understanding.

Does this mean that I have to build a UML architecture kernel to run
the KUnit tests?

*** Rob, if the answer is yes, then it seems like for my workflow,
which is to build for real ARM hardware, my work is doubled (or
worse), because for every patch/commit that I apply, I not only have
to build the ARM kernel and boot on the real hardware to test, I also
have to build the UML kernel and boot in UML.  If that is correct
then I see this as a major problem for me.

Brenden, in the above quote you said that in the future you would
like to make the "tests compile into completely independent test
binaries".  I am assuming those are intended to run as standalone
user space programs instead of inside UML.  Is that correct?  If
so, how will KUnit tests be able to test code that uses locking
mechanisms that require instructions that are not available to
user space execution?  (I _think_ that such instructions may be
present, depending on which locking mechanism, but I might be
mistaken.)

Another possible concern that I have for removing the devicetree
unit tests from my normal kernel build process is that I think
that the ability to use sparse to analyze the source in the
unit tests is removed.  Please correct me if I misunderstand
that.

Another issue is that the devicetree unit tests will no longer
be cross compiled with my ARM compiler, so I lose a small
amount of testing for compiler related issues.

Overall, I'm still trying to learn enough to determine whether
the gains from moving to KUnit outweigh the losses.

-Frank
