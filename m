Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com
 [IPv6:2607:f8b0:4864:20::549])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E780E203042FE
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 22:54:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 28so17324691pgm.12
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 22:52:17 -0700 (PDT)
Date: Tue, 13 Aug 2019 22:50:53 -0700
In-Reply-To: <20190814055108.214253-1-brendanhiggins@google.com>
Message-Id: <20190814055108.214253-4-brendanhiggins@google.com>
Mime-Version: 1.0
References: <20190814055108.214253-1-brendanhiggins@google.com>
Subject: [PATCH v13 03/18] kunit: test: add string_stream a std::stream like
 string builder
From: Brendan Higgins <brendanhiggins@google.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, rdunlap@infradead.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

A number of test features need to do pretty complicated string printing
where it may not be possible to rely on a single preallocated string
with parameters.

So provide a library for constructing the string as you go similar to
C++'s std::string. string_stream is really just a string builder,
nothing more.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 include/kunit/string-stream.h |  51 ++++++++
 kunit/Makefile                |   3 +-
 kunit/string-stream.c         | 217 ++++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+), 1 deletion(-)
 create mode 100644 include/kunit/string-stream.h
 create mode 100644 kunit/string-stream.c

diff --git a/include/kunit/string-stream.h b/include/kunit/string-stream.h
new file mode 100644
index 0000000000000..fe98a00b75a9c
--- /dev/null
+++ b/include/kunit/string-stream.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * C++ stream style string builder used in KUnit for building messages.
+ *
+ * Copyright (C) 2019, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins@google.com>
+ */
+
+#ifndef _KUNIT_STRING_STREAM_H
+#define _KUNIT_STRING_STREAM_H
+
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <stdarg.h>
+
+struct string_stream_fragment {
+	struct kunit *test;
+	struct list_head node;
+	char *fragment;
+};
+
+struct string_stream {
+	size_t length;
+	struct list_head fragments;
+	/* length and fragments are protected by this lock */
+	spinlock_t lock;
+	struct kunit *test;
+	gfp_t gfp;
+};
+
+struct kunit;
+
+struct string_stream *alloc_string_stream(struct kunit *test, gfp_t gfp);
+
+int __printf(2, 3) string_stream_add(struct string_stream *stream,
+				     const char *fmt, ...);
+
+int string_stream_vadd(struct string_stream *stream,
+		       const char *fmt,
+		       va_list args);
+
+char *string_stream_get_string(struct string_stream *stream);
+
+int string_stream_append(struct string_stream *stream,
+			 struct string_stream *other);
+
+bool string_stream_is_empty(struct string_stream *stream);
+
+int string_stream_destroy(struct string_stream *stream);
+
+#endif /* _KUNIT_STRING_STREAM_H */
diff --git a/kunit/Makefile b/kunit/Makefile
index 5efdc4dea2c08..275b565a0e81f 100644
--- a/kunit/Makefile
+++ b/kunit/Makefile
@@ -1 +1,2 @@
-obj-$(CONFIG_KUNIT) +=			test.o
+obj-$(CONFIG_KUNIT) +=			test.o \
+					string-stream.o
diff --git a/kunit/string-stream.c b/kunit/string-stream.c
new file mode 100644
index 0000000000000..e6d17aacca30d
--- /dev/null
+++ b/kunit/string-stream.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * C++ stream style string builder used in KUnit for building messages.
+ *
+ * Copyright (C) 2019, Google LLC.
+ * Author: Brendan Higgins <brendanhiggins@google.com>
+ */
+
+#include <kunit/string-stream.h>
+#include <kunit/test.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+
+struct string_stream_fragment_alloc_context {
+	struct kunit *test;
+	int len;
+	gfp_t gfp;
+};
+
+static int string_stream_fragment_init(struct kunit_resource *res,
+				       void *context)
+{
+	struct string_stream_fragment_alloc_context *ctx = context;
+	struct string_stream_fragment *frag;
+
+	frag = kunit_kzalloc(ctx->test, sizeof(*frag), ctx->gfp);
+	if (!frag)
+		return -ENOMEM;
+
+	frag->test = ctx->test;
+	frag->fragment = kunit_kmalloc(ctx->test, ctx->len, ctx->gfp);
+	if (!frag->fragment)
+		return -ENOMEM;
+
+	res->allocation = frag;
+
+	return 0;
+}
+
+static void string_stream_fragment_free(struct kunit_resource *res)
+{
+	struct string_stream_fragment *frag = res->allocation;
+
+	list_del(&frag->node);
+	kunit_kfree(frag->test, frag->fragment);
+	kunit_kfree(frag->test, frag);
+}
+
+static struct string_stream_fragment *alloc_string_stream_fragment(
+		struct kunit *test, int len, gfp_t gfp)
+{
+	struct string_stream_fragment_alloc_context context = {
+		.test = test,
+		.len = len,
+		.gfp = gfp
+	};
+
+	return kunit_alloc_resource(test,
+				    string_stream_fragment_init,
+				    string_stream_fragment_free,
+				    gfp,
+				    &context);
+}
+
+static int string_stream_fragment_destroy(struct string_stream_fragment *frag)
+{
+	return kunit_resource_destroy(frag->test,
+				      kunit_resource_instance_match,
+				      string_stream_fragment_free,
+				      frag);
+}
+
+int string_stream_vadd(struct string_stream *stream,
+		       const char *fmt,
+		       va_list args)
+{
+	struct string_stream_fragment *frag_container;
+	int len;
+	va_list args_for_counting;
+
+	/* Make a copy because `vsnprintf` could change it */
+	va_copy(args_for_counting, args);
+
+	/* Need space for null byte. */
+	len = vsnprintf(NULL, 0, fmt, args_for_counting) + 1;
+
+	va_end(args_for_counting);
+
+	frag_container = alloc_string_stream_fragment(stream->test,
+						      len,
+						      stream->gfp);
+	if (!frag_container)
+		return -ENOMEM;
+
+	len = vsnprintf(frag_container->fragment, len, fmt, args);
+	spin_lock(&stream->lock);
+	stream->length += len;
+	list_add_tail(&frag_container->node, &stream->fragments);
+	spin_unlock(&stream->lock);
+
+	return 0;
+}
+
+int string_stream_add(struct string_stream *stream, const char *fmt, ...)
+{
+	va_list args;
+	int result;
+
+	va_start(args, fmt);
+	result = string_stream_vadd(stream, fmt, args);
+	va_end(args);
+
+	return result;
+}
+
+static void string_stream_clear(struct string_stream *stream)
+{
+	struct string_stream_fragment *frag_container, *frag_container_safe;
+
+	spin_lock(&stream->lock);
+	list_for_each_entry_safe(frag_container,
+				 frag_container_safe,
+				 &stream->fragments,
+				 node) {
+		string_stream_fragment_destroy(frag_container);
+	}
+	stream->length = 0;
+	spin_unlock(&stream->lock);
+}
+
+char *string_stream_get_string(struct string_stream *stream)
+{
+	struct string_stream_fragment *frag_container;
+	size_t buf_len = stream->length + 1; /* +1 for null byte. */
+	char *buf;
+
+	buf = kunit_kzalloc(stream->test, buf_len, stream->gfp);
+	if (!buf)
+		return NULL;
+
+	spin_lock(&stream->lock);
+	list_for_each_entry(frag_container, &stream->fragments, node)
+		strlcat(buf, frag_container->fragment, buf_len);
+	spin_unlock(&stream->lock);
+
+	return buf;
+}
+
+int string_stream_append(struct string_stream *stream,
+			 struct string_stream *other)
+{
+	const char *other_content;
+
+	other_content = string_stream_get_string(other);
+
+	if (!other_content)
+		return -ENOMEM;
+
+	return string_stream_add(stream, other_content);
+}
+
+bool string_stream_is_empty(struct string_stream *stream)
+{
+	return list_empty(&stream->fragments);
+}
+
+struct string_stream_alloc_context {
+	struct kunit *test;
+	gfp_t gfp;
+};
+
+static int string_stream_init(struct kunit_resource *res, void *context)
+{
+	struct string_stream *stream;
+	struct string_stream_alloc_context *ctx = context;
+
+	stream = kunit_kzalloc(ctx->test, sizeof(*stream), ctx->gfp);
+	if (!stream)
+		return -ENOMEM;
+
+	res->allocation = stream;
+	stream->gfp = ctx->gfp;
+	stream->test = ctx->test;
+	INIT_LIST_HEAD(&stream->fragments);
+	spin_lock_init(&stream->lock);
+
+	return 0;
+}
+
+static void string_stream_free(struct kunit_resource *res)
+{
+	struct string_stream *stream = res->allocation;
+
+	string_stream_clear(stream);
+}
+
+struct string_stream *alloc_string_stream(struct kunit *test, gfp_t gfp)
+{
+	struct string_stream_alloc_context context = {
+		.test = test,
+		.gfp = gfp
+	};
+
+	return kunit_alloc_resource(test,
+				    string_stream_init,
+				    string_stream_free,
+				    gfp,
+				    &context);
+}
+
+int string_stream_destroy(struct string_stream *stream)
+{
+	return kunit_resource_destroy(stream->test,
+				      kunit_resource_instance_match,
+				      string_stream_free,
+				      stream);
+}
-- 
2.23.0.rc1.153.gdeed80330f-goog

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
