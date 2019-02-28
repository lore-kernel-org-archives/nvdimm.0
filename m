Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 76627211CFBE7
 for <linux-nvdimm@lists.01.org>; Thu, 28 Feb 2019 10:02:25 -0800 (PST)
MIME-Version: 1.0
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <155121334527.260864.5324117081460979741@swboyd.mtv.corp.google.com>
 <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com>
Message-ID: <155137694423.260864.2846034318906225490@swboyd.mtv.corp.google.com>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com>
Date: Thu, 28 Feb 2019 10:02:24 -0800
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
Cc: brakmo@fb.com, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, dan.carpenter@oracle.com, devicetree <devicetree@vger.kernel.org>, shuah@kernel.org, "Bird, Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, om@ml01.01.org, Petr Mladek <pmladek@suse.c>, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

Quoting Brendan Higgins (2019-02-28 01:03:24)
> On Tue, Feb 26, 2019 at 12:35 PM Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > when they need to abort and then the test runner would detect that error
> > via the return value from the 'run test' function. That would be a more
> > direct approach, but also more verbose than a single KUNIT_ASSERT()
> > line. It would be more kernel idiomatic too because the control flow
> 
> Yeah, I was intentionally going against that idiom. I think that idiom
> makes test logic more complicated than it needs to be, especially if
> the assertion failure happens in a helper function; then you have to
> pass that error all the way back up. It is important that test code
> should be as simple as possible to the point of being immediately
> obviously correct at first glance because there are no tests for
> tests.
> 
> The idea with assertions is that you use them to state all the
> preconditions for your test. Logically speaking, these are the
> premises of the test case, so if a premise isn't true, there is no
> point in continuing the test case because there are no conclusions
> that can be drawn without the premises. Whereas, the expectation is
> the thing you are trying to prove. It is not used universally in
> x-unit style test frameworks, but I really like it as a convention.
> You could still express the idea of a premise using the above idiom,
> but I think KUNIT_ASSERT_* states the intended idea perfectly.

Fair enough. It would be great if these sorts of things were described
in the commit text.

Is the assumption that things like held locks and refcounted elements
won't exist when one of these assertions is made? It sounds like some of
the cleanup logic could be fairly complicated if a helper function
changes some state and then an assert fails and we have to unwind all
the state from a corrupt location. A similar problem exists for a test
timeout too. How do we get back to a sane state if the test locks up for
a long time? Just don't try?

> 
> > isn't hidden inside a macro and it isn't intimately connected with
> > kthreads and completions.
> 
> Yeah, I wasn't a fan of that myself, but it was broadly available. My
> previous version (still the architecture specific version for UML, not
> in this patchset though) relies on UML_LONGJMP, but is obviously only
> works on UML. A number of people wanted support for other
> architectures. Rob and Luis specifically wanted me to provide a
> version of abort that would work on any architecture, even if it only
> had reduced functionality; I thought this fit the bill okay.

Ok.

> 
> >
> > >
> > > diff --git a/kunit/test.c b/kunit/test.c
> > > index d18c50d5ed671..6e5244642ab07 100644
> > > --- a/kunit/test.c
> > > +++ b/kunit/test.c
> > [...]
> > > +
> > > +static void kunit_generic_throw(struct kunit_try_catch *try_catch)
> > > +{
> > > +       try_catch->context.try_result = -EFAULT;
> > > +       complete_and_exit(try_catch->context.try_completion, -EFAULT);
> > > +}
> > > +
> > > +static int kunit_generic_run_threadfn_adapter(void *data)
> > > +{
> > > +       struct kunit_try_catch *try_catch = data;
> > >
> > > +       try_catch->try(&try_catch->context);
> > > +
> > > +       complete_and_exit(try_catch->context.try_completion, 0);
> >
> > The exit code doesn't matter, right? If so, it might be clearer to just
> > return 0 from this function because kthreads exit themselves as far as I
> > recall.
> 
> You mean complete and then return?

Yes. I was confused for a minute because I thought the exit code was
checked, but it isn't. Instead, the try_catch->context.try_result is
where the test result goes, so calling exit explicitly doesn't seem to
be important here, but it is important in the throw case.

> 
> >
> > > +       else if (exit_code)
> > > +               kunit_err(test, "Unknown error: %d", exit_code);
> > > +}
> > > +
> > > +void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch)
> > > +{
> > > +       try_catch->run = kunit_generic_run_try_catch;
> >
> > Is the idea that 'run' would be anything besides
> > 'kunit_generic_run_try_catch'? If it isn't going to be different, then
> 
> Yeah, it can be overridden with an architecture specific version.
> 
> > maybe it's simpler to just have a function like
> > kunit_generic_run_try_catch() that is called by the unit tests instead
> > of having to write 'try_catch->run(try_catch)' and indirect for the
> > basic case. Maybe I've missed the point entirely though and this is all
> > scaffolding for more complicated exception handling later on.
> 
> Yeah, the idea is that different architectures can override exception
> handling with their own implementation. This is just the generic one.
> For example, UML has one that doesn't depend on kthreads or
> completions; the UML version also allows recovery from some segfault
> conditions.

Ok, got it. It may still be nice to have a wrapper or macro for that
try_catch->run(try_catch) statement so we don't have to know that a
try_catch struct has a run member.

	static inline void kunit_run_try_catch(struct kunit_try_catch *try_catch)
	{
		try_catch->run(try_catch);
	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
