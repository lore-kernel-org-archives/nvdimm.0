Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05E838B7A6;
	Sat,  3 Oct 2026 03:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999968; cv=none; b=kpIbi38UVppsXfvebXFmAlbJugLN8gStYMQ/Van/BpGne3UgWLO1vPeu5o7vKwuyoTkde4rTNE+B/KWsF6KtVe4VB6Bl6+22t2zakxAyMVI1kuQopgYlMf9mjCTJkSguLRCoqFvVesM/SjIyPXhztlH7aqTxuM9CEkq6mDJlHxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999968; c=relaxed/simple;
	bh=qLtnL1zcugdCZ7k2f5owH6NFcJ+HwIDUAHkKxFRjTzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3VNVOzXrONfbvDvPqtErCpbCHqLeoUYA2oF3vRoZRFkrYnWzRarJXbOyyPSOIU9gM7WNAjtWRGgPW+DtTxP57Dtk7Veo925ogIooS4WrSPTj83AFOUod9WjKIfDdfvz6XEXeRdAJAW5zYm9lNuMvzaKHjTSPY7ms24aapDXMB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmXXk7oC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmXXk7oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109391F008AB;
	Sat,  3 Oct 2026 03:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999962;
	bh=vT6DnMwBY+XwQ6aSwUxVvTPJh6+CpecvgsrumKxGDn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmXXk7oClunsZGxVg0LdpLwxBEmS1dKK57/EqG1NCzGo/HBKLnkF+ATtDj1LEWhiL
	 JRzt5u8c4YZ9ac+2rwB+NYvbST7zN7omAYAMfRdLFpmcPA2dLRaCQpI5cvvGZott9c
	 xBh994/qIBf87DnJNnTwbyPKBT6TSn73F+rojOMDNDAfzAboURmN5JBRXDWfm6qpWN
	 NbRH08r8aJSoOGk4A0/dvuhzGEFdsWs3I7bTH/ONxgK1efZuZw7Btq+CVMs3dRGNa1
	 nOiOEe0dj/vIholrDWLDdbCqdLNSK6r5Z64A9lGxJXTP5JB82E7DJ1UprhuIxcvk2y
	 QwUoisd2am7Dg==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Gow <david@davidgow.net>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
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
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev,
	linux-hardening@vger.kernel.org
Subject: [PATCH v4 11/11] docs: core-api: Document the seq_buf API
Date: Fri,  2 Oct 2026 20:59:16 -0700
Message-ID: <20261003035921.1918874-11-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3434; i=kees@kernel.org; h=from:subject; bh=qLtnL1zcugdCZ7k2f5owH6NFcJ+HwIDUAHkKxFRjTzw=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaqfIMonP55oyd9O3xfyq65u4lc99OHbTaOu6qY/fd a3MWuvL0lHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjARvUiG/ymW89/1/F11Uuor 55LI3fItuhlqp/9NU1XveFIY4bjMazHD/5B9d9sb1kUIzLjYFbXi+J/z5quz+/fccZw1nf1+qKz SOQ4A
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

The kernel-doc in include/linux/seq_buf.h and lib/seq_buf.c documents
the seq_buf interface, but no .rst file pulls either of them in, so none
of it reaches the generated documentation.

Add the missing kernel-doc for seq_buf_clear() and seq_buf_init(), and a
Sequence Buffers section to the kernel API documentation. The static
internal helper seq_buf_can_fit() is left out. Additionally fix
seq_buf_hex_dump() indentation to avoid the reported Sphinx error:

  ERROR: Unexpected indentation.
  WARNING: Block quote ends without a blank line; unexpected unindent.

Verified with "make SPHINXDIRS=core-api htmldocs", which rendered
happily into core-api/kernel-api.html.

Assisted-by: LLM
Co-developed-by: Bill Wendling <morbo@google.com>
Signed-off-by: Bill Wendling <morbo@google.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 Documentation/core-api/kernel-api.rst |  9 +++++++++
 include/linux/seq_buf.h               | 12 ++++++++++++
 lib/seq_buf.c                         | 13 +++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index 4c4a57c1c094..f5a0aedbbb48 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -96,6 +96,15 @@ Error Pointers
 .. kernel-doc:: include/linux/err.h
    :internal:
 
+Sequence Buffers
+----------------
+
+.. kernel-doc:: include/linux/seq_buf.h
+   :internal:
+
+.. kernel-doc:: lib/seq_buf.c
+   :no-identifiers: seq_buf_can_fit
+
 Sorting
 -------
 
diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 50b1e78eeea6..c97dd9b0ba53 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -31,6 +31,10 @@ struct seq_buf {
 		.size = SIZE,				\
 	}
 
+/**
+ * seq_buf_clear - reset the seq_buf to be read / appended from the beginning
+ * @s: the seq_buf handle
+ */
 static inline void seq_buf_clear(struct seq_buf *s)
 {
 	s->len = 0;
@@ -38,6 +42,14 @@ static inline void seq_buf_clear(struct seq_buf *s)
 		s->buffer[0] = '\0';
 }
 
+/**
+ * seq_buf_init - initialize a seq_buf
+ * @s: the seq_buf handle
+ * @buf: pointer to the buffer
+ * @size: total size of @buf
+ *
+ * The contents of the buffer are ignored.
+ */
 static inline void
 seq_buf_init(struct seq_buf *s, char *buf, unsigned int size)
 {
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 8da2e9447adf..54b76044e4ba 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -409,12 +409,13 @@ int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, size_t start, int cnt)
  *
  * Function is an analogue of print_hex_dump() and thus has similar interface.
  *
- * linebuf size is maximal length for one line.
- * 32 * 3 - maximum bytes per line, each printed into 2 chars + 1 for
- *	separating space
- * 2 - spaces separating hex dump and ASCII representation
- * 32 - ASCII representation
- * 1 - terminating '\0'
+ * linebuf size is maximal length for one line::
+ *
+ *	32 * 3 - maximum bytes per line, each printed into 2 chars + 1 for
+ *		 separating space
+ *	2 - spaces separating hex dump and ASCII representation
+ *	32 - ASCII representation
+ *	1 - terminating '\0'
  *
  * Returns: zero on success, -1 on overflow.
  */
-- 
2.55.0

