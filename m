From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v14 09/18] kunit: test: add support for test abort
Date: Fri, 23 Aug 2019 09:36:34 -0600
Message-ID: <ae6722ce-80ac-5840-5c4b-6f6726e4239d@kernel.org>
References: <20190820232046.50175-1-brendanhiggins@google.com>
 <20190820232046.50175-10-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820232046.50175-10-brendanhiggins@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>, frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com, shuah <shuah@kernel.org>
List-Id: linux-nvdimm@lists.01.org

Hi Brendan,

On 8/20/19 5:20 PM, Brendan Higgins wrote:
> Add support for aborting/bailing out of test cases, which is needed for
> implementing assertions.
> 
> An assertion is like an expectation, but bails out of the test case
> early if the assertion is not met. The idea with assertions is that you
> use them to state all the preconditions for your test. Logically
> speaking, these are the premises of the test case, so if a premise isn't
> true, there is no point in continuing the test case because there are no
> conclusions that can be drawn without the premises. Whereas, the
> expectation is the thing you are trying to prove.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Reviewed-by: Stephen Boyd <sboyd@kernel.org>
> ---
>   include/kunit/test.h      |   2 +
>   include/kunit/try-catch.h |  75 +++++++++++++++++++++
>   kunit/Makefile            |   3 +-
>   kunit/test.c              | 137 +++++++++++++++++++++++++++++++++-----
>   kunit/try-catch.c         | 118 ++++++++++++++++++++++++++++++++
>   5 files changed, 319 insertions(+), 16 deletions(-)
>   create mode 100644 include/kunit/try-catch.h
>   create mode 100644 kunit/try-catch.c
> 
> diff --git a/include/kunit/test.h b/include/kunit/test.h
> index 6917b186b737a..390ce02f717b6 100644
> --- a/include/kunit/test.h
> +++ b/include/kunit/test.h
> @@ -10,6 +10,7 @@
>   #define _KUNIT_TEST_H
>   
>   #include <kunit/assert.h>
> +#include <kunit/try-catch.h>
>   #include <linux/kernel.h>
>   #include <linux/slab.h>
>   #include <linux/types.h>
> @@ -167,6 +168,7 @@ struct kunit {
>   
>   	/* private: internal use only. */
>   	const char *name; /* Read only after initialization! */
> +	struct kunit_try_catch try_catch;
>   	/*
>   	 * success starts as true, and may only be set to false during a test
>   	 * case; thus, it is safe to update this across multiple threads using
> diff --git a/include/kunit/try-catch.h b/include/kunit/try-catch.h
> new file mode 100644
> index 0000000000000..404f336cbdc85
> --- /dev/null
> +++ b/include/kunit/try-catch.h
> @@ -0,0 +1,75 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * An API to allow a function, that may fail, to be executed, and recover in a
> + * controlled manner.
> + *
> + * Copyright (C) 2019, Google LLC.
> + * Author: Brendan Higgins <brendanhiggins@google.com>
> + */
> +
> +#ifndef _KUNIT_TRY_CATCH_H
> +#define _KUNIT_TRY_CATCH_H
> +
> +#include <linux/types.h>
> +
> +typedef void (*kunit_try_catch_func_t)(void *);
> +
> +struct completion;
> +struct kunit;
> +
> +/**
> + * struct kunit_try_catch - provides a generic way to run code which might fail.
> + * @test: The test case that is currently being executed.
> + * @try_completion: Completion that the control thread waits on while test runs.
> + * @try_result: Contains any errno obtained while running test case.
> + * @try: The function, the test case, to attempt to run.
> + * @catch: The function called if @try bails out.
> + * @context: used to pass user data to the try and catch functions.
> + *
> + * kunit_try_catch provides a generic, architecture independent way to execute
> + * an arbitrary function of type kunit_try_catch_func_t which may bail out by
> + * calling kunit_try_catch_throw(). If kunit_try_catch_throw() is called, @try
> + * is stopped at the site of invocation and @catch is called.
> + *
> + * struct kunit_try_catch provides a generic interface for the functionality
> + * needed to implement kunit->abort() which in turn is needed for implementing
> + * assertions. Assertions allow stating a precondition for a test simplifying
> + * how test cases are written and presented.
> + *
> + * Assertions are like expectations, except they abort (call
> + * kunit_try_catch_throw()) when the specified condition is not met. This is
> + * useful when you look at a test case as a logical statement about some piece
> + * of code, where assertions are the premises for the test case, and the
> + * conclusion is a set of predicates, rather expectations, that must all be
> + * true. If your premises are violated, it does not makes sense to continue.
> + */
> +struct kunit_try_catch {
> +	/* private: internal use only. */
> +	struct kunit *test;
> +	struct completion *try_completion;
> +	int try_result;
> +	kunit_try_catch_func_t try;
> +	kunit_try_catch_func_t catch;
> +	void *context;
> +};
> +
> +void kunit_try_catch_init(struct kunit_try_catch *try_catch,
> +			  struct kunit *test,
> +			  kunit_try_catch_func_t try,
> +			  kunit_try_catch_func_t catch);
> +
> +void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context);
> +
> +void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch);
> +
> +static inline int kunit_try_catch_get_result(struct kunit_try_catch *try_catch)
> +{
> +	return try_catch->try_result;
> +}
> +
> +/*
> + * Exposed for testing only.
> + */
> +void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch);
> +
> +#endif /* _KUNIT_TRY_CATCH_H */
> diff --git a/kunit/Makefile b/kunit/Makefile
> index 4e46450bcb3a8..c9176c9c578c6 100644
> --- a/kunit/Makefile
> +++ b/kunit/Makefile
> @@ -1,6 +1,7 @@
>   obj-$(CONFIG_KUNIT) +=			test.o \
>   					string-stream.o \
> -					assert.o
> +					assert.o \
> +					try-catch.o
>   
>   obj-$(CONFIG_KUNIT_TEST) +=		string-stream-test.o
>   
> diff --git a/kunit/test.c b/kunit/test.c
> index 3cbceb34b3b36..ded9895143209 100644
> --- a/kunit/test.c
> +++ b/kunit/test.c
> @@ -7,7 +7,9 @@
>    */
>   
>   #include <kunit/test.h>
> +#include <kunit/try-catch.h>
>   #include <linux/kernel.h>
> +#include <linux/sched/debug.h>
>   
>   static void kunit_set_failure(struct kunit *test)
>   {
> @@ -162,6 +164,19 @@ static void kunit_fail(struct kunit *test, struct kunit_assert *assert)
>   	WARN_ON(string_stream_destroy(stream));
>   }
>   
> +static void __noreturn kunit_abort(struct kunit *test)
> +{
> +	kunit_try_catch_throw(&test->try_catch); /* Does not return. */
> +
> +	/*
> +	 * Throw could not abort from test.
> +	 *
> +	 * XXX: we should never reach this line! As kunit_try_catch_throw is
> +	 * marked __noreturn.
> +	 */
> +	BUG();


I recall discussion on this. What's the point in keeping thie
BUG() around when it doesn't even reach? It can even be a
WARN_ON() in that case right?

thanks,
-- Shuah
