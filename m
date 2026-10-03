Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A54A337BAB;
	Sat,  3 Oct 2026 04:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791003054; cv=none; b=nNVE0OSN7Ljzf+LKiWijWIyG1pnxaEYrWzssQ5kT5SOgrvfdIT/C3otanZpCcEoxJ1SGoTjQbE+Filnp5QF/PWPdZMXnT/kFCx1+2pOu/9Mt+83ExzddVW0Ogl7+g6vEGZ8+tcdM3gFMcXjzf2wVt9jpBjP24fRfrhEjZc/+rco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791003054; c=relaxed/simple;
	bh=KF5QQQ9RPSVhSfzH8r6fMmA1Wl6ZokjNOwHXb/s/NYk=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=UWRtW6pCkYoVhu0SR6mt5j2e5x4WcvRKMALwesas89T8jy4L57ZbLJLpgDhU74sd7wVwI0So6d5bNb/BbqCKM4bepHhiS1fHKo3L+cWsUoUY9QQtqeWK2yvZDUnD05zYOMMVb3417hv9jRwJAj9kfCez34r4Yva0dsSi2qytqF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TC7nbRqN reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TC7nbRqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BE41F000FF;
	Sat,  3 Oct 2026 04:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791003052;
	bh=DLY7CkY5wWyEZxB66xjOMvgruHX/vgpHJc67oiGl934=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TC7nbRqN4mkHtTgxgpRmcrs+K+wR41ucNCI5+7e4WAy2xtpM4tgDSmHb8ueMOYqs9
	 aeJFga694eL4FspHB/IT8HFlY7zXJy4RIQmsOtG+zlRDaaCuqM/vGlk9eQjdba3F98
	 dfXZ7TZNJvq3KuKbAHj/RPjdYS0fyVevOkLTFlfk4jM5t5wj0KZrF2ikX1JuFkc7R9
	 /xWOEILr3V7436sCd13S3j+5bpjCu/GxDIO1PSwynldmWz9rmkO+Yx93sn86qGJ/Vz
	 klOAjH7MnCbgGgdJgZRitgrL1x3/IohTAlcMv0laQgrt2vS4je+nHlPAWrOgaclw9W
	 YJtEoNwqlc8KQ==
Content-Type: multipart/mixed; boundary="===============4908982598732312440=="
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <aa721817952d2aff37a77588339c61d5090f1589203451243ed88149bf00f1d5@mail.kernel.org>
In-Reply-To: <20261003035921.1918874-1-kees@kernel.org>
References: <20261003035921.1918874-1-kees@kernel.org>
Subject: Re: [PATCH v4 01/11] seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()
From: bot+bpf-ci@kernel.org
To: kees@kernel.org,morbo@google.com
Cc: kees@kernel.org,akpm@linux-foundation.org,david@davidgow.net,pmladek@suse.com,senozhatsky@chromium.org,shuvampandey1@gmail.com,rostedt@goodmis.org,corbet@lwn.net,gnoack@google.com,willy@infradead.org,mic@digikod.net,andriy.shevchenko@linux.intel.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,jikos@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,chleroy@kernel.org,u.kleine-koenig@baylibre.com,maddy@linux.ibm.com,mpe@ellerman.id.au,npiggin@gmail.com,sbhat@linux.ibm.com,blum@kernel.org,alison.schofield@intel.com,dave.jiang@intel.com,gregkh@linuxfoundation.org,lgs201920130244@gmail.com,iweiny@kernel.org,u.kleine-koenig@pengutronix.de,vishal.l.verma@intel.com,rdunlap@infradead.org,skhan@linuxfoundation.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,linux-trace-k
 ernel@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,nvdimm@lists.linux.dev,linux-doc@vger.kernel.org,linux-hardening@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat,  3 Oct 2026 04:50:50 +0000 (UTC)

--===============4908982598732312440==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()

TL;DR: The new KUnit test may fail spuriously, and stop detecting the bug,
when console_loglevel suppresses KERN_INFO (quiet, loglevel=N) or
CONFIG_PRINTK=n, since the capture console never sees records.

> diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
> index eb466386bbef..0934dfb602ff 100644
> --- a/lib/tests/seq_buf_kunit.c
> +++ b/lib/tests/seq_buf_kunit.c

[ ... ]

> +static void seq_buf_printk_run(struct console *capture, struct seq_buf *s)
> +{
> +	seq_buf_printk_marked = 0;
> +	seq_buf_printk_empty = 0;
> +	seq_buf_printk_last_was_ours = false;
> +
> +	/*
> +	 * register_console() will not take an unmatched console without
> +	 * CON_ENABLED, and unregister_console() clears it, so set it on
> +	 * every run to keep the test repeatable.
> +	 */
> +	capture->flags = CON_ENABLED;
> +	register_console(capture);
> +	seq_buf_do_printk(s, KERN_INFO);
> +	unregister_console(capture);
> +}

Does this test depend on console_loglevel being above LOGLEVEL_INFO?

The records are printed at KERN_INFO, and a legacy console only gets a record
through console_emit_next_record(), which calls printk_get_next_message()
with may_suppress set.  That function skips any record for which
suppress_message_printing() is true:

    static bool suppress_message_printing(int level)
    {
            return (level >= console_loglevel && !ignore_loglevel);
    }

A skipped record just advances con->seq and ->write() is never called.

With console_loglevel <= 6, seq_buf_printk_capture() never runs and
seq_buf_printk_marked stays 0, so these expectations in
seq_buf_do_printk_test() fail:

    KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 1);
    KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 2);
    KUNIT_EXPECT_EQ(test, seq_buf_printk_marked, 1);

The seq_buf_printk_empty checks would still pass in that setup, so the test
would also stop detecting the bug it was written for.

CONFIG_CONSOLE_LOGLEVEL_QUIET is 4 when "quiet" is on the command line.  A
loglevel=N boot argument, dmesg -n, or a kernel.printk sysctl that lowers the
console level has the same effect, and some distributions lower it by
default.  With CONFIG_SEQ_BUF_KUNIT_TEST=m this would report a failure.  The
same happens with CONFIG_PRINTK=n, where printk() is a no-op and
SEQ_BUF_KUNIT_TEST depends only on KUNIT.

The kunit.py qemu and UML runs would not notice, since they do not lower the
loglevel.  The later commits in this series still call
seq_buf_do_printk(s, KERN_INFO) unchanged.

Would it make sense to use a level that is not filtered, call kunit_skip()
when console_loglevel would suppress KERN_INFO, or read the records back from
the printk ring buffer instead of a console?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37096036516
--===============4908982598732312440==--
