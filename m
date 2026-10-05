Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB947D464;
	Mon,  5 Oct 2026 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200073; cv=none; b=SNdIMeAtzYd5zWgN9Zf4h2WkVjBqQR05k5agGrxUawTakPgezIdWKUyQ6RXTA94YdPOqVFgUJBEG1+if9doQ24aOOYPj76r+cyG7l9oQQNNZf+109ggR4NZsJllX5TtQ4c6HKdu7ECXSyiIgkz0U/Mz22I2TIlrwyd0gQMMV17A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200073; c=relaxed/simple;
	bh=x95OJZDeN7HUJFiDjGCDLmLH9bfSUJZaYCRFuBjNy+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAdwdTP//V08TqfzI4V/RWlyG4pP/tMFe9ahJQiNGv4zfmS8ipUab5nfpR2+vFfsNMSHixV6p3fwFX4u/jS6EoGCtanI7Ahjryz5uS4SRYSO3FVdljiQyZCfiYfF/h+xiPnpURvlsE4wvgA3Owt3nbzXB8HgCs8etSxJ2q5K92A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGu7cFHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGu7cFHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592031F000FF;
	Mon,  5 Oct 2026 11:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791200072;
	bh=GfHzSlHJ8UI5Oxtdm8BU7e9P310nmqwzsr8Vwb26i2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LGu7cFHiLoleVxKaNXEWg3+hk4n4alCXvLuprPWQEhjOKkys62HeJhx/UbENV031V
	 vIn/6TtJtxJ4vVZb9rnXmiywGirW0RgkjvnuB58tASjcVtU6wkVSS2shU+C/HAHFbp
	 KlgEOWVTWGCe7lgJrWwgepyszO2dtI/ANUif+WUxrjQTe62Dep2+QJVwl3tBvdSTPQ
	 8tdIKlDYRdYPxPlJ1II3h6zxg0tiajgIXcEHp0czbPWMG/jqrvSNQIebFQEBDguOoU
	 zgLw8YhUIYuFxKCCDsOuzd1eZh0m0cOUc1RtREjfI7QsJ5nwq45p57p9GTKfZsiN69
	 fwUMLC3DnyLNg==
Date: Mon, 5 Oct 2026 13:34:10 +0200
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Bill Wendling <morbo@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Gow <david@davidgow.net>, Petr Mladek <pmladek@suse.com>, 
	Shuvam Pandey <shuvampandey1@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Jonathan Corbet <corbet@lwn.net>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jiri Kosina <jikos@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, 
	Thorsten Blum <blum@kernel.org>, Alison Schofield <alison.schofield@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Guangshuo Li <lgs201920130244@gmail.com>, Ira Weiny <iweiny@kernel.org>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 05/11] seq_buf: Add seq_buf_strlen()
Message-ID: <asOKvhT01aNb5-Dg@debian>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261005112209.1e47fa-kees@kernel.org>

Hi Kees, Andy,

> Date: 2026-10-05 04:22:15-0700
> From: Kees Cook <kees@kernel.org>
>
> On Sun, Oct 04, 2026 at 11:34:30AM +0300, Andy Shevchenko wrote:
> > On Sun, Oct 04, 2026 at 12:26:39AM -0700, Kees Cook wrote:
> > > I'd rather not make all 0-len strings return the .data segment's const
> > > "" string...
> >
> > Good point. Perhaps then to add a short note to the kernel doc,
> > so we won't see patches based on the suggestion like I gave?
> 
> Yeah, reasonable. :) For v5 I've added this to seq_buf_str()'s kernel-doc:
> 
>  * A zero-sized seq_buf has nowhere to put a NUL, so the empty string
>  * is returned instead of writing to @s->buffer. Any other seq_buf
>  * returns @s->buffer, even when it holds an empty string, so callers
>  * always get their own buffer back.

Are such buffers actually used on purpose anywhere?  Why not keep the
WARN_ON?


Have a lovely day!
Alex

> 
> -Kees
> 
> -- 
> Kees Cook
> 

-- 
<https://www.alejandro-colomar.es>
