From: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v4 10/17] kunit: test: add test managed resource tests
Date: Fri, 15 Feb 2019 12:54:47 -0800
Message-ID: <155026408761.115909.17855438744578437385@swboyd.mtv.corp.google.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-11-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190214213729.21702-11-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Avinash Kondareddy <avikr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-02-14 13:37:22)
> diff --git a/kunit/test-test.c b/kunit/test-test.c
> index 0b4ad6690310d..bb34431398526 100644
> --- a/kunit/test-test.c
> +++ b/kunit/test-test.c
[...]
> +
> +#define KUNIT_RESOURCE_NUM 5
> +static void kunit_resource_test_cleanup_resources(struct kunit *test)
> +{
> +       int i;
> +       struct kunit_test_resource_context *ctx = test->priv;
> +       struct kunit_resource *resources[KUNIT_RESOURCE_NUM];
> +
> +       for (i = 0; i < KUNIT_RESOURCE_NUM; i++) {

Nitpick: This could use ARRAY_SIZE(resources) and then the #define could
be dropped.

> +               resources[i] = kunit_alloc_resource(&ctx->test,
> +                                                   fake_resource_init,
> +                                                   fake_resource_free,
> +                                                   ctx);
> +       }
> +
> +       kunit_cleanup(&ctx->test);
> +
> +       KUNIT_EXPECT_TRUE(test, list_empty(&ctx->test.resources));
> +}
> +
[...]
> +
> +static struct kunit_case kunit_resource_test_cases[] = {

Can these arrays be const?

> +       KUNIT_CASE(kunit_resource_test_init_resources),
> +       KUNIT_CASE(kunit_resource_test_alloc_resource),
> +       KUNIT_CASE(kunit_resource_test_free_resource),
> +       KUNIT_CASE(kunit_resource_test_cleanup_resources),
> +       {},
> +};
