Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com
 [IPv6:2607:f8b0:4864:20::641])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 806DC21196834
 for <linux-nvdimm@lists.01.org>; Tue,  4 Dec 2018 02:52:19 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id w4so8124378plz.1
 for <linux-nvdimm@lists.01.org>; Tue, 04 Dec 2018 02:52:19 -0800 (PST)
Subject: Re: [RFC v3 00/19] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20181128193636.254378-1-brendanhiggins@google.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <8807ac55-44e7-0ab7-176d-a0f71bff07e6@gmail.com>
Date: Tue, 4 Dec 2018 02:52:11 -0800
MIME-Version: 1.0
In-Reply-To: <20181128193636.254378-1-brendanhiggins@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org
Cc: brakmo@fb.com, robh@kernel.org, knut.omang@oracle.com, richard@nod.at, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, Tim.Bird@sony.com, linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, kieran.bingham@ideasonboard.com, julia.lawall@lip6.fr, joel@jms.id.au, linux-kselftest@vger.kernel.org, khilman@baylibre.com, joe@perches.com, daniel@ffwll.ch, jdike@addtoit.com, kunit-dev@googlegroups.com
List-ID: <linux-nvdimm@lists.01.org>

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

This question might be a misunderstanding of the intent of some of the
terminology in the above paragraph, so this is mostly a request for
clarification.

With my pre-conception of what unit tests are, I read "test a single unit
of code" to mean a relatively narrow piece of a subsystem.  So if I
understand correctly, taking examples from patch 17 "of: unittest:
migrate tests to run on KUnit", each function call like
KUNIT_ASSERT_NOT_ERR_OR_NULL(), KUNIT_EXPECT_STREQ_MSG(), and
KUNIT_EXPECT_EQ_MSG() are each a separate unit test, and thus the
paragraph says that each of these function calls should have no
dependencies outside the test.  Do I understand that correctly?

< snip >

-Frank

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
