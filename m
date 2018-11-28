From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 19/19] of: unittest: split up some super large test cases
Date: Wed, 28 Nov 2018 11:36:36 -0800
Message-ID: <20181128193636.254378-20-brendanhiggins@google.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181128193636.254378-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Split up the super large test cases of_unittest_find_node_by_name and
of_unittest_dynamic into properly sized and defined test cases.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/of/base-test.c | 315 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 260 insertions(+), 55 deletions(-)

diff --git a/drivers/of/base-test.c b/drivers/of/base-test.c
index 5731787a3fca8..46c3dd9ce6628 100644
--- a/drivers/of/base-test.c
+++ b/drivers/of/base-test.c
@@ -8,10 +8,10 @@
 
 #include "test-common.h"
 
-static void of_unittest_find_node_by_name(struct kunit *test)
+static void of_test_find_node_by_name_basic(struct kunit *test)
 {
 	struct device_node *np;
-	const char *options, *name;
+	const char *name;
 
 	np = of_find_node_by_path("/testcase-data");
 	name = kasprintf(GFP_KERNEL, "%pOF", np);
@@ -20,11 +20,21 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 			       "find /testcase-data failed\n");
 	of_node_put(np);
 	kfree(name);
+}
 
+static void of_test_find_node_by_name_trailing_slash(struct kunit *test)
+{
 	/* Test if trailing '/' works */
 	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
 			    "trailing '/' on /testcase-data/ should fail\n");
 
+}
+
+static void of_test_find_node_by_name_multiple_components(struct kunit *test)
+{
+	struct device_node *np;
+	const char *name;
+
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
 	name = kasprintf(GFP_KERNEL, "%pOF", np);
@@ -33,6 +43,12 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 			       "find /testcase-data/phandle-tests/consumer-a failed\n");
 	of_node_put(np);
 	kfree(name);
+}
+
+static void of_test_find_node_by_name_with_alias(struct kunit *test)
+{
+	struct device_node *np;
+	const char *name;
 
 	np = of_find_node_by_path("testcase-alias");
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
@@ -41,10 +57,23 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 			       "find testcase-alias failed\n");
 	of_node_put(np);
 	kfree(name);
+}
 
+static void of_test_find_node_by_name_with_alias_and_slash(struct kunit *test)
+{
 	/* Test if trailing '/' works on aliases */
 	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
-			    "trailing '/' on testcase-alias/ should fail\n");
+			   "trailing '/' on testcase-alias/ should fail\n");
+}
+
+/*
+ * TODO(brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org): This looks like a duplicate of
+ * of_test_find_node_by_name_multiple_components
+ */
+static void of_test_find_node_by_name_multiple_components_2(struct kunit *test)
+{
+	struct device_node *np;
+	const char *name;
 
 	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
@@ -54,29 +83,60 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 			       "find testcase-alias/phandle-tests/consumer-a failed\n");
 	of_node_put(np);
 	kfree(name);
+}
+
+static void of_test_find_node_by_name_missing_path(struct kunit *test)
+{
+	struct device_node *np;
 
 	KUNIT_EXPECT_EQ_MSG(test,
-			    of_find_node_by_path("/testcase-data/missing-path"),
+			    np = of_find_node_by_path(
+					    "/testcase-data/missing-path"),
 			    NULL,
-			    "non-existent path returned node %pOF\n", np);
+			   "non-existent path returned node %pOF\n", np);
 	of_node_put(np);
+}
 
-	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("missing-alias"), NULL,
-			    "non-existent alias returned node %pOF\n", np);
+static void of_test_find_node_by_name_missing_alias(struct kunit *test)
+{
+	struct device_node *np;
+
+	KUNIT_EXPECT_EQ_MSG(test,
+			    np = of_find_node_by_path("missing-alias"), NULL,
+			   "non-existent alias returned node %pOF\n", np);
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_missing_alias_with_relative_path(
+		struct kunit *test)
+{
+	struct device_node *np;
 
 	KUNIT_EXPECT_EQ_MSG(test,
-			    of_find_node_by_path("testcase-alias/missing-path"),
+			    np = of_find_node_by_path(
+					    "testcase-alias/missing-path"),
 			    NULL,
-			    "non-existent alias with relative path returned node %pOF\n",
-			    np);
+			   "non-existent alias with relative path returned node %pOF\n",
+			   np);
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_with_option(struct kunit *test)
+{
+	struct device_node *np;
+	const char *options;
 
 	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
 	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
 			       "option path test failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_with_option_and_slash(struct kunit *test)
+{
+	struct device_node *np;
+	const char *options;
 
 	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
@@ -91,11 +151,22 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
 			       "option path test, subcase #2 failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_with_null_option(struct kunit *test)
+{
+	struct device_node *np;
 
 	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
 	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
 					 "NULL option path test failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_with_option_alias(struct kunit *test)
+{
+	struct device_node *np;
+	const char *options;
 
 	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
 				       &options);
@@ -103,6 +174,13 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
 			       "option alias path test failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_with_option_alias_and_slash(
+		struct kunit *test)
+{
+	struct device_node *np;
+	const char *options;
 
 	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
 				       &options);
@@ -110,11 +188,22 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
 			       "option alias path test, subcase #1 failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_with_null_option_alias(struct kunit *test)
+{
+	struct device_node *np;
 
 	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
-	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
-					 "NULL option alias path test failed\n");
+	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
+			test, np, "NULL option alias path test failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_option_clearing(struct kunit *test)
+{
+	struct device_node *np;
+	const char *options;
 
 	options = "testoption";
 	np = of_find_node_opts_by_path("testcase-alias", &options);
@@ -122,6 +211,12 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
 			    "option clearing test failed\n");
 	of_node_put(np);
+}
+
+static void of_test_find_node_by_name_option_clearing_root(struct kunit *test)
+{
+	struct device_node *np;
+	const char *options;
 
 	options = "testoption";
 	np = of_find_node_opts_by_path("/", &options);
@@ -131,64 +226,147 @@ static void of_unittest_find_node_by_name(struct kunit *test)
 	of_node_put(np);
 }
 
-static void of_unittest_dynamic(struct kunit *test)
+static int of_test_find_node_by_name_init(struct kunit *test)
 {
+	/* adding data for unittest */
+	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
+
+	if (!of_aliases)
+		of_aliases = of_find_node_by_path("/aliases");
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
+			"/testcase-data/phandle-tests/consumer-a"));
+
+	return 0;
+}
+
+static struct kunit_case of_test_find_node_by_name_cases[] = {
+	KUNIT_CASE(of_test_find_node_by_name_basic),
+	KUNIT_CASE(of_test_find_node_by_name_trailing_slash),
+	KUNIT_CASE(of_test_find_node_by_name_multiple_components),
+	KUNIT_CASE(of_test_find_node_by_name_with_alias),
+	KUNIT_CASE(of_test_find_node_by_name_with_alias_and_slash),
+	KUNIT_CASE(of_test_find_node_by_name_multiple_components_2),
+	KUNIT_CASE(of_test_find_node_by_name_missing_path),
+	KUNIT_CASE(of_test_find_node_by_name_missing_alias),
+	KUNIT_CASE(of_test_find_node_by_name_missing_alias_with_relative_path),
+	KUNIT_CASE(of_test_find_node_by_name_with_option),
+	KUNIT_CASE(of_test_find_node_by_name_with_option_and_slash),
+	KUNIT_CASE(of_test_find_node_by_name_with_null_option),
+	KUNIT_CASE(of_test_find_node_by_name_with_option_alias),
+	KUNIT_CASE(of_test_find_node_by_name_with_option_alias_and_slash),
+	KUNIT_CASE(of_test_find_node_by_name_with_null_option_alias),
+	KUNIT_CASE(of_test_find_node_by_name_option_clearing),
+	KUNIT_CASE(of_test_find_node_by_name_option_clearing_root),
+	{},
+};
+
+static struct kunit_module of_test_find_node_by_name_module = {
+	.name = "of-test-find-node-by-name",
+	.init = of_test_find_node_by_name_init,
+	.test_cases = of_test_find_node_by_name_cases,
+};
+module_test(of_test_find_node_by_name_module);
+
+struct of_test_dynamic_context {
 	struct device_node *np;
-	struct property *prop;
+	struct property *prop0;
+	struct property *prop1;
+};
 
-	np = of_find_node_by_path("/testcase-data");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+static void of_test_dynamic_basic(struct kunit *test)
+{
+	struct of_test_dynamic_context *ctx = test->priv;
+	struct device_node *np = ctx->np;
+	struct property *prop0 = ctx->prop0;
 
-	/* Array of 4 properties for the purpose of testing */
-	prop = kcalloc(4, sizeof(*prop), GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop);
+	/* Add a new property - should pass*/
+	prop0->name = "new-property";
+	prop0->value = "new-property-data";
+	prop0->length = strlen(prop0->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
+			    "Adding a new property failed\n");
+
+	/* Test that we can remove a property */
+	KUNIT_EXPECT_EQ(test, of_remove_property(np, prop0), 0);
+}
+
+static void of_test_dynamic_add_existing_property(struct kunit *test)
+{
+	struct of_test_dynamic_context *ctx = test->priv;
+	struct device_node *np = ctx->np;
+	struct property *prop0 = ctx->prop0, *prop1 = ctx->prop1;
 
 	/* Add a new property - should pass*/
-	prop->name = "new-property";
-	prop->value = "new-property-data";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
+	prop0->name = "new-property";
+	prop0->value = "new-property-data";
+	prop0->length = strlen(prop0->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
 			    "Adding a new property failed\n");
 
 	/* Try to add an existing property - should fail */
-	prop++;
-	prop->name = "new-property";
-	prop->value = "new-property-data-should-fail";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop), 0,
+	prop1->name = "new-property";
+	prop1->value = "new-property-data-should-fail";
+	prop1->length = strlen(prop1->value) + 1;
+	KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop1), 0,
 			    "Adding an existing property should have failed\n");
+}
+
+static void of_test_dynamic_modify_existing_property(struct kunit *test)
+{
+	struct of_test_dynamic_context *ctx = test->priv;
+	struct device_node *np = ctx->np;
+	struct property *prop0 = ctx->prop0, *prop1 = ctx->prop1;
+
+	/* Add a new property - should pass*/
+	prop0->name = "new-property";
+	prop0->value = "new-property-data";
+	prop0->length = strlen(prop0->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
+			    "Adding a new property failed\n");
 
 	/* Try to modify an existing property - should pass */
-	prop->value = "modify-property-data-should-pass";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
+	prop1->name = "new-property";
+	prop1->value = "modify-property-data-should-pass";
+	prop1->length = strlen(prop1->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop1), 0,
 			    "Updating an existing property should have passed\n");
+}
+
+static void of_test_dynamic_modify_non_existent_property(struct kunit *test)
+{
+	struct of_test_dynamic_context *ctx = test->priv;
+	struct device_node *np = ctx->np;
+	struct property *prop0 = ctx->prop0;
 
 	/* Try to modify non-existent property - should pass*/
-	prop++;
-	prop->name = "modify-property";
-	prop->value = "modify-missing-property-data-should-pass";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
+	prop0->name = "modify-property";
+	prop0->value = "modify-missing-property-data-should-pass";
+	prop0->length = strlen(prop0->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop0), 0,
 			    "Updating a missing property should have passed\n");
+}
 
-	/* Remove property - should pass */
-	KUNIT_EXPECT_EQ_MSG(test, of_remove_property(np, prop), 0,
-			    "Removing a property should have passed\n");
+static void of_test_dynamic_large_property(struct kunit *test)
+{
+	struct of_test_dynamic_context *ctx = test->priv;
+	struct device_node *np = ctx->np;
+	struct property *prop0 = ctx->prop0;
 
 	/* Adding very large property - should pass */
-	prop++;
-	prop->name = "large-property-PAGE_SIZEx8";
-	prop->length = PAGE_SIZE * 8;
-	prop->value = kzalloc(prop->length, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop->value);
-	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
+	prop0->name = "large-property-PAGE_SIZEx8";
+	prop0->length = PAGE_SIZE * 8;
+	prop0->value = kunit_kzalloc(test, prop0->length, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop0->value);
+
+	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop0), 0,
 			    "Adding a large property should have passed\n");
 }
 
-static int of_test_init(struct kunit *test)
+static int of_test_dynamic_init(struct kunit *test)
 {
-	/* adding data for unittest */
+	struct of_test_dynamic_context *ctx;
+
 	KUNIT_ASSERT_EQ(test, 0, unittest_data_add());
 
 	if (!of_aliases)
@@ -197,18 +375,45 @@ static int of_test_init(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, of_find_node_by_path(
 			"/testcase-data/phandle-tests/consumer-a"));
 
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+	test->priv = ctx;
+
+	ctx->np = of_find_node_by_path("/testcase-data");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->np);
+
+	ctx->prop0 = kunit_kzalloc(test, sizeof(*ctx->prop0), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->prop0);
+
+	ctx->prop1 = kunit_kzalloc(test, sizeof(*ctx->prop1), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->prop1);
+
 	return 0;
 }
 
-static struct kunit_case of_test_cases[] = {
-	KUNIT_CASE(of_unittest_find_node_by_name),
-	KUNIT_CASE(of_unittest_dynamic),
+static void of_test_dynamic_exit(struct kunit *test)
+{
+	struct of_test_dynamic_context *ctx = test->priv;
+	struct device_node *np = ctx->np;
+
+	of_remove_property(np, ctx->prop0);
+	of_remove_property(np, ctx->prop1);
+	of_node_put(np);
+}
+
+static struct kunit_case of_test_dynamic_cases[] = {
+	KUNIT_CASE(of_test_dynamic_basic),
+	KUNIT_CASE(of_test_dynamic_add_existing_property),
+	KUNIT_CASE(of_test_dynamic_modify_existing_property),
+	KUNIT_CASE(of_test_dynamic_modify_non_existent_property),
+	KUNIT_CASE(of_test_dynamic_large_property),
 	{},
 };
 
-static struct kunit_module of_test_module = {
-	.name = "of-base-test",
-	.init = of_test_init,
-	.test_cases = of_test_cases,
+static struct kunit_module of_test_dynamic_module = {
+	.name = "of-dynamic-test",
+	.init = of_test_dynamic_init,
+	.exit = of_test_dynamic_exit,
+	.test_cases = of_test_dynamic_cases,
 };
-module_test(of_test_module);
+module_test(of_test_dynamic_module);
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
