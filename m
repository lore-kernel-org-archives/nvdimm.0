From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 11/18] kunit: test: add the concept of assertions
Date: Mon, 12 Aug 2019 22:09:26 -0700
Message-ID: <CAFd5g47jrUd+ES4AaWsLDRCfsGiKDB-rOP6TR-NdymCeVAK3Kg@mail.gmail.com>
References: <20190812182421.141150-1-brendanhiggins@google.com>
 <20190812182421.141150-12-brendanhiggins@google.com>
 <20190813045510.C1D6E206C2@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190813045510.C1D6E206C2-+nuXSHJNwjE76Z2rM5mHXA@public.gmane.org>
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
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Aug 12, 2019 at 9:55 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-08-12 11:24:14)
> > Add support for assertions which are like expectations except the test
> > terminates if the assertion is not satisfied.
> >
> > The idea with assertions is that you use them to state all the
> > preconditions for your test. Logically speaking, these are the premises
> > of the test case, so if a premise isn't true, there is no point in
> > continuing the test case because there are no conclusions that can be
> > drawn without the premises. Whereas, the expectation is the thing you
> > are trying to prove. It is not used universally in x-unit style test
> > frameworks, but I really like it as a convention.  You could still
> > express the idea of a premise using the above idiom, but I think
> > KUNIT_ASSERT_* states the intended idea perfectly.
> >
> > Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> > Reviewed-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
>
> Reviewed-by: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> > + * Sets an expectation that the values that @left and @right evaluate to are
> > + * not equal. This is semantically equivalent to
> > + * KUNIT_ASSERT_TRUE(@test, strcmp((@left), (@right))). See KUNIT_ASSERT_TRUE()
> > + * for more information.
> > + */
> > +#define KUNIT_ASSERT_STRNEQ(test, left, right)                                \
> > +               KUNIT_BINARY_STR_NE_ASSERTION(test,                            \
> > +                                             KUNIT_ASSERTION,                 \
> > +                                             left,                            \
> > +                                             right)
> > +
> > +#define KUNIT_ASSERT_STRNEQ_MSG(test, left, right, fmt, ...)                  \
> > +               KUNIT_BINARY_STR_NE_MSG_ASSERTION(test,                        \
> > +                                                 KUNIT_ASSERTION,             \
> > +                                                 left,                        \
> > +                                                 right,                       \
> > +                                                 fmt,                         \
>
> Same question about tabbing too.

Yep. WIll fix.

> > diff --git a/kunit/test-test.c b/kunit/test-test.c
> > index 88f4cdf03db2a..058f3fb37458a 100644
> > --- a/kunit/test-test.c
> > +++ b/kunit/test-test.c
> > @@ -78,11 +78,13 @@ static int kunit_try_catch_test_init(struct kunit *test)
> >         struct kunit_try_catch_test_context *ctx;
> >
> >         ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
>
> Ah ok. Question still stands if kunit_kzalloc() should just have the
> assertion on failure.

Right. In the previous patch KUNIT_ASSERT_* doesn't exist yet, so I
can't use it. And rather than fall back to return -ENOMEM like I
should have, I evidently forgot to do that.

> >         test->priv = ctx;
> >
> >         ctx->try_catch = kunit_kmalloc(test,
> >                                        sizeof(*ctx->try_catch),
> >                                        GFP_KERNEL);
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->try_catch);
> >
