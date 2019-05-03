From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 08/17] kunit: test: add support for test abort
Date: Thu, 2 May 2019 23:48:30 -0700
Message-ID: <CAFd5g47hxAd=+72xbPJbWPdZCXRXmtLpsGhUh=zc7MSwfcaGJQ@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-9-brendanhiggins@google.com> <0a605543-477a-1854-eb35-6e586606889b@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a605543-477a-1854-eb35-6e586606889b@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah@kernel.org, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, "Bird, Timothy" <Tim.Bird@sony.com>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, May 2, 2019 at 8:15 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2019-05-01 5:01 p.m., Brendan Higgins wrote:
> > +/*
> > + * struct kunit_try_catch - provides a generic way to run code which might fail.
> > + * @context: used to pass user data to the try and catch functions.
> > + *
> > + * kunit_try_catch provides a generic, architecture independent way to execute
> > + * an arbitrary function of type kunit_try_catch_func_t which may bail out by
> > + * calling kunit_try_catch_throw(). If kunit_try_catch_throw() is called, @try
> > + * is stopped at the site of invocation and @catch is catch is called.
>
> I found some of the C++ comparisons in this series a bit distasteful but
> wasn't going to say anything until I saw the try catch.... But looking
> into the implementation it's just a thread that can exit early which
> seems fine to me. Just a poor choice of name I guess...

Guilty as charged (I have a long history with C++, sorry). Would you
prefer I changed the name? I just figured that try-catch is a commonly
understood pattern that describes exactly what I am doing.

>
> [snip]
>
> > +static void __noreturn kunit_abort(struct kunit *test)
> > +{
> > +     kunit_set_death_test(test, true);
> > +
> > +     kunit_try_catch_throw(&test->try_catch);
> > +
> > +     /*
> > +      * Throw could not abort from test.
> > +      *
> > +      * XXX: we should never reach this line! As kunit_try_catch_throw is
> > +      * marked __noreturn.
> > +      */
> > +     WARN_ONCE(true, "Throw could not abort from test!\n");
> > +}
> > +
> >  int kunit_init_test(struct kunit *test, const char *name)
> >  {
> >       spin_lock_init(&test->lock);
> > @@ -77,6 +103,7 @@ int kunit_init_test(struct kunit *test, const char *name)
> >       test->name = name;
> >       test->vprintk = kunit_vprintk;
> >       test->fail = kunit_fail;
> > +     test->abort = kunit_abort;
>
> There are a number of these function pointers which seem to be pointless
> to me as you only ever set them to one function. Just call the function
> directly. As it is, it is an unnecessary indirection for someone reading
> the code. If and when you have multiple implementations of the function
> then add the pointer. Don't assume you're going to need it later on and
> add all this maintenance burden if you never use it..

Ah, yes, Frank (and probably others) previously asked me to remove
unnecessary method pointers; I removed all the totally unused ones. As
for these, I don't use them in this patchset, but I use them in my
patchsets that will follow up this one. These in particular are
present so that they can be mocked out for testing.

>
> [snip]
>
> > +void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch)
> > +{
> > +     try_catch->run = kunit_generic_run_try_catch;
> > +     try_catch->throw = kunit_generic_throw;
> > +}
>
> Same here. There's only one implementation of try_catch and I can't
> really see any sensible justification for another implementation. Even
> if there is, add the indirection when the second implementation is
> added. This isn't C++ and we don't need to make everything a "method".

These methods are for a UML specific implementation in a follow up
patchset, which is needed for some features like crash recovery, death
tests, and removes dependence on kthreads.

I know this probably sounds like premature complexity. Arguably it is
in hindsight, but I wrote those features before I pulled out these
interfaces (they were actually both originally in this patchset, but I
dropped them to make this patchset easier to review). I can remove
these methods and add them back in when I actually use them in the
follow up patchsets if you prefer.

Thanks!
