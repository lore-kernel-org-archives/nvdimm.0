Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8195381E8B;
	Sat,  3 Oct 2026 04:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791003058; cv=none; b=kidk4oZNXT20VmWnqe3PgeclsqXPD6g6oGgR6GTU1pMWLTzE6h6CL++nlUjqCNEagiLGqwYwSRcSv1uFRS4AV2xEz/AvdeRXmTDxYjQkAZF/Bq4qJzn1qV/Gp/c2ZpcI0Ol1Q6OSEb6rhwmBc5cM/iQl9FYj3ZX1UFvyewAY4Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791003058; c=relaxed/simple;
	bh=kjKU7+89bPCveBQfGr9a1cpwPUYRuGYqIARXKRlNS78=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=NWSybxTGcgouRnWFdZKWRodbHrRsA7i5g2X6q9pNtNP8o6lPOqspgrpdCtPhF5Y++wfDhbkSeHnAYNTPEIHLY+fUk4V1nC4MsbOZOtwBx0nv4HjsOukHklvVK2+UHjv57DpKLJ2zE4yJAaGw77BBcer4XWgvmgvGfnH/ZWWpB4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUnyV3QB reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUnyV3QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BAF1F00893;
	Sat,  3 Oct 2026 04:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791003056;
	bh=PenZzKVUsHBQAUk3JLxySRbntReL+52z92vu5QXeViY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=EUnyV3QBRImlT9jgI8l+Fggx3kguPA3dB3ANstZiR7khV/HS2WoMeSStsst26peZo
	 saWaacobxVr582dbUJMXxH6kzsLGZGdMoIebKAdBoiTF7twxb/GoIKrwAbWcLSAHlL
	 1eWrUuxT8NKxJ82cP2wbmhHFmYbOuOH7vp69m6i60zd2BJL0BQ6VPWSYnXcBbAudP0
	 fmymmFTOcrMCXo1JOd720RW28g2rIhyKlpWuN9SYQrqp7IRAa1Jp7LYw5IzZXuScDu
	 LpoW2FuuXVL4lUBJRX8hUuCXn9yfwGDhcYz3FvPZ7hhVegClaszA6bHJCKwW6hkwC3
	 qnbLuXdFem5uQ==
Content-Type: multipart/mixed; boundary="===============8462905022815828821=="
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <16e533b0eaa776887626c8ca1358b674b82640913706d4dfeb957de5f90de91b@mail.kernel.org>
In-Reply-To: <20261003035921.1918874-4-kees@kernel.org>
References: <20261003035921.1918874-4-kees@kernel.org>
Subject: Re: [PATCH v4 04/11] seq_buf: Clear what a writer did not claim when a seq_buf overflows
From: bot+bpf-ci@kernel.org
To: kees@kernel.org,morbo@google.com
Cc: kees@kernel.org,willy@infradead.org,akpm@linux-foundation.org,andriy.shevchenko@linux.intel.com,david@davidgow.net,jikos@kernel.org,pmladek@suse.com,shuvampandey1@gmail.com,rostedt@goodmis.org,corbet@lwn.net,senozhatsky@chromium.org,gnoack@google.com,mic@digikod.net,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,chleroy@kernel.org,u.kleine-koenig@baylibre.com,maddy@linux.ibm.com,mpe@ellerman.id.au,npiggin@gmail.com,sbhat@linux.ibm.com,blum@kernel.org,alison.schofield@intel.com,dave.jiang@intel.com,gregkh@linuxfoundation.org,lgs201920130244@gmail.com,iweiny@kernel.org,u.kleine-koenig@pengutronix.de,vishal.l.verma@intel.com,rdunlap@infradead.org,skhan@linuxfoundation.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,linux-trace-k
 ernel@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,nvdimm@lists.linux.dev,linux-doc@vger.kernel.org,linux-hardening@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat,  3 Oct 2026 04:50:54 +0000 (UTC)

--===============8462905022815828821==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> seq_buf: Clear what a writer did not claim when a seq_buf overflows

TL;DR: Commit message only: the claim that seq_buf_path() was "never exported,
unlike the other writers" looks inaccurate, since several other writers are
also unexported. The code and export look correct.

>     seq_buf: Clear what a writer did not claim when a seq_buf overflows
>
>     Using seq_buf_set_overflow() would leave the bytes between "len"
>     and "size" untouched, so if seq_buf_str() is used on an overflowed
>     seq_buf, those bytes may be exposed. For any paths that don't claim
>     partially written bytes, by setting "len = size" before calling
>     seq_buf_set_overflow(), wipe the unclaimed bytes. The seq_buf_puts()
>     and related APIs already claim those bytes now, so only the unclaimed
>     cases remain. A specific example of this was seq_buf_path() which uses
>     d_path() and would write to the tail before discovering it was out
>     of space, and would correctly mark a seq_buf as overflowed, but the
>     path fragment would be left over.
>
>     Clear from len to the end of the buffer in seq_buf_set_overflow(), which
>     every overflow goes through, including seq_buf_commit() with a negative
>     count.
>
>     Add a test that fills a seq_buf, leaves it too little room for a path, and
>     checks that nothing of the path is left in the buffer. The tests run before
>     anything writable is mounted, so it takes its file from shmem.
>
>     seq_buf_path() was never exported, unlike the other writers, so the
>     test failed to link as a module. Export it.
>
>     Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
>     and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0, and the
>     test builds as a module (CONFIG_SEQ_BUF_KUNIT_TEST=m).
>
>     Assisted-by: LLM
>     Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     Signed-off-by: Kees Cook <kees@kernel.org>

This isn't a bug, but is the comparison in "seq_buf_path() was never
exported, unlike the other writers" accurate?

In lib/seq_buf.c the only writers with an export are seq_buf_printf(),
seq_buf_puts(), seq_buf_putc(), seq_buf_putmem() and seq_buf_putmem_hex()
(plus seq_buf_do_printk(), which is not a writer).  seq_buf_vprintf(),
seq_buf_bprintf() and seq_buf_hex_dump() also write into a seq_buf and have
no EXPORT_SYMBOL_GPL().

The reason for the export, that the new KUnit test calls seq_buf_path() and
has to link with CONFIG_SEQ_BUF_KUNIT_TEST=m, looks correct.  Could the
sentence drop the "unlike the other writers" part, for example:

  seq_buf_path() was not exported, so the test failed to link as a module.
  Export it.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37096036516
--===============8462905022815828821==--
