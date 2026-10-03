Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB523812EF;
	Sat,  3 Oct 2026 03:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999967; cv=none; b=uxzNALErJYHaXWutPr/u6apHtaKTA485QRdvvgvqQenUEaInAnNc679XL+21xV+lRqXUhLw38eJwblkWiJulI9A//D8sq+Fc+CsqTsMc8vkVmJLt90llaYDgnzjHDW/LpUA1IR3J/h38+acHyF/6Y2v/5h8J7lPw3F037R4y4PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999967; c=relaxed/simple;
	bh=QMqRTQphegL+YGqZELWHP3PitTraEh7YCZhUt0ueL+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TrOUlyqfZA2jfQprdDEjIFk6oxkR18YsgwQwmR1rP//Su5yibyKfd6Y3i4stnrOotZpQq74YkRQUhvMghGdI4k7rBvqZUJ4Q3iKVXxQQWVcq3R0S9pHjK4jpdwD0iEx+vf27dlBkKsTbygeSz/86esvoupYa6cvRR20hqEl6nko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LytJtbRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LytJtbRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C111F008A1;
	Sat,  3 Oct 2026 03:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999962;
	bh=sf8U9e/P/Ck4Sty1kLYW5Wh5J9iqRhQrRMwhuEB4BRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LytJtbRzVGJ2gB5rSYpjnUmcJ+xxGWASCXwMhF3wA5XiUuOMEkosCvymJLQhlFNfs
	 1TTMLD2EK/4S/cHbZyE5se6S1k+tYmdqOTdG2KAtOgWR+pXYqlexmSa8twP9rvVvrt
	 VYu+wXvwJJuwtvWiyTtwZ3qW/eev//6u22fX9HGF16AjZKB1faH96j/7wcoiaWx8x0
	 kD75F0NM30qpfaoxE96GTf6M9S157++2HP8TF/dajR0TXvzEXzjAeytHg4X4Ti/dI0
	 eV7823ZdWPtTDiZlWPOrzqEaJlwWMudWokHz5vbMcturB6i3ZZySAhMtrnVWhfdGCi
	 uGewx4IfggbDg==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Gow <david@davidgow.net>,
	Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
	nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v4 09/11] powerpc/papr_scm: Return the string length from the sysfs show functions
Date: Fri,  2 Oct 2026 20:59:14 -0700
Message-ID: <20261003035921.1918874-9-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=kees@kernel.org; h=from:subject; bh=QMqRTQphegL+YGqZELWHP3PitTraEh7YCZhUt0ueL+o=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaieba/YzTix0net+z9FNczWD3xSL6Bmfjz+/LZl7o m+b04tNHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABPpfsLI8G+xe2b7uYcnTsoy RjS9/G+lccnp4Baxyqrb+yyP7PS+MZvhr6zjr/+rN3Fs+Hxk+RzO+Ca90weOZTT+Dj607E7Dcs5 4M1YA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

perf_stats_show() and flags_show() build their output with a seq_buf
and return seq_buf_used(), which may include the trailing NUL byte
when the seq_buf has overflowed. Use seq_buf_strlen() instead. As
suggested in review, use it as well for flags_show()'s check whether
any flag was printed.

Build tested ARCH=powerpc ppc64_defconfig with GCC powerpc64-linux-gnu
16.2.0:
arch/powerpc/platforms/pseries/papr_scm.o

Assisted-by: LLM
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 75da96c08cdd..5c3bf06bb59b 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -1108,7 +1108,7 @@ static ssize_t perf_stats_show(struct device *dev,
 
 free_stats:
 	kfree(stats);
-	return rc ? rc : (ssize_t)seq_buf_used(&s);
+	return rc ?: (ssize_t)seq_buf_strlen(&s);
 }
 static DEVICE_ATTR_ADMIN_RO(perf_stats);
 
@@ -1147,10 +1147,10 @@ static ssize_t flags_show(struct device *dev,
 	if (health & PAPR_PMEM_SCRUBBED_AND_LOCKED)
 		seq_buf_printf(&s, "scrubbed locked ");
 
-	if (seq_buf_used(&s))
+	if (seq_buf_strlen(&s))
 		seq_buf_printf(&s, "\n");
 
-	return seq_buf_used(&s);
+	return seq_buf_strlen(&s);
 }
 DEVICE_ATTR_RO(flags);
 
-- 
2.55.0

