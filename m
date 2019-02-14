From: Brendan Higgins <brendanhiggins@google.com>
Subject: [RFC v4 16/17] of: unittest: split out a couple of test cases from unittest
Date: Thu, 14 Feb 2019 13:37:28 -0800
Message-ID: <20190214213729.21702-17-brendanhiggins@google.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214213729.21702-1-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: keescook@google.com, mcgrof@kernel.org, shuah@kernel.org, robh@kernel.org, kieran.bingham@ideasonboard.com, frowand.list@gmail.com
Cc: gregkh@linuxfoundation.org, joel@jms.id.au, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, julia.lawall@lip6.fr, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, knut.omang@oracle.com, devicetree@vger.kernel.org, pmladek@suse.com, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, wfg@linux.intel.com, Brendan Higgins <brendanhiggins@google.com>
List-Id: linux-nvdimm@lists.01.org

Split out a couple of test cases that these features in base.c from the
unittest.c monolith. The intention is that we will eventually split out
all test cases and group them together based on what portion of device
tree they test.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
---
 drivers/of/Makefile      |   2 +-
 drivers/of/base-test.c   | 214 ++++++++++++++++++++++++
 drivers/of/test-common.c | 175 ++++++++++++++++++++
 drivers/of/test-common.h |  16 ++
 drivers/of/unittest.c    | 345 +--------------------------------------
 5 files changed, 407 insertions(+), 345 deletions(-)
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
index 0000000000000..3d3f4f1b74800
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
+	KUNIT_EXPECT_STREQ_MSG(
+		test, "/testcase-data/phandle-tests/consumer-a", name,
+		"find /testcase-data/phandle-tests/consumer-a failed\n");
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
+	KUNIT_EXPECT_STREQ_MSG(
+		test, "/testcase-data/phandle-tests/consumer-a", name,
+		"find testcase-alias/phandle-tests/consumer-a failed\n");
+	of_node_put(np);
+	kfree(name);
+
+	KUNIT_EXPECT_EQ_MSG(
+		test,
+		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
+		"non-existent path returned node %pOF\n", np);
+	of_node_put(np);
+
+	KUNIT_EXPECT_EQ_MSG(
+		test, np = of_find_node_by_path("missing-alias"), NULL,
+		"non-existent alias returned node %pOF\n", np);
+	of_node_put(np);
+
+	KUNIT_EXPECT_EQ_MSG(
+		test,
+		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
+		"non-existent alias with relative path returned node %pOF\n",
+		np);
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
+	np = of_find_node_opts_by_path("/testcase-data/testcase-device1:test/option", &options);
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
+	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
+			test, np, "NULL option alias path test failed\n");
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
+	KUNIT_EXPECT_EQ_MSG(
+		test, of_update_property(np, prop), 0,
+		"Updating an existing property should have passed\n");
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
index 0000000000000..4c9a5f3b82f7d
--- /dev/null
+++ b/drivers/of/test-common.c
@@ -0,0 +1,175 @@
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
+ *	@np:	node whose properties are being added to the live tree
+ *	@dup:	node present in live tree to be updated
+ */
+static void update_node_properties(struct device_node *np,
+					struct device_node *dup)
+{
+	struct property *prop;
+	struct property *save_next;
+	struct device_node *child;
+	int ret;
+
+	for_each_child_of_node(np, child)
+		child->parent = dup;
+
+	/*
+	 * "unittest internal error: unable to add testdata property"
+	 *
+	 *    If this message reports a property in node '/__symbols__' then
+	 *    the respective unittest overlay contains a label that has the
+	 *    same name as a label in the live devicetree.  The label will
+	 *    be in the live devicetree only if the devicetree source was
+	 *    compiled with the '-@' option.  If you encounter this error,
+	 *    please consider renaming __all__ of the labels in the unittest
+	 *    overlay dts files with an odd prefix that is unlikely to be
+	 *    used in a real devicetree.
+	 */
+
+	/*
+	 * open code for_each_property_of_node() because of_add_property()
+	 * sets prop->next to NULL
+	 */
+	for (prop = np->properties; prop != NULL; prop = save_next) {
+		save_next = prop->next;
+		ret = of_add_property(dup, prop);
+		if (ret)
+			pr_err("unittest internal error: unable to add testdata property %pOF/%s",
+			       np, prop->name);
+	}
+}
+
+/**
+ *	attach_node_and_children - attaches nodes
+ *	and its children to live tree
+ *
+ *	@np:	Node to attach to live tree
+ */
+static void attach_node_and_children(struct device_node *np)
+{
+	struct device_node *next, *dup, *child;
+	unsigned long flags;
+	const char *full_name;
+
+	full_name = kasprintf(GFP_KERNEL, "%pOF", np);
+
+	if (!strcmp(full_name, "/__local_fixups__") ||
+	    !strcmp(full_name, "/__fixups__"))
+		return;
+
+	dup = of_find_node_by_path(full_name);
+	kfree(full_name);
+	if (dup) {
+		update_node_properties(np, dup);
+		return;
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
+		pr_err("%s: Failed to resolve phandles (rc=%i)\n", __func__, rc);
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
index 96de69ccb3e63..05a2610d0be7f 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -29,184 +29,7 @@
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
-	KUNIT_EXPECT_STREQ_MSG(
-		test, "/testcase-data/phandle-tests/consumer-a", name,
-		"find /testcase-data/phandle-tests/consumer-a failed\n");
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
-	KUNIT_EXPECT_STREQ_MSG(
-		test, "/testcase-data/phandle-tests/consumer-a", name,
-		"find testcase-alias/phandle-tests/consumer-a failed\n");
-	of_node_put(np);
-	kfree(name);
-
-	KUNIT_EXPECT_EQ_MSG(
-		test,
-		np = of_find_node_by_path("/testcase-data/missing-path"), NULL,
-		"non-existent path returned node %pOF\n", np);
-	of_node_put(np);
-
-	KUNIT_EXPECT_EQ_MSG(
-		test, np = of_find_node_by_path("missing-alias"), NULL,
-		"non-existent alias returned node %pOF\n", np);
-	of_node_put(np);
-
-	KUNIT_EXPECT_EQ_MSG(
-		test,
-		np = of_find_node_by_path("testcase-alias/missing-path"), NULL,
-		"non-existent alias with relative path returned node %pOF\n",
-		np);
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
-	KUNIT_EXPECT_NOT_ERR_OR_NULL_MSG(
-			test, np, "NULL option alias path test failed\n");
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
-	KUNIT_EXPECT_EQ_MSG(
-		test, of_update_property(np, prop), 0,
-		"Updating an existing property should have passed\n");
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
@@ -1177,170 +1000,6 @@ static void of_unittest_platform_populate(struct kunit *test)
 	of_node_put(np);
 }
 
-/**
- *	update_node_properties - adds the properties
- *	of np into dup node (present in live tree) and
- *	updates parent of children of np to dup.
- *
- *	@np:	node whose properties are being added to the live tree
- *	@dup:	node present in live tree to be updated
- */
-static void update_node_properties(struct device_node *np,
-					struct device_node *dup)
-{
-	struct property *prop;
-	struct property *save_next;
-	struct device_node *child;
-	int ret;
-
-	for_each_child_of_node(np, child)
-		child->parent = dup;
-
-	/*
-	 * "unittest internal error: unable to add testdata property"
-	 *
-	 *    If this message reports a property in node '/__symbols__' then
-	 *    the respective unittest overlay contains a label that has the
-	 *    same name as a label in the live devicetree.  The label will
-	 *    be in the live devicetree only if the devicetree source was
-	 *    compiled with the '-@' option.  If you encounter this error,
-	 *    please consider renaming __all__ of the labels in the unittest
-	 *    overlay dts files with an odd prefix that is unlikely to be
-	 *    used in a real devicetree.
-	 */
-
-	/*
-	 * open code for_each_property_of_node() because of_add_property()
-	 * sets prop->next to NULL
-	 */
-	for (prop = np->properties; prop != NULL; prop = save_next) {
-		save_next = prop->next;
-		ret = of_add_property(dup, prop);
-		if (ret)
-			pr_err("unittest internal error: unable to add testdata property %pOF/%s",
-			       np, prop->name);
-	}
-}
-
-/**
- *	attach_node_and_children - attaches nodes
- *	and its children to live tree
- *
- *	@np:	Node to attach to live tree
- */
-static void attach_node_and_children(struct device_node *np)
-{
-	struct device_node *next, *dup, *child;
-	unsigned long flags;
-	const char *full_name;
-
-	full_name = kasprintf(GFP_KERNEL, "%pOF", np);
-
-	if (!strcmp(full_name, "/__local_fixups__") ||
-	    !strcmp(full_name, "/__fixups__"))
-		return;
-
-	dup = of_find_node_by_path(full_name);
-	kfree(full_name);
-	if (dup) {
-		update_node_properties(np, dup);
-		return;
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
 
@@ -2563,8 +2222,6 @@ static int of_test_init(struct kunit *test)
 static struct kunit_case of_test_cases[] = {
 	KUNIT_CASE(of_unittest_check_tree_linkage),
 	KUNIT_CASE(of_unittest_check_phandles),
-	KUNIT_CASE(of_unittest_find_node_by_name),
-	KUNIT_CASE(of_unittest_dynamic),
 	KUNIT_CASE(of_unittest_parse_phandle_with_args),
 	KUNIT_CASE(of_unittest_parse_phandle_with_args_map),
 	KUNIT_CASE(of_unittest_printf),
-- 
2.21.0.rc0.258.g878e2cd30e-goog
