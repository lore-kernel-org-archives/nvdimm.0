Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FBBF21188C47
 for <linux-nvdimm@lists.01.org>; Fri,  2 Nov 2018 11:44:48 -0700 (PDT)
Subject: Re: [RFC v2 01/14] kunit: test: add KUnit test runner core
References: <20181023235750.103146-1-brendanhiggins@google.com>
 <20181023235750.103146-2-brendanhiggins@google.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <017b111f-d960-c1ef-46ae-eb0eb639fe5b@kernel.org>
Date: Fri, 2 Nov 2018 12:44:46 -0600
MIME-Version: 1.0
In-Reply-To: <20181023235750.103146-2-brendanhiggins@google.com>
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

On 10/23/2018 05:57 PM, Brendan Higgins wrote:
> Add core facilities for defining unit tests; this provides a common way
> to define test cases, functions that execute code which is under test
> and determine whether the code under test behaves as expected; this also
> provides a way to group together related test cases in test suites (here
> we call them test_modules).
> 
> Just define test cases and how to execute them for now; setting
> expectations on code will be defined later.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  include/kunit/test.h | 165 ++++++++++++++++++++++++++++++++++++++++++
>  kunit/Kconfig        |  17 +++++
>  kunit/Makefile       |   1 +
>  kunit/test.c         | 168 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 351 insertions(+)
>  create mode 100644 include/kunit/test.h
>  create mode 100644 kunit/Kconfig
>  create mode 100644 kunit/Makefile
>  create mode 100644 kunit/test.c
> 
> diff --git a/include/kunit/test.h b/include/kunit/test.h
> new file mode 100644
> index 0000000000000..e0b14b227ac44
> --- /dev/null
> +++ b/include/kunit/test.h
> @@ -0,0 +1,165 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Base unit test (KUnit) API.
> + *
> + * Copyright (C) 2018, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#ifndef _KUNIT_TEST_H
> +#define _KUNIT_TEST_H
> +
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +
> +struct test;
> +
> +/**
> + * struct test_case - represents an individual test case.
> + * @run_case: the function representing the actual test case.
> + * @name: the name of the test case.
> + *
> + * A test case is a function with the signature, ``void (*)(struct test *)``
> + * that makes expectations (see TEST_EXPECT_TRUE()) about code under test. Each
> + * test case is associated with a &struct test_module and will be run after the
> + * module's init function and followed by the module's exit function.
> + *
> + * A test case should be static and should only be created with the TEST_CASE()
> + * macro; additionally, every array of test cases should be terminated with an
> + * empty test case.
> + *
> + * Example:
> + *
> + * .. code-block:: c
> + *
> + *	void add_test_basic(struct test *test)
> + *	{
> + *		TEST_EXPECT_EQ(test, 1, add(1, 0));
> + *		TEST_EXPECT_EQ(test, 2, add(1, 1));
> + *		TEST_EXPECT_EQ(test, 0, add(-1, 1));
> + *		TEST_EXPECT_EQ(test, INT_MAX, add(0, INT_MAX));
> + *		TEST_EXPECT_EQ(test, -1, add(INT_MAX, INT_MIN));
> + *	}
> + *
> + *	static struct test_case example_test_cases[] = {
> + *		TEST_CASE(add_test_basic),
> + *		{},
> + *	};
> + *
> + */
> +struct test_case {
> +	void (*run_case)(struct test *test);
> +	const char name[256];
> +
> +	/* private: internal use only. */
> +	bool success;
> +};
> +

Introducing a prefix kunit_* might be a good idea for the API.
This comment applies to the rest of patches as well.

thanks,
-- Shuah
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
