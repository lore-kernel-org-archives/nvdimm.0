Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com
 [IPv6:2607:f8b0:4864:20::d34])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE9D521A02937
 for <linux-nvdimm@lists.01.org>; Wed, 17 Oct 2018 20:55:53 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m16-v6so20183705ioj.4
 for <linux-nvdimm@lists.01.org>; Wed, 17 Oct 2018 20:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20181016235120.138227-1-brendanhiggins@google.com>
In-Reply-To: <20181016235120.138227-1-brendanhiggins@google.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Oct 2018 20:55:41 -0700
Message-ID: <CAA9_cmeRE3mPvxb3NciGFYjNu9aMFx4iTMeUq2fC3UtsyXky2A@mail.gmail.com>
Subject: Re: [RFC v1 00/31] kunit: Introducing KUnit, the Linux kernel unit
 testing framework
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
To: brendanhiggins@google.com
Cc: brakmo@fb.com, richard@nod.at, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, jdike@addtoit.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, linux-um@lists.infradead.org, Julia Lawall <julia.lawall@lip6.fr>, mcgrof@kernel.org, joel@jms.id.au, linux-kselftest@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, shuah@kernel.org, khilman@baylibre.com, kunit-dev@googlegroups.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 16, 2018 at 4:54 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
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

Nice! I've been using mocking techniques in kernel code for the
libnvdimm test infrastructure in tools/testing/nvdimm/. It's part unit
test infrastructure, part emulation, and I've always had the feeling
it's all a bit too adhoc. I'm going to take a look and see what can be
converted to kunit. Please include linux-nvdimm@lists.01.org on future
postings.

I'll shamelessly plug my lwn article about unit testing
https://lwn.net/Articles/654071/ because it's always good to find
fellow co-travelers to compare notes and advocate for more test
oriented kernel development.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
