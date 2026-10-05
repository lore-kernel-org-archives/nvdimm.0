Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145D446BF6;
	Mon,  5 Oct 2026 10:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194722; cv=none; b=YwAY4/9VOacorI0QPFxaJKzeRapQKqaCbSlYVqWpmwvV68AxJexzW+1t7tuvMUBCOwIVssbw3bo+wownd2mrz5o2rMcQqrl/w5W+8+n6Z7lv5xfdLHfV1/s5EL3SG36FOnGsoqHjVRW+2c4WBfLp33iEpBW4tdabIMcoKu5gY5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194722; c=relaxed/simple;
	bh=ZiuGDrdc6aZGtiV36uQBUTDHEKtykfDGsCQ5qvgYNP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rHqTorGPflxXcQ3XNDnblchg9ugeWFTPPq84Je4HwYVCi2yqcX3bUjsqxz169KagF4PDSQzPBvn5GJjwST50j+k1Tqz//ddRt7O5brxw1tw/tvuTqf96EMs/D+7AkHqewYSMy/bVCZX9J1ysSJT3fjaG9QeZMnNc6n6J/7hql1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbdTYaz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbdTYaz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75B21F000FF;
	Mon,  5 Oct 2026 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194712;
	bh=RbmlOi1nGG3+a2z8L1s863EzCm/o39cVEUMyhcapV9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nbdTYaz5G5Vkm8F9hfuQAM0E0M1F5n3QWdYI5CrJ18VVF4g5ez2EotxymSCFYDWME
	 3yDzw+8uah/GcVop/IKDGdRijkxrUpylpwXVIV0YDghdLk4hMtObdGQgLeeXATPvPv
	 ApeEf/6jesqm5R/1nQsZK6bkoweYBvg5XFQOsImy5jyX9SMXxwKlSruYVO45eiN65m
	 MldLiX/5LBwCxjJAsyNWLJbxi0a207TQ7iZCkcYS0S/vCp7PE6y2MDb904rQocX3y+
	 qHaoevr+sVWKgJHJIdYcHCs9tjR7zt/WJTmmAN4gWx/heUF+zEDulsT/4EWQrSBHk4
	 ZWcF8RB/RSCeg==
Date: Mon, 5 Oct 2026 03:05:12 -0700
From: Kees Cook <kees@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: morbo@google.com, akpm@linux-foundation.org, david@davidgow.net,
	pmladek@suse.com, senozhatsky@chromium.org, shuvampandey1@gmail.com,
	rostedt@goodmis.org, corbet@lwn.net, gnoack@google.com,
	willy@infradead.org, mic@digikod.net,
	andriy.shevchenko@linux.intel.com, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, jikos@kernel.org, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
	ihor.solodrai@linux.dev, chleroy@kernel.org,
	u.kleine-koenig@baylibre.com, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, sbhat@linux.ibm.com,
	blum@kernel.org, alison.schofield@intel.com, dave.jiang@intel.com,
	gregkh@linuxfoundation.org, lgs201920130244@gmail.com,
	iweiny@kernel.org, u.kleine-koenig@pengutronix.de,
	vishal.l.verma@intel.com, rdunlap@infradead.org,
	skhan@linuxfoundation.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-k@lists.ozlabs.org, ernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-hardening@vger.kernel.org,
	martin.lau@kernel.org, mason@kernel.org
Subject: Re: [PATCH v4 01/11] seq_buf: Do not print an empty line from an
 overflowed seq_buf_do_printk()
Message-ID: <20261005100502.86b595-kees@kernel.org>
References: <20261003035921.1918874-1-kees@kernel.org>
 <aa721817952d2aff37a77588339c61d5090f1589203451243ed88149bf00f1d5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa721817952d2aff37a77588339c61d5090f1589203451243ed88149bf00f1d5@mail.kernel.org>

On Sat, Oct 03, 2026 at 04:50:50AM +0000, bot+bpf-ci@kernel.org wrote:
> TL;DR: The new KUnit test may fail spuriously, and stop detecting the bug,
> when console_loglevel suppresses KERN_INFO (quiet, loglevel=N) or
> CONFIG_PRINTK=n, since the capture console never sees records.

That's a pointless state to handle: KUnit reports its own results at
KERN_INFO, so with a console that hides KERN_INFO, or with printk
compiled out, all of KUnit is unusable, not just this test.

-Kees

-- 
Kees Cook
