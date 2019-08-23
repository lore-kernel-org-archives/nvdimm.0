From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v14 01/18] kunit: test: add KUnit test runner core
Date: Fri, 23 Aug 2019 09:33:13 -0600
Message-ID: <7f2c8908-75f6-b793-7113-ad57c51777ce@kernel.org>
References: <20190820232046.50175-1-brendanhiggins@google.com>
 <20190820232046.50175-2-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820232046.50175-2-brendanhiggins@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>, frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, shuah <shuah@kernel.org>, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

Hi Brendan,

On 8/20/19 5:20 PM, Brendan Higgins wrote:
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
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Stephen Boyd <sboyd@kernel.org>
> ---
>   include/kunit/test.h | 179 ++++++++++++++++++++++++++++++++++++++++
>   kunit/Kconfig        |  17 ++++
>   kunit/Makefile       |   1 +
>   kunit/test.c         | 191 +++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 388 insertions(+)
>   create mode 100644 include/kunit/test.h
>   create mode 100644 kunit/Kconfig
>   create mode 100644 kunit/Makefile
>   create mode 100644 kunit/test.c
> 
> diff --git a/include/kunit/test.h b/include/kunit/test.h
> new file mode 100644
> index 0000000000000..e0b34acb9ee4e
> --- /dev/null
> +++ b/include/kunit/test.h
> @@ -0,0 +1,179 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Base unit test (KUnit) API.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#ifndef _KUNIT_TEST_H
> +#define _KUNIT_TEST_H
> +
> +#include <linux/types.h>
> +
> +struct kunit;
> +
> +/**
> + * struct kunit_case - represents an individual test case.
> + * @run_case: the function representing the actual test case.
> + * @name: the name of the test case.
> + *
> + * A test case is a function with the signature, ``void (*)(struct kunit *)``
> + * that makes expectations (see KUNIT_EXPECT_TRUE()) about code under test. Each
> + * test case is associated with a &struct kunit_suite and will be run after the
> + * suite's init function and followed by the suite's exit function.
> + *
> + * A test case should be static and should only be created with the KUNIT_CASE()
> + * macro; additionally, every array of test cases should be terminated with an
> + * empty test case.
> + *
> + * Example:

Can you fix these line continuations. It makes it very hard to read.
Sorry for this late comment. These comments lines are longer than 80
and wrap.

There are several comment lines in the file that are way too long.

thanks,
-- Shuah
