From: Frank Rowand <frowand.list@gmail.com>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Mon, 18 Feb 2019 12:02:24 -0800
Message-ID: <a6ae907e-391b-993e-6011-6f40c761b339@gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214213729.21702-1-brendanhiggins@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org, robh@kernel.org, kieran.bingham@ideasonboard.com
Cc: gregkh@linuxfoundation.org, joel@jms.id.au, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, julia.lawall@lip6.fr, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, knut.omang@oracle.com, devicetree@vger.kernel.org, pmladek@suse.com, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, wfg@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

On 2/14/19 1:37 PM, Brendan Higgins wrote:
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
> https://kunit.googlesource.com/linux/+/kunit/rfc/5.0-rc5/v4
> The repo may be cloned with:
> git clone https://kunit.googlesource.com/linux
> This patchset is on the kunit/rfc/5.0-rc5/v4 branch.
> 
> ## Changes Since Last Version
> 
>  - Got KUnit working on (hypothetically) all architectures (tested on
>    x86), as per Rob's (and other's) request
>  - Punting all KUnit features/patches depending on UML for now.
>  - Broke out UML specific support into arch/um/* as per "[RFC v3 01/19]
>    kunit: test: add KUnit test runner core", as requested by Luis.
>  - Added support to kunit_tool to allow it to build kernels in external
>    directories, as suggested by Kieran.
>  - Added a UML defconfig, and a config fragment for KUnit as suggested
>    by Kieran and Luis.
>  - Cleaned up, and reformatted a bunch of stuff.
> 

I have not read through the patches in any detail.  I have read some of
the code to try to understand the patches to the devicetree unit tests.
So that may limit how valid my comments below are.

I found the code difficult to read in places where it should have been
much simpler to read.  Structuring the code in a pseudo object oriented
style meant that everywhere in a code path that I encountered a dynamic
function call, I had to go find where that dynamic function call was
initialized (and being the cautious person that I am, verify that
no where else was the value of that dynamic function call).  With
primitive vi and tags, that search would have instead just been a
simple key press (or at worst a few keys) if hard coded function
calls were done instead of dynamic function calls.  In the code paths
that I looked at, I did not see any case of a dynamic function being
anything other than the value it was originally initialized as.
There may be such cases, I did not read the entire patch set.  There
may also be cases envisioned in the architects mind of how this
flexibility may be of future value.  Dunno.

-Frank
