Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F52368D7E;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999963; cv=none; b=aH/Q4QZ9CYFffc1QNPX42+ftfdSSHYD1jpIO8StHoaKq+J9K2avrR5pm3JHEWVKxgldIBYUrEopkeA4XXLH5Ik7CtpVORczOqH0RcE5pCcyN7dznH1F6WgQrJHRRYwhjobi/VTY5dC2SEfjuUQB1hfgTJq7zMrZIj9RGAM2XrI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999963; c=relaxed/simple;
	bh=o5V36NyfVK3hMKB+tbhdWbAituk8g3ITmVsNRW2Bu78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GGMhGoXzDoUVtyfR3+sco5xmDsdY74fPz6BxAhO7tuxgvyz728VQqDmXA96Rtx0/4kexS8Ru3PqeAvSMh5TA9xZPWIBkIhgDoDbB9QwT3kPnXquzRsIGp4jYNgxe0X5btFMsMENNUplFg8wr3S59/6NfP5rTFFJL1gfrlTWO9Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRVgJThu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRVgJThu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA2A1F00893;
	Sat,  3 Oct 2026 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790999961;
	bh=Iz/iiVNpot9SQ40RqImswFHFAvzYEcM0QzTbuF87koc=;
	h=From:To:Cc:Subject:Date;
	b=CRVgJThudtPmKx6F0fS4quTB6ZiwftEwgVcOt/oHDqi+Wn2qlzhoua4NO+MWxwfBC
	 AUkTUiMJAB971ZujH1Qwb77P9vmmtTCavBRXqeD3nBxron5keUmi4osrVSbA9ye4vi
	 xkx7wyrgAisAXoGB4hCq+OFUyvEh0uZIQkHIvrHIOhX4Fn8kxrFCEv5jbzsJGDchpF
	 YLHXfTDd8d8dmQR7xjAnDdeDcCBUBARDhoGYRnSMRocz51A+hxE8TLXwutTCGCP3S+
	 SRPBHGyASdeC/cOIaIyWlmyE6GtduVzcCfdM9VsEnp2ePSNAJsCM6J8CzPNjrmUB4x
	 KgwaXD6h4BXhQ==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
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
Subject: [PATCH v4 00/11] seq_buf: Add seq_buf_strlen()
Date: Fri,  2 Oct 2026 20:59:05 -0700
Message-ID: <20261003035906.too.263-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2797; i=kees@kernel.org; h=from:subject:message-id; bh=o5V36NyfVK3hMKB+tbhdWbAituk8g3ITmVsNRW2Bu78=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHaic49f89dz/sTb7grdS7PYYOekF5J5isN2ulunw+8 +nK1huBHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABN5vYThf2CNoetRRdvahU66 ermb7AoqdxeEHfrHJzBd2e/l4Zs9WxkZ9kmwzppgN1Vy0c6VPYzx5rZBptFpqeecN+7U1fsc+u8 DKwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi,

While working on seq_buf conversions[1], we found there was a need for
seq_buf_strlen() (since calling strlen(seq_buf_str()) would be a waste
of time: seq_buf already knows the length), seq_buf_init_append() (to
start a seq_buf from an existing string buffer), and seq_buf_terminate()
(as there are many callers using seq_buf_str() just for its termination
side-effect). And while implementing that, we found a bunch of other
related things that needed fixing. This is that ever-growing series,
with tests for each fix.

 v4:
  - add trailers from v3
  - 03/11, 04/11: export seq_buf_putmem() and seq_buf_path(), which the
    tests call, so they also build as a module
  - 08/11: start out overflowed when the buffer has no NUL within its
    size, as strlcat() treats it as already truncated (Andy)
  - 09/11: use seq_buf_strlen() for flags_show()'s check whether any
    flag was printed, too (Madhavan)
  - 01/11, 05/11: drop doubled blank lines and re-wrap a declaration in
    the tests (Andy)
  - v3..v4 diff: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/diff/?id=dev/v7.3-rc2/seq_buf/v4&id2=dev/v7.3-rc2/seq_buf/v3
 v3: https://lore.kernel.org/all/20260930235231.out.387-kees@kernel.org/
 v2: https://lore.kernel.org/all/20260919002658.stay.929-kees@kernel.org/
 v1: https://lore.kernel.org/all/20260917002312.i.923-kees@kernel.org/

Thanks!

-Kees

[1] https://lore.kernel.org/all/20260917011359.1585961-1-morbo@google.com/

Bill Wendling (1):
  seq_buf: Add seq_buf_init_append()

Kees Cook (10):
  seq_buf: Do not print an empty line from an overflowed
    seq_buf_do_printk()
  seq_buf: Do not pop from an overflowed seq_buf
  seq_buf: Copy what fits when seq_buf_puts() and seq_buf_putmem()
    overflow
  seq_buf: Clear what a writer did not claim when a seq_buf overflows
  seq_buf: Add seq_buf_strlen()
  seq_buf: Add seq_buf_terminate()
  bpf: Remove dead newline stripping from format_disasm_line()
  powerpc/papr_scm: Return the string length from the sysfs show
    functions
  nvdimm: ndtest: Return the string length from flags_show()
  docs: core-api: Document the seq_buf API

 Documentation/core-api/kernel-api.rst     |   9 +
 include/linux/seq_buf.h                   | 139 +++++-
 include/linux/trace_seq.h                 |   5 +-
 arch/powerpc/platforms/pseries/papr_scm.c |   6 +-
 kernel/bpf/diagnostics.c                  |   8 +-
 kernel/trace/trace_events.c               |   4 +-
 kernel/trace/trace_events_hist.c          |   6 +-
 lib/seq_buf.c                             |  37 +-
 lib/tests/seq_buf_kunit.c                 | 528 +++++++++++++++++++++-
 tools/testing/nvdimm/test/ndtest.c        |   2 +-
 10 files changed, 708 insertions(+), 36 deletions(-)

-- 
2.55.0

