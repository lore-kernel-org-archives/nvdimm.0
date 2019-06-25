Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 25 Jun 2019 22:33:12 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v5 01/18] kunit: test: add KUnit test runner core
Message-ID: <20190625223312.GP19023@42.do-not-panic.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-2-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617082613.109131-2-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 17, 2019 at 01:25:56AM -0700, Brendan Higgins wrote:
> +/**
> + * module_test() - used to register a &struct kunit_module with KUnit.
> + * @module: a statically allocated &struct kunit_module.
> + *
> + * Registers @module with the test framework. See &struct kunit_module for more
> + * information.
> + */
> +#define module_test(module) \
> +		static int module_kunit_init##module(void) \
> +		{ \
> +			return kunit_run_tests(&module); \
> +		} \
> +		late_initcall(module_kunit_init##module)

Becuase late_initcall() is used, if these modules are built-in, this
would preclude the ability to test things prior to this part of the
kernel under UML or whatever architecture runs the tests. So, this
limits the scope of testing. Small detail but the scope whould be
documented.

> +static void kunit_print_tap_version(void)
> +{
> +	if (!kunit_has_printed_tap_version) {
> +		kunit_printk_emit(LOGLEVEL_INFO, "TAP version 14\n");

What is this TAP thing? Why should we care what version it is on?
Why are we printing this?

> +		kunit_has_printed_tap_version = true;
> +	}
> +}
> +
> +static size_t kunit_test_cases_len(struct kunit_case *test_cases)
> +{
> +	struct kunit_case *test_case;
> +	size_t len = 0;
> +
> +	for (test_case = test_cases; test_case->run_case; test_case++)

If we make the last test case NULL, we'd just check for test_case here,
and save ourselves an extra few bytes per test module. Any reason why
the last test case cannot be NULL?

> +void kunit_init_test(struct kunit *test, const char *name)
> +{
> +	spin_lock_init(&test->lock);
> +	test->name = name;
> +	test->success = true;
> +}
> +
> +/*
> + * Performs all logic to run a test case.
> + */
> +static void kunit_run_case(struct kunit_module *module,
> +			   struct kunit_case *test_case)
> +{
> +	struct kunit test;
> +	int ret = 0;
> +
> +	kunit_init_test(&test, test_case->name);
> +
> +	if (module->init) {
> +		ret = module->init(&test);

I believe if we used struct kunit_module *kmodule it would be much
clearer who's init this is.

  Luis
