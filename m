From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v1 11/17] kunit: test: add test managed resource tests
Date: Wed, 24 Apr 2019 15:00:20 -0400
Message-ID: <20190424190019.wvljyeo3y7gd24p5@gabell>
References: <20190404220652.19765-1-brendanhiggins@google.com>
 <20190404220652.19765-12-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190404220652.19765-12-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: corbet@lwn.net, frowand.list@gmail.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, shuah@kernel.org, yamada.masahiro@socionext.com, pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, wfg@linux.intel.com, joel@jms.id.au, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, Avinash Kondareddy <akndr41@gmail.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, danie
List-Id: linux-nvdimm@lists.01.org

On Thu, Apr 04, 2019 at 03:06:46PM -0700, Brendan Higgins wrote:
> From: Avinash Kondareddy <akndr41@gmail.com>
> 
> Tests how tests interact with test managed resources in their lifetime.
> 
> Signed-off-by: Avinash Kondareddy <akndr41@gmail.com>
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> ---
>  kunit/test-test.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
> 
> diff --git a/kunit/test-test.c b/kunit/test-test.c
> index 4bd7a34d0a6cb..54add8ca418a0 100644
> --- a/kunit/test-test.c
> +++ b/kunit/test-test.c
> @@ -135,3 +135,125 @@ static struct kunit_module kunit_try_catch_test_module = {
>  	.test_cases = kunit_try_catch_test_cases,
>  };
>  module_test(kunit_try_catch_test_module);
> +
> +/*
> + * Context for testing test managed resources
> + * is_resource_initialized is used to test arbitrary resources
> + */
> +struct kunit_test_resource_context {
> +	struct kunit test;
> +	bool is_resource_initialized;
> +};
> +
> +static int fake_resource_init(struct kunit_resource *res, void *context)
> +{
> +	struct kunit_test_resource_context *ctx = context;
> +
> +	res->allocation = &ctx->is_resource_initialized;
> +	ctx->is_resource_initialized = true;
> +	return 0;
> +}
> +
> +static void fake_resource_free(struct kunit_resource *res)
> +{
> +	bool *is_resource_initialized = res->allocation;
> +
> +	*is_resource_initialized = false;
> +}
> +
> +static void kunit_resource_test_init_resources(struct kunit *test)
> +{
> +	struct kunit_test_resource_context *ctx = test->priv;
> +
> +	kunit_init_test(&ctx->test, "testing_test_init_test");
> +
> +	KUNIT_EXPECT_TRUE(test, list_empty(&ctx->test.resources));
> +}
> +
> +static void kunit_resource_test_alloc_resource(struct kunit *test)
> +{
> +	struct kunit_test_resource_context *ctx = test->priv;
> +	struct kunit_resource *res;
> +	kunit_resource_free_t free = fake_resource_free;
> +
> +	res = kunit_alloc_resource(&ctx->test,
> +				   fake_resource_init,
> +				   fake_resource_free,
> +				   ctx);
> +

> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, res);

	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, res);

Thanks!
Masa
