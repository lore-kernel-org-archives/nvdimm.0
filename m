Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C67B382368;
	Sat,  3 Oct 2026 03:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999966; cv=none; b=QEIaW9cw/N9Zo1i1G1ZJ58DiRiEfHS8WIcPXKEKXJGLv716XCq+C7yZ/PMeC+gFiEy9KKkUL08ncfPGHmUwSETIv1phIKG3vlUSXfPDfikm5wPbIGZCktGawyGzkBOlKXenLg4ufCnGL+2bp3CTrnoqWtayShiLjwSV4nyWbKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999966; c=relaxed/simple;
	bh=Uvs263p1VOF3KjbLbP8qADuB9XdfNoGQP81dWpKJ1so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDKFDtV6kZbnpiCP91SC5Jvub1OzrHiZPtVeqmVgcYJMbpEf3vh1XL24AKEuiTr+d4gB/Um7GiUyaUmLHiEdY4PU17kUFWA/esnGWQ2MWE4wdmGrEX5FumAKMwKdHX43w9+eYppsIrEJzpOX9b5gXxYZmUTITQlv0Z1FoCzL4HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTaMp43V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTaMp43V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97351F00921;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999961;
	bh=W1h8D0qFbXv4uHjnh+bT1GE2haEyVpm8BZuu64sYKfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTaMp43VcVtbjsHgzd54qsMCsQjk7iCpLJ3EbRu16TKgx2UFigg1hBBIcXLUuJNl/
	 Et0UV+Yy3Y8407yiioKH4FaL5g1fv1z1d8SN7i3KTnxdt5YBYoCEd6a7iz5lEHiE/b
	 HHSVfRnxx4F+kAxyHr7rFlBOj91GA4kP0WzVPpjfGEUFJgRT42L59+Dvw8sL47hSaD
	 aDoy0vY8kvrjnAQ9SLEZvjkRgu1HUixUiraew3FNR7Da7V89Flht9QWwebbS/EW/mo
	 b+NVdZIxAToNDyn/ht7sOqwbldHuQjYe+uzsBtxZbCpWuZjp6Ye/W3sBltmMZ7Uhbt
	 /Pv6l+qEiF2Hw==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	David Gow <david@davidgow.net>,
	Petr Mladek <pmladek@suse.com>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
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
Subject: [PATCH v4 03/11] seq_buf: Copy what fits when seq_buf_puts() and seq_buf_putmem() overflow
Date: Fri,  2 Oct 2026 20:59:08 -0700
Message-ID: <20261003035921.1918874-3-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8779; i=kees@kernel.org; h=from:subject; bh=Uvs263p1VOF3KjbLbP8qADuB9XdfNoGQP81dWpKJ1so=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaidOtWOZzLnVPChWstA0Yss9y6+H94jZxV317kyJO 9Dy4Fd7RykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETarRn+l79Iz5SX/55bOnvi smRNzam74xkWbpX8vTL8T+6/R6vZjRn+x6j3mb0LP/H9lsLTc1M/cbI7RgpV3j79MfjzKiU2N15 fRgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

When seq_buf_puts() or seq_buf_putmem() is given more than fits, it
copies nothing and only marks the seq_buf as overflowed. If seq_buf_str()
is used, it will terminate the buffer in its last byte, so every byte
between the end of the data and the end of the buffer becomes part of
the string, though the seq_buf never wrote them.

seq_buf_printf() does not have this problem, because vsnprintf() writes
as much of the output as fits, followed by a NUL. Repeat this behavior
in seq_buf_puts(), using strscpy(), and in seq_buf_putmem(), which also
covers seq_buf_putmem_hex(). seq_buf_putc() needs no change, as it can
only overflow when the buffer is already full.

Each writer now records the buffer as full once it has copied what fits,
so that what it wrote can be told apart from bytes nothing touched.

Update seq_buf_putmem_hex_overflow_test, which expected a hex group that
did not fit whole to be left out entirely, and add tests that overflow
seq_buf_puts(), seq_buf_putmem() and seq_buf_putmem_hex() with stale
bytes in the buffer.

The three partial-overflow tests check the buffer itself rather than
seq_buf_str(). Neither writer leaves the last byte of the buffer alone:
seq_buf_putmem() copies raw bytes and writes no NUL, and seq_buf_puts()
relies on strscpy() to write one. That byte is exactly where
seq_buf_str() writes its terminator, so asserting only on the string
would pass whether the copy stopped a byte early or dropped the NUL
entirely.

seq_buf_putmem() was never exported, unlike the other writers, so the
test failed to link as a module. Export it.

Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0, and the
test builds as a module (CONFIG_SEQ_BUF_KUNIT_TEST=m).

Assisted-by: LLM
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/seq_buf.h   |  6 +++
 lib/seq_buf.c             | 17 +++++++-
 lib/tests/seq_buf_kunit.c | 85 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index f5a350347bc5..77e76e283370 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -55,6 +55,12 @@ seq_buf_has_overflowed(struct seq_buf *s)
 	return s->len > s->size;
 }
 
+/*
+ * Mark @s as overflowed, which discards the length of what it holds. The
+ * bytes up to its last one are the string from then on, as that is where
+ * seq_buf_str() terminates it, so a caller that could not fill the buffer
+ * has to NUL them itself before calling this.
+ */
 static inline void
 seq_buf_set_overflow(struct seq_buf *s)
 {
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 35a5964370b4..60e9eadb3ef7 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -175,7 +175,9 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
  * @s: seq_buf descriptor
  * @str: simple string to record
  *
- * Copy a simple string into the sequence buffer.
+ * Copy a simple string into the sequence buffer. If @str does not fit,
+ * as much of it as fits is copied, followed by a null byte, as
+ * seq_buf_printf() does.
  *
  * Returns: zero on success, -1 on overflow.
  */
@@ -194,6 +196,11 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
 		s->len += len - 1;
 		return 0;
 	}
+	/* Copy what fits, so the buffer never holds stale bytes */
+	if (s->len < s->size) {
+		strscpy(s->buffer + s->len, str, s->size - s->len);
+		s->len = s->size;
+	}
 	seq_buf_set_overflow(s);
 	return -1;
 }
@@ -229,7 +236,7 @@ EXPORT_SYMBOL_GPL(seq_buf_putc);
  *
  * There may be cases where raw memory needs to be written into the
  * buffer and a strcpy() would not work. Using this function allows
- * for such cases.
+ * for such cases. If @mem does not fit, as much of it as fits is copied.
  *
  * Returns: zero on success, -1 on overflow.
  */
@@ -242,9 +249,15 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
 		s->len += len;
 		return 0;
 	}
+	/* Copy what fits, so the buffer never holds stale bytes */
+	if (s->len < s->size) {
+		memcpy(s->buffer + s->len, mem, s->size - s->len);
+		s->len = s->size;
+	}
 	seq_buf_set_overflow(s);
 	return -1;
 }
+EXPORT_SYMBOL_GPL(seq_buf_putmem);
 
 #define MAX_MEMHEX_BYTES	8U
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index de491f96c1ac..046614100c77 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -248,9 +248,9 @@ static void seq_buf_putmem_hex_overflow_test(struct kunit *test)
 	DECLARE_SEQ_BUF(s, 20);
 	const u8 data[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
 #ifdef __BIG_ENDIAN
-	const char *expected = "0001020304050607 ";
+	const char *expected = "0001020304050607 08";
 #else
-	const char *expected = "0706050403020100 ";
+	const char *expected = "0706050403020100 09";
 #endif
 
 	KUNIT_EXPECT_EQ(test, seq_buf_putmem_hex(&s, data, sizeof(data)), -1);
@@ -259,6 +259,84 @@ static void seq_buf_putmem_hex_overflow_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
 }
 
+static void seq_buf_puts_partial_overflow_test(struct kunit *test)
+{
+	static const char expected[] = "abcdefg";
+	DECLARE_SEQ_BUF(s, 16);
+	struct seq_buf t;
+	char buf[8];
+
+	/* As much of the string as fits is written, like seq_buf_printf(). */
+	seq_buf_puts(&s, "hello");
+	KUNIT_EXPECT_EQ(test, seq_buf_puts(&s, " world, again"), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 16);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hello world, ag");
+
+	/* Stale bytes after the data must not show up in the string. */
+	memset(buf, 'X', sizeof(buf));
+	seq_buf_init(&t, buf, sizeof(buf));
+	seq_buf_putc(&t, 'a');
+	KUNIT_EXPECT_EQ(test, seq_buf_puts(&t, "bcdefghij"), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&t));
+
+	/*
+	 * Check the buffer before seq_buf_str() does: it would write the
+	 * terminator over the last byte itself, hiding whether the copy
+	 * placed one there. The literal's own NUL is the eighth byte.
+	 */
+	KUNIT_EXPECT_MEMEQ(test, buf, expected, sizeof(buf));
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&t), "abcdefg");
+}
+
+static void seq_buf_putmem_partial_overflow_test(struct kunit *test)
+{
+	const u8 data[] = { 1, 2, 3, 4, 5, 6, 7 };
+	const char expected[] = { 'a', 'b', 1, 2, 3, 4, 5, 6 };
+	struct seq_buf s;
+	char buf[8];
+
+	memset(buf, 'X', sizeof(buf));
+	seq_buf_init(&s, buf, sizeof(buf));
+	seq_buf_putmem(&s, "ab", 2);
+
+	/* One byte too many, so the last byte of @data is dropped. */
+	KUNIT_EXPECT_EQ(test, seq_buf_putmem(&s, data, sizeof(data)), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+
+	/*
+	 * Check the buffer rather than seq_buf_str(): seq_buf_putmem() writes
+	 * no NUL of its own, so a short copy leaves a stale byte at the end,
+	 * exactly where seq_buf_str() would then write the terminator and
+	 * hide it.
+	 */
+	KUNIT_EXPECT_MEMEQ(test, buf, expected, sizeof(buf));
+}
+
+static void seq_buf_putmem_hex_partial_overflow_test(struct kunit *test)
+{
+	const u8 data[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+#ifdef __BIG_ENDIAN
+	const char *expected = "0001020304050607 08";
+	static const char expected_raw[] = "0001020304050607 080";
+#else
+	const char *expected = "0706050403020100 09";
+	static const char expected_raw[] = "0706050403020100 090";
+#endif
+	struct seq_buf s;
+	char buf[20];
+
+	/* Stale bytes after the data must not show up in the string. */
+	memset(buf, 'X', sizeof(buf));
+	seq_buf_init(&s, buf, sizeof(buf));
+	KUNIT_EXPECT_EQ(test, seq_buf_putmem_hex(&s, data, sizeof(data)), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+
+	/* Before seq_buf_str() writes the terminator over the last byte. */
+	KUNIT_EXPECT_MEMEQ(test, buf, expected_raw, sizeof(buf));
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
+}
+
 /*
  * Counters for the console that seq_buf_do_printk_test() registers while it
  * runs. Only records carrying the marker are counted, so unrelated kernel
@@ -401,6 +479,9 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_get_buf_commit_test),
 	KUNIT_CASE(seq_buf_putmem_hex_test),
 	KUNIT_CASE(seq_buf_putmem_hex_overflow_test),
+	KUNIT_CASE(seq_buf_puts_partial_overflow_test),
+	KUNIT_CASE(seq_buf_putmem_partial_overflow_test),
+	KUNIT_CASE(seq_buf_putmem_hex_partial_overflow_test),
 	KUNIT_CASE(seq_buf_do_printk_test),
 	{}
 };
-- 
2.55.0

