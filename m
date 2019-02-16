From: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v4 15/17] of: unittest: migrate tests to run on KUnit
Date: Fri, 15 Feb 2019 16:24:42 -0800
Message-ID: <cda7c8db-a6d0-6a93-5c33-9ccf32dfd29a@gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-16-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190214213729.21702-16-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 2/14/19 1:37 PM, Brendan Higgins wrote:
> Migrate tests without any cleanup, or modifying test logic in anyway to
> run under KUnit using the KUnit expectation and assertion API.
> 
> Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/of/Kconfig    |    1 +
>  drivers/of/unittest.c | 1310 +++++++++++++++++++++--------------------
>  2 files changed, 671 insertions(+), 640 deletions(-)
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index ad3fcad4d75b8..f309399deac20 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -15,6 +15,7 @@ if OF
>  config OF_UNITTEST
>  	bool "Device Tree runtime unit tests"
>  	depends on !SPARC
> +	depends on KUNIT
>  	select IRQ_DOMAIN
>  	select OF_EARLY_FLATTREE
>  	select OF_RESOLVE
> diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c

These comments are from applying the patches to 5.0-rc3.

The final hunk of this patch fails to apply because it depends upon

   [PATCH v1 0/1] of: unittest: unflatten device tree on UML when testing.

If I apply that patch then I can apply patches 15 through 17.

If I apply patches 1 through 14 and boot the uml kernel then the devicetree
unittest result is:

  ### dt-test ### FAIL of_unittest_overlay_high_level():2372 overlay_base_root not initialized
  ### dt-test ### end of unittest - 219 passed, 1 failed

This is as expected from your previous reports, and is fixed after
applying

   [PATCH v1 0/1] of: unittest: unflatten device tree on UML when testing.

with the devicetree unittest result of:

   ### dt-test ### end of unittest - 224 passed, 0 failed

After adding patch 15, there are a lot of "unittest internal error" messages.

-Frank


> index effa4e2b9d992..96de69ccb3e63 100644
> --- a/drivers/of/unittest.c
> +++ b/drivers/of/unittest.c
> @@ -26,186 +26,189 @@
>  
>  #include <linux/bitops.h>
>  
> +#include <kunit/test.h>### dt-test ### end of unittest - 224 passed, 0 failed
> +
>  #include "of_private.h"
>  
> -static struct unittest_results {
> -	int passed;
> -	int failed;
> -} unittest_results;
> -
> -#define unittest(result, fmt, ...) ({ \
> -	bool failed = !(result); \
> -	if (failed) { \
> -		unittest_results.failed++; \
> -		pr_err("FAIL %s():%i " fmt, __func__, __LINE__, ##__VA_ARGS__); \
> -	} else { \
> -		unittest_results.passed++; \
> -		pr_debug("pass %s():%i\n", __func__, __LINE__); \
> -	} \
> -	failed; \
> -})
> -
> -static void __init of_unittest_find_node_by_name(void)
> +static void of_unittest_find_node_by_name(struct kunit *test)
>  {
>  	struct device_node *np;
>  	const char *options, *name;
>  
>  	np = of_find_node_by_path("/testcase-data");
>  	name = kasprintf(GFP_KERNEL, "%pOF", np);
> -	unittest(np && !strcmp("/testcase-data", name),
> -		"find /testcase-data failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
> +			       "find /testcase-data failed\n");
>  	of_node_put(np);
>  	kfree(name);
>  
>  	/* Test if trailing '/' works */
> -	np = of_find_node_by_path("/testcase-data/");
> -	unittest(!np, "trailing '/' on /testcase-data/ should fail\n");
> +	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
> +			    "trailing '/' on /testcase-data/ should fail\n");
>  
>  	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  	name = kasprintf(GFP_KERNEL, "%pOF", np);
> -	unittest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", name),
> +	KUNIT_EXPECT_STREQ_MSG(
> +		test, "/testcase-data/phandle-tests/consumer-a", name,
>  		"find /testcase-data/phandle-tests/consumer-a failed\n");
>  	of_node_put(np);
>  	kfree(name);
>  
>  	np = of_find_node_by_path("testcase-alias");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  	name = kasprintf(GFP_KERNEL, "%pOF", np);
> -	unittest(np && !strcmp("/testcase-data", name),
> -		"find testcase-alias failed\n");
> +	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
> +			       "find testcase-alias failed\n");
>  	of_node_put(np);
>  	kfree(name);
>  
>  	/* Test if trailing '/' works on aliases */
> -	np = of_find_node_by_path("testcase-alias/");
> -	unittest(!np, "trailing '/' on testcase-alias/ should fail\n");
> +	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
> +			    "trailing '/' on testcase-alias/ should fail\n");
>  
>  	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  	name = kasprintf(GFP_KERNEL, "%pOF", np);
> -	unittest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", name),
> +	KUNIT_EXPECT_STREQ_MSG(
> +		test, "/testcase-data/phandle-tests/consumer-a", name,
>  		"find testcase-alias/phandle-tests/consumer-a failed\n");
>  	of_node_put(np);
>  	kfree(name);
>  
> -	np = of_find_node_by_path("/testcase-data/missing-path");
> -	unittest(!np, "non-existent path returned node %pOF\n", np);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
> +		"non-existent path returned node %pOF\n", np);
>  	of_node_put(np);
>  
> -	np = of_find_node_by_path("missing-alias");
> -	unittest(!np, "non-existent alias returned node %pOF\n", np);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test, np = of_find_node_by_path("missing-alias"), NULL,
> +		"non-existent alias returned node %pOF\n", np);
>  	of_node_put(np);
>  
> -	np = of_find_node_by_path("testcase-alias/missing-path");
> -	unittest(!np, "non-existent alias with relative path returned node %pOF\n", np);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
> +		"non-existent alias with relative path returned node %pOF\n",
> +		np);
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
> -	unittest(np && !strcmp("testoption", options),
> -		 "option path test failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
> +			       "option path test failed\n");
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
> -	unittest(np && !strcmp("test/option", options),
> -		 "option path test, subcase #1 failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
> +			       "option path test, subcase #1 failed\n");
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
> -	unittest(np && !strcmp("test/option", options),
> -		 "option path test, subcase #2 failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
> +			       "option path test, subcase #2 failed\n");
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
> -	unittest(np, "NULL option path test failed\n");
> +	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
> +					 "NULL option path test failed\n");
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
>  				       &options);
> -	unittest(np && !strcmp("testaliasoption", options),
> -		 "option alias path test failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
> +			       "option alias path test failed\n");
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
>  				       &options);
> -	unittest(np && !strcmp("test/alias/option", options),
> -		 "option alias path test, subcase #1 failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
> +			       "option alias path test, subcase #1 failed\n");
>  	of_node_put(np);
>  
>  	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
> -	unittest(np, "NULL option alias path test failed\n");
> +	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
> +			test, np, "NULL option alias path test failed\n");
>  	of_node_put(np);
>  
>  	options = "testoption";
>  	np = of_find_node_opts_by_path("testcase-alias", &options);
> -	unittest(np && !options, "option clearing test failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
> +			    "option clearing test failed\n");
>  	of_node_put(np);
>  
>  	options = "testoption";
>  	np = of_find_node_opts_by_path("/", &options);
> -	unittest(np && !options, "option clearing root node test failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
> +			    "option clearing root node test failed\n");
>  	of_node_put(np);
>  }
>  
> -static void __init of_unittest_dynamic(void)
> +static void of_unittest_dynamic(struct kunit *test)
>  {
>  	struct device_node *np;
>  	struct property *prop;
>  
>  	np = of_find_node_by_path("/testcase-data");
> -	if (!np) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	/* Array of 4 properties for the purpose of testing */
>  	prop = kcalloc(4, sizeof(*prop), GFP_KERNEL);
> -	if (!prop) {
> -		unittest(0, "kzalloc() failed\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop);
>  
>  	/* Add a new property - should pass*/
>  	prop->name = "new-property";
>  	prop->value = "new-property-data";
>  	prop->length = strlen(prop->value) + 1;
> -	unittest(of_add_property(np, prop) == 0, "Adding a new property failed\n");
> +	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
> +			    "Adding a new property failed\n");
>  
>  	/* Try to add an existing property - should fail */
>  	prop++;
>  	prop->name = "new-property";
>  	prop->value = "new-property-data-should-fail";
>  	prop->length = strlen(prop->value) + 1;
> -	unittest(of_add_property(np, prop) != 0,
> -		 "Adding an existing property should have failed\n");
> +	KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop), 0,
> +			    "Adding an existing property should have failed\n");
>  
>  	/* Try to modify an existing property - should pass */
>  	prop->value = "modify-property-data-should-pass";
>  	prop->length = strlen(prop->value) + 1;
> -	unittest(of_update_property(np, prop) == 0,
> -		 "Updating an existing property should have passed\n");
> +	KUNIT_EXPECT_EQ_MSG(
> +		test, of_update_property(np, prop), 0,
> +		"Updating an existing property should have passed\n");
>  
>  	/* Try to modify non-existent property - should pass*/
>  	prop++;
>  	prop->name = "modify-property";
>  	prop->value = "modify-missing-property-data-should-pass";
>  	prop->length = strlen(prop->value) + 1;
> -	unittest(of_update_property(np, prop) == 0,
> -		 "Updating a missing property should have passed\n");
> +	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
> +			    "Updating a missing property should have passed\n");
>  
>  	/* Remove property - should pass */
> -	unittest(of_remove_property(np, prop) == 0,
> -		 "Removing a property should have passed\n");
> +	KUNIT_EXPECT_EQ_MSG(test, of_remove_property(np, prop), 0,
> +			    "Removing a property should have passed\n");
>  
>  	/* Adding very large property - should pass */
>  	prop++;
>  	prop->name = "large-property-PAGE_SIZEx8";
>  	prop->length = PAGE_SIZE * 8;
>  	prop->value = kzalloc(prop->length, GFP_KERNEL);
> -	unittest(prop->value != NULL, "Unable to allocate large buffer\n");
> -	if (prop->value)
> -		unittest(of_add_property(np, prop) == 0,
> -			 "Adding a large property should have passed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop->value);
> +	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
> +			    "Adding a large property should have passed\n");
>  }
>  
> -static int __init of_unittest_check_node_linkage(struct device_node *np)
> +static int of_unittest_check_node_linkage(struct device_node *np)
>  {
>  	struct device_node *child;
>  	int count = 0, rc;
> @@ -230,27 +233,30 @@ static int __init of_unittest_check_node_linkage(struct device_node *np)
>  	return rc;
>  }
>  
> -static void __init of_unittest_check_tree_linkage(void)
> +static void of_unittest_check_tree_linkage(struct kunit *test)
>  {
>  	struct device_node *np;
>  	int allnode_count = 0, child_count;
>  
> -	if (!of_root)
> -		return;
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_root);
>  
>  	for_each_of_allnodes(np)
>  		allnode_count++;
>  	child_count = of_unittest_check_node_linkage(of_root);
>  
> -	unittest(child_count > 0, "Device node data structure is corrupted\n");
> -	unittest(child_count == allnode_count,
> -		 "allnodes list size (%i) doesn't match sibling lists size (%i)\n",
> -		 allnode_count, child_count);
> +	KUNIT_EXPECT_GT_MSG(test, child_count, 0,
> +			    "Device node data structure is corrupted\n");
> +	KUNIT_EXPECT_EQ_MSG(
> +		test, child_count, allnode_count,
> +		"allnodes list size (%i) doesn't match sibling lists size (%i)\n",
> +		allnode_count, child_count);
>  	pr_debug("allnodes list size (%i); sibling lists size (%i)\n", allnode_count, child_count);
>  }
>  
> -static void __init of_unittest_printf_one(struct device_node *np, const char *fmt,
> -					  const char *expected)
> +static void of_unittest_printf_one(struct kunit *test,
> +				   struct device_node *np,
> +				   const char *fmt,
> +				   const char *expected)
>  {
>  	unsigned char *buf;
>  	int buf_size;
> @@ -265,8 +271,12 @@ static void __init of_unittest_printf_one(struct device_node *np, const char *fm
>  	memset(buf, 0xff, buf_size);
>  	size = snprintf(buf, buf_size - 2, fmt, np);
>  
> -	/* use strcmp() instead of strncmp() here to be absolutely sure strings match */
> -	unittest((strcmp(buf, expected) == 0) && (buf[size+1] == 0xff),
> +	KUNIT_EXPECT_STREQ_MSG(
> +		test, buf, expected,
> +		"sprintf failed; fmt='%s' expected='%s' rslt='%s'\n",
> +		fmt, expected, buf);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test, buf[size+1], 0xff,
>  		"sprintf failed; fmt='%s' expected='%s' rslt='%s'\n",
>  		fmt, expected, buf);
>  
> @@ -276,44 +286,49 @@ static void __init of_unittest_printf_one(struct device_node *np, const char *fm
>  		/* Clear the buffer, and make sure it works correctly still */
>  		memset(buf, 0xff, buf_size);
>  		snprintf(buf, size+1, fmt, np);
> -		unittest(strncmp(buf, expected, size) == 0 && (buf[size+1] == 0xff),
> +		KUNIT_EXPECT_STREQ_MSG(
> +			test, buf, expected,
> +			"snprintf failed; size=%i fmt='%s' expected='%s' rslt='%s'\n",
> +			size, fmt, expected, buf);
> +		KUNIT_EXPECT_EQ_MSG(
> +			test, buf[size+1], 0xff,
>  			"snprintf failed; size=%i fmt='%s' expected='%s' rslt='%s'\n",
>  			size, fmt, expected, buf);
>  	}
>  	kfree(buf);
>  }
>  
> -static void __init of_unittest_printf(void)
> +static void of_unittest_printf(struct kunit *test)
>  {
>  	struct device_node *np;
>  	const char *full_name = "/testcase-data/platform-tests/test-device@1/dev@100";
>  	char phandle_str[16] = "";
>  
>  	np = of_find_node_by_path(full_name);
> -	if (!np) {
> -		unittest(np, "testcase data missing\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	num_to_str(phandle_str, sizeof(phandle_str), np->phandle, 0);
>  
> -	of_unittest_printf_one(np, "%pOF",  full_name);
> -	of_unittest_printf_one(np, "%pOFf", full_name);
> -	of_unittest_printf_one(np, "%pOFn", "dev");
> -	of_unittest_printf_one(np, "%2pOFn", "dev");
> -	of_unittest_printf_one(np, "%5pOFn", "  dev");
> -	of_unittest_printf_one(np, "%pOFnc", "dev:test-sub-device");
> -	of_unittest_printf_one(np, "%pOFp", phandle_str);
> -	of_unittest_printf_one(np, "%pOFP", "dev@100");
> -	of_unittest_printf_one(np, "ABC %pOFP ABC", "ABC dev@100 ABC");
> -	of_unittest_printf_one(np, "%10pOFP", "   dev@100");
> -	of_unittest_printf_one(np, "%-10pOFP", "dev@100   ");
> -	of_unittest_printf_one(of_root, "%pOFP", "/");
> -	of_unittest_printf_one(np, "%pOFF", "----");
> -	of_unittest_printf_one(np, "%pOFPF", "dev@100:----");
> -	of_unittest_printf_one(np, "%pOFPFPc", "dev@100:----:dev@100:test-sub-device");
> -	of_unittest_printf_one(np, "%pOFc", "test-sub-device");
> -	of_unittest_printf_one(np, "%pOFC",
> +	of_unittest_printf_one(test, np, "%pOF",  full_name);
> +	of_unittest_printf_one(test, np, "%pOFf", full_name);
> +	of_unittest_printf_one(test, np, "%pOFn", "dev");
> +	of_unittest_printf_one(test, np, "%2pOFn", "dev");
> +	of_unittest_printf_one(test, np, "%5pOFn", "  dev");
> +	of_unittest_printf_one(test, np, "%pOFnc", "dev:test-sub-device");
> +	of_unittest_printf_one(test, np, "%pOFp", phandle_str);
> +	of_unittest_printf_one(test, np, "%pOFP", "dev@100");
> +	of_unittest_printf_one(test, np, "ABC %pOFP ABC", "ABC dev@100 ABC");
> +	of_unittest_printf_one(test, np, "%10pOFP", "   dev@100");
> +	of_unittest_printf_one(test, np, "%-10pOFP", "dev@100   ");
> +	of_unittest_printf_one(test, of_root, "%pOFP", "/");
> +	of_unittest_printf_one(test, np, "%pOFF", "----");
> +	of_unittest_printf_one(test, np, "%pOFPF", "dev@100:----");
> +	of_unittest_printf_one(test,
> +			       np,
> +			       "%pOFPFPc",
> +			       "dev@100:----:dev@100:test-sub-device");
> +	of_unittest_printf_one(test, np, "%pOFc", "test-sub-device");
> +	of_unittest_printf_one(test, np, "%pOFC",
>  			"\"test-sub-device\",\"test-compat2\",\"test-compat3\"");
>  }
>  
> @@ -323,7 +338,7 @@ struct node_hash {
>  };
>  
>  static DEFINE_HASHTABLE(phandle_ht, 8);
> -static void __init of_unittest_check_phandles(void)
> +static void of_unittest_check_phandles(struct kunit *test)
>  {
>  	struct device_node *np;
>  	struct node_hash *nh;
> @@ -335,24 +350,26 @@ static void __init of_unittest_check_phandles(void)
>  			continue;
>  
>  		hash_for_each_possible(phandle_ht, nh, node, np->phandle) {
> +			KUNIT_EXPECT_NE_MSG(
> +				test, nh->np->phandle, np->phandle,
> +				"Duplicate phandle! %i used by %pOF and %pOF\n",
> +				np->phandle, nh->np, np);
>  			if (nh->np->phandle == np->phandle) {
> -				pr_info("Duplicate phandle! %i used by %pOF and %pOF\n",
> -					np->phandle, nh->np, np);
>  				dup_count++;
>  				break;
>  			}
>  		}
>  
>  		nh = kzalloc(sizeof(*nh), GFP_KERNEL);
> -		if (WARN_ON(!nh))
> -			return;
> +		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, nh);
>  
>  		nh->np = np;
>  		hash_add(phandle_ht, &nh->node, np->phandle);
>  		phandle_count++;
>  	}
> -	unittest(dup_count == 0, "Found %i duplicates in %i phandles\n",
> -		 dup_count, phandle_count);
> +	KUNIT_EXPECT_EQ_MSG(test, dup_count, 0,
> +			    "Found %i duplicates in %i phandles\n",
> +			    dup_count, phandle_count);
>  
>  	/* Clean up */
>  	hash_for_each_safe(phandle_ht, i, tmp, nh, node) {
> @@ -361,20 +378,21 @@ static void __init of_unittest_check_phandles(void)
>  	}
>  }
>  
> -static void __init of_unittest_parse_phandle_with_args(void)
> +static void of_unittest_parse_phandle_with_args(struct kunit *test)
>  {
>  	struct device_node *np;
>  	struct of_phandle_args args;
> -	int i, rc;
> +	int i, rc = 0;
>  
>  	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
> -	if (!np) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
> -	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
> -	unittest(rc == 7, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_count_phandle_with_args(
> +			np, "phandle-list", "#phandle-cells"),
> +		7,
> +		"of_count_phandle_with_args() returned %i, expected 7\n", rc);
>  
>  	for (i = 0; i < 8; i++) {
>  		bool passed = true;
> @@ -428,85 +446,91 @@ static void __init of_unittest_parse_phandle_with_args(void)
>  			passed = false;
>  		}
>  
> -		unittest(passed, "index %i - data error on node %pOF rc=%i\n",
> -			 i, args.np, rc);
> +		KUNIT_EXPECT_TRUE_MSG(
> +			test, passed,
> +			"index %i - data error on node %pOF rc=%i\n",
> +			i, args.np, rc);
>  	}
>  
>  	/* Check for missing list property */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
> -					"#phandle-cells", 0, &args);
> -	unittest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
> -	rc = of_count_phandle_with_args(np, "phandle-list-missing",
> -					"#phandle-cells");
> -	unittest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args(
> +			np, "phandle-list-missing", "#phandle-cells", 0, &args),
> +		-ENOENT);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_count_phandle_with_args(
> +			np, "phandle-list-missing", "#phandle-cells"),
> +		-ENOENT);
>  
>  	/* Check for missing cells property */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args(np, "phandle-list",
> -					"#phandle-cells-missing", 0, &args);
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> -	rc = of_count_phandle_with_args(np, "phandle-list",
> -					"#phandle-cells-missing");
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args(
> +			np, "phandle-list", "#phandle-cells-missing", 0, &args),
> +		-EINVAL);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_count_phandle_with_args(
> +			np, "phandle-list", "#phandle-cells-missing"),
> +		-EINVAL);
>  
>  	/* Check for bad phandle in list */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
> -					"#phandle-cells", 0, &args);
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> -	rc = of_count_phandle_with_args(np, "phandle-list-bad-phandle",
> -					"#phandle-cells");
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
> +					   "#phandle-cells", 0, &args),
> +		-EINVAL);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_count_phandle_with_args(
> +			np, "phandle-list-bad-phandle", "#phandle-cells"),
> +		-EINVAL);
>  
>  	/* Check for incorrectly formed argument list */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
> -					"#phandle-cells", 1, &args);
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> -	rc = of_count_phandle_with_args(np, "phandle-list-bad-args",
> -					"#phandle-cells");
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args(np, "phandle-list-bad-args",
> +					   "#phandle-cells", 1, &args),
> +		-EINVAL);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_count_phandle_with_args(
> +			np, "phandle-list-bad-args", "#phandle-cells"),
> +		-EINVAL);
>  }
>  
> -static void __init of_unittest_parse_phandle_with_args_map(void)
> +static void of_unittest_parse_phandle_with_args_map(struct kunit *test)
>  {
>  	struct device_node *np, *p0, *p1, *p2, *p3;
>  	struct of_phandle_args args;
>  	int i, rc;
>  
>  	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-b");
> -	if (!np) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	p0 = of_find_node_by_path("/testcase-data/phandle-tests/provider0");
> -	if (!p0) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p0);
>  
>  	p1 = of_find_node_by_path("/testcase-data/phandle-tests/provider1");
> -	if (!p1) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
>  
>  	p2 = of_find_node_by_path("/testcase-data/phandle-tests/provider2");
> -	if (!p2) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p2);
>  
>  	p3 = of_find_node_by_path("/testcase-data/phandle-tests/provider3");
> -	if (!p3) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p3);
>  
> -	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
> -	unittest(rc == 7, "of_count_phandle_with_args() returned %i, expected 7\n", rc);
> +	KUNIT_EXPECT_EQ(test,
> +		       of_count_phandle_with_args(np,
> +						  "phandle-list",
> +						  "#phandle-cells"),
> +		       7);
>  
>  	for (i = 0; i < 8; i++) {
>  		bool passed = true;
> @@ -564,121 +588,186 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
>  			passed = false;
>  		}
>  
> -		unittest(passed, "index %i - data error on node %s rc=%i\n",
> -			 i, args.np->full_name, rc);
> +		KUNIT_EXPECT_TRUE_MSG(
> +			test, passed,
> +			"index %i - data error on node %s rc=%i\n",
> +			i, (args.np ? args.np->full_name : "missing np"), rc);
>  	}
>  
>  	/* Check for missing list property */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args_map(np, "phandle-list-missing",
> -					    "phandle", 0, &args);
> -	unittest(rc == -ENOENT, "expected:%i got:%i\n", -ENOENT, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args_map(
> +			np, "phandle-list-missing", "phandle", 0, &args),
> +		-ENOENT);
>  
>  	/* Check for missing cells,map,mask property */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args_map(np, "phandle-list",
> -					    "phandle-missing", 0, &args);
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args_map(
> +			np, "phandle-list", "phandle-missing", 0, &args),
> +		-EINVAL);
>  
>  	/* Check for bad phandle in list */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args_map(np, "phandle-list-bad-phandle",
> -					    "phandle", 0, &args);
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args_map(
> +			np, "phandle-list-bad-phandle", "phandle", 0, &args),
> +		-EINVAL);
>  
>  	/* Check for incorrectly formed argument list */
>  	memset(&args, 0, sizeof(args));
> -	rc = of_parse_phandle_with_args_map(np, "phandle-list-bad-args",
> -					    "phandle", 1, &args);
> -	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_parse_phandle_with_args_map(
> +			np, "phandle-list-bad-args", "phandle", 1, &args),
> +		-EINVAL);
>  }
>  
> -static void __init of_unittest_property_string(void)
> +static void of_unittest_property_string(struct kunit *test)
>  {
>  	const char *strings[4];
>  	struct device_node *np;
>  	int rc;
>  
>  	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
> -	if (!np) {
> -		pr_err("No testcase data in device tree\n");
> -		return;
> -	}
> -
> -	rc = of_property_match_string(np, "phandle-list-names", "first");
> -	unittest(rc == 0, "first expected:0 got:%i\n", rc);
> -	rc = of_property_match_string(np, "phandle-list-names", "second");
> -	unittest(rc == 1, "second expected:1 got:%i\n", rc);
> -	rc = of_property_match_string(np, "phandle-list-names", "third");
> -	unittest(rc == 2, "third expected:2 got:%i\n", rc);
> -	rc = of_property_match_string(np, "phandle-list-names", "fourth");
> -	unittest(rc == -ENODATA, "unmatched string; rc=%i\n", rc);
> -	rc = of_property_match_string(np, "missing-property", "blah");
> -	unittest(rc == -EINVAL, "missing property; rc=%i\n", rc);
> -	rc = of_property_match_string(np, "empty-property", "blah");
> -	unittest(rc == -ENODATA, "empty property; rc=%i\n", rc);
> -	rc = of_property_match_string(np, "unterminated-string", "blah");
> -	unittest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
> +
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_property_match_string(np, "phandle-list-names", "first"),
> +		0);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_property_match_string(np, "phandle-list-names", "second"),
> +		1);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_property_match_string(np, "phandle-list-names", "third"),
> +		2);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_match_string(np, "phandle-list-names", "fourth"),
> +		-ENODATA,
> +		"unmatched string");
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_match_string(np, "missing-property", "blah"),
> +		-EINVAL,
> +		"missing property");
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_match_string(np, "empty-property", "blah"),
> +		-ENODATA,
> +		"empty property");
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_match_string(np, "unterminated-string", "blah"),
> +		-EILSEQ,
> +		"unterminated string");
>  
>  	/* of_property_count_strings() tests */
> -	rc = of_property_count_strings(np, "string-property");
> -	unittest(rc == 1, "Incorrect string count; rc=%i\n", rc);
> -	rc = of_property_count_strings(np, "phandle-list-names");
> -	unittest(rc == 3, "Incorrect string count; rc=%i\n", rc);
> -	rc = of_property_count_strings(np, "unterminated-string");
> -	unittest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
> -	rc = of_property_count_strings(np, "unterminated-string-list");
> -	unittest(rc == -EILSEQ, "unterminated string array; rc=%i\n", rc);
> +	KUNIT_EXPECT_EQ(test,
> +			of_property_count_strings(np, "string-property"), 1);
> +	KUNIT_EXPECT_EQ(test,
> +			of_property_count_strings(np, "phandle-list-names"), 3);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_count_strings(np, "unterminated-string"), -EILSEQ,
> +		"unterminated string");
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_count_strings(np, "unterminated-string-list"),
> +		-EILSEQ,
> +		"unterminated string array");
>  
>  	/* of_property_read_string_index() tests */
>  	rc = of_property_read_string_index(np, "string-property", 0, strings);
> -	unittest(rc == 0 && !strcmp(strings[0], "foobar"), "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_ASSERT_EQ(test, rc, 0);
> +	KUNIT_EXPECT_STREQ(test, strings[0], "foobar");
> +
>  	strings[0] = NULL;
>  	rc = of_property_read_string_index(np, "string-property", 1, strings);
> -	unittest(rc == -ENODATA && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_EXPECT_EQ(test, rc, -ENODATA);
> +	KUNIT_EXPECT_EQ(test, strings[0], NULL);
> +
>  	rc = of_property_read_string_index(np, "phandle-list-names", 0, strings);
> -	unittest(rc == 0 && !strcmp(strings[0], "first"), "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_ASSERT_EQ(test, rc, 0);
> +	KUNIT_EXPECT_STREQ(test, strings[0], "first");
> +
>  	rc = of_property_read_string_index(np, "phandle-list-names", 1, strings);
> -	unittest(rc == 0 && !strcmp(strings[0], "second"), "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_ASSERT_EQ(test, rc, 0);
> +	KUNIT_EXPECT_STREQ(test, strings[0], "second");
> +
>  	rc = of_property_read_string_index(np, "phandle-list-names", 2, strings);
> -	unittest(rc == 0 && !strcmp(strings[0], "third"), "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_ASSERT_EQ(test, rc, 0);
> +	KUNIT_EXPECT_STREQ(test, strings[0], "third");
> +
>  	strings[0] = NULL;
>  	rc = of_property_read_string_index(np, "phandle-list-names", 3, strings);
> -	unittest(rc == -ENODATA && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_EXPECT_EQ(test, rc, -ENODATA);
> +	KUNIT_EXPECT_EQ(test, strings[0], NULL);
> +
>  	strings[0] = NULL;
>  	rc = of_property_read_string_index(np, "unterminated-string", 0, strings);
> -	unittest(rc == -EILSEQ && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_EXPECT_EQ(test, rc, -EILSEQ);
> +	KUNIT_EXPECT_EQ(test, strings[0], NULL);
> +
>  	rc = of_property_read_string_index(np, "unterminated-string-list", 0, strings);
> -	unittest(rc == 0 && !strcmp(strings[0], "first"), "of_property_read_string_index() failure; rc=%i\n", rc);
> +	KUNIT_ASSERT_EQ(test, rc, 0);
> +	KUNIT_EXPECT_STREQ(test, strings[0], "first");
> +
>  	strings[0] = NULL;
>  	rc = of_property_read_string_index(np, "unterminated-string-list", 2, strings); /* should fail */
> -	unittest(rc == -EILSEQ && strings[0] == NULL, "of_property_read_string_index() failure; rc=%i\n", rc);
> -	strings[1] = NULL;
> +	KUNIT_EXPECT_EQ(test, rc, -EILSEQ);
> +	KUNIT_EXPECT_EQ(test, strings[0], NULL);
>  
>  	/* of_property_read_string_array() tests */
> -	rc = of_property_read_string_array(np, "string-property", strings, 4);
> -	unittest(rc == 1, "Incorrect string count; rc=%i\n", rc);
> -	rc = of_property_read_string_array(np, "phandle-list-names", strings, 4);
> -	unittest(rc == 3, "Incorrect string count; rc=%i\n", rc);
> -	rc = of_property_read_string_array(np, "unterminated-string", strings, 4);
> -	unittest(rc == -EILSEQ, "unterminated string; rc=%i\n", rc);
> +	strings[1] = NULL;
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_property_read_string_array(
> +			np, "string-property", strings, 4),
> +		1);
> +	KUNIT_EXPECT_EQ(
> +		test,
> +		of_property_read_string_array(
> +			np, "phandle-list-names", strings, 4),
> +		3);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_read_string_array(
> +			np, "unterminated-string", strings, 4),
> +		-EILSEQ,
> +		"unterminated string");
>  	/* -- An incorrectly formed string should cause a failure */
> -	rc = of_property_read_string_array(np, "unterminated-string-list", strings, 4);
> -	unittest(rc == -EILSEQ, "unterminated string array; rc=%i\n", rc);
> +	KUNIT_EXPECT_EQ_MSG(
> +		test,
> +		of_property_read_string_array(
> +			np, "unterminated-string-list", strings, 4),
> +		-EILSEQ,
> +		"unterminated string array");
>  	/* -- parsing the correctly formed strings should still work: */
>  	strings[2] = NULL;
>  	rc = of_property_read_string_array(np, "unterminated-string-list", strings, 2);
> -	unittest(rc == 2 && strings[2] == NULL, "of_property_read_string_array() failure; rc=%i\n", rc);
> +	KUNIT_EXPECT_EQ(test, rc, 2);
> +	KUNIT_EXPECT_EQ(test, strings[2], NULL);
> +
>  	strings[1] = NULL;
>  	rc = of_property_read_string_array(np, "phandle-list-names", strings, 1);
> -	unittest(rc == 1 && strings[1] == NULL, "Overwrote end of string array; rc=%i, str='%s'\n", rc, strings[1]);
> +	KUNIT_ASSERT_EQ(test, rc, 1);
> +	KUNIT_EXPECT_EQ_MSG(test, strings[1], NULL,
> +			    "Overwrote end of string array");
>  }
>  
>  #define propcmp(p1, p2) (((p1)->length == (p2)->length) && \
>  			(p1)->value && (p2)->value && \
>  			!memcmp((p1)->value, (p2)->value, (p1)->length) && \
>  			!strcmp((p1)->name, (p2)->name))
> -static void __init of_unittest_property_copy(void)
> +static void of_unittest_property_copy(struct kunit *test)
>  {
>  #ifdef CONFIG_OF_DYNAMIC
>  	struct property p1 = { .name = "p1", .length = 0, .value = "" };
> @@ -686,20 +775,24 @@ static void __init of_unittest_property_copy(void)
>  	struct property *new;
>  
>  	new = __of_prop_dup(&p1, GFP_KERNEL);
> -	unittest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, new);
> +	KUNIT_EXPECT_TRUE_MSG(test, propcmp(&p1, new),
> +			      "empty property didn't copy correctly");
>  	kfree(new->value);
>  	kfree(new->name);
>  	kfree(new);
>  
>  	new = __of_prop_dup(&p2, GFP_KERNEL);
> -	unittest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, new);
> +	KUNIT_EXPECT_TRUE_MSG(test, propcmp(&p2, new),
> +			      "non-empty property didn't copy correctly");
>  	kfree(new->value);
>  	kfree(new->name);
>  	kfree(new);
>  #endif
>  }
>  
> -static void __init of_unittest_changeset(void)
> +static void of_unittest_changeset(struct kunit *test)
>  {
>  #ifdef CONFIG_OF_DYNAMIC
>  	struct property *ppadd, padd = { .name = "prop-add", .length = 1, .value = "" };
> @@ -712,32 +805,32 @@ static void __init of_unittest_changeset(void)
>  	struct of_changeset chgset;
>  
>  	n1 = __of_node_dup(NULL, "n1");
> -	unittest(n1, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, n1);
>  
>  	n2 = __of_node_dup(NULL, "n2");
> -	unittest(n2, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, n2);
>  
>  	n21 = __of_node_dup(NULL, "n21");
> -	unittest(n21, "testcase setup failure %p\n", n21);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, n21);
>  
>  	nchangeset = of_find_node_by_path("/testcase-data/changeset");
>  	nremove = of_get_child_by_name(nchangeset, "node-remove");
> -	unittest(nremove, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, nremove);
>  
>  	ppadd = __of_prop_dup(&padd, GFP_KERNEL);
> -	unittest(ppadd, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ppadd);
>  
>  	ppname_n1  = __of_prop_dup(&pname_n1, GFP_KERNEL);
> -	unittest(ppname_n1, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ppname_n1);
>  
>  	ppname_n2  = __of_prop_dup(&pname_n2, GFP_KERNEL);
> -	unittest(ppname_n2, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ppname_n2);
>  
>  	ppname_n21 = __of_prop_dup(&pname_n21, GFP_KERNEL);
> -	unittest(ppname_n21, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ppname_n21);
>  
>  	ppupdate = __of_prop_dup(&pupdate, GFP_KERNEL);
> -	unittest(ppupdate, "testcase setup failure\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ppupdate);
>  
>  	parent = nchangeset;
>  	n1->parent = parent;
> @@ -745,54 +838,72 @@ static void __init of_unittest_changeset(void)
>  	n21->parent = n2;
>  
>  	ppremove = of_find_property(parent, "prop-remove", NULL);
> -	unittest(ppremove, "failed to find removal prop");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ppremove);
>  
>  	of_changeset_init(&chgset);
>  
> -	unittest(!of_changeset_attach_node(&chgset, n1), "fail attach n1\n");
> -	unittest(!of_changeset_add_property(&chgset, n1, ppname_n1), "fail add prop name\n");
> -
> -	unittest(!of_changeset_attach_node(&chgset, n2), "fail attach n2\n");
> -	unittest(!of_changeset_add_property(&chgset, n2, ppname_n2), "fail add prop name\n");
> -
> -	unittest(!of_changeset_detach_node(&chgset, nremove), "fail remove node\n");
> -	unittest(!of_changeset_add_property(&chgset, n21, ppname_n21), "fail add prop name\n");
> -
> -	unittest(!of_changeset_attach_node(&chgset, n21), "fail attach n21\n");
> -
> -	unittest(!of_changeset_add_property(&chgset, parent, ppadd), "fail add prop prop-add\n");
> -	unittest(!of_changeset_update_property(&chgset, parent, ppupdate), "fail update prop\n");
> -	unittest(!of_changeset_remove_property(&chgset, parent, ppremove), "fail remove prop\n");
> -
> -	unittest(!of_changeset_apply(&chgset), "apply failed\n");
> +	KUNIT_EXPECT_FALSE_MSG(test, of_changeset_attach_node(&chgset, n1),
> +			       "fail attach n1\n");
> +	KUNIT_EXPECT_FALSE_MSG(
> +		test, of_changeset_add_property(&chgset, n1, ppname_n1),
> +		"fail add prop name\n");
> +
> +	KUNIT_EXPECT_FALSE_MSG(test, of_changeset_attach_node(&chgset, n2),
> +			       "fail attach n2\n");
> +	KUNIT_EXPECT_FALSE_MSG(
> +		test, of_changeset_add_property(&chgset, n2, ppname_n2),
> +			       "fail add prop name\n");
> +
> +	KUNIT_EXPECT_FALSE_MSG(test, of_changeset_detach_node(&chgset, nremove),
> +			       "fail remove node\n");
> +	KUNIT_EXPECT_FALSE_MSG(
> +		test, of_changeset_add_property(&chgset, n21, ppname_n21),
> +		"fail add prop name\n");
> +
> +	KUNIT_EXPECT_FALSE_MSG(test, of_changeset_attach_node(&chgset, n21),
> +			       "fail attach n21\n");
> +
> +	KUNIT_EXPECT_FALSE_MSG(
> +		test,
> +		of_changeset_add_property(&chgset, parent, ppadd),
> +		"fail add prop prop-add\n");
> +	KUNIT_EXPECT_FALSE_MSG(
> +		test,
> +		of_changeset_update_property(&chgset, parent, ppupdate),
> +		"fail update prop\n");
> +	KUNIT_EXPECT_FALSE_MSG(
> +		test,
> +		of_changeset_remove_property(&chgset, parent, ppremove),
> +		"fail remove prop\n");
> +
> +	KUNIT_EXPECT_FALSE_MSG(test, of_changeset_apply(&chgset),
> +			       "apply failed\n");
>  
>  	of_node_put(nchangeset);
>  
>  	/* Make sure node names are constructed correctly */
> -	unittest((np = of_find_node_by_path("/testcase-data/changeset/n2/n21")),
> -		 "'%pOF' not added\n", n21);
> +	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
> +		test,
> +		np = of_find_node_by_path("/testcase-data/changeset/n2/n21"),
> +		"'%pOF' not added\n", n21);
>  	of_node_put(np);
>  
> -	unittest(!of_changeset_revert(&chgset), "revert failed\n");
> +	KUNIT_EXPECT_FALSE(test, of_changeset_revert(&chgset));
>  
>  	of_changeset_destroy(&chgset);
>  #endif
>  }
>  
> -static void __init of_unittest_parse_interrupts(void)
> +static void of_unittest_parse_interrupts(struct kunit *test)
>  {
>  	struct device_node *np;
>  	struct of_phandle_args args;
>  	int i, rc;
>  
> -	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
> -		return;
> +	KUNIT_ASSERT_FALSE(test, of_irq_workarounds & OF_IMAP_OLDWORLD_MAC);
>  
>  	np = of_find_node_by_path("/testcase-data/interrupts/interrupts0");
> -	if (!np) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	for (i = 0; i < 4; i++) {
>  		bool passed = true;
> @@ -804,16 +915,15 @@ static void __init of_unittest_parse_interrupts(void)
>  		passed &= (args.args_count == 1);
>  		passed &= (args.args[0] == (i + 1));
>  
> -		unittest(passed, "index %i - data error on node %pOF rc=%i\n",
> -			 i, args.np, rc);
> +		KUNIT_EXPECT_TRUE_MSG(
> +			test, passed,
> +			"index %i - data error on node %pOF rc=%i\n",
> +			i, args.np, rc);
>  	}
>  	of_node_put(np);
>  
>  	np = of_find_node_by_path("/testcase-data/interrupts/interrupts1");
> -	if (!np) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	for (i = 0; i < 4; i++) {
>  		bool passed = true;
> @@ -850,26 +960,24 @@ static void __init of_unittest_parse_interrupts(void)
>  		default:
>  			passed = false;
>  		}
> -		unittest(passed, "index %i - data error on node %pOF rc=%i\n",
> -			 i, args.np, rc);
> +		KUNIT_EXPECT_TRUE_MSG(
> +			test, passed,
> +			"index %i - data error on node %pOF rc=%i\n",
> +			i, args.np, rc);
>  	}
>  	of_node_put(np);
>  }
>  
> -static void __init of_unittest_parse_interrupts_extended(void)
> +static void of_unittest_parse_interrupts_extended(struct kunit *test)
>  {
>  	struct device_node *np;
>  	struct of_phandle_args args;
>  	int i, rc;
>  
> -	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
> -		return;
> +	KUNIT_ASSERT_FALSE(test, of_irq_workarounds & OF_IMAP_OLDWORLD_MAC);
>  
>  	np = of_find_node_by_path("/testcase-data/interrupts/interrupts-extended0");
> -	if (!np) {
> -		pr_err("missing testcase data\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	for (i = 0; i < 7; i++) {
>  		bool passed = true;
> @@ -924,8 +1032,10 @@ static void __init of_unittest_parse_interrupts_extended(void)
>  			passed = false;
>  		}
>  
> -		unittest(passed, "index %i - data error on node %pOF rc=%i\n",
> -			 i, args.np, rc);
> +		KUNIT_EXPECT_TRUE_MSG(
> +			test, passed,
> +			"index %i - data error on node %pOF rc=%i\n",
> +			i, args.np, rc);
>  	}
>  	of_node_put(np);
>  }
> @@ -965,7 +1075,7 @@ static struct {
>  	{ .path = "/testcase-data/match-node/name9", .data = "K", },
>  };
>  
> -static void __init of_unittest_match_node(void)
> +static void of_unittest_match_node(struct kunit *test)
>  {
>  	struct device_node *np;
>  	const struct of_device_id *match;
> @@ -973,26 +1083,19 @@ static void __init of_unittest_match_node(void)
>  
>  	for (i = 0; i < ARRAY_SIZE(match_node_tests); i++) {
>  		np = of_find_node_by_path(match_node_tests[i].path);
> -		if (!np) {
> -			unittest(0, "missing testcase node %s\n",
> -				match_node_tests[i].path);
> -			continue;
> -		}
> +		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  		match = of_match_node(match_node_table, np);
> -		if (!match) {
> -			unittest(0, "%s didn't match anything\n",
> -				match_node_tests[i].path);
> -			continue;
> -		}
> +		KUNIT_ASSERT_NOT_ERR_OR_NULL_MSG(test, np,
> +						 "%s didn't match anything",
> +						 match_node_tests[i].path);
>  
> -		if (strcmp(match->data, match_node_tests[i].data) != 0) {
> -			unittest(0, "%s got wrong match. expected %s, got %s\n",
> -				match_node_tests[i].path, match_node_tests[i].data,
> -				(const char *)match->data);
> -			continue;
> -		}
> -		unittest(1, "passed");
> +		KUNIT_EXPECT_STREQ_MSG(
> +			test,
> +			match->data, match_node_tests[i].data,
> +			"%s got wrong match. expected %s, got %s\n",
> +			match_node_tests[i].path, match_node_tests[i].data,
> +			(const char *)match->data);
>  	}
>  }
>  
> @@ -1004,9 +1107,9 @@ static struct resource test_bus_res = {
>  static const struct platform_device_info test_bus_info = {
>  	.name = "unittest-bus",
>  };
> -static void __init of_unittest_platform_populate(void)
> +static void of_unittest_platform_populate(struct kunit *test)
>  {
> -	int irq, rc;
> +	int irq;
>  	struct device_node *np, *child, *grandchild;
>  	struct platform_device *pdev, *test_bus;
>  	const struct of_device_id match[] = {
> @@ -1020,32 +1123,27 @@ static void __init of_unittest_platform_populate(void)
>  	/* Test that a missing irq domain returns -EPROBE_DEFER */
>  	np = of_find_node_by_path("/testcase-data/testcase-device1");
>  	pdev = of_find_device_by_node(np);
> -	unittest(pdev, "device 1 creation failed\n");
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pdev);
>  
>  	if (!(of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)) {
>  		irq = platform_get_irq(pdev, 0);
> -		unittest(irq == -EPROBE_DEFER,
> -			 "device deferred probe failed - %d\n", irq);
> +		KUNIT_ASSERT_EQ(test, irq, -EPROBE_DEFER);
>  
>  		/* Test that a parsing failure does not return -EPROBE_DEFER */
>  		np = of_find_node_by_path("/testcase-data/testcase-device2");
>  		pdev = of_find_device_by_node(np);
> -		unittest(pdev, "device 2 creation failed\n");
> +		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pdev);
>  		irq = platform_get_irq(pdev, 0);
> -		unittest(irq < 0 && irq != -EPROBE_DEFER,
> -			 "device parsing error failed - %d\n", irq);
> +		KUNIT_ASSERT_TRUE_MSG(test, irq < 0 && irq != -EPROBE_DEFER,
> +				      "device parsing error failed - %d\n",
> +				      irq);
>  	}
>  
>  	np = of_find_node_by_path("/testcase-data/platform-tests");
> -	unittest(np, "No testcase data in device tree\n");
> -	if (!np)
> -		return;
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>  
>  	test_bus = platform_device_register_full(&test_bus_info);
> -	rc = PTR_ERR_OR_ZERO(test_bus);
> -	unittest(!rc, "testbus registration failed; rc=%i\n", rc);
> -	if (rc)
> -		return;
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_bus);
>  	test_bus->dev.of_node = np;
>  
>  	/*
> @@ -1060,17 +1158,19 @@ static void __init of_unittest_platform_populate(void)
>  	of_platform_populate(np, match, NULL, &test_bus->dev);
>  	for_each_child_of_node(np, child) {
>  		for_each_child_of_node(child, grandchild)
> -			unittest(of_find_device_by_node(grandchild),
> -				 "Could not create device for node '%pOFn'\n",
> -				 grandchild);
> +			KUNIT_EXPECT_TRUE_MSG(
> +				test, of_find_device_by_node(grandchild),
> +				"Could not create device for node '%pOFn'\n",
> +				grandchild);
>  	}
>  
>  	of_platform_depopulate(&test_bus->dev);
>  	for_each_child_of_node(np, child) {
>  		for_each_child_of_node(child, grandchild)
> -			unittest(!of_find_device_by_node(grandchild),
> -				 "device didn't get destroyed '%pOFn'\n",
> -				 grandchild);
> +			KUNIT_EXPECT_FALSE_MSG(
> +				test, of_find_device_by_node(grandchild),
> +				"device didn't get destroyed '%pOFn'\n",
> +				grandchild);
>  	}
>  
>  	platform_device_unregister(test_bus);
> @@ -1171,7 +1271,7 @@ static void attach_node_and_children(struct device_node *np)
>   *	unittest_data_add - Reads, copies data from
>   *	linked tree and attaches it to the live tree
>   */
> -static int __init unittest_data_add(void)
> +static int unittest_data_add(void)
>  {
>  	void *unittest_data;
>  	struct device_node *unittest_data_node, *np;
> @@ -1242,7 +1342,7 @@ static int __init unittest_data_add(void)
>  }
>  
>  #ifdef CONFIG_OF_OVERLAY
> -static int __init overlay_data_apply(const char *overlay_name, int *overlay_id);
> +static int overlay_data_apply(const char *overlay_name, int *overlay_id);
>  
>  static int unittest_probe(struct platform_device *pdev)
>  {
> @@ -1471,172 +1571,146 @@ static void of_unittest_destroy_tracked_overlays(void)
>  	} while (defers > 0);
>  }
>  
> -static int __init of_unittest_apply_overlay(int overlay_nr, int *overlay_id)
> +static int of_unittest_apply_overlay(struct kunit *test,
> +				     int overlay_nr,
> +				     int *overlay_id)
>  {
>  	const char *overlay_name;
>  
>  	overlay_name = overlay_name_from_nr(overlay_nr);
>  
> -	if (!overlay_data_apply(overlay_name, overlay_id)) {
> -		unittest(0, "could not apply overlay \"%s\"\n",
> -				overlay_name);
> -		return -EFAULT;
> -	}
> +	KUNIT_ASSERT_TRUE_MSG(test,
> +			      overlay_data_apply(overlay_name, overlay_id),
> +			      "could not apply overlay \"%s\"\n", overlay_name);
>  	of_unittest_track_overlay(*overlay_id);
>  
>  	return 0;
>  }
>  
>  /* apply an overlay while checking before and after states */
> -static int __init of_unittest_apply_overlay_check(int overlay_nr,
> +static int of_unittest_apply_overlay_check(struct kunit *test, int overlay_nr,
>  		int unittest_nr, int before, int after,
>  		enum overlay_type ovtype)
>  {
>  	int ret, ovcs_id;
>  
>  	/* unittest device must not be in before state */
> -	if (of_unittest_device_exists(unittest_nr, ovtype) != before) {
> -		unittest(0, "%s with device @\"%s\" %s\n",
> -				overlay_name_from_nr(overlay_nr),
> -				unittest_path(unittest_nr, ovtype),
> -				!before ? "enabled" : "disabled");
> -		return -EINVAL;
> -	}
> +	KUNIT_ASSERT_EQ_MSG(
> +		test, of_unittest_device_exists(unittest_nr, ovtype), before,
> +		"%s with device @\"%s\" %s\n", overlay_name_from_nr(overlay_nr),
> +		unittest_path(unittest_nr, ovtype),
> +		!before ? "enabled" : "disabled");
>  
>  	ovcs_id = 0;
> -	ret = of_unittest_apply_overlay(overlay_nr, &ovcs_id);
> +	ret = of_unittest_apply_overlay(test, overlay_nr, &ovcs_id);
>  	if (ret != 0) {
> -		/* of_unittest_apply_overlay already called unittest() */
> +		/* of_unittest_apply_overlay already set expectation */
>  		return ret;
>  	}
>  
>  	/* unittest device must be to set to after state */
> -	if (of_unittest_device_exists(unittest_nr, ovtype) != after) {
> -		unittest(0, "%s failed to create @\"%s\" %s\n",
> -				overlay_name_from_nr(overlay_nr),
> -				unittest_path(unittest_nr, ovtype),
> -				!after ? "enabled" : "disabled");
> -		return -EINVAL;
> -	}
> +	KUNIT_ASSERT_EQ_MSG(
> +		test, of_unittest_device_exists(unittest_nr, ovtype), after,
> +		"%s failed to create @\"%s\" %s\n",
> +		overlay_name_from_nr(overlay_nr),
> +		unittest_path(unittest_nr, ovtype),
> +		!after ? "enabled" : "disabled");
>  
>  	return 0;
>  }
>  
>  /* apply an overlay and then revert it while checking before, after states */
> -static int __init of_unittest_apply_revert_overlay_check(int overlay_nr,
> +static int of_unittest_apply_revert_overlay_check(
> +		struct kunit *test, int overlay_nr,
>  		int unittest_nr, int before, int after,
>  		enum overlay_type ovtype)
>  {
>  	int ret, ovcs_id;
>  
>  	/* unittest device must be in before state */
> -	if (of_unittest_device_exists(unittest_nr, ovtype) != before) {
> -		unittest(0, "%s with device @\"%s\" %s\n",
> -				overlay_name_from_nr(overlay_nr),
> -				unittest_path(unittest_nr, ovtype),
> -				!before ? "enabled" : "disabled");
> -		return -EINVAL;
> -	}
> +	KUNIT_ASSERT_EQ_MSG(
> +		test, of_unittest_device_exists(unittest_nr, ovtype), before,
> +		"%s with device @\"%s\" %s\n", overlay_name_from_nr(overlay_nr),
> +		unittest_path(unittest_nr, ovtype),
> +		!before ? "enabled" : "disabled");
>  
>  	/* apply the overlay */
>  	ovcs_id = 0;
> -	ret = of_unittest_apply_overlay(overlay_nr, &ovcs_id);
> +	ret = of_unittest_apply_overlay(test, overlay_nr, &ovcs_id);
>  	if (ret != 0) {
> -		/* of_unittest_apply_overlay already called unittest() */
> +		/* of_unittest_apply_overlay already set expectation. */
>  		return ret;
>  	}
>  
>  	/* unittest device must be in after state */
> -	if (of_unittest_device_exists(unittest_nr, ovtype) != after) {
> -		unittest(0, "%s failed to create @\"%s\" %s\n",
> -				overlay_name_from_nr(overlay_nr),
> -				unittest_path(unittest_nr, ovtype),
> -				!after ? "enabled" : "disabled");
> -		return -EINVAL;
> -	}
> -
> -	ret = of_overlay_remove(&ovcs_id);
> -	if (ret != 0) {
> -		unittest(0, "%s failed to be destroyed @\"%s\"\n",
> -				overlay_name_from_nr(overlay_nr),
> -				unittest_path(unittest_nr, ovtype));
> -		return ret;
> -	}
> +	KUNIT_ASSERT_EQ_MSG(
> +		test, of_unittest_device_exists(unittest_nr, ovtype), after,
> +		"%s failed to create @\"%s\" %s\n",
> +		overlay_name_from_nr(overlay_nr),
> +		unittest_path(unittest_nr, ovtype),
> +		!after ? "enabled" : "disabled");
> +
> +	KUNIT_ASSERT_EQ_MSG(test, of_overlay_remove(&ovcs_id), 0,
> +			    "%s failed to be destroyed @\"%s\"\n",
> +			    overlay_name_from_nr(overlay_nr),
> +			    unittest_path(unittest_nr, ovtype));
>  
>  	/* unittest device must be again in before state */
> -	if (of_unittest_device_exists(unittest_nr, PDEV_OVERLAY) != before) {
> -		unittest(0, "%s with device @\"%s\" %s\n",
> -				overlay_name_from_nr(overlay_nr),
> -				unittest_path(unittest_nr, ovtype),
> -				!before ? "enabled" : "disabled");
> -		return -EINVAL;
> -	}
> +	KUNIT_ASSERT_EQ_MSG(
> +		test,
> +		of_unittest_device_exists(unittest_nr, PDEV_OVERLAY), before,
> +		"%s with device @\"%s\" %s\n",
> +		overlay_name_from_nr(overlay_nr),
> +		unittest_path(unittest_nr, ovtype),
> +		!before ? "enabled" : "disabled");
>  
>  	return 0;
>  }
>  
>  /* test activation of device */
> -static void __init of_unittest_overlay_0(void)
> +static void of_unittest_overlay_0(struct kunit *test)
>  {
>  	/* device should enable */
> -	if (of_unittest_apply_overlay_check(0, 0, 0, 1, PDEV_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 0);
> +	of_unittest_apply_overlay_check(test, 0, 0, 0, 1, PDEV_OVERLAY);
>  }
>  
>  /* test deactivation of device */
> -static void __init of_unittest_overlay_1(void)
> +static void of_unittest_overlay_1(struct kunit *test)
>  {
>  	/* device should disable */
> -	if (of_unittest_apply_overlay_check(1, 1, 1, 0, PDEV_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 1);
> +	of_unittest_apply_overlay_check(test, 1, 1, 1, 0, PDEV_OVERLAY);
>  }
>  
>  /* test activation of device */
> -static void __init of_unittest_overlay_2(void)
> +static void of_unittest_overlay_2(struct kunit *test)
>  {
>  	/* device should enable */
> -	if (of_unittest_apply_overlay_check(2, 2, 0, 1, PDEV_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 2);
> +	of_unittest_apply_overlay_check(test, 2, 2, 0, 1, PDEV_OVERLAY);
>  }
>  
>  /* test deactivation of device */
> -static void __init of_unittest_overlay_3(void)
> +static void of_unittest_overlay_3(struct kunit *test)
>  {
>  	/* device should disable */
> -	if (of_unittest_apply_overlay_check(3, 3, 1, 0, PDEV_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 3);
> +	of_unittest_apply_overlay_check(test, 3, 3, 1, 0, PDEV_OVERLAY);
>  }
>  
>  /* test activation of a full device node */
> -static void __init of_unittest_overlay_4(void)
> +static void of_unittest_overlay_4(struct kunit *test)
>  {
>  	/* device should disable */
> -	if (of_unittest_apply_overlay_check(4, 4, 0, 1, PDEV_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 4);
> +	of_unittest_apply_overlay_check(test, 4, 4, 0, 1, PDEV_OVERLAY);
>  }
>  
>  /* test overlay apply/revert sequence */
> -static void __init of_unittest_overlay_5(void)
> +static void of_unittest_overlay_5(struct kunit *test)
>  {
>  	/* device should disable */
> -	if (of_unittest_apply_revert_overlay_check(5, 5, 0, 1, PDEV_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 5);
> +	of_unittest_apply_revert_overlay_check(test, 5, 5, 0, 1, PDEV_OVERLAY);
>  }
>  
>  /* test overlay application in sequence */
> -static void __init of_unittest_overlay_6(void)
> +static void of_unittest_overlay_6(struct kunit *test)
>  {
>  	int i, ov_id[2], ovcs_id;
>  	int overlay_nr = 6, unittest_nr = 6;
> @@ -1645,74 +1719,67 @@ static void __init of_unittest_overlay_6(void)
>  
>  	/* unittest device must be in before state */
>  	for (i = 0; i < 2; i++) {
> -		if (of_unittest_device_exists(unittest_nr + i, PDEV_OVERLAY)
> -				!= before) {
> -			unittest(0, "%s with device @\"%s\" %s\n",
> -					overlay_name_from_nr(overlay_nr + i),
> -					unittest_path(unittest_nr + i,
> -						PDEV_OVERLAY),
> -					!before ? "enabled" : "disabled");
> -			return;
> -		}
> +		KUNIT_ASSERT_EQ_MSG(test,
> +				    of_unittest_device_exists(unittest_nr + i,
> +							      PDEV_OVERLAY),
> +				    before,
> +				    "%s with device @\"%s\" %s\n",
> +				    overlay_name_from_nr(overlay_nr + i),
> +				    unittest_path(unittest_nr + i,
> +						  PDEV_OVERLAY),
> +				    !before ? "enabled" : "disabled");
>  	}
>  
>  	/* apply the overlays */
>  	for (i = 0; i < 2; i++) {
> -
>  		overlay_name = overlay_name_from_nr(overlay_nr + i);
>  
> -		if (!overlay_data_apply(overlay_name, &ovcs_id)) {
> -			unittest(0, "could not apply overlay \"%s\"\n",
> -					overlay_name);
> -			return;
> -		}
> +		KUNIT_ASSERT_TRUE_MSG(
> +			test, overlay_data_apply(overlay_name, &ovcs_id),
> +			"could not apply overlay \"%s\"\n", overlay_name);
>  		ov_id[i] = ovcs_id;
>  		of_unittest_track_overlay(ov_id[i]);
>  	}
>  
>  	for (i = 0; i < 2; i++) {
>  		/* unittest device must be in after state */
> -		if (of_unittest_device_exists(unittest_nr + i, PDEV_OVERLAY)
> -				!= after) {
> -			unittest(0, "overlay @\"%s\" failed @\"%s\" %s\n",
> -					overlay_name_from_nr(overlay_nr + i),
> -					unittest_path(unittest_nr + i,
> -						PDEV_OVERLAY),
> -					!after ? "enabled" : "disabled");
> -			return;
> -		}
> +		KUNIT_ASSERT_EQ_MSG(test,
> +				    of_unittest_device_exists(unittest_nr + i,
> +							      PDEV_OVERLAY),
> +				    after,
> +				    "overlay @\"%s\" failed @\"%s\" %s\n",
> +				    overlay_name_from_nr(overlay_nr + i),
> +				    unittest_path(unittest_nr + i,
> +						  PDEV_OVERLAY),
> +				    !after ? "enabled" : "disabled");
>  	}
>  
>  	for (i = 1; i >= 0; i--) {
>  		ovcs_id = ov_id[i];
> -		if (of_overlay_remove(&ovcs_id)) {
> -			unittest(0, "%s failed destroy @\"%s\"\n",
> -					overlay_name_from_nr(overlay_nr + i),
> -					unittest_path(unittest_nr + i,
> -						PDEV_OVERLAY));
> -			return;
> -		}
> +		KUNIT_ASSERT_FALSE_MSG(
> +			test, of_overlay_remove(&ovcs_id),
> +			"%s failed destroy @\"%s\"\n",
> +			overlay_name_from_nr(overlay_nr + i),
> +			unittest_path(unittest_nr + i, PDEV_OVERLAY));
>  		of_unittest_untrack_overlay(ov_id[i]);
>  	}
>  
>  	for (i = 0; i < 2; i++) {
>  		/* unittest device must be again in before state */
> -		if (of_unittest_device_exists(unittest_nr + i, PDEV_OVERLAY)
> -				!= before) {
> -			unittest(0, "%s with device @\"%s\" %s\n",
> -					overlay_name_from_nr(overlay_nr + i),
> -					unittest_path(unittest_nr + i,
> -						PDEV_OVERLAY),
> -					!before ? "enabled" : "disabled");
> -			return;
> -		}
> +		KUNIT_ASSERT_EQ_MSG(test,
> +				    of_unittest_device_exists(unittest_nr + i,
> +							      PDEV_OVERLAY),
> +				    before,
> +				    "%s with device @\"%s\" %s\n",
> +				    overlay_name_from_nr(overlay_nr + i),
> +				    unittest_path(unittest_nr + i,
> +						  PDEV_OVERLAY),
> +				    !before ? "enabled" : "disabled");
>  	}
> -
> -	unittest(1, "overlay test %d passed\n", 6);
>  }
>  
>  /* test overlay application in sequence */
> -static void __init of_unittest_overlay_8(void)
> +static void of_unittest_overlay_8(struct kunit *test)
>  {
>  	int i, ov_id[2], ovcs_id;
>  	int overlay_nr = 8, unittest_nr = 8;
> @@ -1722,76 +1789,64 @@ static void __init of_unittest_overlay_8(void)
>  
>  	/* apply the overlays */
>  	for (i = 0; i < 2; i++) {
> -
>  		overlay_name = overlay_name_from_nr(overlay_nr + i);
>  
> -		if (!overlay_data_apply(overlay_name, &ovcs_id)) {
> -			unittest(0, "could not apply overlay \"%s\"\n",
> -					overlay_name);
> -			return;
> -		}
> +		KUNIT_ASSERT_TRUE_MSG(
> +			test, overlay_data_apply(overlay_name, &ovcs_id),
> +			"could not apply overlay \"%s\"\n", overlay_name);
>  		ov_id[i] = ovcs_id;
>  		of_unittest_track_overlay(ov_id[i]);
>  	}
>  
>  	/* now try to remove first overlay (it should fail) */
>  	ovcs_id = ov_id[0];
> -	if (!of_overlay_remove(&ovcs_id)) {
> -		unittest(0, "%s was destroyed @\"%s\"\n",
> -				overlay_name_from_nr(overlay_nr + 0),
> -				unittest_path(unittest_nr,
> -					PDEV_OVERLAY));
> -		return;
> -	}
> +	KUNIT_ASSERT_TRUE_MSG(
> +		test, of_overlay_remove(&ovcs_id),
> +		"%s was destroyed @\"%s\"\n",
> +		overlay_name_from_nr(overlay_nr + 0),
> +		unittest_path(unittest_nr, PDEV_OVERLAY));
>  
>  	/* removing them in order should work */
>  	for (i = 1; i >= 0; i--) {
>  		ovcs_id = ov_id[i];
> -		if (of_overlay_remove(&ovcs_id)) {
> -			unittest(0, "%s not destroyed @\"%s\"\n",
> -					overlay_name_from_nr(overlay_nr + i),
> -					unittest_path(unittest_nr,
> -						PDEV_OVERLAY));
> -			return;
> -		}
> +		KUNIT_ASSERT_FALSE_MSG(
> +			test, of_overlay_remove(&ovcs_id),
> +			"%s not destroyed @\"%s\"\n",
> +			overlay_name_from_nr(overlay_nr + i),
> +			unittest_path(unittest_nr, PDEV_OVERLAY));
>  		of_unittest_untrack_overlay(ov_id[i]);
>  	}
> -
> -	unittest(1, "overlay test %d passed\n", 8);
>  }
>  
>  /* test insertion of a bus with parent devices */
> -static void __init of_unittest_overlay_10(void)
> +static void of_unittest_overlay_10(struct kunit *test)
>  {
> -	int ret;
>  	char *child_path;
>  
>  	/* device should disable */
> -	ret = of_unittest_apply_overlay_check(10, 10, 0, 1, PDEV_OVERLAY);
> -	if (unittest(ret == 0,
> -			"overlay test %d failed; overlay application\n", 10))
> -		return;
> +	KUNIT_ASSERT_EQ_MSG(
> +		test,
> +		of_unittest_apply_overlay_check(
> +				test, 10, 10, 0, 1, PDEV_OVERLAY),
> +		0,
> +		"overlay test %d failed; overlay application\n", 10);
>  
>  	child_path = kasprintf(GFP_KERNEL, "%s/test-unittest101",
>  			unittest_path(10, PDEV_OVERLAY));
> -	if (unittest(child_path, "overlay test %d failed; kasprintf\n", 10))
> -		return;
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, child_path);
>  
> -	ret = of_path_device_type_exists(child_path, PDEV_OVERLAY);
> +	KUNIT_EXPECT_TRUE_MSG(
> +		test, of_path_device_type_exists(child_path, PDEV_OVERLAY),
> +		"overlay test %d failed; no child device\n", 10);
>  	kfree(child_path);
> -
> -	unittest(ret, "overlay test %d failed; no child device\n", 10);
>  }
>  
>  /* test insertion of a bus with parent devices (and revert) */
> -static void __init of_unittest_overlay_11(void)
> +static void of_unittest_overlay_11(struct kunit *test)
>  {
> -	int ret;
> -
>  	/* device should disable */
> -	ret = of_unittest_apply_revert_overlay_check(11, 11, 0, 1,
> -			PDEV_OVERLAY);
> -	unittest(ret == 0, "overlay test %d failed; overlay apply\n", 11);
> +	KUNIT_EXPECT_FALSE(test, of_unittest_apply_revert_overlay_check(
> +		test, 11, 11, 0, 1, PDEV_OVERLAY));
>  }
>  
>  #if IS_BUILTIN(CONFIG_I2C) && IS_ENABLED(CONFIG_OF_OVERLAY)
> @@ -2013,25 +2068,18 @@ static struct i2c_driver unittest_i2c_mux_driver = {
>  
>  #endif
>  
> -static int of_unittest_overlay_i2c_init(void)
> +static int of_unittest_overlay_i2c_init(struct kunit *test)
>  {
> -	int ret;
> -
> -	ret = i2c_add_driver(&unittest_i2c_dev_driver);
> -	if (unittest(ret == 0,
> -			"could not register unittest i2c device driver\n"))
> -		return ret;
> +	KUNIT_ASSERT_EQ_MSG(test, i2c_add_driver(&unittest_i2c_dev_driver), 0,
> +			    "could not register unittest i2c device driver\n");
>  
> -	ret = platform_driver_register(&unittest_i2c_bus_driver);
> -	if (unittest(ret == 0,
> -			"could not register unittest i2c bus driver\n"))
> -		return ret;
> +	KUNIT_ASSERT_EQ_MSG(
> +		test, platform_driver_register(&unittest_i2c_bus_driver), 0,
> +		"could not register unittest i2c bus driver\n");
>  
>  #if IS_BUILTIN(CONFIG_I2C_MUX)
> -	ret = i2c_add_driver(&unittest_i2c_mux_driver);
> -	if (unittest(ret == 0,
> -			"could not register unittest i2c mux driver\n"))
> -		return ret;
> +	KUNIT_ASSERT_EQ_MSG(test, i2c_add_driver(&unittest_i2c_mux_driver), 0,
> +			    "could not register unittest i2c mux driver\n");
>  #endif
>  
>  	return 0;
> @@ -2046,101 +2094,85 @@ static void of_unittest_overlay_i2c_cleanup(void)
>  	i2c_del_driver(&unittest_i2c_dev_driver);
>  }
>  
> -static void __init of_unittest_overlay_i2c_12(void)
> +static void of_unittest_overlay_i2c_12(struct kunit *test)
>  {
>  	/* device should enable */
> -	if (of_unittest_apply_overlay_check(12, 12, 0, 1, I2C_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 12);
> +	of_unittest_apply_overlay_check(test, 12, 12, 0, 1, I2C_OVERLAY);
>  }
>  
>  /* test deactivation of device */
> -static void __init of_unittest_overlay_i2c_13(void)
> +static void of_unittest_overlay_i2c_13(struct kunit *test)
>  {
>  	/* device should disable */
> -	if (of_unittest_apply_overlay_check(13, 13, 1, 0, I2C_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 13);
> +	of_unittest_apply_overlay_check(test, 13, 13, 1, 0, I2C_OVERLAY);
>  }
>  
>  /* just check for i2c mux existence */
> -static void of_unittest_overlay_i2c_14(void)
> +static void of_unittest_overlay_i2c_14(struct kunit *test)
>  {
> +	KUNIT_SUCCEED(test);
>  }
>  
> -static void __init of_unittest_overlay_i2c_15(void)
> +static void of_unittest_overlay_i2c_15(struct kunit *test)
>  {
>  	/* device should enable */
> -	if (of_unittest_apply_overlay_check(15, 15, 0, 1, I2C_OVERLAY))
> -		return;
> -
> -	unittest(1, "overlay test %d passed\n", 15);
> +	of_unittest_apply_overlay_check(test, 15, 15, 0, 1, I2C_OVERLAY);
>  }
>  
>  #else
>  
> -static inline void of_unittest_overlay_i2c_14(void) { }
> -static inline void of_unittest_overlay_i2c_15(void) { }
> +static inline void of_unittest_overlay_i2c_14(struct kunit *test) { }
> +static inline void of_unittest_overlay_i2c_15(struct kunit *test) { }
>  
>  #endif
>  
> -static void __init of_unittest_overlay(void)
> +static void of_unittest_overlay(struct kunit *test)
>  {
>  	struct device_node *bus_np = NULL;
>  
> -	if (platform_driver_register(&unittest_driver)) {
> -		unittest(0, "could not register unittest driver\n");
> -		goto out;
> -	}
> +	KUNIT_ASSERT_FALSE_MSG(test, platform_driver_register(&unittest_driver),
> +			       "could not register unittest driver\n");
>  
>  	bus_np = of_find_node_by_path(bus_path);
> -	if (bus_np == NULL) {
> -		unittest(0, "could not find bus_path \"%s\"\n", bus_path);
> -		goto out;
> -	}
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL_MSG(
> +		test, bus_np, "could not find bus_path \"%s\"\n", bus_path);
>  
> -	if (of_platform_default_populate(bus_np, NULL, NULL)) {
> -		unittest(0, "could not populate bus @ \"%s\"\n", bus_path);
> -		goto out;
> -	}
> -
> -	if (!of_unittest_device_exists(100, PDEV_OVERLAY)) {
> -		unittest(0, "could not find unittest0 @ \"%s\"\n",
> -				unittest_path(100, PDEV_OVERLAY));
> -		goto out;
> -	}
> +	KUNIT_ASSERT_FALSE_MSG(
> +		test, of_platform_default_populate(bus_np, NULL, NULL),
> +		"could not populate bus @ \"%s\"\n", bus_path);
>  
> -	if (of_unittest_device_exists(101, PDEV_OVERLAY)) {
> -		unittest(0, "unittest1 @ \"%s\" should not exist\n",
> -				unittest_path(101, PDEV_OVERLAY));
> -		goto out;
> -	}
> +	KUNIT_ASSERT_TRUE_MSG(
> +		test, of_unittest_device_exists(100, PDEV_OVERLAY),
> +		"could not find unittest0 @ \"%s\"\n",
> +		unittest_path(100, PDEV_OVERLAY));
>  
> -	unittest(1, "basic infrastructure of overlays passed");
> +	KUNIT_ASSERT_FALSE_MSG(
> +		test, of_unittest_device_exists(101, PDEV_OVERLAY),
> +		"unittest1 @ \"%s\" should not exist\n",
> +		unittest_path(101, PDEV_OVERLAY));
>  
>  	/* tests in sequence */
> -	of_unittest_overlay_0();
> -	of_unittest_overlay_1();
> -	of_unittest_overlay_2();
> -	of_unittest_overlay_3();
> -	of_unittest_overlay_4();
> -	of_unittest_overlay_5();
> -	of_unittest_overlay_6();
> -	of_unittest_overlay_8();
> -
> -	of_unittest_overlay_10();
> -	of_unittest_overlay_11();
> +	of_unittest_overlay_0(test);
> +	of_unittest_overlay_1(test);
> +	of_unittest_overlay_2(test);
> +	of_unittest_overlay_3(test);
> +	of_unittest_overlay_4(test);
> +	of_unittest_overlay_5(test);
> +	of_unittest_overlay_6(test);
> +	of_unittest_overlay_8(test);
> +
> +	of_unittest_overlay_10(test);
> +	of_unittest_overlay_11(test);
>  
>  #if IS_BUILTIN(CONFIG_I2C)
> -	if (unittest(of_unittest_overlay_i2c_init() == 0, "i2c init failed\n"))
> -		goto out;
> +	KUNIT_ASSERT_EQ_MSG(test, of_unittest_overlay_i2c_init(test), 0,
> +			    "i2c init failed\n");
> +	goto out;
>  
> -	of_unittest_overlay_i2c_12();
> -	of_unittest_overlay_i2c_13();
> -	of_unittest_overlay_i2c_14();
> -	of_unittest_overlay_i2c_15();
> +	of_unittest_overlay_i2c_12(test);
> +	of_unittest_overlay_i2c_13(test);
> +	of_unittest_overlay_i2c_14(test);
> +	of_unittest_overlay_i2c_15(test);
>  
>  	of_unittest_overlay_i2c_cleanup();
>  #endif
> @@ -2152,7 +2184,7 @@ static void __init of_unittest_overlay(void)
>  }
>  
>  #else
> -static inline void __init of_unittest_overlay(void) { }
> +static inline void of_unittest_overlay(struct kunit *test) { }
>  #endif
>  
>  #ifdef CONFIG_OF_OVERLAY
> @@ -2313,7 +2345,7 @@ void __init unittest_unflatten_overlay_base(void)
>   *
>   * Return 0 on unexpected error.
>   */
> -static int __init overlay_data_apply(const char *overlay_name, int *overlay_id)
> +static int overlay_data_apply(const char *overlay_name, int *overlay_id)
>  {
>  	struct overlay_info *info;
>  	int found = 0;
> @@ -2359,19 +2391,17 @@ static int __init overlay_data_apply(const char *overlay_name, int *overlay_id)
>   * The first part of the function is _not_ normal overlay usage; it is
>   * finishing splicing the base overlay device tree into the live tree.
>   */
> -static __init void of_unittest_overlay_high_level(void)
> +static void of_unittest_overlay_high_level(struct kunit *test)
>  {
>  	struct device_node *last_sibling;
>  	struct device_node *np;
>  	struct device_node *of_symbols;
> -	struct device_node *overlay_base_symbols;
> +	struct device_node *overlay_base_symbols = 0;
>  	struct device_node **pprev;
>  	struct property *prop;
>  
> -	if (!overlay_base_root) {
> -		unittest(0, "overlay_base_root not initialized\n");
> -		return;
> -	}
> +	KUNIT_ASSERT_TRUE_MSG(test, overlay_base_root,
> +			      "overlay_base_root not initialized\n");
>  
>  	/*
>  	 * Could not fixup phandles in unittest_unflatten_overlay_base()
> @@ -2418,11 +2448,9 @@ static __init void of_unittest_overlay_high_level(void)
>  	for_each_child_of_node(overlay_base_root, np) {
>  		struct device_node *base_child;
>  		for_each_child_of_node(of_root, base_child) {
> -			if (!strcmp(np->full_name, base_child->full_name)) {
> -				unittest(0, "illegal node name in overlay_base %pOFn",
> -					 np);
> -				return;
> -			}
> +			KUNIT_ASSERT_STRNEQ_MSG(
> +				test, np->full_name, base_child->full_name,
> +				"illegal node name in overlay_base %pOFn", np);
>  		}
>  	}
>  
> @@ -2456,21 +2484,24 @@ static __init void of_unittest_overlay_high_level(void)
>  
>  			new_prop = __of_prop_dup(prop, GFP_KERNEL);
>  			if (!new_prop) {
> -				unittest(0, "__of_prop_dup() of '%s' from overlay_base node __symbols__",
> -					 prop->name);
> +				KUNIT_FAIL(test,
> +					   "__of_prop_dup() of '%s' from overlay_base node __symbols__",
> +					   prop->name);
>  				goto err_unlock;
>  			}
>  			if (__of_add_property(of_symbols, new_prop)) {
>  				/* "name" auto-generated by unflatten */
>  				if (!strcmp(new_prop->name, "name"))
>  					continue;
> -				unittest(0, "duplicate property '%s' in overlay_base node __symbols__",
> -					 prop->name);
> +				KUNIT_FAIL(test,
> +					   "duplicate property '%s' in overlay_base node __symbols__",
> +					   prop->name);
>  				goto err_unlock;
>  			}
>  			if (__of_add_property_sysfs(of_symbols, new_prop)) {
> -				unittest(0, "unable to add property '%s' in overlay_base node __symbols__ to sysfs",
> -					 prop->name);
> +				KUNIT_FAIL(test,
> +					   "unable to add property '%s' in overlay_base node __symbols__ to sysfs",
> +					   prop->name);
>  				goto err_unlock;
>  			}
>  		}
> @@ -2481,20 +2512,24 @@ static __init void of_unittest_overlay_high_level(void)
>  
>  	/* now do the normal overlay usage test */
>  
> -	unittest(overlay_data_apply("overlay", NULL),
> -		 "Adding overlay 'overlay' failed\n");
> +	KUNIT_EXPECT_TRUE_MSG(test, overlay_data_apply("overlay", NULL),
> +			      "Adding overlay 'overlay' failed\n");
>  
> -	unittest(overlay_data_apply("overlay_bad_add_dup_node", NULL),
> -		 "Adding overlay 'overlay_bad_add_dup_node' failed\n");
> +	KUNIT_EXPECT_TRUE_MSG(
> +		test, overlay_data_apply("overlay_bad_add_dup_node", NULL),
> +		"Adding overlay 'overlay_bad_add_dup_node' failed\n");
>  
> -	unittest(overlay_data_apply("overlay_bad_add_dup_prop", NULL),
> -		 "Adding overlay 'overlay_bad_add_dup_prop' failed\n");
> +	KUNIT_EXPECT_TRUE_MSG(
> +		test, overlay_data_apply("overlay_bad_add_dup_prop", NULL),
> +		"Adding overlay 'overlay_bad_add_dup_prop' failed\n");
>  
> -	unittest(overlay_data_apply("overlay_bad_phandle", NULL),
> -		 "Adding overlay 'overlay_bad_phandle' failed\n");
> +	KUNIT_EXPECT_TRUE_MSG(
> +		test, overlay_data_apply("overlay_bad_phandle", NULL),
> +		"Adding overlay 'overlay_bad_phandle' failed\n");
>  
> -	unittest(overlay_data_apply("overlay_bad_symbol", NULL),
> -		 "Adding overlay 'overlay_bad_symbol' failed\n");
> +	KUNIT_EXPECT_TRUE_MSG(
> +		test, overlay_data_apply("overlay_bad_symbol", NULL),
> +		"Adding overlay 'overlay_bad_symbol' failed\n");
>  
>  	return;
>  
> @@ -2504,57 +2539,52 @@ static __init void of_unittest_overlay_high_level(void)
>  
>  #else
>  
> -static inline __init void of_unittest_overlay_high_level(void) {}
> +static inline void of_unittest_overlay_high_level(struct kunit *test) {}
>  
>  #endif
>  
> -static int __init of_unittest(void)
> +static int of_test_init(struct kunit *test)
>  {
> -	struct device_node *np;
> -	int res;
> -
>  	/* adding data for unittest */
> -	res = unittest_data_add();
> -	if (res)
> -		return res;
> +	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
> +
>  	if (!of_aliases)
>  		of_aliases = of_find_node_by_path("/aliases");
>  
> -	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
> -	if (!np) {
> -		pr_info("No testcase data in device tree; not running tests\n");
> -		return 0;
> -	}
> -	of_node_put(np);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
> +		"/testcase-data/phandle-tests/consumer-a"));
>  
>  	if (IS_ENABLED(CONFIG_UML))
>  		unflatten_device_tree();
>  
> -	pr_info("start of unittest - you will see error messages\n");
> -	of_unittest_check_tree_linkage();
> -	of_unittest_check_phandles();
> -	of_unittest_find_node_by_name();
> -	of_unittest_dynamic();
> -	of_unittest_parse_phandle_with_args();
> -	of_unittest_parse_phandle_with_args_map();
> -	of_unittest_printf();
> -	of_unittest_property_string();
> -	of_unittest_property_copy();
> -	of_unittest_changeset();
> -	of_unittest_parse_interrupts();
> -	of_unittest_parse_interrupts_extended();
> -	of_unittest_match_node();
> -	of_unittest_platform_populate();
> -	of_unittest_overlay();
> +	return 0;
> +}
>  
> +static struct kunit_case of_test_cases[] = {
> +	KUNIT_CASE(of_unittest_check_tree_linkage),
> +	KUNIT_CASE(of_unittest_check_phandles),
> +	KUNIT_CASE(of_unittest_find_node_by_name),
> +	KUNIT_CASE(of_unittest_dynamic),
> +	KUNIT_CASE(of_unittest_parse_phandle_with_args),
> +	KUNIT_CASE(of_unittest_parse_phandle_with_args_map),
> +	KUNIT_CASE(of_unittest_printf),
> +	KUNIT_CASE(of_unittest_property_string),
> +	KUNIT_CASE(of_unittest_property_copy),
> +	KUNIT_CASE(of_unittest_changeset),
> +	KUNIT_CASE(of_unittest_parse_interrupts),
> +	KUNIT_CASE(of_unittest_parse_interrupts_extended),
> +	KUNIT_CASE(of_unittest_match_node),
> +	KUNIT_CASE(of_unittest_platform_populate),
> +	KUNIT_CASE(of_unittest_overlay),
>  	/* Double check linkage after removing testcase data */
> -	of_unittest_check_tree_linkage();
> -
> -	of_unittest_overlay_high_level();
> -
> -	pr_info("end of unittest - %i passed, %i failed\n",
> -		unittest_results.passed, unittest_results.failed);
> +	KUNIT_CASE(of_unittest_check_tree_linkage),
> +	KUNIT_CASE(of_unittest_overlay_high_level),
> +	{},
> +};
>  
> -	return 0;
> -}
> -late_initcall(of_unittest);
> +static struct kunit_module of_test_module = {
> +	.name = "of-test",
> +	.init = of_test_init,
> +	.test_cases = of_test_cases,
> +};
> +module_test(of_test_module);
> 
