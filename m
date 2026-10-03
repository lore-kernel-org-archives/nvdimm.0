Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB3E3890F3;
	Sat,  3 Oct 2026 03:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999967; cv=none; b=L+mx0DLPTuitd1JsZ7QMa6ln2iikrxClkuk4/izVzM0S0bLj0DDHe3t+pTLtjozscBEl4sKx73GsUVp9jKAsGMHsynDXdTJzeFR58C/6iimDIhVNWKySIH7UmD4cOosF+Pz/5RZ7cxk2BFTwxhmbbB70VsmVKeh1/Uh1yCwJBKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999967; c=relaxed/simple;
	bh=ABJPjYt7NWFo2zXFUU3mJzXUMXyVzwHTx+55Tm7/WDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuvEprGqbvQNsi86fFmJI0wqCoAJT4yVUWBaSJaXPGvGZddoo7vAubXTXLpNQ5T59tALuoHoQS5WIzmQ/2i6IbWUy/i/zwcr/huPV2Dz1cv2jBct3udxLWUX7Pn736jeS7vOwWgEawoeIODPoezYwwV9g/An5wBYAyD8qCyXoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrQhgPhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrQhgPhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30EE1F00A07;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999962;
	bh=XDlGomlR0yD+DXZBg/pGmMB7mteUfN0wwi+oXTAvHDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrQhgPhcT4Ea7xGuH66p0cd05bW222wqloOtK5Bw8A3JZg89l/dTcmKZUtpt6mXvU
	 wgznY+3X429DHPSFrH/rcxBb22tRGQLwCieL3mvMnNewOd603k+g1uH0trurXrraZf
	 XsLEwtvUR98RjktXcTzkYPBI+G8MdMf5C72q9jGbq/aFEgfCR5sEXtcHVqA9Xkpmir
	 T7kMF9p5k840j33wFShhheD2BqJfUdMs0gxHqZp21hH7hdHQYW3+HjId68lTC/5dt6
	 AepQp10YxJ00mln4wf2e335r6yoJ7CBlA/2TKS2sIvAHcinOu7vJf+BxJEg2jyqetz
	 Fr+2WI1zg2oug==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
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
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	David Gow <david@davidgow.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Jiri Kosina <jikos@kernel.org>,
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
	linux-security-module@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v4 06/11] seq_buf: Add seq_buf_terminate()
Date: Fri,  2 Oct 2026 20:59:11 -0700
Message-ID: <20261003035921.1918874-6-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6401; i=kees@kernel.org; h=from:subject; bh=ABJPjYt7NWFo2zXFUU3mJzXUMXyVzwHTx+55Tm7/WDY=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaidJiBZtarhbxsTEUr/S7PlNgw9Xov1Fj80ziZ7a0 dBaXrCko4SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCImpQzfY3U/yTuGHr3kuO92 TtUVS8b1B51dq1jv7085Je9i5vWA4b/fzfk/ZxfdemO/8aP71i2ui93mnL3ws9M0YvfqxLXO7KI cAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Seven callers call seq_buf_str() only to NUL-terminate the buffer,
discarding the returned pointer. Two of them need a comment to say so.

Add seq_buf_terminate(), wrapping the __seq_buf_terminate() helper that
seq_buf_str() and seq_buf_strlen() already use, and convert those
callers. It returns void: returning the offset would just be
seq_buf_strlen() under another name. A zero-sized seq_buf is left
untouched, as in the other accessors.

Add tests for the three cases: room for the NUL after the data, an
overflowed buffer where it lands in the last byte, and a zero-sized
buffer that must not be written to.

Build tested ARCH=x86_64 defconfig with GCC 16.2.0, plus
CONFIG_HIST_TRIGGERS=y and CONFIG_BPF_SYSCALL=y to reach the converted
call sites in kernel/trace/trace_events_hist.c and
kernel/bpf/diagnostics.c. Tests run 24/24 passing on ARCH=um.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/seq_buf.h          | 23 +++++++++++++++++++++++
 kernel/bpf/diagnostics.c         |  6 +++---
 kernel/trace/trace_events.c      |  4 ++--
 kernel/trace/trace_events_hist.c |  6 ++----
 lib/tests/seq_buf_kunit.c        | 28 ++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 87ccc62f1c62..195e612a212a 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -171,6 +171,29 @@ static inline size_t seq_buf_strlen(struct seq_buf *s)
 	return __seq_buf_terminate(s);
 }
 
+/**
+ * seq_buf_terminate - NUL-terminate the string in a seq_buf
+ * @s: the seq_buf handle
+ *
+ * Terminate @s->buffer exactly as seq_buf_str() and seq_buf_strlen() do,
+ * for callers that want neither the pointer nor the length and only need
+ * the buffer to be safe to read as a C string. A zero-sized seq_buf has
+ * nowhere to put a NUL and is left untouched.
+ *
+ * Nothing is returned on purpose: a caller that wants the length should
+ * use seq_buf_strlen(), which says so.
+ *
+ * After this function is called, s->buffer is safe to use
+ * in string operations.
+ */
+static inline void seq_buf_terminate(struct seq_buf *s)
+{
+	if (s->size == 0)
+		return;
+
+	__seq_buf_terminate(s);
+}
+
 /**
  * seq_buf_get_buf - get buffer to write arbitrary data to
  * @s: the seq_buf handle
diff --git a/kernel/bpf/diagnostics.c b/kernel/bpf/diagnostics.c
index 0abbbe177e31..594cf3c8b74c 100644
--- a/kernel/bpf/diagnostics.c
+++ b/kernel/bpf/diagnostics.c
@@ -351,7 +351,7 @@ static void diag_fmt_restore(struct bpf_verifier_env *env, struct diag_fmt_mark
 
 	if (mark.chunk) {
 		mark.chunk->seq.len = mark.len;
-		seq_buf_str(&mark.chunk->seq);
+		seq_buf_terminate(&mark.chunk->seq);
 	}
 }
 
@@ -631,11 +631,11 @@ static void format_disasm_line(struct bpf_verifier_env *env, int insn_idx,
 		return;
 
 	print_bpf_insn(&cbs, insn, env->allow_ptr_leaks);
-	seq_buf_str(&ctx.seq);
+	seq_buf_terminate(&ctx.seq);
 	ctx.seq.len = strnlen(line->text, sizeof(line->text));
 	while (ctx.seq.len && line->text[ctx.seq.len - 1] == '\n')
 		seq_buf_pop(&ctx.seq);
-	seq_buf_str(&ctx.seq);
+	seq_buf_terminate(&ctx.seq);
 
 	line->valid = true;
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9dbc2441763b..39bb391546de 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -4906,7 +4906,7 @@ static __init int event_trace_enable(void)
 	 */
 	__trace_early_add_events(tr);
 
-	seq_buf_str(&bootup_event_seq);
+	seq_buf_terminate(&bootup_event_seq);
 	early_enable_events(tr, bootup_event_buf, false);
 
 	trace_printk_start_comm();
@@ -4935,7 +4935,7 @@ static __init int event_trace_enable_again(void)
 	if (!tr)
 		return -ENODEV;
 
-	seq_buf_str(&bootup_event_seq);
+	seq_buf_terminate(&bootup_event_seq);
 	early_enable_events(tr, bootup_event_buf, true);
 
 	return 0;
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 963e0d6b61fd..57bd1cd5c657 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2988,8 +2988,7 @@ find_synthetic_field_var(struct hist_trigger_data *target_hist_data,
 	seq_buf_init(&s, synthetic_name, MAX_FILTER_STR_VAL);
 	seq_buf_printf(&s, "synthetic_%s", field_name);
 
-	/* Terminate synthetic_name with a NUL. */
-	seq_buf_str(&s);
+	seq_buf_terminate(&s);
 
 	if (seq_buf_has_overflowed(&s)) {
 		kfree(synthetic_name);
@@ -3106,8 +3105,7 @@ create_field_var_hist(struct hist_trigger_data *target_hist_data,
 	if (saved_filter)
 		seq_buf_printf(&s, " if %s", saved_filter);
 
-	/* Terminate cmd with a NUL. */
-	seq_buf_str(&s);
+	seq_buf_terminate(&s);
 
 	if (seq_buf_has_overflowed(&s)) {
 		kfree(cmd);
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index 569ab3d96f10..b6fc7b784859 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -633,6 +633,33 @@ static void seq_buf_strlen_zero_size_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, buf, "untouched");
 }
 
+static void seq_buf_terminate_test(struct kunit *test)
+{
+	char buf[16];
+	struct seq_buf s;
+
+	/* Terminates directly after the data when there is room. */
+	memset(buf, 'z', sizeof(buf));
+	seq_buf_init(&s, buf, sizeof(buf));
+	seq_buf_puts(&s, "ab");
+	seq_buf_terminate(&s);
+	KUNIT_EXPECT_STREQ(test, buf, "ab");
+
+	/* Terminates in the last byte once the buffer has overflowed. */
+	memset(buf, 'z', sizeof(buf));
+	seq_buf_init(&s, buf, 4);
+	seq_buf_puts(&s, "abcdef");
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	seq_buf_terminate(&s);
+	KUNIT_EXPECT_STREQ(test, buf, "abc");
+
+	/* A zero-sized seq_buf is left alone. */
+	strscpy(buf, "untouched", sizeof(buf));
+	seq_buf_init(&s, buf, 0);
+	seq_buf_terminate(&s);
+	KUNIT_EXPECT_STREQ(test, buf, "untouched");
+}
+
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
 	KUNIT_CASE(seq_buf_declare_test),
@@ -656,6 +683,7 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_strlen_puts_overflow_test),
 	KUNIT_CASE(seq_buf_strlen_embedded_nul_test),
 	KUNIT_CASE(seq_buf_strlen_zero_size_test),
+	KUNIT_CASE(seq_buf_terminate_test),
 	KUNIT_CASE(seq_buf_do_printk_test),
 	{}
 };
-- 
2.55.0

