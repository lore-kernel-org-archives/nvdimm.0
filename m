From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 07/14] kunit: test: add initial tests
Date: Tue, 23 Oct 2018 16:57:43 -0700
Message-ID: <20181023235750.103146-8-brendanhiggins@google.com>
References: <20181023235750.103146-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181023235750.103146-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
Cc: brakmo-b10kYP2dOMg@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Add a test for string stream along with a simpler example.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kunit/Kconfig              | 12 ++++++
 kunit/Makefile             |  4 +-
 kunit/example-test.c       | 88 ++++++++++++++++++++++++++++++++++++++
 kunit/string-stream-test.c | 61 ++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 1 deletion(-)
 create mode 100644 kunit/example-test.c
 create mode 100644 kunit/string-stream-test.c

diff --git a/kunit/Kconfig b/kunit/Kconfig
index 49b44c4f6630a..c3dc7bca83f9d 100644
--- a/kunit/Kconfig
+++ b/kunit/Kconfig
@@ -14,4 +14,16 @@ config KUNIT
 	  special hardware. For more information, please see
 	  Documentation/kunit/
 
+config KUNIT_TEST
+	bool "KUnit test for KUnit"
+	depends on KUNIT
+	help
+	  Enables KUnit test to test KUnit.
+
+config KUNIT_EXAMPLE_TEST
+	bool "Example test for KUnit"
+	depends on KUNIT
+	help
+	  Enables example KUnit test to demo features of KUnit.
+
 endmenu
diff --git a/kunit/Makefile b/kunit/Makefile
index 5b4562ea7f322..b437bd546ab70 100644
--- a/kunit/Makefile
+++ b/kunit/Makefile
@@ -1 +1,3 @@
-obj-$(CONFIG_KUNIT)		+= test.o string-stream.o test-stream.o
+obj-$(CONFIG_KUNIT)			+= test.o string-stream.o test-stream.o
+obj-$(CONFIG_KUNIT_TEST)		+= string-stream-test.o
+obj-$(CONFIG_KUNIT_EXAMPLE_TEST)	+= example-test.o
diff --git a/kunit/example-test.c b/kunit/example-test.c
new file mode 100644
index 0000000000000..e9bd2b41c5fd2
--- /dev/null
+++ b/kunit/example-test.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Example KUnit test to show how to use KUnit.
+ *
+ * Copyright (C) 2018, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ */
+
+#include <kunit/test.h>
+
+/*
+ * This is the most fundamental element of KUnit, the test case. A test case
+ * makes a set EXPECTATIONs and ASSERTIONs about the behavior of some code; if
+ * any expectations or assertions are not met, the test fails; otherwise, the
+ * test passes.
+ *
+ * In KUnit, a test case is just a function with the signature
+ * `void (*)(struct test *)`. `struct test` is a context object that stores
+ * information about the current test.
+ */
+static void example_simple_test(struct test *test)
+{
+	/*
+	 * This is an EXPECTATION; it is how KUnit tests things. When you want
+	 * to test a piece of code, you set some expectations about what the
+	 * code should do. KUnit then runs the test and verifies that the code's
+	 * behavior matched what was expected.
+	 */
+	TEST_EXPECT_EQ(test, 1 + 1, 2);
+}
+
+/*
+ * This is run once before each test case, see the comment on
+ * example_test_module for more information.
+ */
+static int example_test_init(struct test *test)
+{
+	test_info(test, "initializing");
+
+	return 0;
+}
+
+/*
+ * Here we make a list of all the test cases we want to add to the test module
+ * below.
+ */
+static struct test_case example_test_cases[] = {
+	/*
+	 * This is a helper to create a test case object from a test case
+	 * function; its exact function is not important to understand how to
+	 * use KUnit, just know that this is how you associate test cases with a
+	 * test module.
+	 */
+	TEST_CASE(example_simple_test),
+	{},
+};
+
+/*
+ * This defines a suite or grouping of tests.
+ *
+ * Test cases are defined as belonging to the suite by adding them to
+ * `test_cases`.
+ *
+ * Often it is desirable to run some function which will set up things which
+ * will be used by every test; this is accomplished with an `init` function
+ * which runs before each test case is invoked. Similarly, an `exit` function
+ * may be specified which runs after every test case and can be used to for
+ * cleanup. For clarity, running tests in a test module would behave as follows:
+ *
+ * module.init(test);
+ * module.test_case[0](test);
+ * module.exit(test);
+ * module.init(test);
+ * module.test_case[1](test);
+ * module.exit(test);
+ * ...;
+ */
+static struct test_module example_test_module = {
+	.name = "example",
+	.init = example_test_init,
+	.test_cases = example_test_cases,
+};
+
+/*
+ * This registers the above test module telling KUnit that this is a suite of
+ * tests that need to be run.
+ */
+module_test(example_test_module);
diff --git a/kunit/string-stream-test.c b/kunit/string-stream-test.c
new file mode 100644
index 0000000000000..07c626cbfffbf
--- /dev/null
+++ b/kunit/string-stream-test.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for struct string_stream.
+ *
+ * Copyright (C) 2018, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ */
+
+#include <linux/slab.h>
+#include <kunit/test.h>
+#include <kunit/string-stream.h>
+
+static void string_stream_test_get_string(struct test *test)
+{
+	struct string_stream *stream = new_string_stream();
+	char *output;
+
+	stream->add(stream, "Foo");
+	stream->add(stream, " %s", "bar");
+
+	output = stream->get_string(stream);
+	TEST_EXPECT_STREQ(test, output, "Foo bar");
+	kfree(output);
+	destroy_string_stream(stream);
+}
+
+static void string_stream_test_add_and_clear(struct test *test)
+{
+	struct string_stream *stream = new_string_stream();
+	char *output;
+	int i;
+
+	for (i = 0; i < 10; i++)
+		stream->add(stream, "A");
+
+	output = stream->get_string(stream);
+	TEST_EXPECT_STREQ(test, output, "AAAAAAAAAA");
+	TEST_EXPECT_EQ(test, stream->length, 10);
+	TEST_EXPECT_FALSE(test, stream->is_empty(stream));
+	kfree(output);
+
+	stream->clear(stream);
+
+	output = stream->get_string(stream);
+	TEST_EXPECT_STREQ(test, output, "");
+	TEST_EXPECT_TRUE(test, stream->is_empty(stream));
+	destroy_string_stream(stream);
+}
+
+static struct test_case string_stream_test_cases[] = {
+	TEST_CASE(string_stream_test_get_string),
+	TEST_CASE(string_stream_test_add_and_clear),
+	{}
+};
+
+static struct test_module string_stream_test_module = {
+	.name = "string-stream-test",
+	.test_cases = string_stream_test_cases
+};
+module_test(string_stream_test_module);
+
-- 
2.19.1.568.g152ad8e336-goog
