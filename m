Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0ECF35B63C;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999963; cv=none; b=h/DJAX87ywQPA/EObw/wNk13qxiJHDD3YBgcPDwOQb81tJIEad4E/n269cjLpC+IGckF4Dzac1mhRS2m2nr8mdjum/+1Zzkkd60ub9lzneMVKZpo4Kj233t52r1WAOJkDZYQTuxB3XBAEQISkS/VjOJ6qm//LHXZSTtx3DsNIu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999963; c=relaxed/simple;
	bh=kDcTaJ85ccrzvosuGa0deab469m50rh398m0lHPUoiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn7Rjg6oxQ4afqkJawgKl9xmAxYVUpAuBGy/ajPDBDGa09lEYGBBeJvIQ1+pk35h8WxCxx1mXQnB+4qpY4/ORpz5P1jU69HSxwhIV9PbEsLIjRqQlLsf7pl3WwCguxyY5OZry6qT6sr4bTc2Jl/+13qH1duPJ6OQC6MLVjVZtV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByCWR3fu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByCWR3fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725B51F00898;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999961;
	bh=wgIoxI8+F7q0MuL9Ab/j+Tx062dTho+i6o6sYhEpJsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByCWR3fuaN6dwDxOes1VevKDG6LVtgpoXFlwYAbhUFJvCDJMqnVNM3RmQlFPdfluU
	 7Aar7PVF2QbYcsITwR4cPPpNEvdlQE6LkJR/qsa6DWQo8t/amI8y5XiAVs0i74dI0C
	 qw24+wsLwBNJoIsNKJLj29Cbohe4aMkMW/bs58QHTr2olp7naKzB4NUmwxcZzZ2AtK
	 9me/PH7dij+nSwuY6KOV+AQmCHRbNP6EXhfipr/PLNIQ1k8DEsJekH7jgFeKO5Qowf
	 7H9mEon/9bdlFr5deHpTEb4TK5LGXqAN6nh6rgG44uSGW8FCm8k0YK6uouScZ+2po3
	 Scd8r3B6hFq6Q==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Gow <david@davidgow.net>,
	Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jiri Kosina <jikos@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Thorsten Blum <blum@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ira Weiny <iweiny@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v4 01/11] seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()
Date: Fri,  2 Oct 2026 20:59:06 -0700
Message-ID: <20261003035921.1918874-1-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6763; i=kees@kernel.org; h=from:subject; bh=kDcTaJ85ccrzvosuGa0deab469m50rh398m0lHPUoiY=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaicUxbzY13eA34btWdT1KvtVxc618/9JVi+qtuGWm jv3+a6OjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIncCGVkmBRupOfQH3dR5NvX Fcuirv5a8jlaojhOUnmzSUnv+6wD0xgZVvCtmMC2YT7b+0X17+97yHSfk8yUvm49O9a5YWamUs4 rdgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

seq_buf_do_printk() prints a buffer line by line, then prints whatever
follows the last newline. When a string has overflowed at exactly a
newline, an empty line is printed since the pointer hasn't reached the
overflow mark of the seq_buf. Switch to just check if the string is
already empty and only print if not.

The only caller is the memory cgroup OOM report, so this could only ever
add a blank line to a report whose statistics already did not fit.

Add a test that registers a console to count the records that
seq_buf_do_printk() emits. It counts the records carrying the test's
marker, and the records holding nothing but a line feed that arrive
after one, so that unrelated kernel messages do not disturb it. Both
states that reach the flaw are covered: exactly full, and overflowed.

Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0.

Fixes: 96928d9032a7c ("seq_buf: Add seq_buf_do_printk() helper")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 lib/seq_buf.c             |   2 +-
 lib/tests/seq_buf_kunit.c | 132 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index a92093f346da..35a5964370b4 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -128,7 +128,7 @@ void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
 	}
 
 	/* No trailing LF */
-	if (start < s->buffer + s->len)
+	if (*start)
 		printk("%s%s\n", lvl, start);
 }
 EXPORT_SYMBOL_GPL(seq_buf_do_printk);
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index eb466386bbef..0934dfb602ff 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -6,7 +6,9 @@
  */
 
 #include <kunit/test.h>
+#include <linux/console.h>
 #include <linux/seq_buf.h>
+#include <linux/string.h>
 
 static void seq_buf_init_test(struct kunit *test)
 {
@@ -216,6 +218,135 @@ static void seq_buf_putmem_hex_overflow_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
 }
 
+/*
+ * Counters for the console that seq_buf_do_printk_test() registers while it
+ * runs. Only records carrying the marker are counted, so unrelated kernel
+ * messages do not disturb them.
+ *
+ * An empty record carries nothing to recognize it by, so count one only
+ * where the flaw puts it: directly after a record of ours, with nothing in
+ * between. That still misreads a bare line feed printed by another CPU in
+ * exactly that gap, but no longer counts one printed at any point while the
+ * console happens to be registered.
+ */
+#define SEQ_BUF_PRINTK_MARKER	"sbdpkx"
+
+static unsigned int seq_buf_printk_marked;
+static unsigned int seq_buf_printk_empty;
+static bool seq_buf_printk_last_was_ours;
+
+static void seq_buf_printk_capture(struct console *con,
+				   const char *s, unsigned int count)
+{
+	const char *text = s;
+	const char *prefix;
+
+	/*
+	 * Skip what printk() puts in front of the message: a timestamp,
+	 * and the caller id as well under CONFIG_PRINTK_CALLER, so strip
+	 * every bracketed group rather than just the first.
+	 */
+	while (count && text[0] == '[') {
+		prefix = memchr(text, ']', count);
+		if (!prefix)
+			break;
+		count -= prefix + 1 - text;
+		text = prefix + 1;
+		if (count && text[0] == ' ') {
+			text++;
+			count--;
+		}
+	}
+
+	if (strnstr(text, SEQ_BUF_PRINTK_MARKER, count)) {
+		seq_buf_printk_marked++;
+		seq_buf_printk_last_was_ours = true;
+		return;
+	}
+
+	if (seq_buf_printk_last_was_ours &&
+	    (count == 0 || (count == 1 && text[0] == '\n')))
+		seq_buf_printk_empty++;
+
+	seq_buf_printk_last_was_ours = false;
+}
+
+static void seq_buf_printk_run(struct console *capture, struct seq_buf *s)
+{
+	seq_buf_printk_marked = 0;
+	seq_buf_printk_empty = 0;
+	seq_buf_printk_last_was_ours = false;
+
+	/*
+	 * register_console() will not take an unmatched console without
+	 * CON_ENABLED, and unregister_console() clears it, so set it on
+	 * every run to keep the test repeatable.
+	 */
+	capture->flags = CON_ENABLED;
+	register_console(capture);
+	seq_buf_do_printk(s, KERN_INFO);
+	unregister_console(capture);
+}
+
+static void seq_buf_do_printk_test(struct kunit *test)
+{
+	/*
+	 * A registered console is a global object: printk() reaches it
+	 * through the console list from any CPU, and the console code writes
+	 * back into it, so keep it out of this function's stack frame the
+	 * way every other console in the tree does.
+	 */
+	static struct console capture = {
+		.name = "sbufcap",
+		.write = seq_buf_printk_capture,
+		.index = -1,
+	};
+	DECLARE_SEQ_BUF(s, 8);
+	DECLARE_SEQ_BUF(t, 16);
+	DECLARE_SEQ_BUF(u, 8);
+
+	/*
+	 * Fill the buffer exactly, so that the NUL takes the place of the
+	 * last byte and the string ends with the line feed before it.
+	 */
+	seq_buf_puts(&s, SEQ_BUF_PRINTK_MARKER);
+	seq_buf_putc(&s, '\n');
+	seq_buf_putc(&s, '!');
+	KUNIT_ASSERT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_ASSERT_EQ(test, seq_buf_used(&s), 8);
+	KUNIT_ASSERT_EQ(test, strlen(seq_buf_str(&s)), 7);
+
+	seq_buf_printk_run(&capture, &s);
+
+	/* The one line that was written, and nothing after it. */
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 1);
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
+
+	/* Check that lines without a trailing newline are shown. */
+	seq_buf_puts(&t, SEQ_BUF_PRINTK_MARKER "\n" SEQ_BUF_PRINTK_MARKER);
+	KUNIT_ASSERT_FALSE(test, seq_buf_has_overflowed(&t));
+
+	seq_buf_printk_run(&capture, &t);
+
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 2);
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
+
+	/*
+	 * The buffer above was exactly full, where "len" equals the size. A
+	 * buffer that actually overflowed reaches the same bug by the other
+	 * route the old test had, with "len" one past the size.
+	 */
+	seq_buf_puts(&u, SEQ_BUF_PRINTK_MARKER "\n");
+	KUNIT_EXPECT_EQ(test, seq_buf_puts(&u, "yy"), -1);
+	KUNIT_ASSERT_TRUE(test, seq_buf_has_overflowed(&u));
+	KUNIT_ASSERT_EQ(test, u.len, u.size + 1);
+
+	seq_buf_printk_run(&capture, &u);
+
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 1);
+	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
+}
+
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
 	KUNIT_CASE(seq_buf_declare_test),
@@ -228,6 +359,7 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_get_buf_commit_test),
 	KUNIT_CASE(seq_buf_putmem_hex_test),
 	KUNIT_CASE(seq_buf_putmem_hex_overflow_test),
+	KUNIT_CASE(seq_buf_do_printk_test),
 	{}
 };
 
-- 
2.55.0

