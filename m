Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F40450F2;
	Sat,  3 Oct 2026 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791002043; cv=none; b=KnCERuzadMNQu5B5GQ/4ShdFtM8O9SW5HzSsZT5tpT+HiIvoWx9n0NrTao2ksWUQedy09OwF9HJh6yKzYbIe7y+8Et8x8oWv4zgBSOLa1uE3nS3K5DQJcucsy8L1B4MGnpj3xZhLA086QRhK53mPSIN5g7blE9D4gkq4IEVmgDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791002043; c=relaxed/simple;
	bh=zGsMMCFnuZoFawv7/XTqHVMWITtkX2O6G8xrb12kjxs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=CnE0kVGkNNBTUtK5EWrW/xJEH42blNe62YWDLfMHsFRLhnPXpzX8rskK1tHXMUMe3rNWaNHqmF6xwDwuaTGce6yCi9nFOf4+6A4RNuAc/kB4iQs2s3bIE0KI8N2RfGLeWomfqksiLdL+Iw/KVGOGH69+sTNzkQIEpY5Cg9GVQ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMZBO/0C reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMZBO/0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2089C1F000FF;
	Sat,  3 Oct 2026 04:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791002041;
	bh=T5WqpPkABYIUr+bdw9uNCeIvTTslukdoECjwAYUP7k8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=CMZBO/0C5xeumMuL3ncSkFagppcPpT5dOBjyZc+U25dEpLF/06r0ZRaHPXYDLuqD6
	 SNcQRLrq+gVgrsRiZKbdWdUuby/voNjj10L7uz5SMzAVj3vpKVOtP/p6BjKY5bgDGa
	 mKbfI1DXTb4RaywucblX8VTCk2IVBVBv32LzbGlrHmPLImUMnup8WdULwUFxyR7b3S
	 xU4XPlOThF3RXjVJfDS3SprBoad763bLCItuU1Wu1M6MngY1qY3pbifawvQrozhrgG
	 Dzz5fuCF0GcT9b6O5AIJJsItZDm/UXZINp0EBqrWEbp2sT4jVzKo5EYUNgCqDGWxqH
	 8sGRvF90o/fvg==
Content-Type: multipart/mixed; boundary="===============0675329118283778615=="
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <f3b5a05404cc45b59981e869a0203ed07497f6f6942e6d72cee63b37612b7cda@mail.kernel.org>
In-Reply-To: <20261003035921.1918874-8-kees@kernel.org>
References: <20261003035921.1918874-8-kees@kernel.org>
Subject: Re: [PATCH v4 08/11] seq_buf: Add seq_buf_init_append()
From: bot+bpf-ci@kernel.org
To: kees@kernel.org,morbo@google.com
Cc: kees@kernel.org,willy@infradead.org,akpm@linux-foundation.org,andriy.shevchenko@linux.intel.com,david@davidgow.net,pmladek@suse.com,shuvampandey1@gmail.com,rostedt@goodmis.org,corbet@lwn.net,senozhatsky@chromium.org,gnoack@google.com,mic@digikod.net,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,jikos@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,chleroy@kernel.org,u.kleine-koenig@baylibre.com,maddy@linux.ibm.com,mpe@ellerman.id.au,npiggin@gmail.com,sbhat@linux.ibm.com,blum@kernel.org,alison.schofield@intel.com,dave.jiang@intel.com,gregkh@linuxfoundation.org,lgs201920130244@gmail.com,iweiny@kernel.org,u.kleine-koenig@pengutronix.de,vishal.l.verma@intel.com,rdunlap@infradead.org,skhan@linuxfoundation.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,linux-trace-k
 ernel@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,nvdimm@lists.linux.dev,linux-doc@vger.kernel.org,linux-hardening@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat,  3 Oct 2026 04:33:59 +0000 (UTC)

--===============0675329118283778615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> seq_buf: Add seq_buf_init_append()

TL;DR: Commit message only: it says seq_buf_init() sets the buffer size to 0
via seq_buf_clear(), but it resets the length, not the size. The code is not
reported as buggy.

> seq_buf: Add seq_buf_init_append()
>
> Several strlcat() call sites being converted to seq_buf need behavior
> seq_buf doesn't currently provide. The normal seq_buf_init() always
> sets the new buffer size to 0 via seq_buf_clear(). Code migrating from
> strlcat(buf, ...), which appends to whatever buf already contains,
> can't use seq_buf_init() without discarding that existing content. Add
> seq_buf_init_append(), which preserves the existing contents and positions
> the seq_buf to append after it. A buffer with no NUL within its size
> starts out overflowed, as strlcat() treats it as already truncated.
> Add KUnit tests for behavior coverage.
>
> Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
> and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0.
>
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Co-developed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Kees Cook <kees@kernel.org>

This isn't a bug in the code, but is the changelog accurate when it says
seq_buf_init() "always sets the new buffer size to 0 via seq_buf_clear()"?

seq_buf_init() stores the size it was given in s->size, and seq_buf_clear()
leaves s->size alone.  It only resets the length and terminates the first
byte:

    static inline void seq_buf_clear(struct seq_buf *s)
    {
    	s->len = 0;
    	if (s->size)
    		s->buffer[0] = '\0';
    }

Should the sentence say that seq_buf_init() always sets the length (s->len)
to 0 via seq_buf_clear(), rather than the buffer size?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37096036516
--===============0675329118283778615==--
