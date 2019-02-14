From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v4 08/17] kunit: test: add support for test abort
Date: Thu, 14 Feb 2019 13:37:20 -0800
Message-ID: <20190214213729.21702-9-brendanhiggins@google.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190214213729.21702-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Add support for aborting/bailing out of test cases. Needed for
implementing assertions.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Changes Since Last Version
 - This patch is new introducing a new cross-architecture way to abort
   out of a test case (needed for KUNIT_ASSERT_*, see next patch for
   details).
 - On a side note, this is not a complete replacement for the UML abort
   mechanism, but covers the majority of necessary functionality. UML
   architecture specific featurs have been dropped from the initial
   patchset.
---
 include/kunit/test.h |  24 +++++
 kunit/Makefile       |   3 +-
 kunit/test-test.c    | 127 ++++++++++++++++++++++++++
 kunit/test.c         | 208 +++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 353 insertions(+), 9 deletions(-)
 create mode 100644 kunit/test-test.c

diff --git a/include/kunit/test.h b/include/kunit/test.h
index a36ad1a502c66..cd02dca96eb61 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -151,6 +151,26 @@ struct kunit_module {
 	struct kunit_case *test_cases;
 };
 
+struct kunit_try_catch_context {
+	struct kunit *test;
+	struct kunit_module *module;
+	struct kunit_case *test_case;
+	struct completion *try_completion;
+	int try_result;
+};
+
+struct kunit_try_catch {
+	void (*run)(struct kunit_try_catch *try_catch);
+	void (*throw)(struct kunit_try_catch *try_catch);
+	struct kunit_try_catch_context context;
+	void (*try)(struct kunit_try_catch_context *context);
+	void (*catch)(struct kunit_try_catch_context *context);
+};
+
+void kunit_try_catch_init(struct kunit_try_catch *try_catch);
+
+void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch);
+
 /**
  * struct kunit - represents a running instance of a test.
  * @priv: for user to store arbitrary data. Commonly used to pass data created
@@ -166,13 +186,17 @@ struct kunit {
 
 	/* private: internal use only. */
 	const char *name; /* Read only after initialization! */
+	struct kunit_try_catch try_catch;
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
diff --git a/kunit/test-test.c b/kunit/test-test.c
new file mode 100644
index 0000000000000..a936c041f1c8f
--- /dev/null
+++ b/kunit/test-test.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for core test infrastructure.
+ *
+ * Copyright (C) 2019, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ */
+#include <kunit/test.h>
+
+struct kunit_try_catch_test_context {
+	struct kunit_try_catch *try_catch;
+	bool function_called;
+};
+
+void kunit_test_successful_try(struct kunit_try_catch_context *context)
+{
+	struct kunit_try_catch_test_context *ctx = context->test->priv;
+
+	ctx->function_called = true;
+}
+
+void kunit_test_no_catch(struct kunit_try_catch_context *context)
+{
+	KUNIT_FAIL(context->test, "Catch should not be called.");
+}
+
+static void kunit_test_try_catch_successful_try_no_catch(struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	try_catch->try = kunit_test_successful_try;
+	try_catch->catch = kunit_test_no_catch;
+	try_catch->run(try_catch);
+
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+void kunit_test_unsuccessful_try(struct kunit_try_catch_context *context)
+{
+	struct kunit_try_catch *try_catch = container_of(context,
+							 struct kunit_try_catch,
+							 context);
+
+	try_catch->throw(try_catch);
+	KUNIT_FAIL(context->test, "This line should never be reached.");
+}
+
+void kunit_test_catch(struct kunit_try_catch_context *context)
+{
+	struct kunit_try_catch_test_context *ctx = context->test->priv;
+
+	ctx->function_called = true;
+}
+
+static void kunit_test_try_catch_unsuccessful_try_does_catch(struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	try_catch->try = kunit_test_unsuccessful_try;
+	try_catch->catch = kunit_test_catch;
+	try_catch->run(try_catch);
+
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+static void kunit_test_generic_try_catch_successful_try_no_catch(
+		struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	kunit_generic_try_catch_init(try_catch);
+
+	try_catch->try = kunit_test_successful_try;
+	try_catch->catch = kunit_test_no_catch;
+	try_catch->run(try_catch);
+
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+static void kunit_test_generic_try_catch_unsuccessful_try_does_catch(
+		struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx = test->priv;
+	struct kunit_try_catch *try_catch = ctx->try_catch;
+
+	kunit_generic_try_catch_init(try_catch);
+
+	try_catch->try = kunit_test_unsuccessful_try;
+	try_catch->catch = kunit_test_catch;
+	try_catch->run(try_catch);
+
+	KUNIT_EXPECT_TRUE(test, ctx->function_called);
+}
+
+static int kunit_try_catch_test_init(struct kunit *test)
+{
+	struct kunit_try_catch_test_context *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	test->priv = ctx;
+
+	ctx->try_catch = kunit_kmalloc(test,
+				       sizeof(*ctx->try_catch),
+				       GFP_KERNEL);
+	kunit_try_catch_init(ctx->try_catch);
+	ctx->try_catch->context.test = test;
+
+	return 0;
+}
+
+static struct kunit_case kunit_try_catch_test_cases[] = {
+	KUNIT_CASE(kunit_test_try_catch_successful_try_no_catch),
+	KUNIT_CASE(kunit_test_try_catch_unsuccessful_try_does_catch),
+	KUNIT_CASE(kunit_test_generic_try_catch_successful_try_no_catch),
+	KUNIT_CASE(kunit_test_generic_try_catch_unsuccessful_try_does_catch),
+	{},
+};
+
+static struct kunit_module kunit_try_catch_test_module = {
+	.name = "kunit-try-catch-test",
+	.init = kunit_try_catch_test_init,
+	.test_cases = kunit_try_catch_test_cases,
+};
+module_test(kunit_try_catch_test_module);
diff --git a/kunit/test.c b/kunit/test.c
index d18c50d5ed671..6e5244642ab07 100644
--- a/kunit/test.c
+++ b/kunit/test.c
@@ -6,9 +6,9 @@
  * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
  */
 
-#include <linux/sched.h>
 #include <linux/sched/debug.h>
-#include <os.h>
+#include <linux/completion.h>
+#include <linux/kthread.h>
 #include <kunit/test.h>
 
 static bool kunit_get_success(struct kunit *test)
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
@@ -70,13 +91,29 @@ static void kunit_fail(struct kunit *test, struct kunit_stream *stream)
 	stream->commit(stream);
 }
 
+static void __noreturn kunit_abort(struct kunit *test)
+{
+	kunit_set_death_test(test, true);
+
+	test->try_catch.throw(&test->try_catch);
+
+	/*
+	 * Throw could not abort from test.
+	 */
+	kunit_err(test, "Throw could not abort from test!");
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
@@ -122,16 +159,171 @@ static void kunit_run_case_cleanup(struct kunit *test,
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
+
+	kunit_case_internal_cleanup(test);
+}
+
+static void kunit_generic_throw(struct kunit_try_catch *try_catch)
+{
+	try_catch->context.try_result = -EFAULT;
+	complete_and_exit(try_catch->context.try_completion, -EFAULT);
+}
+
+static int kunit_generic_run_threadfn_adapter(void *data)
+{
+	struct kunit_try_catch *try_catch = data;
 
+	try_catch->try(&try_catch->context);
+
+	complete_and_exit(try_catch->context.try_completion, 0);
+}
+
+static void kunit_generic_run_try_catch(struct kunit_try_catch *try_catch)
+{
+	struct task_struct *task_struct;
+	struct kunit *test = try_catch->context.test;
+	int exit_code, wake_result;
+	DECLARE_COMPLETION(test_case_completion);
+
+	try_catch->context.try_completion = &test_case_completion;
+	try_catch->context.try_result = 0;
+	task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
+					     try_catch,
+					     "kunit_try_catch_thread");
+	if (IS_ERR_OR_NULL(task_struct)) {
+		try_catch->catch(&try_catch->context);
+		return;
+	}
+
+	wake_result = wake_up_process(task_struct);
+	if (wake_result != 0 && wake_result != 1) {
+		kunit_err(test, "task was not woken properly: %d", wake_result);
+		try_catch->catch(&try_catch->context);
+	}
+
+	/*
+	 * TODO(brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org): We should probably have some type of
+	 * timeout here. The only question is what that timeout value should be.
+	 *
+	 * The intention has always been, at some point, to be able to label
+	 * tests with some type of size bucket (unit/small, integration/medium,
+	 * large/system/end-to-end, etc), where each size bucket would get a
+	 * default timeout value kind of like what Bazel does:
+	 * https://docs.bazel.build/versions/master/be/common-definitions.html#test.size
+	 * There is still some debate to be had on exactly how we do this. (For
+	 * one, we probably want to have some sort of test runner level
+	 * timeout.)
+	 *
+	 * For more background on this topic, see:
+	 * https://mike-bland.com/2011/11/01/small-medium-large.html
+	 */
+	wait_for_completion(&test_case_completion);
+
+	exit_code = try_catch->context.try_result;
+	if (exit_code == -EFAULT)
+		try_catch->catch(&try_catch->context);
+	else if (exit_code == -EINTR)
+		kunit_err(test, "wake_up_process() was never called.");
+	else if (exit_code)
+		kunit_err(test, "Unknown error: %d", exit_code);
+}
+
+void kunit_generic_try_catch_init(struct kunit_try_catch *try_catch)
+{
+	try_catch->run = kunit_generic_run_try_catch;
+	try_catch->throw = kunit_generic_throw;
+}
+
+void __weak kunit_try_catch_init(struct kunit_try_catch *try_catch)
+{
+	kunit_generic_try_catch_init(try_catch);
+}
+
+static void kunit_try_run_case(struct kunit_try_catch_context *context)
+{
+	struct kunit_try_catch_context *ctx = context;
+	struct kunit *test = ctx->test;
+	struct kunit_module *module = ctx->module;
+	struct kunit_case *test_case = ctx->test_case;
+
+	/*
+	 * kunit_run_case_internal may encounter a fatal error; if it does, we
+	 * will jump to ENTER_HANDLER above instead of continuing normal control
+	 * flow.
+	 */
 	kunit_run_case_internal(test, module, test_case);
+	/* This line may never be reached. */
 	kunit_run_case_cleanup(test, module, test_case);
+}
+
+static void kunit_catch_run_case(struct kunit_try_catch_context *context)
+{
+	struct kunit_try_catch_context *ctx = context;
+	struct kunit *test = ctx->test;
+	struct kunit_module *module = ctx->module;
+	struct kunit_case *test_case = ctx->test_case;
+
+	if (kunit_get_death_test(test)) {
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
+	struct kunit_try_catch *try_catch = &test->try_catch;
+	struct kunit_try_catch_context *context = &try_catch->context;
+
+	kunit_try_catch_init(try_catch);
+
+	kunit_set_success(test, true);
+	kunit_set_death_test(test, false);
+
+	/*
+	 * ENTER HANDLER: If a failure occurs, we enter here.
+	 */
+	context->test = test;
+	context->module = module;
+	context->test_case = test_case;
+	try_catch->try = kunit_try_run_case;
+	try_catch->catch = kunit_catch_run_case;
+	try_catch->run(try_catch);
+	/*
+	 * EXIT HANDLER: test case has been run and all possible errors have
+	 * been handled.
+	 */
 
 	return kunit_get_success(test);
 }
@@ -148,7 +340,7 @@ int kunit_run_tests(struct kunit_module *module)
 		return ret;
 
 	for (test_case = module->test_cases; test_case->run_case; test_case++) {
-		success = kunit_run_case(&test, module, test_case);
+		success = kunit_run_case_catch_errors(&test, module, test_case);
 		if (!success)
 			all_passed = false;
 
-- 
2.21.0.rc0.258.g878e2cd30e-goog
