From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 09/19] kunit: test: add the concept of assertions
Date: Wed, 28 Nov 2018 11:36:26 -0800
Message-ID: <20181128193636.254378-10-brendanhiggins@google.com>
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

Add support for assertions which are like expectations except the test
terminates if the assertion is not satisfied.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/kunit/test.h       | 388 ++++++++++++++++++++++++++++++++++++-
 kunit/Makefile             |   3 +-
 kunit/string-stream-test.c |  12 +-
 kunit/test-test.c          |  37 ++++
 kunit/test.c               | 164 +++++++++++++++-
 5 files changed, 586 insertions(+), 18 deletions(-)
 create mode 100644 kunit/test-test.c

diff --git a/include/kunit/test.h b/include/kunit/test.h
index 098a9dceef9ea..7be11dba0b14e 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -84,9 +84,10 @@ struct kunit;
  * @name: the name of the test case.
  *
  * A test case is a function with the signature, ``void (*)(struct kunit *)``
- * that makes expectations (see KUNIT_EXPECT_TRUE()) about code under test. Each
- * test case is associated with a &struct kunit_module and will be run after the
- * module's init function and followed by the module's exit function.
+ * that makes expectations and assertions (see KUNIT_EXPECT_TRUE() and
+ * KUNIT_ASSERT_TRUE()) about code under test. Each test case is associated with
+ * a &struct kunit_module and will be run after the module's init function and
+ * followed by the module's exit function.
  *
  * A test case should be static and should only be created with the KUNIT_CASE()
  * macro; additionally, every array of test cases should be terminated with an
@@ -168,11 +169,14 @@ struct kunit {
 	const char *name; /* Read only after initialization! */
 	spinlock_t lock; /* Gaurds all mutable test state. */
 	bool success; /* Protected by lock. */
+	bool death_test; /* Protected by lock. */
 	struct list_head resources; /* Protected by lock. */
+	void (*set_death_test)(struct kunit *test, bool death_test);
 	void (*vprintk)(const struct kunit *test,
 			const char *level,
 			struct va_format *vaf);
 	void (*fail)(struct kunit *test, struct kunit_stream *stream);
+	void (*abort)(struct kunit *test);
 };
 
 int kunit_init_test(struct kunit *test, const char *name);
@@ -652,4 +656,382 @@ static inline void kunit_expect_binary(struct kunit *test,
 	KUNIT_EXPECT_END(test, !IS_ERR_OR_NULL(__ptr), __stream);	       \
 } while (0)
 
+static inline struct kunit_stream *kunit_assert_start(struct kunit *test,
+						    const char *file,
+						    const char *line)
+{
+	struct kunit_stream *stream = kunit_new_stream(test);
+
+	stream->add(stream, "ASSERTION FAILED at %s:%s\n\t", file, line);
+
+	return stream;
+}
+
+static inline void kunit_assert_end(struct kunit *test,
+				   bool success,
+				   struct kunit_stream *stream)
+{
+	if (!success) {
+		test->fail(test, stream);
+		test->abort(test);
+	} else {
+		stream->clear(stream);
+	}
+}
+
+#define KUNIT_ASSERT_START(test) \
+		kunit_assert_start(test, __FILE__, __stringify(__LINE__))
+
+#define KUNIT_ASSERT_END(test, success, stream) \
+		kunit_assert_end(test, success, stream)
+
+#define KUNIT_ASSERT(test, success, message) do {			       \
+	struct kunit_stream *__stream = KUNIT_ASSERT_START(test);	       \
+									       \
+	__stream->add(__stream, message);				       \
+	KUNIT_ASSERT_END(test, success, __stream);			       \
+} while (0)
+
+#define KUNIT_ASSERT_MSG(test, success, message, fmt, ...) do {		       \
+	struct kunit_stream *__stream = KUNIT_ASSERT_START(test);	       \
+									       \
+	__stream->add(__stream, message);				       \
+	__stream->add(__stream, fmt, ##__VA_ARGS__);			       \
+	KUNIT_ASSERT_END(test, success, __stream);			       \
+} while (0)
+
+#define KUNIT_ASSERT_FAILURE(test, fmt, ...) \
+		KUNIT_ASSERT_MSG(test, false, "", fmt, ##__VA_ARGS__)
+
+/**
+ * KUNIT_ASSERT_TRUE() - Sets an assertion that @condition is true.
+ * @test: The test context object.
+ * @condition: an arbitrary boolean expression. The test fails and aborts when
+ * this does not evaluate to true.
+ *
+ * This and assertions of the form `KUNIT_ASSERT_*` will cause the test case to
+ * fail *and immediately abort* when the specified condition is not met. Unlike
+ * an expectation failure, it will prevent the test case from continuing to run;
+ * this is otherwise known as an *assertion failure*.
+ */
+#define KUNIT_ASSERT_TRUE(test, condition)				       \
+		KUNIT_ASSERT(test, (condition),				       \
+		       "Asserted " #condition " is true, but is false.")
+
+#define KUNIT_ASSERT_TRUE_MSG(test, condition, fmt, ...)		       \
+		KUNIT_ASSERT_MSG(test, (condition),			       \
+				"Asserted " #condition " is true, but is false.\n",\
+				fmt, ##__VA_ARGS__)
+
+/**
+ * KUNIT_ASSERT_FALSE() - Sets an assertion that @condition is false.
+ * @test: The test context object.
+ * @condition: an arbitrary boolean expression.
+ *
+ * Sets an assertion that the value that @condition evaluates to is false. This
+ * is the same as KUNIT_EXPECT_FALSE(), except it causes an assertion failure
+ * (see KUNIT_ASSERT_TRUE()) when the assertion is not met.
+ */
+#define KUNIT_ASSERT_FALSE(test, condition)				       \
+		KUNIT_ASSERT(test, !(condition),			       \
+		       "Asserted " #condition " is false, but is true.")
+
+#define KUNIT_ASSERT_FALSE_MSG(test, condition, fmt, ...)		       \
+		KUNIT_ASSERT_MSG(test, !(condition),			       \
+				"Asserted " #condition " is false, but is true.\n",\
+				fmt, ##__VA_ARGS__)
+
+void kunit_assert_binary_msg(struct kunit *test,
+			    long long left, const char *left_name,
+			    long long right, const char *right_name,
+			    bool compare_result,
+			    const char *compare_name,
+			    const char *file,
+			    const char *line,
+			    const char *fmt, ...);
+
+static inline void kunit_assert_binary(struct kunit *test,
+				      long long left, const char *left_name,
+				      long long right, const char *right_name,
+				      bool compare_result,
+				      const char *compare_name,
+				      const char *file,
+				      const char *line)
+{
+	kunit_assert_binary_msg(test,
+			       left, left_name,
+			       right, right_name,
+			       compare_result,
+			       compare_name,
+			       file,
+			       line,
+			       NULL);
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
+#define KUNIT_ASSERT_BINARY(test, left, condition, right) do {		       \
+	typeof(left) __left = (left);					       \
+	typeof(right) __right = (right);				       \
+	kunit_assert_binary(test,					       \
+			   (long long) __left, #left,			       \
+			   (long long) __right, #right,			       \
+			   __left condition __right, #condition,	       \
+			   __FILE__, __stringify(__LINE__));		       \
+} while (0)
+
+#define KUNIT_ASSERT_BINARY_MSG(test, left, condition, right, fmt, ...) do {   \
+	typeof(left) __left = (left);					       \
+	typeof(right) __right = (right);				       \
+	kunit_assert_binary_msg(test,					       \
+			       (long long) __left, #left,		       \
+			       (long long) __right, #right,		       \
+			       __left condition __right, #condition,	       \
+			       __FILE__, __stringify(__LINE__),		       \
+			       fmt, ##__VA_ARGS__);			       \
+} while (0)
+
+/**
+ * KUNIT_ASSERT_EQ() - Sets an assertion that @left and @right are equal.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an assertion that the values that @left and @right evaluate to are
+ * equal. This is the same as KUNIT_EXPECT_EQ(), except it causes an assertion
+ * failure (see KUNIT_ASSERT_TRUE()) when the assertion is not met.
+ */
+#define KUNIT_ASSERT_EQ(test, left, right) \
+		KUNIT_ASSERT_BINARY(test, left, ==, right)
+
+#define KUNIT_ASSERT_EQ_MSG(test, left, right, fmt, ...)		       \
+		KUNIT_ASSERT_BINARY_MSG(test,				       \
+					left,				       \
+					==,				       \
+					right,				       \
+					fmt,				       \
+					##__VA_ARGS__)
+
+/**
+ * KUNIT_ASSERT_NE() - An assertion that @left and @right are not equal.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an assertion that the values that @left and @right evaluate to are not
+ * equal. This is the same as KUNIT_EXPECT_NE(), except it causes an assertion
+ * failure (see KUNIT_ASSERT_TRUE()) when the assertion is not met.
+ */
+#define KUNIT_ASSERT_NE(test, left, right) \
+		KUNIT_ASSERT_BINARY(test, left, !=, right)
+
+#define KUNIT_ASSERT_NE_MSG(test, left, right, fmt, ...)		       \
+		KUNIT_ASSERT_BINARY_MSG(test,				       \
+					left,				       \
+					!=,				       \
+					right,				       \
+					fmt,				       \
+					##__VA_ARGS__)
+
+/**
+ * KUNIT_ASSERT_LT() - An assertion that @left is less than @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an assertion that the value that @left evaluates to is less than the
+ * value that @right evaluates to. This is the same as KUNIT_EXPECT_LT(), except
+ * it causes an assertion failure (see KUNIT_ASSERT_TRUE()) when the assertion
+ * is not met.
+ */
+#define KUNIT_ASSERT_LT(test, left, right) \
+		KUNIT_ASSERT_BINARY(test, left, <, right)
+
+#define KUNIT_ASSERT_LT_MSG(test, left, right, fmt, ...)		       \
+		KUNIT_ASSERT_BINARY_MSG(test,				       \
+					left,				       \
+					<,				       \
+					right,				       \
+					fmt,				       \
+					##__VA_ARGS__)
+/**
+ * KUNIT_ASSERT_LE() - An assertion that @left is less than or equal to @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an assertion that the value that @left evaluates to is less than or
+ * equal to the value that @right evaluates to. This is the same as
+ * KUNIT_EXPECT_LE(), except it causes an assertion failure (see
+ * KUNIT_ASSERT_TRUE()) when the assertion is not met.
+ */
+#define KUNIT_ASSERT_LE(test, left, right) \
+		KUNIT_ASSERT_BINARY(test, left, <=, right)
+
+#define KUNIT_ASSERT_LE_MSG(test, left, right, fmt, ...)		       \
+		KUNIT_ASSERT_BINARY_MSG(test,				       \
+					left,				       \
+					<=,				       \
+					right,				       \
+					fmt,				       \
+					##__VA_ARGS__)
+/**
+ * KUNIT_ASSERT_GT() - An assertion that @left is greater than @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an assertion that the value that @left evaluates to is greater than the
+ * value that @right evaluates to. This is the same as KUNIT_EXPECT_GT(), except
+ * it causes an assertion failure (see KUNIT_ASSERT_TRUE()) when the assertion
+ * is not met.
+ */
+#define KUNIT_ASSERT_GT(test, left, right) \
+		KUNIT_ASSERT_BINARY(test, left, >, right)
+
+#define KUNIT_ASSERT_GT_MSG(test, left, right, fmt, ...)		       \
+		KUNIT_ASSERT_BINARY_MSG(test,				       \
+					left,				       \
+					>,				       \
+					right,				       \
+					fmt,				       \
+					##__VA_ARGS__)
+
+/**
+ * KUNIT_ASSERT_GE() - Assertion that @left is greater than or equal to @right.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a primitive C type.
+ * @right: an arbitrary expression that evaluates to a primitive C type.
+ *
+ * Sets an assertion that the value that @left evaluates to is greater than the
+ * value that @right evaluates to. This is the same as KUNIT_EXPECT_GE(), except
+ * it causes an assertion failure (see KUNIT_ASSERT_TRUE()) when the assertion
+ * is not met.
+ */
+#define KUNIT_ASSERT_GE(test, left, right) \
+		KUNIT_ASSERT_BINARY(test, left, >=, right)
+
+#define KUNIT_ASSERT_GE_MSG(test, left, right, fmt, ...)		       \
+		KUNIT_ASSERT_BINARY_MSG(test,				       \
+					left,				       \
+					>=,				       \
+					right,				       \
+					fmt,				       \
+					##__VA_ARGS__)
+
+/**
+ * KUNIT_ASSERT_STREQ() - An assertion that strings @left and @right are equal.
+ * @test: The test context object.
+ * @left: an arbitrary expression that evaluates to a null terminated string.
+ * @right: an arbitrary expression that evaluates to a null terminated string.
+ *
+ * Sets an assertion that the values that @left and @right evaluate to are
+ * equal. This is the same as KUNIT_EXPECT_STREQ(), except it causes an
+ * assertion failure (see KUNIT_ASSERT_TRUE()) when the assertion is not met.
+ */
+#define KUNIT_ASSERT_STREQ(test, left, right) do {			       \
+	struct kunit_stream *__stream = KUNIT_ASSERT_START(test);	       \
+	typeof(left) __left = (left);					       \
+	typeof(right) __right = (right);				       \
+									       \
+	__stream->add(__stream, "Asserted " #left " == " #right ", but\n");    \
+	__stream->add(__stream, "\t\t%s == %s\n", #left, __left);	       \
+	__stream->add(__stream, "\t\t%s == %s\n", #right, __right);	       \
+									       \
+	KUNIT_ASSERT_END(test, !strcmp(left, right), __stream);		       \
+} while (0)
+
+#define KUNIT_ASSERT_STREQ_MSG(test, left, right, fmt, ...) do {	       \
+	struct kunit_stream *__stream = KUNIT_ASSERT_START(test);	       \
+	typeof(left) __left = (left);					       \
+	typeof(right) __right = (right);				       \
+									       \
+	__stream->add(__stream, "Expected " #left " == " #right ", but\n");    \
+	__stream->add(__stream, "\t\t%s == %s\n", #left, __left);	       \
+	__stream->add(__stream, "\t\t%s == %s\n", #right, __right);	       \
+	__stream->add(__stream, fmt, ##__VA_ARGS__);			       \
+									       \
+	KUNIT_ASSERT_END(test, !strcmp(left, right), __stream);		       \
+} while (0)
+
+/**
+ * KUNIT_ASSERT_NOT_ERR_OR_NULL() - Assertion that @ptr is not null and not err.
+ * @test: The test context object.
+ * @ptr: an arbitrary pointer.
+ *
+ * Sets an assertion that the value that @ptr evaluates to is not null and not
+ * an errno stored in a pointer. This is the same as
+ * KUNIT_EXPECT_NOT_ERR_OR_NULL(), except it causes an assertion failure (see
+ * KUNIT_ASSERT_TRUE()) when the assertion is not met.
+ */
+#define KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr) do {			       \
+	struct kunit_stream *__stream = KUNIT_ASSERT_START(test);	       \
+	typeof(ptr) __ptr = (ptr);					       \
+									       \
+	if (!__ptr)							       \
+		__stream->add(__stream,					       \
+			      "Asserted " #ptr " is not null, but is.");       \
+	if (IS_ERR(__ptr))						       \
+		__stream->add(__stream,					       \
+			      "Asserted " #ptr " is not error, but is: %ld",   \
+			      PTR_ERR(__ptr));				       \
+									       \
+	KUNIT_ASSERT_END(test, !IS_ERR_OR_NULL(__ptr), __stream);	       \
+} while (0)
+
+#define KUNIT_ASSERT_NOT_ERR_OR_NULL_MSG(test, ptr, fmt, ...) do {	       \
+	struct kunit_stream *__stream = KUNIT_ASSERT_START(test);	       \
+	typeof(ptr) __ptr = (ptr);					       \
+									       \
+	if (!__ptr) {							       \
+		__stream->add(__stream,					       \
+			      "Asserted " #ptr " is not null, but is.");       \
+		__stream->add(__stream, fmt, ##__VA_ARGS__);		       \
+	}								       \
+	if (IS_ERR(__ptr)) {						       \
+		__stream->add(__stream,					       \
+			      "Asserted " #ptr " is not error, but is: %ld",   \
+			      PTR_ERR(__ptr));				       \
+									       \
+		__stream->add(__stream, fmt, ##__VA_ARGS__);		       \
+	}								       \
+	KUNIT_ASSERT_END(test, !IS_ERR_OR_NULL(__ptr), __stream);	       \
+} while (0)
+
+/**
+ * KUNIT_ASSERT_SIGSEGV() - An assertion that @expr will cause a segfault.
+ * @test: The test context object.
+ * @expr: an arbitrary block of code.
+ *
+ * Sets an assertion that @expr, when evaluated, will cause a segfault.
+ * Currently this assertion is only really useful for testing the KUnit
+ * framework, as a segmentation fault in normal kernel code is always incorrect.
+ * However, the plan is to replace this assertion with an arbitrary death
+ * assertion similar to
+ * https://github.com/google/googletest/blob/master/googletest/docs/advanced.md#death-tests
+ * which will probably be massaged to make sense in the context of the kernel
+ * (maybe assert that a panic occurred, or that BUG() was called).
+ *
+ * NOTE: no code after this assertion will ever be executed.
+ */
+#define KUNIT_ASSERT_SIGSEGV(test, expr) do {				       \
+	test->set_death_test(test, true);				       \
+	expr;								       \
+	test->set_death_test(test, false);				       \
+	KUNIT_ASSERT_FAILURE(test,					       \
+			    "Asserted that " #expr " would cause death, but did not.");\
+} while (0)
+
 #endif /* _KUNIT_TEST_H */
diff --git a/kunit/Makefile b/kunit/Makefile
index 60a9ea6cb4697..e4c300f67479a 100644
--- a/kunit/Makefile
+++ b/kunit/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_KUNIT) +=			test.o \
 					string-stream.o \
 					kunit-stream.o
 
-obj-$(CONFIG_KUNIT_TEST) +=		string-stream-test.o
+obj-$(CONFIG_KUNIT_TEST) +=		test-test.o \
+					string-stream-test.o
 
 obj-$(CONFIG_KUNIT_EXAMPLE_TEST) +=	example-test.o
diff --git a/kunit/string-stream-test.c b/kunit/string-stream-test.c
index ec2675593c364..c5346a6c932ce 100644
--- a/kunit/string-stream-test.c
+++ b/kunit/string-stream-test.c
@@ -19,7 +19,7 @@ static void string_stream_test_get_string(struct kunit *test)
 	stream->add(stream, " %s", "bar");
 
 	output = stream->get_string(stream);
-	KUNIT_EXPECT_STREQ(test, output, "Foo bar");
+	KUNIT_ASSERT_STREQ(test, output, "Foo bar");
 	kfree(output);
 	destroy_string_stream(stream);
 }
@@ -34,16 +34,16 @@ static void string_stream_test_add_and_clear(struct kunit *test)
 		stream->add(stream, "A");
 
 	output = stream->get_string(stream);
-	KUNIT_EXPECT_STREQ(test, output, "AAAAAAAAAA");
-	KUNIT_EXPECT_EQ(test, stream->length, 10);
-	KUNIT_EXPECT_FALSE(test, stream->is_empty(stream));
+	KUNIT_ASSERT_STREQ(test, output, "AAAAAAAAAA");
+	KUNIT_ASSERT_EQ(test, stream->length, 10);
+	KUNIT_ASSERT_FALSE(test, stream->is_empty(stream));
 	kfree(output);
 
 	stream->clear(stream);
 
 	output = stream->get_string(stream);
-	KUNIT_EXPECT_STREQ(test, output, "");
-	KUNIT_EXPECT_TRUE(test, stream->is_empty(stream));
+	KUNIT_ASSERT_STREQ(test, output, "");
+	KUNIT_ASSERT_TRUE(test, stream->is_empty(stream));
 	destroy_string_stream(stream);
 }
 
diff --git a/kunit/test-test.c b/kunit/test-test.c
new file mode 100644
index 0000000000000..88b3bcf9c4e00
--- /dev/null
+++ b/kunit/test-test.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for core test infrastructure.
+ *
+ * Copyright (C) 2018, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ */
+#include <kunit/test.h>
+
+static void test_test_catches_segfault(struct kunit *test)
+{
+	void (*invalid_func)(void) = (void (*)(void)) SIZE_MAX;
+
+	KUNIT_ASSERT_SIGSEGV(test, invalid_func());
+}
+
+static int test_test_init(struct kunit *test)
+{
+	return 0;
+}
+
+static void test_test_exit(struct kunit *test)
+{
+}
+
+static struct kunit_case test_test_cases[] = {
+	KUNIT_CASE(test_test_catches_segfault),
+	{},
+};
+
+static struct kunit_module test_test_module = {
+	.name = "test-test",
+	.init = test_test_init,
+	.exit = test_test_exit,
+	.test_cases = test_test_cases,
+};
+module_test(test_test_module);
diff --git a/kunit/test.c b/kunit/test.c
index 0fe6571f23d41..db3b0ea0f5888 100644
--- a/kunit/test.c
+++ b/kunit/test.c
@@ -32,6 +32,27 @@ static void kunit_set_success(struct kunit *test, bool success)
 	spin_unlock_irqrestore(&test->lock, flags);
 }
 
+static bool kunit_get_death_test(struct kunit *test)
+{
+	unsigned long flags;
+	bool death_test;
+
+	spin_lock_irqsave(&test->lock, flags);
+	death_test = test->death_test;
+	spin_unlock_irqrestore(&test->lock, flags);
+
+	return death_test;
+}
+
+static void kunit_set_death_test(struct kunit *test, bool death_test)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&test->lock, flags);
+	test->death_test = death_test;
+	spin_unlock_irqrestore(&test->lock, flags);
+}
+
 static int kunit_vprintk_emit(const struct kunit *test,
 			      int level,
 			      const char *fmt,
@@ -70,13 +91,34 @@ static void kunit_fail(struct kunit *test, struct kunit_stream *stream)
 	stream->commit(stream);
 }
 
+static void __noreturn kunit_abort(struct kunit *test)
+{
+	kunit_set_death_test(test, true);
+	if (current->thread.fault_catcher && current->thread.is_running_test)
+		UML_LONGJMP(current->thread.fault_catcher, 1);
+
+	/*
+	 * Attempted to abort from a not properly initialized test context.
+	 */
+	kunit_err(test,
+		 "Attempted to abort from a not properly initialized test context!");
+	if (!current->thread.fault_catcher)
+		kunit_err(test, "No fault_catcher present!");
+	if (!current->thread.is_running_test)
+		kunit_err(test, "is_running_test not set!");
+	show_stack(NULL, NULL);
+	BUG();
+}
+
 int kunit_init_test(struct kunit *test, const char *name)
 {
 	spin_lock_init(&test->lock);
 	INIT_LIST_HEAD(&test->resources);
 	test->name = name;
+	test->set_death_test = kunit_set_death_test;
 	test->vprintk = kunit_vprintk;
 	test->fail = kunit_fail;
+	test->abort = kunit_abort;
 
 	return 0;
 }
@@ -122,16 +164,89 @@ static void kunit_run_case_cleanup(struct kunit *test,
 }
 
 /*
- * Performs all logic to run a test case.
+ * Handles an unexpected crash in a test case.
  */
-static bool kunit_run_case(struct kunit *test,
-			   struct kunit_module *module,
-			   struct kunit_case *test_case)
+static void kunit_handle_test_crash(struct kunit *test,
+				   struct kunit_module *module,
+				   struct kunit_case *test_case)
 {
-	kunit_set_success(test, true);
+	kunit_err(test, "%s crashed", test_case->name);
+	/*
+	 * TODO(brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org): This prints the stack trace up
+	 * through this frame, not up to the frame that caused the crash.
+	 */
+	show_stack(NULL, NULL);
 
-	kunit_run_case_internal(test, module, test_case);
-	kunit_run_case_cleanup(test, module, test_case);
+	kunit_case_internal_cleanup(test);
+}
+
+/*
+ * Performs all logic to run a test case. It also catches most errors that
+ * occurs in a test case and reports them as failures.
+ *
+ * XXX: THIS DOES NOT FOLLOW NORMAL CONTROL FLOW. READ CAREFULLY!!!
+ */
+static bool kunit_run_case_catch_errors(struct kunit *test,
+				       struct kunit_module *module,
+				       struct kunit_case *test_case)
+{
+	jmp_buf fault_catcher;
+	int faulted;
+
+	kunit_set_success(test, true);
+	kunit_set_death_test(test, false);
+
+	/*
+	 * Tell the trap subsystem that we want to catch any segfaults that
+	 * occur.
+	 */
+	current->thread.is_running_test = true;
+	current->thread.fault_catcher = &fault_catcher;
+
+	/*
+	 * ENTER HANDLER: If a failure occurs, we enter here.
+	 */
+	faulted = UML_SETJMP(&fault_catcher);
+	if (faulted == 0) {
+		/*
+		 * NORMAL CASE: we have not run kunit_run_case_internal yet.
+		 *
+		 * kunit_run_case_internal may encounter a fatal error; if it
+		 * does, we will jump to ENTER_HANDLER above instead of
+		 * continuing normal control flow.
+		 */
+		kunit_run_case_internal(test, module, test_case);
+		/*
+		 * This line may never be reached.
+		 */
+		kunit_run_case_cleanup(test, module, test_case);
+	} else if (kunit_get_death_test(test)) {
+		/*
+		 * EXPECTED DEATH: kunit_run_case_internal encountered
+		 * anticipated fatal error. Everything should be in a safe
+		 * state.
+		 */
+		kunit_run_case_cleanup(test, module, test_case);
+	} else {
+		/*
+		 * UNEXPECTED DEATH: kunit_run_case_internal encountered an
+		 * unanticipated fatal error. We have no idea what the state of
+		 * the test case is in.
+		 */
+		kunit_handle_test_crash(test, module, test_case);
+		kunit_set_success(test, false);
+	}
+	/*
+	 * EXIT HANDLER: test case has been run and all possible errors have
+	 * been handled.
+	 */
+
+	/*
+	 * Tell the trap subsystem that we no longer want to catch any
+	 * segfaults.
+	 */
+	current->thread.fault_catcher = NULL;
+	current->thread.is_running_test = false;
 
 	return kunit_get_success(test);
 }
@@ -148,7 +263,7 @@ int kunit_run_tests(struct kunit_module *module)
 		return ret;
 
 	for (test_case = module->test_cases; test_case->run_case; test_case++) {
-		success = kunit_run_case(&test, module, test_case);
+		success = kunit_run_case_catch_errors(&test, module, test_case);
 		if (!success)
 			all_passed = false;
 
@@ -303,3 +418,36 @@ void kunit_expect_binary_msg(struct kunit *test,
 	kunit_expect_end(test, compare_result, stream);
 }
 
+void kunit_assert_binary_msg(struct kunit *test,
+			     long long left, const char *left_name,
+			     long long right, const char *right_name,
+			     bool compare_result,
+			     const char *compare_name,
+			     const char *file,
+			     const char *line,
+			     const char *fmt, ...)
+{
+	struct kunit_stream *stream = kunit_assert_start(test, file, line);
+	struct va_format vaf;
+	va_list args;
+
+	stream->add(stream,
+		    "Asserted %s %s %s, but\n",
+		    left_name, compare_name, right_name);
+	stream->add(stream, "\t\t%s == %lld\n", left_name, left);
+	stream->add(stream, "\t\t%s == %lld", right_name, right);
+
+	if (fmt) {
+		va_start(args, fmt);
+
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		stream->add(stream, "\n%pV", &vaf);
+
+		va_end(args);
+	}
+
+	kunit_assert_end(test, compare_result, stream);
+}
+
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
