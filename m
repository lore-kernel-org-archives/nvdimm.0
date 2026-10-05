Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588B14CDA3A;
	Mon,  5 Oct 2026 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791215927; cv=none; b=uKAmB7AdZzEMj/xAfQ7kH0YPf/0hiGzgefXKH24ugtN8JheUqgKYBcrTGubUviSlDn8lTMdimNLNa7ZHGN5yhpPNaXXDAvM7rfFgiiFL6Zt2f7hhltV6cHAvnYTa4L/gxkYRT8FEWFlN956TSEX3M9KhQkclJ/0LcUGmYgHju44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791215927; c=relaxed/simple;
	bh=b4IJqXx+udUexVuL32KrcEb1C/aYXq6Fd7NuBJSyaa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnJ4FFyR3LSLSBiWRHhh4d8Rn+Fy+XGC2lQ/Lgg36PX5maUJGja9F3/PkJRO067TWOr7GpmakRBi1nI3gwm1ma6SOfegn55fbL4GP0UCOojUcXzVqMhwHSFNEYDtu1E5y+nFipJoYaSYafp5xTEmFwWXiomPmnz5Ti+uRbFYru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LF24PVnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LF24PVnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04021F00893;
	Mon,  5 Oct 2026 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791215926;
	bh=unJVs8XKy/ViJvkyFC1zJx/IWmn39RPVHGP+T8Nd3dY=;
	h=Date:From:List-Id:To:Cc:Subject:References:In-Reply-To;
	b=LF24PVnRFhTlc9BEimSTExr9zUlpqrHyxrAGI7xZb/ZfXouE0BCbuO9zcuJ+RBZdF
	 yjoRuFTSMwvI1Ht6xWt/tMJsOlO8nZgrwWDePGsDn0+YsY438uvxaRnwjBDS2H+37x
	 nTSG5Fpy2ERh7+9AbNJtIdfvqrEhlyYcZFmuE02ErrDhiqyqYJjJaR4+Cv5TTevh4U
	 MfMeMSspVc6JWVpoCQhOlEEB8m7p/vh96oV2ehORFdvGBW1VcAgYqnIQi+ruFsOetu
	 ST40EqgKy44/Q0XqKG4whbJGBeuYc59+yMzF2LeMixthMp3KyWpBUEPr5MEZQSYPs7
	 ijRBPuBdWa62w==
Date: Mon, 5 Oct 2026 08:58:45 -0700
From: Kees Cook <kees@kernel.org>
To: Alejandro Colomar <alx+linux-hardening@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Gow <david@davidgow.net>, Petr Mladek <pmladek@suse.com>,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jiri Kosina <jikos@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
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
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 05/11] seq_buf: Add seq_buf_strlen()
Message-ID: <20261005155839.d5d200-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
 <asOKvhT01aNb5-Dg@debian>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asOKvhT01aNb5-Dg@debian>

On Mon, Oct 05, 2026 at 01:34:10PM +0200, Alejandro Colomar wrote:
> > Yeah, reasonable. :) For v5 I've added this to seq_buf_str()'s kernel-doc:
> >
> >  * A zero-sized seq_buf has nowhere to put a NUL, so the empty string
> >  * is returned instead of writing to @s->buffer. Any other seq_buf
> >  * returns @s->buffer, even when it holds an empty string, so callers
> >  * always get their own buffer back.
>
> Are such buffers actually used on purpose anywhere?  Why not keep the
> WARN_ON?

Yes, though not often: the sched_ext debug dump builds a nested per-CPU
seq_buf from seq_buf_get_buf(), which returns a size of 0 once the dump
buffer has overflowed, and it handles that case on purpose (see the
"$s may already have overflowed" comment in kernel/sched/ext/ext.c).

Greg asked about the WARN_ON() in v2[1]: a size that comes from a device
or from userspace would have to be checked before every seq_buf_init(),
or it becomes a crash under panic_on_warn, and an empty buffer can just
hold the empty string. So the accessors do that instead.

[1] https://lore.kernel.org/all/2026091953-cherub-empty-ef35@gregkh/

-Kees

-- 
Kees Cook
