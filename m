Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE258171B1;
	Sat,  3 Oct 2026 03:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999968; cv=none; b=SNvhtytDkswXT4kSH3oU7jWcrZ1cuhj2o3hiWPZzedx7bxqe6iLdrZWCE/FcSSvssURvi98BOnm5jtu2XdPCJL0o6z7NFPzLKt4djlTlmaZk2k963X2i8zNZaQzje9cQsuFdp2Ph5wpbaq3rQnRmMzT1d/8pDdJkxc2lPW2plSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999968; c=relaxed/simple;
	bh=eY39Ee90iVfytIwZQ4wwkkecuyCM3GL1BJJRjmfclnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBFSUrJmRKzWeggmvO8CM8zgFcoM//NtiqwUcFqM/bl1B4rlGRkMyfp6dXScaZQZ/4Y3RC4WI4JIM1n3+WINfCwLGnYQJIs4hBZUXPkZtfXcZns0nufrJZXd//uqNRr//LvRR8MwHDuFl35I3LDB266FfpyTT7ZyaaM5/6yi7vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5FYEPVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5FYEPVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB15F1F0089F;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999962;
	bh=WJOH6AQ8tetgnokAWXFnxnkRE5uHEBUR/4+Ytl/n/jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5FYEPVNUiFqWWtq94G7bfbVqkLClYCIEtkyv7o4eoHtZZ//Ri39hKIZtd3Q7jbGK
	 LxKGz96lPn4C9SVmOezL0FMqgm+X7Tk2KNNhw02HccPM9qt1vFWQhmse9aFRtFcKIb
	 OHZbwe+axz0cYjpyjGGSKypvo8oA9/dPVVDtPaBJKIYtRI5R5wUUFSVsNHWojsWrN9
	 pM3MvrqpfCnRrZmTVNgECJlR9b7LFtWkmo37c7sFKbS7us4yJFJkDIQIust7Tao76T
	 A+jlgSStzT9QczqE77XtbkV7R/lWhceiW4+8Kjs5NpU2XiCsZbXbLL0Og1qK3EQhpx
	 SyeqMOSEsb7bA==
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
Subject: [PATCH v4 08/11] seq_buf: Add seq_buf_init_append()
Date: Fri,  2 Oct 2026 20:59:13 -0700
Message-ID: <20261003035921.1918874-8-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5668; i=kees@kernel.org; h=from:subject; bh=ik9iA+b1cAttumuOloxZAmUkMLLeNDkCAUvz7Q3ejlM=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaifX6/Rds12x7tNi20/Gh92mak9323hdue4TS2nP0 n8VM7t2dpSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAEykRIfhf8yWJGdV051bjP7f ib956C53tYL0M6n5L6Orr/6NcVgjHs3wv6aP3zrRM/+BcfvyKdbPvv7Nz0vl+/nPK2lTf6P/Qzc 2RgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

From: Bill Wendling <morbo@google.com>

Several strlcat() call sites being converted to seq_buf need behavior
seq_buf doesn't currently provide. The normal seq_buf_init() always
sets the new buffer size to 0 via seq_buf_clear(). Code migrating from
strlcat(buf, ...), which appends to whatever buf already contains,
can't use seq_buf_init() without discarding that existing content. Add
seq_buf_init_append(), which preserves the existing contents and positions
the seq_buf to append after it. A buffer with no NUL within its size
starts out overflowed, as strlcat() treats it as already truncated.
Add KUnit tests for behavior coverage.

Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0.

Assisted-by: LLM
Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Co-developed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/seq_buf.h   | 25 +++++++++++++++
 lib/tests/seq_buf_kunit.c | 67 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 195e612a212a..50b1e78eeea6 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -71,6 +71,31 @@ seq_buf_set_overflow(struct seq_buf *s)
 	s->len = s->size + 1;
 }
 
+/**
+ * seq_buf_init_append - initialize a seq_buf over a buffer that may
+ *			 already hold NUL-terminated content
+ * @s: the seq_buf handle
+ * @buf: pointer to the (possibly non-empty) buffer
+ * @size: total size of @buf
+ *
+ * Unlike seq_buf_init(), which always starts @buf at len=0, this
+ * preserves whatever NUL-terminated content @buf already holds and
+ * positions @s to append after it. Useful for converting code that used
+ * to append to an existing buffer with strlcat()/scnprintf() and friends.
+ *
+ * If @buf holds no NUL within @size, @s starts out overflowed, as
+ * strlcat() treats such a buffer as already truncated.
+ */
+static inline void
+seq_buf_init_append(struct seq_buf *s, char *buf, unsigned int size)
+{
+	s->buffer = buf;
+	s->size = size;
+	s->len = strnlen(buf, size);
+	if (s->len == size)
+		seq_buf_set_overflow(s);
+}
+
 /*
  * How much buffer is left on the seq_buf?
  */
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index b6fc7b784859..170524146892 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -29,6 +29,72 @@ static void seq_buf_init_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, seq_buf_strlen(&s), 0);
 }
 
+static void seq_buf_init_append_test(struct kunit *test)
+{
+	char buf[32] = "hello";
+	struct seq_buf s;
+
+	/* Initial string contents match. */
+	seq_buf_init_append(&s, buf, sizeof(buf));
+	KUNIT_EXPECT_EQ(test, s.size, 32);
+	KUNIT_EXPECT_EQ(test, s.len, 5);
+	KUNIT_EXPECT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_buffer_left(&s), 32 - 5);
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 5);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hello");
+	KUNIT_EXPECT_EQ(test, seq_buf_strlen(&s), 5);
+
+	/* Appending with space works. */
+	seq_buf_puts(&s, " world");
+	KUNIT_EXPECT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 11);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hello world");
+	KUNIT_EXPECT_EQ(test, seq_buf_strlen(&s), 11);
+
+	/* No truncation when space for NUL is present. */
+	seq_buf_init_append(&s, buf, 12);
+	KUNIT_EXPECT_EQ(test, s.size, 12);
+	KUNIT_EXPECT_EQ(test, s.len, 11);
+	KUNIT_EXPECT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 11);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hello world");
+	KUNIT_EXPECT_EQ(test, seq_buf_strlen(&s), 11);
+
+	/*
+	 * No NUL within the size: the content is already truncated, as
+	 * strlcat() would see it, so @s starts out overflowed. The content
+	 * stays, and appending adds nothing.
+	 */
+	seq_buf_init_append(&s, buf, 11);
+	KUNIT_EXPECT_EQ(test, s.size, 11);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_buffer_left(&s), 0);
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 11);
+	KUNIT_EXPECT_MEMEQ(test, buf, "hello world", 11);
+	seq_buf_puts(&s, "!");
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_MEMEQ(test, buf, "hello world", 11);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hello worl");
+	KUNIT_EXPECT_EQ(test, seq_buf_strlen(&s), 10);
+
+	/*
+	 * The size bounds the scan: the string runs past it, so there is
+	 * no NUL within the size either.
+	 */
+	seq_buf_init_append(&s, buf, 5);
+	KUNIT_EXPECT_EQ(test, s.size, 5);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_buffer_left(&s), 0);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hell");
+
+	/* With no room even for a NUL, @s is overflowed and @buf untouched. */
+	seq_buf_init_append(&s, buf, 0);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 0);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "");
+	KUNIT_EXPECT_EQ(test, buf[0], 'h');
+}
+
 static void seq_buf_declare_test(struct kunit *test)
 {
 	DECLARE_SEQ_BUF(s, 24);
@@ -662,6 +728,7 @@ static void seq_buf_terminate_test(struct kunit *test)
 
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
+	KUNIT_CASE(seq_buf_init_append_test),
 	KUNIT_CASE(seq_buf_declare_test),
 	KUNIT_CASE(seq_buf_clear_test),
 	KUNIT_CASE(seq_buf_puts_test),
-- 
2.55.0

