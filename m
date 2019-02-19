From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v4 10/17] kunit: test: add test managed resource tests
Date: Tue, 19 Feb 2019 15:20:18 -0800
Message-ID: <CAFd5g44Dizk-VsFOmGn++E0d40sZmH6V+j05Eu6zUXaBj1xfcA@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-11-brendanhiggins@google.com> <155026408761.115909.17855438744578437385@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155026408761.115909.17855438744578437385@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, shuah@kernel.org, Greg KH <gregkh@linuxfoundation.org>, Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, brakmo@fb.com, Steven Rostedt <rostedt@goodmis.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kevin Hilman <khilman@baylibre.com>, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>
List-Id: linux-nvdimm@lists.01.org

On Fri, Feb 15, 2019 at 12:54 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Brendan Higgins (2019-02-14 13:37:22)
> > diff --git a/kunit/test-test.c b/kunit/test-test.c
> > index 0b4ad6690310d..bb34431398526 100644
> > --- a/kunit/test-test.c
> > +++ b/kunit/test-test.c
> [...]
> > +
> > +#define KUNIT_RESOURCE_NUM 5
> > +static void kunit_resource_test_cleanup_resources(struct kunit *test)
> > +{
> > +       int i;
> > +       struct kunit_test_resource_context *ctx = test->priv;
> > +       struct kunit_resource *resources[KUNIT_RESOURCE_NUM];
> > +
> > +       for (i = 0; i < KUNIT_RESOURCE_NUM; i++) {
>
> Nitpick: This could use ARRAY_SIZE(resources) and then the #define could
> be dropped.

Noted. Will fix in next revision.

>
> > +               resources[i] = kunit_alloc_resource(&ctx->test,
> > +                                                   fake_resource_init,
> > +                                                   fake_resource_free,
> > +                                                   ctx);
> > +       }
> > +
> > +       kunit_cleanup(&ctx->test);
> > +
> > +       KUNIT_EXPECT_TRUE(test, list_empty(&ctx->test.resources));
> > +}
> > +
> [...]
> > +
> > +static struct kunit_case kunit_resource_test_cases[] = {
>
> Can these arrays be const?

There is some private mutable state inside of `struct kunit_case` that
would be kind of annoying to pull out; I don't think it would make it
cleaner.
