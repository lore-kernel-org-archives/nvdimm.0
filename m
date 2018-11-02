Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F151D21188C47
 for <linux-nvdimm@lists.01.org>; Fri,  2 Nov 2018 11:23:55 -0700 (PDT)
Subject: Re: [RFC v2 00/14] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20181023235750.103146-1-brendanhiggins@google.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <f3682d48-6f27-5eef-8274-02f90dd65188@kernel.org>
Date: Fri, 2 Nov 2018 12:23:53 -0600
MIME-Version: 1.0
In-Reply-To: <20181023235750.103146-1-brendanhiggins@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org
Cc: brakmo@fb.com, robh@kernel.org, richard@nod.at, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, Tim.Bird@sony.com, linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, kieran.bingham@ideasonboard.com, julia.lawall@lip6.fr, joel@jms.id.au, linux-kselftest@vger.kernel.org, khilman@baylibre.com, joe@perches.com, daniel@ffwll.ch, Shuah Khan <shuah@kernel.org>, jdike@addtoit.com, kunit-dev@googlegroups.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Brendan,


On 10/23/2018 05:57 PM, Brendan Higgins wrote:
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
> 
> ## Changes Since Last Version
> 
>  - Updated patchset to apply cleanly on 4.19.
>  - Stripped down patchset to focus on just the core features (I dropped
>    mocking, spying, and the MMIO stuff for now; you can find these
>    patches here: https://kunit-review.googlesource.com/c/linux/+/1132),
>    as suggested by Rob.
>  - Cleaned up some of the commit messages and tweaked commit order a
>    bit based on suggestions.
>

Framework looks good. I think it would be helpful to include a real test
in the patch series to get a feel for how effective it is.

On one hand, KUnit stands on its own as its own and maybe it should be placed in
under tools/testing/KUnit, however I am wondering would it be beneficial for the
framework to under selftests.

I am a bit concerned about the number of test framework we have at the moment and
are we running the risk of fragmenting the landscape. I am concerned if this would
lead to developer confusion as to where to add tests.

That being said, I don't have a strong opinion one way or the other.

btw I started playing with kunit following the instructions and ran into problems:

./tools/testing/kunit/kunit.py 
usage: kunit.py [-h] {run,new} ...

Helps writing and running KUnit tests.

positional arguments:
  {run,new}
    run       Runs KUnit tests.
    new       Prints out boilerplate for writing new tests.

optional arguments:
  -h, --help  show this help message and exit

./tools/testing/kunit/kunit.py run
Regenerating .config ...
ERROR:root:Provided Kconfig is not contained in validated .config!

thanks,
-- Shuah
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
