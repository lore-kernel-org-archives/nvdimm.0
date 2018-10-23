From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 05/14] kunit: test: add the concept of expectations
Date: Tue, 23 Oct 2018 16:57:41 -0700
Message-ID: <20181023235750.103146-6-brendanhiggins@google.com>
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

Add support for expectations, which allow properties to be specified and
then verified in tests.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/kunit/test.h | 259 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 259 insertions(+)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index 68320fa2452de..d652825d7296f 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -273,4 +273,263 @@ void __printf(3, 4) test_printk(const char *level,
 #define test_err(test, fmt, ...) \
 		test_printk(KERN_ERR, test, fmt, ##__VA_ARGS__)
 
+static inline struct test_stream *test_expect_start(struct test *test,
+						    const char *file,
+						    const char *line)
+{
+	struct test_stream *stream = test_new_stream(test);
+
+	stream->add(stream, "EXPECTATION FAILED at %s:%s\n\t", file, line);
+
+	return stream;
+}
+
+static inline void test_expect_end(struct test *test,
+				   bool success,
+				   struct test_stream *stream)
+{
+	if (!success)
+		test->fail(test, stream);
+	else
+		stream->clear(stream);
+}
+
+#define TEST_EXPECT_START(test) \
+		test_expect_start(test, __FILE__, __stringify(__LINE__))
+
+#define TEST_EXPECT_END(test, success, stream) \
+		test_expect_end(test, success, stream)
+
+#define TEST_EXPECT(test, success, message) do {			       \
+	struct test_stream *__stream = TEST_EXPECT_START(test);		       \
+									       \
+	__stream->add(__stream, message);				       \
+	TEST_EXPECT_END(test, success, __stream);			       \
+} while (0)
+
+/**
+ * TEST_SUCCEED() - A no-op expectation. Only exists for code clarity.
+ * @test: The test context object.
+ *
+ * The opposite of TEST_FAIL(), it is an expectation that cannot fail. In other
+ * words, it does nothing and only exists for code clarity. See
+ * TEST_EXPECT_TRUE() for more information.
+ */
+#define TEST_SUCCEED(test) do {} while (0)
+
+/**
+ * TEST_FAIL() - Always causes a test to fail when evaluated.
+ * @test: The test context object.
+ * @message: an informational message to be printed when the assertion is made.
+ *
+ * The opposite of TEST_SUCCEED(), it is an expectation that always fails. In
+ * other words, it always results in a failed expectation, and consequently
+ * always causes the test case to fail when evaluated. See TEST_EXPECT_TRUE()
+ * for more information.
+ */
+#define TEST_FAIL(test, message) TEST_EXPECT(test, false, message)
+
+/**
+ * TEST_EXPECT_TRUE() - Causes a test failure when the expression is not true.
+ * @test: The test context object.
+ * @condition: an arbitrary boolean expression. The test fails when this does
+ * not evaluate to true.
+ *
+ * This and expectations of the form `TEST_EXPECT_*` will cause the test case to
+ * fail when the specified condition is not met; however, it will not prevent
+ * the test case from continuing to run; this is otherwise known as an
+ * *expectation failure*.
+ */
+#define TEST_EXPECT_TRUE(test, condition)				       \
+		TEST_EXPECT(test, (condition),				       \
+		       "Expected " #condition " is true, but is false.")
+
+/**
+ * TEST_EXPECT_FALSE() - Causes a test failure when the expression is not false.
+ * @test: The test context object.
+ * @condition: an arbitrary boolean expression. The test fails when this does
+ * not evaluate to false.
+ *
+ * Sets an expectation that @condition evaluates to false. See
+ * TEST_EXPECT_TRUE() for more information.
+ */
+#define TEST_EXPECT_FALSE(test, condition)				       \
+		TEST_EXPECT(test, !(condition),				       \
+		       "Expected " #condition " is false, but is true.")
+
+static inline void test_expect_binary(struct test *test,
+				      long long left, const char *left_name,
+				      long long right, const char *right_name,
+				      bool compare_result,
+				      const char *compare_name,
+				      const char *file,
+				      const char *line)
+{
+	struct test_stream *stream = test_expect_start(test, file, line);
+
+	stream->add(stream,
+		    "Expected %s %s %s, but\n",
+		    left_name, compare_name, right_name);
+	stream->add(stream, "\t\t%s == %lld\n", left_name, left);
+	stream->add(stream, "\t\t%s == %lld", right_name, right);
+
+	test_expect_end(test, compare_result, stream);
+}
+
+/*
+ * A factory macro for defining the expectations for the basic comparisons
+ * defined for the built in types.
+ *
+ * Unfortunately, there is no common type that all types can be promoted to for
+ * which all the binary operators behave the same way as for the actual types
+ * (for example, there is no type that long long and unsigned long long can
+ * both be cast to where the comparison result is preserved for all values). So
+ * the best we can do is do the comparison in the original types and then coerce
+ * everything to long long for printing; this way, the comparison behaves
+ * correctly and the printed out value usually makes sense without
+ * interpretation, but can always be interpretted to figure out the actual
+ * value.
+ */
+#define TEST_EXPECT_BINARY(test, left, condition, right) do {		       \
+	typeof(left) __left = (left);					       \
+	typeof(right) __right = (right);				       \
+	test_expect_binary(test,					       \
+			   (long long) __left, #left,			       \
+			   (long long) __right, #right,			       \
+			   __left condition __right, #condition,	       \
+			   __FILE__, __stringify(__LINE__));		       \
+} while (0)
+
+/**
+ * TEST_EXPECT_EQ() - Sets an expectation that @left and @right are equal.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an expectation that the values that @left and @right evaluate to are
+ * equal. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, (@left) == (@right)). See TEST_EXPECT_TRUE() for more
+ * information.
+ */
+#define TEST_EXPECT_EQ(test, left, right) \
+		TEST_EXPECT_BINARY(test, left, ==, right)
+
+/**
+ * TEST_EXPECT_NE() - An expectation that @left and @right are not equal.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an expectation that the values that @left and @right evaluate to are not
+ * equal. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, (@left) != (@right)). See TEST_EXPECT_TRUE() for more
+ * information.
+ */
+#define TEST_EXPECT_NE(test, left, right) \
+		TEST_EXPECT_BINARY(test, left, !=, right)
+
+/**
+ * TEST_EXPECT_LT() - An expectation that @left is less than @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an expectation that the value that @left evaluates to is less than the
+ * value that @right evaluates to. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, (@left) < (@right)). See TEST_EXPECT_TRUE() for more
+ * information.
+ */
+#define TEST_EXPECT_LT(test, left, right) \
+		TEST_EXPECT_BINARY(test, left, <, right)
+
+/**
+ * TEST_EXPECT_LE() - An expectation that @left is less than or equal to @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an expectation that the value that @left evaluates to is less than or
+ * equal to the value that @right evaluates to. Semantically this is equivalent
+ * to TEST_EXPECT_TRUE(@test, (@left) <= (@right)). See TEST_EXPECT_TRUE() for
+ * more information.
+ */
+#define TEST_EXPECT_LE(test, left, right) \
+		TEST_EXPECT_BINARY(test, left, <=, right)
+
+/**
+ * TEST_EXPECT_GT() - An expectation that @left is greater than @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an expectation that the value that @left evaluates to is greater than
+ * the value that @right evaluates to. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, (@left) > (@right)). See TEST_EXPECT_TRUE() for more
+ * information.
+ */
+#define TEST_EXPECT_GT(test, left, right) \
+		TEST_EXPECT_BINARY(test, left, >, right)
+
+/**
+ * TEST_EXPECT_GE() - Expects that @left is greater than or equal to @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an expectation that the value that @left evaluates to is greater than
+ * the value that @right evaluates to. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, (@left) >= (@right)). See TEST_EXPECT_TRUE() for more
+ * information.
+ */
+#define TEST_EXPECT_GE(test, left, right) \
+		TEST_EXPECT_BINARY(test, left, >=, right)
+
+/**
+ * TEST_EXPECT_STREQ() - An expectation that strings @left and @right are equal.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a null terminated string.
+ * @right: an arbitrary expression that evaluates to a null terminated string.
+ *
+ * Sets an expectation that the values that @left and @right evaluate to are
+ * equal. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, !strcmp((@left), (@right))). See TEST_EXPECT_TRUE()
+ * for more information.
+ */
+#define TEST_EXPECT_STREQ(test, left, right) do {			       \
+	struct test_stream *__stream = TEST_EXPECT_START(test);		       \
+	typeof(left) __left = (left);					       \
+	typeof(right) __right = (right);				       \
+									       \
+	__stream->add(__stream, "Expected " #left " == " #right ", but\n");    \
+	__stream->add(__stream, "\t\t%s == %s\n", #left, __left);	       \
+	__stream->add(__stream, "\t\t%s == %s\n", #right, __right);	       \
+									       \
+	TEST_EXPECT_END(test, !strcmp(left, right), __stream);		       \
+} while (0)
+
+/**
+ * TEST_EXPECT_NOT_ERR_OR_NULL() - Expects that @ptr is not null and not err.
+ * @test: The test context object.
+ * @ptr: an arbitrary pointer.
+ *
+ * Sets an expectation that the value that @ptr evaluates to is not null and not
+ * an errno stored in a pointer. This is semantically equivalent to
+ * TEST_EXPECT_TRUE(@test, !IS_ERR_OR_NULL(@ptr)). See TEST_EXPECT_TRUE() for
+ * more information.
+ */
+#define TEST_EXPECT_NOT_ERR_OR_NULL(test, ptr) do {			       \
+	struct test_stream *__stream = TEST_EXPECT_START(test);		       \
+	typeof(ptr) __ptr = (ptr);					       \
+									       \
+	if (!__ptr)							       \
+		__stream->add(__stream,					       \
+			      "Expected " #ptr " is not null, but is.");       \
+	if (IS_ERR(__ptr))						       \
+		__stream->add(__stream,					       \
+			      "Expected " #ptr " is not error, but is: %ld",   \
+			      PTR_ERR(__ptr));				       \
+									       \
+	TEST_EXPECT_END(test, !IS_ERR_OR_NULL(__ptr), __stream);	       \
+} while (0)
+
 #endif /* _KUNIT_TEST_H */
-- 
2.19.1.568.g152ad8e336-goog
