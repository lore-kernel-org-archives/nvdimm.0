From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v4 02/17] kunit: test: add test resource management API
Date: Tue, 19 Feb 2019 15:24:01 -0800
Message-ID: <CAFd5g47yPUQFiEb4PaN_6xgY-ORTr-Z6W_gf8sWmpQ82fuSB_g@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-3-brendanhiggins@google.com> <155026451067.115909.17082794837098610153@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155026451067.115909.17082794837098610153@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, shuah@kernel.org, Greg KH <gregkh@linuxfoundation.org>, Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, brakmo@fb.com, Steven Rostedt <rostedt@goodmis.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kevin Hilman <khilman@baylibre.com>, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>
List-Id: linux-nvdimm@lists.01.org

On Fri, Feb 15, 2019 at 1:01 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Brendan Higgins (2019-02-14 13:37:14)
> > @@ -104,6 +167,7 @@ struct kunit {
> >         const char *name; /* Read only after initialization! */
> >         spinlock_t lock; /* Gaurds all mutable test state. */
> >         bool success; /* Protected by lock. */
> > +       struct list_head resources; /* Protected by lock. */
> >         void (*vprintk)(const struct kunit *test,
> >                         const char *level,
> >                         struct va_format *vaf);
> > @@ -127,6 +191,51 @@ int kunit_run_tests(struct kunit_module *module);
> >                 } \
> >                 late_initcall(module_kunit_init##module)
> >
> > +/**
> > + * kunit_alloc_resource() - Allocates a *test managed resource*.
> > + * @test: The test context object.
> > + * @init: a user supplied function to initialize the resource.
> > + * @free: a user supplied function to free the resource.
> > + * @context: for the user to pass in arbitrary data.
>
> Nitpick: "pass in arbitrary data to the init function"? Maybe that
> provides some more clarity.

I think that makes sense. Will fix in next revision.
