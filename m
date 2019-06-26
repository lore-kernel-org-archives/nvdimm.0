From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v5 01/18] kunit: test: add KUnit test runner core
Date: Tue, 25 Jun 2019 17:07:32 -0700
Message-ID: <CAFd5g46TLAONgXiZkFM98BPd-sariMTwhmYG9hSJ+M9=r-ixeg@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-2-brendanhiggins@google.com> <20190625223312.GP19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190625223312.GP19023@42.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Peter Zijlstra <peterz@infradead.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah <shuah@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Masahiro Yamada <yamada.masahiro@socionext.com>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-ks>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 25, 2019 at 3:33 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Mon, Jun 17, 2019 at 01:25:56AM -0700, Brendan Higgins wrote:
> > +/**
> > + * module_test() - used to register a &struct kunit_module with KUnit.
> > + * @module: a statically allocated &struct kunit_module.
> > + *
> > + * Registers @module with the test framework. See &struct kunit_module for more
> > + * information.
> > + */
> > +#define module_test(module) \
> > +             static int module_kunit_init##module(void) \
> > +             { \
> > +                     return kunit_run_tests(&module); \
> > +             } \
> > +             late_initcall(module_kunit_init##module)
>
> Becuase late_initcall() is used, if these modules are built-in, this
> would preclude the ability to test things prior to this part of the
> kernel under UML or whatever architecture runs the tests. So, this
> limits the scope of testing. Small detail but the scope whould be
> documented.

You aren't the first person to complain about this (and I am not sure
it is the first time you have complained about it). Anyway, I have
some follow on patches that will improve the late_initcall thing, and
people seemed okay with discussing the follow on patches as part of a
subsequent patchset after this gets merged.

I will nevertheless document the restriction until then.

> > +static void kunit_print_tap_version(void)
> > +{
> > +     if (!kunit_has_printed_tap_version) {
> > +             kunit_printk_emit(LOGLEVEL_INFO, "TAP version 14\n");
>
> What is this TAP thing? Why should we care what version it is on?
> Why are we printing this?

It's part of the TAP specification[1]. Greg and Frank asked me to make
the intermediate format conform to TAP. Seems like something else I
should probable document...

> > +             kunit_has_printed_tap_version = true;
> > +     }
> > +}
> > +
> > +static size_t kunit_test_cases_len(struct kunit_case *test_cases)
> > +{
> > +     struct kunit_case *test_case;
> > +     size_t len = 0;
> > +
> > +     for (test_case = test_cases; test_case->run_case; test_case++)
>
> If we make the last test case NULL, we'd just check for test_case here,
> and save ourselves an extra few bytes per test module. Any reason why
> the last test case cannot be NULL?

Is there anyway to make that work with a statically defined array?

Basically, I want to be able to do something like:

static struct kunit_case example_test_cases[] = {
        KUNIT_CASE(example_simple_test),
        KUNIT_CASE(example_mock_test),
        {}
};

FYI,
#define KUNIT_CASE(test_name) { .run_case = test_name, .name = #test_name }

In order to do what you are proposing, I think I need an array of
pointers to test cases, which is not ideal.

> > +void kunit_init_test(struct kunit *test, const char *name)
> > +{
> > +     spin_lock_init(&test->lock);
> > +     test->name = name;
> > +     test->success = true;
> > +}
> > +
> > +/*
> > + * Performs all logic to run a test case.
> > + */
> > +static void kunit_run_case(struct kunit_module *module,
> > +                        struct kunit_case *test_case)
> > +{
> > +     struct kunit test;
> > +     int ret = 0;
> > +
> > +     kunit_init_test(&test, test_case->name);
> > +
> > +     if (module->init) {
> > +             ret = module->init(&test);
>
> I believe if we used struct kunit_module *kmodule it would be much
> clearer who's init this is.

That's reasonable. I will fix in next revision.

Cheers!

[1] https://github.com/TestAnything/Specification/blob/tap-14-specification/specification.md
