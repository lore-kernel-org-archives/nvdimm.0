Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
 [209.85.210.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 961FF2194EB75
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 20:36:46 -0700 (PDT)
Received: by mail-pf1-f196.google.com with SMTP id m30so527658pff.8
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 20:36:46 -0700 (PDT)
Date: Wed, 26 Jun 2019 03:36:43 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v5 01/18] kunit: test: add KUnit test runner core
Message-ID: <20190626033643.GX19023@42.do-not-panic.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-2-brendanhiggins@google.com>
 <20190625223312.GP19023@42.do-not-panic.com>
 <CAFd5g46TLAONgXiZkFM98BPd-sariMTwhmYG9hSJ+M9=r-ixeg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFd5g46TLAONgXiZkFM98BPd-sariMTwhmYG9hSJ+M9=r-ixeg@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Poimboeuf <jpoimboe@redhat.com>, kunit-dev@googlegroups.com, Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Stephen Boyd <sboyd@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 25, 2019 at 05:07:32PM -0700, Brendan Higgins wrote:
> On Tue, Jun 25, 2019 at 3:33 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Mon, Jun 17, 2019 at 01:25:56AM -0700, Brendan Higgins wrote:
> > > +/**
> > > + * module_test() - used to register a &struct kunit_module with KUnit.
> > > + * @module: a statically allocated &struct kunit_module.
> > > + *
> > > + * Registers @module with the test framework. See &struct kunit_module for more
> > > + * information.
> > > + */
> > > +#define module_test(module) \
> > > +             static int module_kunit_init##module(void) \
> > > +             { \
> > > +                     return kunit_run_tests(&module); \
> > > +             } \
> > > +             late_initcall(module_kunit_init##module)
> >
> > Becuase late_initcall() is used, if these modules are built-in, this
> > would preclude the ability to test things prior to this part of the
> > kernel under UML or whatever architecture runs the tests. So, this
> > limits the scope of testing. Small detail but the scope whould be
> > documented.
> 
> You aren't the first person to complain about this (and I am not sure
> it is the first time you have complained about it). Anyway, I have
> some follow on patches that will improve the late_initcall thing, and
> people seemed okay with discussing the follow on patches as part of a
> subsequent patchset after this gets merged.
> 
> I will nevertheless document the restriction until then.

To be clear, I am not complaining about it. I just find it simply
critical to document its limitations, so folks don't try to invest
time and energy on kunit right away for an early init test, if it
cannot support it.

If support for that requires some work, it may be worth mentioning
as well.

> > > +static void kunit_print_tap_version(void)
> > > +{
> > > +     if (!kunit_has_printed_tap_version) {
> > > +             kunit_printk_emit(LOGLEVEL_INFO, "TAP version 14\n");
> >
> > What is this TAP thing? Why should we care what version it is on?
> > Why are we printing this?
> 
> It's part of the TAP specification[1]. Greg and Frank asked me to make
> the intermediate format conform to TAP. Seems like something else I
> should probable document...

Yes thanks!

> > > +             kunit_has_printed_tap_version = true;
> > > +     }
> > > +}
> > > +
> > > +static size_t kunit_test_cases_len(struct kunit_case *test_cases)
> > > +{
> > > +     struct kunit_case *test_case;
> > > +     size_t len = 0;
> > > +
> > > +     for (test_case = test_cases; test_case->run_case; test_case++)
> >
> > If we make the last test case NULL, we'd just check for test_case here,
> > and save ourselves an extra few bytes per test module. Any reason why
> > the last test case cannot be NULL?
> 
> Is there anyway to make that work with a statically defined array?

No you're right.

> Basically, I want to be able to do something like:
> 
> static struct kunit_case example_test_cases[] = {
>         KUNIT_CASE(example_simple_test),
>         KUNIT_CASE(example_mock_test),
>         {}
> };
> 
> FYI,
> #define KUNIT_CASE(test_name) { .run_case = test_name, .name = #test_name }

> 
> In order to do what you are proposing, I think I need an array of
> pointers to test cases, which is not ideal.

Yeah, you're right. The only other alternative is to have a:

struct kunit_module {
       const char name[256];
       int (*init)(struct kunit *test);
       void (*exit)(struct kunit *test);
       struct kunit_case *test_cases;
+       unsigned int num_cases;
};

And then something like:

#define KUNIT_MODULE(name, init, exit, cases) { \
	.name = name, \
	.init = init, \
	.exit = exit, \
	.test_cases = cases,
	num_cases = ARRAY_SIZE(cases), \
}

Let's evaluate which is better: one extra test case per all test cases, or
an extra unsigned int for each kunit module.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
