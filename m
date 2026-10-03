Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F25382283;
	Sat,  3 Oct 2026 03:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999965; cv=none; b=b3P+X7WchQ9VMmU7Gfo92HIAAKxJAyL/E1BdGObuPhyKB0Glc5ZZeKLrrZ4/oOanH8iW8mJ4T5byEpVv6Ld9h2xxDhA9mzQqsEMxVlYzw8hYoHl3ri9NNe548qzQsa1uPR1b9yLG3PG/9FFVdzO3aL4zMIOO49aesNRCJy96agI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999965; c=relaxed/simple;
	bh=ImCEZna+PC/g/biseLLYGZ6y7IF2OH0vpiCopYhdIXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT1e25U6l/+RO0GSFoXPk5UXcLKz66zKIQOWhzs7j2/o4uSQJIqsUPAftNAN4px+Ldw5xqFLJ5xpdfbDsEqcfjwF11tCCZCX0WDuRHNy8ICITBHBYGecDk0Lcj5n6KEMWsHlx9BXvAYvuy1MZzPJVTPCLEfLRmQ1PJPYN6AYcXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnYWsbfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnYWsbfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF43C1F00A02;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999961;
	bh=Y1aDauPJdFX/50NTYqGW/RNt6s7sh61+A08L3Yfzp1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnYWsbfwd0Mkv6Zwet6rFXDJc0F1v9LnKSJLDTY8NHPB00+kVKifK9f93G8h7KPg2
	 QuNK02RNRwJtNEshseLwjETizIhP9nE8RnIeHWYdR0+0hYuMBgNMFjk17GiDP4jrx1
	 owgFbD/qQHVOzKZz8HtVEX3S6XMnuZL0BPllQ8oTv3sG4UQjTAZDGm4/FNLCW3pyzD
	 iz6ezaxzGXuExGHssu/QJCs1IaaLJhRuMz8l2l77zhv6COY9b5qRd6W7urLIxZzlNV
	 8eCTy0F+qCAkINzPFYxu/YD7W9erP6OQEaFxbdoIwdMCRv4xelNn3gyMNnbUk6LF9e
	 4FiV2ZIeZERkQ==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	David Gow <david@davidgow.net>,
	Jiri Kosina <jikos@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v4 04/11] seq_buf: Clear what a writer did not claim when a seq_buf overflows
Date: Fri,  2 Oct 2026 20:59:09 -0700
Message-ID: <20261003035921.1918874-4-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5997; i=kees@kernel.org; h=from:subject; bh=ImCEZna+PC/g/biseLLYGZ6y7IF2OH0vpiCopYhdIXs=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaifeDRWb+fZuJ9/3KxFxvZMFcn7tf5+Xah187Yj6t vsv1i116ChlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZiIQSrDP23Ftn3FF6QNRFOq b054X+OrseA9+3uTRe4xpVJ9s/grZjAynL6o1+jOmxCnsUxK50uqbsjevU+s95/6q+p9jrno2/E 2ZgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Using seq_buf_set_overflow() would leave the bytes between "len"
and "size" untouched, so if seq_buf_str() is used on an overflowed
seq_buf, those bytes may be exposed. For any paths that don't claim
partially written bytes, by setting "len = size" before calling
seq_buf_set_overflow(), wipe the unclaimed bytes. The seq_buf_puts()
and related APIs already claim those bytes now, so only the unclaimed
cases remain. A specific example of this was seq_buf_path() which uses
d_path() and would write to the tail before discovering it was out
of space, and would correctly mark a seq_buf as overflowed, but the
path fragment would be left over.

Clear from len to the end of the buffer in seq_buf_set_overflow(), which
every overflow goes through, including seq_buf_commit() with a negative
count.

Add a test that fills a seq_buf, leaves it too little room for a path, and
checks that nothing of the path is left in the buffer. The tests run before
anything writable is mounted, so it takes its file from shmem.

seq_buf_path() was never exported, unlike the other writers, so the
test failed to link as a module. Export it.

Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0, and the
test builds as a module (CONFIG_SEQ_BUF_KUNIT_TEST=m).

Assisted-by: LLM
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/seq_buf.h   |  8 +++++--
 lib/seq_buf.c             |  5 +++++
 lib/tests/seq_buf_kunit.c | 45 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 77e76e283370..0c0a0db04b09 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -5,6 +5,7 @@
 #include <linux/bug.h>
 #include <linux/minmax.h>
 #include <linux/seq_file.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
 /*
@@ -58,12 +59,15 @@ seq_buf_has_overflowed(struct seq_buf *s)
 /*
  * Mark @s as overflowed, which discards the length of what it holds. The
  * bytes up to its last one are the string from then on, as that is where
- * seq_buf_str() terminates it, so a caller that could not fill the buffer
- * has to NUL them itself before calling this.
+ * seq_buf_str() terminates it, so clear whatever was not written: a writer
+ * sets len to how much it filled, and anything past that was never adopted.
  */
 static inline void
 seq_buf_set_overflow(struct seq_buf *s)
 {
+	if (s->len < s->size)
+		memset(s->buffer + s->len, 0, s->size - s->len);
+
 	s->len = s->size + 1;
 }
 
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 60e9eadb3ef7..8da2e9447adf 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -76,6 +76,8 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
 			s->len += len;
 			return 0;
 		}
+		/* vsnprintf() wrote as much as fits, so none of it is stale */
+		s->len = s->size;
 	}
 	seq_buf_set_overflow(s);
 	return -1;
@@ -164,6 +166,8 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 			s->len += ret;
 			return 0;
 		}
+		/* bstr_printf() wrote as much as fits, so none of it is stale */
+		s->len = s->size;
 	}
 	seq_buf_set_overflow(s);
 	return -1;
@@ -343,6 +347,7 @@ int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(seq_buf_path);
 
 /**
  * seq_buf_to_user - copy the sequence buffer to user space
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index 046614100c77..d5b819fc0ff3 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -6,6 +6,9 @@
  */
 
 #include <kunit/test.h>
+#include <linux/fs.h>
+#include <linux/seq_buf.h>
+#include <linux/shmem_fs.h>
 #include <linux/console.h>
 #include <linux/seq_buf.h>
 #include <linux/string.h>
@@ -466,6 +469,47 @@ static void seq_buf_do_printk_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, seq_buf_printk_empty, 0);
 }
 
+/* Long enough that it cannot fit in the room the test leaves for it. */
+#define SEQ_BUF_TEST_PATH	"/seq_buf_kunit_path_name"
+
+static void seq_buf_path_overflow_test(struct kunit *test)
+{
+	DECLARE_SEQ_BUF(s, 32);
+	const char *expected = "keep:xxxxxxxxxxxxxxxxxxxxxxx";
+	struct file *file;
+	size_t len;
+	int i;
+
+	/*
+	 * The tests run before anything writable is mounted, so take the file
+	 * whose path gets printed from shmem, which needs no mount of its own.
+	 */
+	file = shmem_file_setup(SEQ_BUF_TEST_PATH, 0, EMPTY_VMA_FLAGS);
+	if (IS_ERR(file))
+		kunit_skip(test, "cannot create a file to print the path of");
+
+	/* Leave less room than the path needs, so d_path() cannot fit it. */
+	seq_buf_puts(&s, "keep:");
+	len = seq_buf_used(&s);
+	for (i = len; i < 28; i++)
+		seq_buf_putc(&s, 'x');
+
+	KUNIT_EXPECT_EQ(test, seq_buf_path(&s, &file->f_path, "\n"), -1);
+	fput(file);
+
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+
+	/*
+	 * d_path() keeps as much of the path as fits when it does not fit
+	 * whole, and seq_buf_str() would hand out that fragment, as it ends
+	 * the string at the last byte of an overflowed buffer.
+	 */
+	for (i = 28; i < 32; i++)
+		KUNIT_EXPECT_EQ_MSG(test, s.buffer[i], '\0',
+				    "byte %d past the data is not cleared", i);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
+}
+
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
 	KUNIT_CASE(seq_buf_declare_test),
@@ -482,6 +526,7 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_puts_partial_overflow_test),
 	KUNIT_CASE(seq_buf_putmem_partial_overflow_test),
 	KUNIT_CASE(seq_buf_putmem_hex_partial_overflow_test),
+	KUNIT_CASE(seq_buf_path_overflow_test),
 	KUNIT_CASE(seq_buf_do_printk_test),
 	{}
 };
-- 
2.55.0

