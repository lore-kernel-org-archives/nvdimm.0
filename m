From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Mon, 4 Mar 2019 14:39:47 -0800
Message-ID: <CAFd5g46v5tYRcXaAj9j6XBaO14q1R+2-7LOSgdgJSkwWqDim4g@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <155121334527.260864.5324117081460979741@swboyd.mtv.corp.google.com>
 <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com>
 <155137694423.260864.2846034318906225490@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <155137694423.260864.2846034318906225490-n1Xw8LXHxjTHt/MElyovVYaSKrA+ACpX0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux
List-Id: linux-nvdimm@lists.01.org

On Thu, Feb 28, 2019 at 10:02 AM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-02-28 01:03:24)
> > On Tue, Feb 26, 2019 at 12:35 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > when they need to abort and then the test runner would detect that error
> > > via the return value from the 'run test' function. That would be a more
> > > direct approach, but also more verbose than a single KUNIT_ASSERT()
> > > line. It would be more kernel idiomatic too because the control flow
> >
> > Yeah, I was intentionally going against that idiom. I think that idiom
> > makes test logic more complicated than it needs to be, especially if
> > the assertion failure happens in a helper function; then you have to
> > pass that error all the way back up. It is important that test code
> > should be as simple as possible to the point of being immediately
> > obviously correct at first glance because there are no tests for
> > tests.
> >
> > The idea with assertions is that you use them to state all the
> > preconditions for your test. Logically speaking, these are the
> > premises of the test case, so if a premise isn't true, there is no
> > point in continuing the test case because there are no conclusions
> > that can be drawn without the premises. Whereas, the expectation is
> > the thing you are trying to prove. It is not used universally in
> > x-unit style test frameworks, but I really like it as a convention.
> > You could still express the idea of a premise using the above idiom,
> > but I think KUNIT_ASSERT_* states the intended idea perfectly.
>
> Fair enough. It would be great if these sorts of things were described
> in the commit text.

Good point. Will fix.

>
> Is the assumption that things like held locks and refcounted elements
> won't exist when one of these assertions is made? It sounds like some of
> the cleanup logic could be fairly complicated if a helper function
> changes some state and then an assert fails and we have to unwind all
> the state from a corrupt location. A similar problem exists for a test
> timeout too. How do we get back to a sane state if the test locks up for
> a long time? Just don't try?

It depends on the situation, if it is part of a KUnit test itself
(probably not code under test), then you can use the kunit_resource
API: https://lkml.org/lkml/2019/2/14/1125; it is inspired by the
devm_* family of functions, such that when a KUnit test case ends, for
any reason, all the kunit_resources are automatically cleaned up.
Similarly, kunit_module.exit is called at the end of every test case,
regardless of how it terminates.

>
> >
> > > isn't hidden inside a macro and it isn't intimately connected with
> > > kthreads and completions.
> >
> > Yeah, I wasn't a fan of that myself, but it was broadly available. My
> > previous version (still the architecture specific version for UML, not
> > in this patchset though) relies on UML_LONGJMP, but is obviously only
> > works on UML. A number of people wanted support for other
> > architectures. Rob and Luis specifically wanted me to provide a
> > version of abort that would work on any architecture, even if it only
> > had reduced functionality; I thought this fit the bill okay.
>
> Ok.
>
> >
> > >
> > > >
> > > > diff --git a/kunit/test.c b/kunit/test.c
> > > > index d18c50d5ed671..6e5244642ab07 100644
> > > > --- a/kunit/test.c
> > > > +++ b/kunit/test.c
> > > [...]
> > > > +
> > > > +static void kunit_generic_throw(struct kunit_try_catch *try_catch)
> > > > +{
> > > > +       try_catch->context.try_result = -EFAULT;
> > > > +       complete_and_exit(try_catch->context.try_completion, -EFAULT);
> > > > +}
> > > > +
> > > > +static int kunit_generic_run_threadfn_adapter(void *data)
> > > > +{
> > > > +       struct kunit_try_catch *try_catch = data;
> > > >
> > > > +       try_catch->try(&try_catch->context);
> > > > +
> > > > +       complete_and_exit(try_catch->context.try_completion, 0);
> > >
> > > The exit code doesn't matter, right? If so, it might be clearer to just
> > > return 0 from this function because kthreads exit themselves as far as I
> > > recall.
> >
> > You mean complete and then return?
>
> Yes. I was confused for a minute because I thought the exit code was
> checked, but it isn't. Instead, the try_catch->context.try_result is
> where the test result goes, so calling exit explicitly doesn't seem to
> be important here, but it is important in the throw case.

Yep.

>
> >
> > >
> > > > +       else if (exit_code)
> > > > +               kunit_err(test, "Unknown error: %d", exit_code);
> > > > +}
> > > > +
> > > > +void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch)
> > > > +{
> > > > +       try_catch->run = kunit_generic_run_try_catch;
> > >
> > > Is the idea that 'run' would be anything besides
> > > 'kunit_generic_run_try_catch'? If it isn't going to be different, then
> >
> > Yeah, it can be overridden with an architecture specific version.
> >
> > > maybe it's simpler to just have a function like
> > > kunit_generic_run_try_catch() that is called by the unit tests instead
> > > of having to write 'try_catch->run(try_catch)' and indirect for the
> > > basic case. Maybe I've missed the point entirely though and this is all
> > > scaffolding for more complicated exception handling later on.
> >
> > Yeah, the idea is that different architectures can override exception
> > handling with their own implementation. This is just the generic one.
> > For example, UML has one that doesn't depend on kthreads or
> > completions; the UML version also allows recovery from some segfault
> > conditions.
>
> Ok, got it. It may still be nice to have a wrapper or macro for that
> try_catch->run(try_catch) statement so we don't have to know that a
> try_catch struct has a run member.
>
>         static inline void kunit_run_try_catch(struct kunit_try_catch *try_catch)
>         {
>                 try_catch->run(try_catch);
>         }

Makes sense. Will fix in the next revision.
