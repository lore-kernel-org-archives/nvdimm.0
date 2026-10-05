Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAED2386426;
	Mon,  5 Oct 2026 10:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194784; cv=none; b=s/B6ctdLimoIbkkVD6m+O1//I0RxaSRPZcxb7i2QjJDFVQ7eSkzebHN4WxwhFDn/FAhtPE21DAenZRkiFuYlAlF5Yulh10qPSZyajl36ez+gMTdl4w/mAxDfhh/7ErEGrNOfzLOMUZeviifr/QWgtNvBVkacq4D2vTSId55cXIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194784; c=relaxed/simple;
	bh=nTD0Xkee+BQdx1eflaB0JEr7XyCJv7GSy5Qt/SmQHNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MoJhBlteMu5uCQolJ2kHs26gwmHuqFhoe4F42q8/tIZaw8n4UVKG5O/aPTSlkkrXLYrDpIDWoMsQoiaGQZOV9gHmSONEDNHuzt1ODWhB6VphNR6mAlBNc3hJOk3BD3sq7rNLnDbX1PorqskYeo2ae6b7vEgKuuqw+0KD32wyqaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9Vw8OX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9Vw8OX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8463A1F000FF;
	Mon,  5 Oct 2026 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194782;
	bh=lAhDeLm001y8d2rTQ8LrJKpRoIPXeBeu9XYjdt9WEUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U9Vw8OX0iqlkEMKheLqMbvkJ/ddL3ZMGgKrclUymrHHKsSYX1RAEB1YoHNpGaKitZ
	 BFRlYdQ/V6EFB5LJLlqznpli7kI4tcWfKAspzsDdUlxMDxEJ3ZLrcBqhX6sipMKumj
	 BNFHZfwPypV8prDEsa872iyraShZdLQ5/bjwsAdmhauoNpoBqQjHWbXl9bYxxNlOAw
	 hik6sGI7lAHCBsiLayC/uwuOL02m3h3xLVwKk1HXPVu4Gk7xSvj4iDVH/L0aOu5FDs
	 gBSsL7xVIemQlDbtmdU2J6dJLATMj8KB/9LemNVyps/fPA6dgebPfWCmLcSRUTQJ0p
	 9g/ceZ2N8tpIw==
Date: Mon, 5 Oct 2026 03:06:22 -0700
From: Kees Cook <kees@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: morbo@google.com, willy@infradead.org, akpm@linux-foundation.org,
	andriy.shevchenko@linux.intel.com, david@davidgow.net,
	pmladek@suse.com, shuvampandey1@gmail.com, rostedt@goodmis.org,
	corbet@lwn.net, senozhatsky@chromium.org, gnoack@google.com,
	mic@digikod.net, mhiramat@kernel.org,
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
Subject: Re: [PATCH v4 03/11] seq_buf: Copy what fits when seq_buf_puts() and
 seq_buf_putmem() overflow
Message-ID: <20261005100616.d111aa-kees@kernel.org>
References: <20261003035921.1918874-3-kees@kernel.org>
 <d56cb11faf507e24e879644226fdd67d0191840f3ed43153577f5f6ae6854236@mail.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d56cb11faf507e24e879644226fdd67d0191840f3ed43153577f5f6ae6854236@mail.kernel.org>

On Sat, Oct 03, 2026 at 04:50:58AM +0000, bot+bpf-ci@kernel.org wrote:
> Can this break callers that rely on seq_buf_puts() dropping a string whole
> when it does not fit?

Yes, good catch; lpfc does. For v5 there's a new patch ahead of this one
that has lpfc_rx_monitor_report() print each record with
seq_buf_printf() and, when one doesn't fit, end the string where it
began, so its debugfs output still stops at the last whole record.

I've checked all the other users of seq_buf_puts() and didn't find any
other cases like this.

-Kees

-- 
Kees Cook
