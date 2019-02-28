From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Thu, 28 Feb 2019 01:03:24 -0800
Message-ID: <CAFd5g46QCisA4PHQXo57-LC6sNdk=OUjBE0O1s4005uBz_Vo6Q@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <155121334527.260864.5324117081460979741@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <155121334527.260864.5324117081460979741-n1Xw8LXHxjTHt/MElyovVYaSKrA+ACpX0E9HWUfgJXw@public.gmane.org>
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
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Bird, Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>Linux Kernel Mailing List <linu>
List-Id: linux-nvdimm@lists.01.org

On Tue, Feb 26, 2019 at 12:35 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-02-14 13:37:20)
> > Add support for aborting/bailing out of test cases. Needed for
> > implementing assertions.
>
> Can you add some more text here with the motivating reasons for
> implementing assertions and bailing out of test cases?

Sure. Yeah, this comes before the commit that adds assertions, so I
should probably put a better explanation here.
>
> For example, I wonder why unit tests can't just return with a failure

Well, you could. You can just do the check as you would without KUnit,
except call KUNIT_FAIL(...) before you return. For example, instead
of:

KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);

you could do:

if (IS_ERR_OR_NULL(ptr)) {
        KUNIT_FAIL(test, "ptr is an errno or null: %ld", ptr);
        return;
}

> when they need to abort and then the test runner would detect that error
> via the return value from the 'run test' function. That would be a more
> direct approach, but also more verbose than a single KUNIT_ASSERT()
> line. It would be more kernel idiomatic too because the control flow

Yeah, I was intentionally going against that idiom. I think that idiom
makes test logic more complicated than it needs to be, especially if
the assertion failure happens in a helper function; then you have to
pass that error all the way back up. It is important that test code
should be as simple as possible to the point of being immediately
obviously correct at first glance because there are no tests for
tests.

The idea with assertions is that you use them to state all the
preconditions for your test. Logically speaking, these are the
premises of the test case, so if a premise isn't true, there is no
point in continuing the test case because there are no conclusions
that can be drawn without the premises. Whereas, the expectation is
the thing you are trying to prove. It is not used universally in
x-unit style test frameworks, but I really like it as a convention.
You could still express the idea of a premise using the above idiom,
but I think KUNIT_ASSERT_* states the intended idea perfectly.

> isn't hidden inside a macro and it isn't intimately connected with
> kthreads and completions.

Yeah, I wasn't a fan of that myself, but it was broadly available. My
previous version (still the architecture specific version for UML, not
in this patchset though) relies on UML_LONGJMP, but is obviously only
works on UML. A number of people wanted support for other
architectures. Rob and Luis specifically wanted me to provide a
version of abort that would work on any architecture, even if it only
had reduced functionality; I thought this fit the bill okay.

>
> >
> > Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> [...]
> > diff --git a/kunit/test-test.c b/kunit/test-test.c
> > new file mode 100644
> > index 0000000000000..a936c041f1c8f
>
> Could this whole file be another patch? It seems to be a test for the
> try catch mechanism.

Sure.

>
> > diff --git a/kunit/test.c b/kunit/test.c
> > index d18c50d5ed671..6e5244642ab07 100644
> > --- a/kunit/test.c
> > +++ b/kunit/test.c
> [...]
> > +
> > +static void kunit_generic_throw(struct kunit_try_catch *try_catch)
> > +{
> > +       try_catch->context.try_result = -EFAULT;
> > +       complete_and_exit(try_catch->context.try_completion, -EFAULT);
> > +}
> > +
> > +static int kunit_generic_run_threadfn_adapter(void *data)
> > +{
> > +       struct kunit_try_catch *try_catch = data;
> >
> > +       try_catch->try(&try_catch->context);
> > +
> > +       complete_and_exit(try_catch->context.try_completion, 0);
>
> The exit code doesn't matter, right? If so, it might be clearer to just
> return 0 from this function because kthreads exit themselves as far as I
> recall.

You mean complete and then return?

>
> > +}
> > +
> > +static void kunit_generic_run_try_catch(struct kunit_try_catch *try_catch)
> > +{
> > +       struct task_struct *task_struct;
> > +       struct kunit *test = try_catch->context.test;
> > +       int exit_code, wake_result;
> > +       DECLARE_COMPLETION(test_case_completion);
>
> DECLARE_COMPLETION_ONSTACK()?

Whoops, yeah, that one.

>
> > +
> > +       try_catch->context.try_completion = &test_case_completion;
> > +       try_catch->context.try_result = 0;
> > +       task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
> > +                                            try_catch,
> > +                                            "kunit_try_catch_thread");
> > +       if (IS_ERR_OR_NULL(task_struct)) {
>
> It looks like NULL is never returned from kthread_create(), so don't
> check for it here.

Bad habit, sorry.

>
> > +               try_catch->catch(&try_catch->context);
> > +               return;
> > +       }
> > +
> > +       wake_result = wake_up_process(task_struct);
> > +       if (wake_result != 0 && wake_result != 1) {
>
> These are the only two possible return values of wake_up_process(), so
> why not just use kthread_run() and check for an error on the process
> creation?

Good point, I am not sure why I did that.

>
> > +               kunit_err(test, "task was not woken properly: %d", wake_result);
> > +               try_catch->catch(&try_catch->context);
> > +       }
> > +
> > +       /*
> > +        * TODO(brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org): We should probably have some type of
> > +        * timeout here. The only question is what that timeout value should be.
> > +        *
> > +        * The intention has always been, at some point, to be able to label
> > +        * tests with some type of size bucket (unit/small, integration/medium,
> > +        * large/system/end-to-end, etc), where each size bucket would get a
> > +        * default timeout value kind of like what Bazel does:
> > +        * https://docs.bazel.build/versions/master/be/common-definitions.html#test.size
> > +        * There is still some debate to be had on exactly how we do this. (For
> > +        * one, we probably want to have some sort of test runner level
> > +        * timeout.)
> > +        *
> > +        * For more background on this topic, see:
> > +        * https://mike-bland.com/2011/11/01/small-medium-large.html
> > +        */
> > +       wait_for_completion(&test_case_completion);
>
> It doesn't seem like a bad idea to make this have some arbitrarily large
> timeout value to start with. Just to make sure the whole thing doesn't
> get wedged. It's a timeout, so in theory it should never trigger if it's
> large enough.

Seems reasonable.

>
> > +
> > +       exit_code = try_catch->context.try_result;
> > +       if (exit_code == -EFAULT)
> > +               try_catch->catch(&try_catch->context);
> > +       else if (exit_code == -EINTR)
> > +               kunit_err(test, "wake_up_process() was never called.");
>
> Does kunit_err() add newlines? It would be good to stick to the rest of
> kernel style (printk, tracing, etc.) and rely on the callers to have the
> newlines they want. Also, remove the full-stop because it isn't really
> necessary to have those in error logs.

Will do.

>
> > +       else if (exit_code)
> > +               kunit_err(test, "Unknown error: %d", exit_code);
> > +}
> > +
> > +void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch)
> > +{
> > +       try_catch->run = kunit_generic_run_try_catch;
>
> Is the idea that 'run' would be anything besides
> 'kunit_generic_run_try_catch'? If it isn't going to be different, then

Yeah, it can be overridden with an architecture specific version.

> maybe it's simpler to just have a function like
> kunit_generic_run_try_catch() that is called by the unit tests instead
> of having to write 'try_catch->run(try_catch)' and indirect for the
> basic case. Maybe I've missed the point entirely though and this is all
> scaffolding for more complicated exception handling later on.

Yeah, the idea is that different architectures can override exception
handling with their own implementation. This is just the generic one.
For example, UML has one that doesn't depend on kthreads or
completions; the UML version also allows recovery from some segfault
conditions.

>
> > +       try_catch->throw = kunit_generic_throw;
> > +}
> > +
> > +void __weak kunit_try_catch_init(struct kunit_try_catch *try_catch)
> > +{
> > +       kunit_generic_try_catch_init(try_catch);
> > +}
> > +
> > +static void kunit_try_run_case(struct kunit_try_catch_context *context)
> > +{
> > +       struct kunit_try_catch_context *ctx = context;
> > +       struct kunit *test = ctx->test;
> > +       struct kunit_module *module = ctx->module;
> > +       struct kunit_case *test_case = ctx->test_case;
> > +
> > +       /*
> > +        * kunit_run_case_internal may encounter a fatal error; if it does, we
> > +        * will jump to ENTER_HANDLER above instead of continuing normal control
>
> Where is 'ENTER_HANDLER' above?

Whoops, sorry, that is left over from v3. Will remove.

>
> > +        * flow.
> > +        */
> >         kunit_run_case_internal(test, module, test_case);
> > +       /* This line may never be reached. */
> >         kunit_run_case_cleanup(test, module, test_case);
> > +}

Thanks!
