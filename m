From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 11/17] kunit: test: add test managed resource tests
Date: Thu, 25 Apr 2019 14:39:15 -0700
Message-ID: <CAFd5g45CaCFdQCxQqxgYfoQSGAF8RAV2YrOMs0oR4R-iCTZrig@mail.gmail.com>
References: <20190404220652.19765-1-brendanhiggins@google.com>
 <20190404220652.19765-12-brendanhiggins@google.com>
 <20190424190019.wvljyeo3y7gd24p5@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190424190019.wvljyeo3y7gd24p5@gabell>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, "Bird, Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Avinash Kondareddy <akndr41-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia
List-Id: linux-nvdimm@lists.01.org

On Wed, Apr 24, 2019 at 12:00 PM Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Thu, Apr 04, 2019 at 03:06:46PM -0700, Brendan Higgins wrote:
> > From: Avinash Kondareddy <akndr41-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > Tests how tests interact with test managed resources in their lifetime.
> >
> > Signed-off-by: Avinash Kondareddy <akndr41-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  kunit/test-test.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 122 insertions(+)
> >
> > diff --git a/kunit/test-test.c b/kunit/test-test.c
> > index 4bd7a34d0a6cb..54add8ca418a0 100644
> > --- a/kunit/test-test.c
> > +++ b/kunit/test-test.c
> > @@ -135,3 +135,125 @@ static struct kunit_module kunit_try_catch_test_module = {
> >       .test_cases = kunit_try_catch_test_cases,
> >  };
> >  module_test(kunit_try_catch_test_module);
> > +
> > +/*
> > + * Context for testing test managed resources
> > + * is_resource_initialized is used to test arbitrary resources
> > + */
> > +struct kunit_test_resource_context {
> > +     struct kunit test;
> > +     bool is_resource_initialized;
> > +};
> > +
> > +static int fake_resource_init(struct kunit_resource *res, void *context)
> > +{
> > +     struct kunit_test_resource_context *ctx = context;
> > +
> > +     res->allocation = &ctx->is_resource_initialized;
> > +     ctx->is_resource_initialized = true;
> > +     return 0;
> > +}
> > +
> > +static void fake_resource_free(struct kunit_resource *res)
> > +{
> > +     bool *is_resource_initialized = res->allocation;
> > +
> > +     *is_resource_initialized = false;
> > +}
> > +
> > +static void kunit_resource_test_init_resources(struct kunit *test)
> > +{
> > +     struct kunit_test_resource_context *ctx = test->priv;
> > +
> > +     kunit_init_test(&ctx->test, "testing_test_init_test");
> > +
> > +     KUNIT_EXPECT_TRUE(test, list_empty(&ctx->test.resources));
> > +}
> > +
> > +static void kunit_resource_test_alloc_resource(struct kunit *test)
> > +{
> > +     struct kunit_test_resource_context *ctx = test->priv;
> > +     struct kunit_resource *res;
> > +     kunit_resource_free_t free = fake_resource_free;
> > +
> > +     res = kunit_alloc_resource(&ctx->test,
> > +                                fake_resource_init,
> > +                                fake_resource_free,
> > +                                ctx);
> > +
>
> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, res);
>
>         KUNIT_EXPECT_NOT_ERR_OR_NULL(test, res);

See my reply to your email on the 14/17 patch.
