From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 04/14] kunit: test: add test_stream a std::stream like logger
Date: Tue, 23 Oct 2018 16:57:40 -0700
Message-ID: <20181023235750.103146-5-brendanhiggins@google.com>
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

A lot of the expectation and assertion infrastructure prints out fairly
complicated test failure messages, so add a C++ style log library for
for logging test results.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/kunit/test-stream.h |  49 ++++++++++++
 include/kunit/test.h        |   2 +
 kunit/Makefile              |   2 +-
 kunit/test-stream.c         | 153 ++++++++++++++++++++++++++++++++++++
 kunit/test.c                |   8 ++
 5 files changed, 213 insertions(+), 1 deletion(-)
 create mode 100644 include/kunit/test-stream.h
 create mode 100644 kunit/test-stream.c

diff --git a/include/kunit/test-stream.h b/include/kunit/test-stream.h
new file mode 100644
index 0000000000000..c5dfd95ef21bb
--- /dev/null
+++ b/include/kunit/test-stream.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * C++ stream style string formatter and printer used in KUnit for outputting
+ * KUnit messages.
+ *
+ * Copyright (C) 2018, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ */
+
+#ifndef _KUNIT_TEST_STREAM_H
+#define _KUNIT_TEST_STREAM_H
+
+#include <linux/types.h>
+#include <kunit/string-stream.h>
+
+struct test;
+
+/**
+ * struct test_stream - a std::stream style string builder.
+ * @set_level: sets the level that this string should be printed at.
+ * @add: adds the formatted input to the internal buffer.
+ * @commit: prints out the internal buffer to the user.
+ * @clear: clears the internal buffer.
+ *
+ * A std::stream style string builder. Allows messages to be built up and
+ * printed all at once.
+ */
+struct test_stream {
+	void (*set_level)(struct test_stream *this, const char *level);
+	void (*add)(struct test_stream *this, const char *fmt, ...);
+	void (*append)(struct test_stream *this, struct test_stream *other);
+	void (*commit)(struct test_stream *this);
+	void (*clear)(struct test_stream *this);
+	/* private: internal use only. */
+	struct test *test;
+	spinlock_t lock; /* Guards level. */
+	const char *level;
+	struct string_stream *internal_stream;
+};
+
+/**
+ * test_new_stream() - constructs a new &struct test_stream.
+ * @test: The test context object.
+ *
+ * Constructs a new test managed &struct test_stream.
+ */
+struct test_stream *test_new_stream(struct test *test);
+
+#endif /* _KUNIT_TEST_STREAM_H */
diff --git a/include/kunit/test.h b/include/kunit/test.h
index 1c116a20063da..68320fa2452de 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <kunit/test-stream.h>
 
 struct test_resource;
 
@@ -171,6 +172,7 @@ struct test {
 	void (*vprintk)(const struct test *test,
 			const char *level,
 			struct va_format *vaf);
+	void (*fail)(struct test *test, struct test_stream *stream);
 };
 
 int test_init_test(struct test *test, const char *name);
diff --git a/kunit/Makefile b/kunit/Makefile
index 7fc613a9b383b..5b4562ea7f322 100644
--- a/kunit/Makefile
+++ b/kunit/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_KUNIT)		+= test.o string-stream.o
+obj-$(CONFIG_KUNIT)		+= test.o string-stream.o test-stream.o
diff --git a/kunit/test-stream.c b/kunit/test-stream.c
new file mode 100644
index 0000000000000..392966864a708
--- /dev/null
+++ b/kunit/test-stream.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * C++ stream style string formatter and printer used in KUnit for outputting
+ * KUnit messages.
+ *
+ * Copyright (C) 2018, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ */
+
+#include <kunit/test.h>
+#include <kunit/test-stream.h>
+#include <kunit/string-stream.h>
+
+static const char *test_stream_get_level(struct test_stream *this)
+{
+	unsigned long flags;
+	const char *level;
+
+	spin_lock_irqsave(&this->lock, flags);
+	level = this->level;
+	spin_unlock_irqrestore(&this->lock, flags);
+
+	return level;
+}
+
+static void test_stream_set_level(struct test_stream *this, const char *level)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&this->lock, flags);
+	this->level = level;
+	spin_unlock_irqrestore(&this->lock, flags);
+}
+
+static void test_stream_add(struct test_stream *this, const char *fmt, ...)
+{
+	va_list args;
+	struct string_stream *stream = this->internal_stream;
+
+	va_start(args, fmt);
+	if (stream->vadd(stream, fmt, args) < 0)
+		test_err(this->test, "Failed to allocate fragment: %s", fmt);
+
+	va_end(args);
+}
+
+static void test_stream_append(struct test_stream *this,
+			       struct test_stream *other)
+{
+	struct string_stream *other_stream = other->internal_stream;
+	const char *other_content;
+
+	other_content = other_stream->get_string(other_stream);
+
+	if (!other_content) {
+		test_err(this->test,
+			 "Failed to get string from second argument for appending.");
+		return;
+	}
+
+	this->add(this, other_content);
+}
+
+static void test_stream_clear(struct test_stream *this)
+{
+	this->internal_stream->clear(this->internal_stream);
+}
+
+static void test_stream_commit(struct test_stream *this)
+{
+	struct string_stream *stream = this->internal_stream;
+	struct string_stream_fragment *fragment;
+	const char *level;
+	char *buf;
+
+	level = test_stream_get_level(this);
+	if (!level) {
+		test_err(this->test,
+			 "Stream was committed without a specified log level.");
+		level = KERN_ERR;
+		this->set_level(this, level);
+	}
+
+	buf = stream->get_string(stream);
+	if (!buf) {
+		test_err(this->test,
+			 "Could not allocate buffer, dumping stream:");
+		list_for_each_entry(fragment, &stream->fragments, node) {
+			test_err(this->test, fragment->fragment);
+		}
+		goto cleanup;
+	}
+
+	test_printk(level, this->test, buf);
+	kfree(buf);
+
+cleanup:
+	this->clear(this);
+}
+
+static int test_stream_init(struct test_resource *res, void *context)
+{
+	struct test *test = context;
+	struct test_stream *stream;
+
+	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
+	if (!stream)
+		return -ENOMEM;
+	res->allocation = stream;
+	stream->test = test;
+	spin_lock_init(&stream->lock);
+	stream->internal_stream = new_string_stream();
+
+	if (!stream->internal_stream)
+		return -ENOMEM;
+
+	stream->set_level = test_stream_set_level;
+	stream->add = test_stream_add;
+	stream->append = test_stream_append;
+	stream->commit = test_stream_commit;
+	stream->clear = test_stream_clear;
+
+	return 0;
+}
+
+static void test_stream_free(struct test_resource *res)
+{
+	struct test_stream *stream = res->allocation;
+
+	if (!stream->internal_stream->is_empty(stream->internal_stream)) {
+		test_err(stream->test,
+			 "End of test case reached with uncommitted stream entries.");
+		stream->commit(stream);
+	}
+
+	destroy_string_stream(stream->internal_stream);
+	kfree(stream);
+}
+
+struct test_stream *test_new_stream(struct test *test)
+{
+	struct test_resource *res;
+
+	res = test_alloc_resource(test,
+				  test_stream_init,
+				  test_stream_free,
+				  test);
+
+	if (res)
+		return res->allocation;
+	else
+		return NULL;
+}
diff --git a/kunit/test.c b/kunit/test.c
index fd0a51245215e..f798183533c8d 100644
--- a/kunit/test.c
+++ b/kunit/test.c
@@ -63,12 +63,20 @@ static void test_vprintk(const struct test *test,
 			 "kunit %s: %pV", test->name, vaf);
 }
 
+static void test_fail(struct test *test, struct test_stream *stream)
+{
+	test_set_success(test, false);
+	stream->set_level(stream, KERN_ERR);
+	stream->commit(stream);
+}
+
 int test_init_test(struct test *test, const char *name)
 {
 	spin_lock_init(&test->lock);
 	INIT_LIST_HEAD(&test->resources);
 	test->name = name;
 	test->vprintk = test_vprintk;
+	test->fail = test_fail;
 
 	return 0;
 }
-- 
2.19.1.568.g152ad8e336-goog
