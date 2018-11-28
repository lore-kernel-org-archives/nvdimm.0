From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 18/19] of: unittest: split out a couple of test cases from
 unittest
Date: Wed, 28 Nov 2018 11:36:35 -0800
Message-ID: <20181128193636.254378-19-brendanhiggins@google.com>
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

Split out a couple of test cases that these features in base.c from the
unittest.c monolith. The intention is that we will eventually split out
all test cases and group them together based on what portion of device
tree they test.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/of/Makefile      |   2 +-
 drivers/of/base-test.c   | 214 ++++++++++++++++++++++++++
 drivers/of/test-common.c | 149 ++++++++++++++++++
 drivers/of/test-common.h |  16 ++
 drivers/of/unittest.c    | 316 +--------------------------------------
 5 files changed, 381 insertions(+), 316 deletions(-)
 create mode 100644 drivers/of/base-test.c
 create mode 100644 drivers/of/test-common.c
 create mode 100644 drivers/of/test-common.h

diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 663a4af0cccd5..4a4bd527d586c 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
-obj-$(CONFIG_OF_UNITTEST) += unittest.o
+obj-$(CONFIG_OF_UNITTEST) += unittest.o base-test.o test-common.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
diff --git a/drivers/of/base-test.c b/drivers/of/base-test.c
new file mode 100644
index 0000000000000..5731787a3fca8
--- /dev/null
+++ b/drivers/of/base-test.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Unit tests for functions defined in base.c.
+ */
+#include <linux/of.h>
+
+#include <kunit/test.h>
+
+#include "test-common.h"
+
+static void of_unittest_find_node_by_name(struct kunit *test)
+{
+	struct device_node *np;
+	const char *options, *name;
+
+	np = of_find_node_by_path("/testcase-data");
+	name = kasprintf(GFP_KERNEL, "%pOF", np);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
+			       "find /testcase-data failed\n");
+	of_node_put(np);
+	kfree(name);
+
+	/* Test if trailing '/' works */
+	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
+			    "trailing '/' on /testcase-data/ should fail\n");
+
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	name = kasprintf(GFP_KERNEL, "%pOF", np);
+	KUNIT_EXPECT_STREQ_MSG(test,
+			       "/testcase-data/phandle-tests/consumer-a", name,
+			       "find /testcase-data/phandle-tests/consumer-a failed\n");
+	of_node_put(np);
+	kfree(name);
+
+	np = of_find_node_by_path("testcase-alias");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	name = kasprintf(GFP_KERNEL, "%pOF", np);
+	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
+			       "find testcase-alias failed\n");
+	of_node_put(np);
+	kfree(name);
+
+	/* Test if trailing '/' works on aliases */
+	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
+			    "trailing '/' on testcase-alias/ should fail\n");
+
+	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	name = kasprintf(GFP_KERNEL, "%pOF", np);
+	KUNIT_EXPECT_STREQ_MSG(test,
+			       "/testcase-data/phandle-tests/consumer-a", name,
+			       "find testcase-alias/phandle-tests/consumer-a failed\n");
+	of_node_put(np);
+	kfree(name);
+
+	KUNIT_EXPECT_EQ_MSG(test,
+			    of_find_node_by_path("/testcase-data/missing-path"),
+			    NULL,
+			    "non-existent path returned node %pOF\n", np);
+	of_node_put(np);
+
+	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("missing-alias"), NULL,
+			    "non-existent alias returned node %pOF\n", np);
+	of_node_put(np);
+
+	KUNIT_EXPECT_EQ_MSG(test,
+			    of_find_node_by_path("testcase-alias/missing-path"),
+			    NULL,
+			    "non-existent alias with relative path returned node %pOF\n",
+			    np);
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
+			       "option path test failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
+			       "option path test, subcase #1 failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path(
+			"/testcase-data/testcase-device1:test/option",
+			&options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
+			       "option path test, subcase #2 failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
+					 "NULL option path test failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
+				       &options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
+			       "option alias path test failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
+				       &options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
+			       "option alias path test, subcase #1 failed\n");
+	of_node_put(np);
+
+	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
+					 "NULL option alias path test failed\n");
+	of_node_put(np);
+
+	options = "testoption";
+	np = of_find_node_opts_by_path("testcase-alias", &options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
+			    "option clearing test failed\n");
+	of_node_put(np);
+
+	options = "testoption";
+	np = of_find_node_opts_by_path("/", &options);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
+			    "option clearing root node test failed\n");
+	of_node_put(np);
+}
+
+static void of_unittest_dynamic(struct kunit *test)
+{
+	struct device_node *np;
+	struct property *prop;
+
+	np = of_find_node_by_path("/testcase-data");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
+
+	/* Array of 4 properties for the purpose of testing */
+	prop = kcalloc(4, sizeof(*prop), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop);
+
+	/* Add a new property - should pass*/
+	prop->name = "new-property";
+	prop->value = "new-property-data";
+	prop->length = strlen(prop->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
+			    "Adding a new property failed\n");
+
+	/* Try to add an existing property - should fail */
+	prop++;
+	prop->name = "new-property";
+	prop->value = "new-property-data-should-fail";
+	prop->length = strlen(prop->value) + 1;
+	KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop), 0,
+			    "Adding an existing property should have failed\n");
+
+	/* Try to modify an existing property - should pass */
+	prop->value = "modify-property-data-should-pass";
+	prop->length = strlen(prop->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
+			    "Updating an existing property should have passed\n");
+
+	/* Try to modify non-existent property - should pass*/
+	prop++;
+	prop->name = "modify-property";
+	prop->value = "modify-missing-property-data-should-pass";
+	prop->length = strlen(prop->value) + 1;
+	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
+			    "Updating a missing property should have passed\n");
+
+	/* Remove property - should pass */
+	KUNIT_EXPECT_EQ_MSG(test, of_remove_property(np, prop), 0,
+			    "Removing a property should have passed\n");
+
+	/* Adding very large property - should pass */
+	prop++;
+	prop->name = "large-property-PAGE_SIZEx8";
+	prop->length = PAGE_SIZE * 8;
+	prop->value = kzalloc(prop->length, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop->value);
+	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
+			    "Adding a large property should have passed\n");
+}
+
+static int of_test_init(struct kunit *test)
+{
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
+static struct kunit_case of_test_cases[] = {
+	KUNIT_CASE(of_unittest_find_node_by_name),
+	KUNIT_CASE(of_unittest_dynamic),
+	{},
+};
+
+static struct kunit_module of_test_module = {
+	.name = "of-base-test",
+	.init = of_test_init,
+	.test_cases = of_test_cases,
+};
+module_test(of_test_module);
diff --git a/drivers/of/test-common.c b/drivers/of/test-common.c
new file mode 100644
index 0000000000000..0b2319fde3b3e
--- /dev/null
+++ b/drivers/of/test-common.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common code to be used by unit tests.
+ */
+#include "test-common.h"
+
+#include <linux/of_fdt.h>
+#include <linux/slab.h>
+
+#include "of_private.h"
+
+/**
+ *	update_node_properties - adds the properties
+ *	of np into dup node (present in live tree) and
+ *	updates parent of children of np to dup.
+ *
+ *	@np:	node already present in live tree
+ *	@dup:	node present in live tree to be updated
+ */
+static void update_node_properties(struct device_node *np,
+					struct device_node *dup)
+{
+	struct property *prop;
+	struct device_node *child;
+
+	for_each_property_of_node(np, prop)
+		of_add_property(dup, prop);
+
+	for_each_child_of_node(np, child)
+		child->parent = dup;
+}
+
+/**
+ *	attach_node_and_children - attaches nodes
+ *	and its children to live tree
+ *
+ *	@np:	Node to attach to live tree
+ */
+static int attach_node_and_children(struct device_node *np)
+{
+	struct device_node *next, *dup, *child;
+	unsigned long flags;
+	const char *full_name;
+
+	full_name = kasprintf(GFP_KERNEL, "%pOF", np);
+	dup = of_find_node_by_path(full_name);
+	kfree(full_name);
+	if (dup) {
+		update_node_properties(np, dup);
+		return 0;
+	}
+
+	child = np->child;
+	np->child = NULL;
+
+	mutex_lock(&of_mutex);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
+	np->sibling = np->parent->child;
+	np->parent->child = np;
+	of_node_clear_flag(np, OF_DETACHED);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+
+	__of_attach_node_sysfs(np);
+	mutex_unlock(&of_mutex);
+
+	while (child) {
+		next = child->sibling;
+		attach_node_and_children(child);
+		child = next;
+	}
+
+	return 0;
+}
+
+/**
+ *	unittest_data_add - Reads, copies data from
+ *	linked tree and attaches it to the live tree
+ */
+int unittest_data_add(void)
+{
+	void *unittest_data;
+	struct device_node *unittest_data_node, *np;
+	/*
+	 * __dtb_testcases_begin[] and __dtb_testcases_end[] are magically
+	 * created by cmd_dt_S_dtb in scripts/Makefile.lib
+	 */
+	extern uint8_t __dtb_testcases_begin[];
+	extern uint8_t __dtb_testcases_end[];
+	const int size = __dtb_testcases_end - __dtb_testcases_begin;
+	int rc;
+
+	if (!size) {
+		pr_warn("%s: No testcase data to attach; not running tests\n",
+			__func__);
+		return -ENODATA;
+	}
+
+	/* creating copy */
+	unittest_data = kmemdup(__dtb_testcases_begin, size, GFP_KERNEL);
+
+	if (!unittest_data) {
+		pr_warn("%s: Failed to allocate memory for unittest_data; "
+			"not running tests\n", __func__);
+		return -ENOMEM;
+	}
+	of_fdt_unflatten_tree(unittest_data, NULL, &unittest_data_node);
+	if (!unittest_data_node) {
+		pr_warn("%s: No tree to attach; not running tests\n", __func__);
+		return -ENODATA;
+	}
+
+	/*
+	 * This lock normally encloses of_resolve_phandles()
+	 */
+	of_overlay_mutex_lock();
+
+	rc = of_resolve_phandles(unittest_data_node);
+	if (rc) {
+		pr_err("%s: Failed to resolve phandles (rc=%i)\n",
+		       __func__, rc);
+		of_overlay_mutex_unlock();
+		return -EINVAL;
+	}
+
+	if (!of_root) {
+		of_root = unittest_data_node;
+		for_each_of_allnodes(np)
+			__of_attach_node_sysfs(np);
+		of_aliases = of_find_node_by_path("/aliases");
+		of_chosen = of_find_node_by_path("/chosen");
+		of_overlay_mutex_unlock();
+		return 0;
+	}
+
+	/* attach the sub-tree to live tree */
+	np = unittest_data_node->child;
+	while (np) {
+		struct device_node *next = np->sibling;
+
+		np->parent = of_root;
+		attach_node_and_children(np);
+		np = next;
+	}
+
+	of_overlay_mutex_unlock();
+
+	return 0;
+}
+
diff --git a/drivers/of/test-common.h b/drivers/of/test-common.h
new file mode 100644
index 0000000000000..a35484406bbf1
--- /dev/null
+++ b/drivers/of/test-common.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Common code to be used by unit tests.
+ */
+#ifndef _LINUX_OF_TEST_COMMON_H
+#define _LINUX_OF_TEST_COMMON_H
+
+#include <linux/of.h>
+
+/**
+ *	unittest_data_add - Reads, copies data from
+ *	linked tree and attaches it to the live tree
+ */
+int unittest_data_add(void);
+
+#endif /* _LINUX_OF_TEST_COMMON_H */
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index a5ef44730ffdb..b8c220d330f03 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -29,182 +29,7 @@
 #include <kunit/test.h>
 
 #include "of_private.h"
-
-static void of_unittest_find_node_by_name(struct kunit *test)
-{
-	struct device_node *np;
-	const char *options, *name;
-
-	np = of_find_node_by_path("/testcase-data");
-	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
-			       "find /testcase-data failed\n");
-	of_node_put(np);
-	kfree(name);
-
-	/* Test if trailing '/' works */
-	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("/testcase-data/"), NULL,
-			    "trailing '/' on /testcase-data/ should fail\n");
-
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	KUNIT_EXPECT_STREQ_MSG(test,
-			       "/testcase-data/phandle-tests/consumer-a", name,
-			       "find /testcase-data/phandle-tests/consumer-a failed\n");
-	of_node_put(np);
-	kfree(name);
-
-	np = of_find_node_by_path("testcase-alias");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	KUNIT_EXPECT_STREQ_MSG(test, "/testcase-data", name,
-			       "find testcase-alias failed\n");
-	of_node_put(np);
-	kfree(name);
-
-	/* Test if trailing '/' works on aliases */
-	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("testcase-alias/"), NULL,
-			    "trailing '/' on testcase-alias/ should fail\n");
-
-	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	name = kasprintf(GFP_KERNEL, "%pOF", np);
-	KUNIT_EXPECT_STREQ_MSG(test,
-			       "/testcase-data/phandle-tests/consumer-a", name,
-			       "find testcase-alias/phandle-tests/consumer-a failed\n");
-	of_node_put(np);
-	kfree(name);
-
-	KUNIT_EXPECT_EQ_MSG(test,
-			    of_find_node_by_path("/testcase-data/missing-path"),
-			    NULL,
-			    "non-existent path returned node %pOF\n", np);
-	of_node_put(np);
-
-	KUNIT_EXPECT_EQ_MSG(test, of_find_node_by_path("missing-alias"), NULL,
-			    "non-existent alias returned node %pOF\n", np);
-	of_node_put(np);
-
-	KUNIT_EXPECT_EQ_MSG(test,
-			    of_find_node_by_path("testcase-alias/missing-path"),
-			    NULL,
-			    "non-existent alias with relative path returned node %pOF\n",
-			    np);
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("/testcase-data:testoption", &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_STREQ_MSG(test, "testoption", options,
-			       "option path test failed\n");
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("/testcase-data:test/option", &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
-			       "option path test, subcase #1 failed\n");
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_STREQ_MSG(test, "test/option", options,
-			       "option path test, subcase #2 failed\n");
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("/testcase-data:testoption", NULL);
-	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
-					 "NULL option path test failed\n");
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("testcase-alias:testaliasoption",
-				       &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_STREQ_MSG(test, "testaliasoption", options,
-			       "option alias path test failed\n");
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("testcase-alias:test/alias/option",
-				       &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_STREQ_MSG(test, "test/alias/option", options,
-			       "option alias path test, subcase #1 failed\n");
-	of_node_put(np);
-
-	np = of_find_node_opts_by_path("testcase-alias:testaliasoption", NULL);
-	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(test, np,
-					 "NULL option alias path test failed\n");
-	of_node_put(np);
-
-	options = "testoption";
-	np = of_find_node_opts_by_path("testcase-alias", &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
-			    "option clearing test failed\n");
-	of_node_put(np);
-
-	options = "testoption";
-	np = of_find_node_opts_by_path("/", &options);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-	KUNIT_EXPECT_EQ_MSG(test, options, NULL,
-			    "option clearing root node test failed\n");
-	of_node_put(np);
-}
-
-static void of_unittest_dynamic(struct kunit *test)
-{
-	struct device_node *np;
-	struct property *prop;
-
-	np = of_find_node_by_path("/testcase-data");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
-
-	/* Array of 4 properties for the purpose of testing */
-	prop = kcalloc(4, sizeof(*prop), GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop);
-
-	/* Add a new property - should pass*/
-	prop->name = "new-property";
-	prop->value = "new-property-data";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
-			    "Adding a new property failed\n");
-
-	/* Try to add an existing property - should fail */
-	prop++;
-	prop->name = "new-property";
-	prop->value = "new-property-data-should-fail";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_NE_MSG(test, of_add_property(np, prop), 0,
-			    "Adding an existing property should have failed\n");
-
-	/* Try to modify an existing property - should pass */
-	prop->value = "modify-property-data-should-pass";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
-			    "Updating an existing property should have passed\n");
-
-	/* Try to modify non-existent property - should pass*/
-	prop++;
-	prop->name = "modify-property";
-	prop->value = "modify-missing-property-data-should-pass";
-	prop->length = strlen(prop->value) + 1;
-	KUNIT_EXPECT_EQ_MSG(test, of_update_property(np, prop), 0,
-			    "Updating a missing property should have passed\n");
-
-	/* Remove property - should pass */
-	KUNIT_EXPECT_EQ_MSG(test, of_remove_property(np, prop), 0,
-			    "Removing a property should have passed\n");
-
-	/* Adding very large property - should pass */
-	prop++;
-	prop->name = "large-property-PAGE_SIZEx8";
-	prop->length = PAGE_SIZE * 8;
-	prop->value = kzalloc(prop->length, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, prop->value);
-	KUNIT_EXPECT_EQ_MSG(test, of_add_property(np, prop), 0,
-			    "Adding a large property should have passed\n");
-}
+#include "test-common.h"
 
 static int of_unittest_check_node_linkage(struct device_node *np)
 {
@@ -1200,143 +1025,6 @@ static void of_unittest_platform_populate(struct kunit *test)
 	of_node_put(np);
 }
 
-/**
- *	update_node_properties - adds the properties
- *	of np into dup node (present in live tree) and
- *	updates parent of children of np to dup.
- *
- *	@np:	node already present in live tree
- *	@dup:	node present in live tree to be updated
- */
-static void update_node_properties(struct device_node *np,
-					struct device_node *dup)
-{
-	struct property *prop;
-	struct device_node *child;
-
-	for_each_property_of_node(np, prop)
-		of_add_property(dup, prop);
-
-	for_each_child_of_node(np, child)
-		child->parent = dup;
-}
-
-/**
- *	attach_node_and_children - attaches nodes
- *	and its children to live tree
- *
- *	@np:	Node to attach to live tree
- */
-static int attach_node_and_children(struct device_node *np)
-{
-	struct device_node *next, *dup, *child;
-	unsigned long flags;
-	const char *full_name;
-
-	full_name = kasprintf(GFP_KERNEL, "%pOF", np);
-	dup = of_find_node_by_path(full_name);
-	kfree(full_name);
-	if (dup) {
-		update_node_properties(np, dup);
-		return 0;
-	}
-
-	child = np->child;
-	np->child = NULL;
-
-	mutex_lock(&of_mutex);
-	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np->sibling = np->parent->child;
-	np->parent->child = np;
-	of_node_clear_flag(np, OF_DETACHED);
-	raw_spin_unlock_irqrestore(&devtree_lock, flags);
-
-	__of_attach_node_sysfs(np);
-	mutex_unlock(&of_mutex);
-
-	while (child) {
-		next = child->sibling;
-		attach_node_and_children(child);
-		child = next;
-	}
-
-	return 0;
-}
-
-/**
- *	unittest_data_add - Reads, copies data from
- *	linked tree and attaches it to the live tree
- */
-static int unittest_data_add(void)
-{
-	void *unittest_data;
-	struct device_node *unittest_data_node, *np;
-	/*
-	 * __dtb_testcases_begin[] and __dtb_testcases_end[] are magically
-	 * created by cmd_dt_S_dtb in scripts/Makefile.lib
-	 */
-	extern uint8_t __dtb_testcases_begin[];
-	extern uint8_t __dtb_testcases_end[];
-	const int size = __dtb_testcases_end - __dtb_testcases_begin;
-	int rc;
-
-	if (!size) {
-		pr_warn("%s: No testcase data to attach; not running tests\n",
-			__func__);
-		return -ENODATA;
-	}
-
-	/* creating copy */
-	unittest_data = kmemdup(__dtb_testcases_begin, size, GFP_KERNEL);
-
-	if (!unittest_data) {
-		pr_warn("%s: Failed to allocate memory for unittest_data; "
-			"not running tests\n", __func__);
-		return -ENOMEM;
-	}
-	of_fdt_unflatten_tree(unittest_data, NULL, &unittest_data_node);
-	if (!unittest_data_node) {
-		pr_warn("%s: No tree to attach; not running tests\n", __func__);
-		return -ENODATA;
-	}
-
-	/*
-	 * This lock normally encloses of_resolve_phandles()
-	 */
-	of_overlay_mutex_lock();
-
-	rc = of_resolve_phandles(unittest_data_node);
-	if (rc) {
-		pr_err("%s: Failed to resolve phandles (rc=%i)\n", __func__, rc);
-		of_overlay_mutex_unlock();
-		return -EINVAL;
-	}
-
-	if (!of_root) {
-		of_root = unittest_data_node;
-		for_each_of_allnodes(np)
-			__of_attach_node_sysfs(np);
-		of_aliases = of_find_node_by_path("/aliases");
-		of_chosen = of_find_node_by_path("/chosen");
-		of_overlay_mutex_unlock();
-		return 0;
-	}
-
-	/* attach the sub-tree to live tree */
-	np = unittest_data_node->child;
-	while (np) {
-		struct device_node *next = np->sibling;
-
-		np->parent = of_root;
-		attach_node_and_children(np);
-		np = next;
-	}
-
-	of_overlay_mutex_unlock();
-
-	return 0;
-}
-
 #ifdef CONFIG_OF_OVERLAY
 static int overlay_data_apply(const char *overlay_name, int *overlay_id);
 
@@ -2560,8 +2248,6 @@ static int of_test_init(struct kunit *test)
 static struct kunit_case of_test_cases[] = {
 	KUNIT_CASE(of_unittest_check_tree_linkage),
 	KUNIT_CASE(of_unittest_check_phandles),
-	KUNIT_CASE(of_unittest_find_node_by_name),
-	KUNIT_CASE(of_unittest_dynamic),
 	KUNIT_CASE(of_unittest_parse_phandle_with_args),
 	KUNIT_CASE(of_unittest_parse_phandle_with_args_map),
 	KUNIT_CASE(of_unittest_printf),
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
