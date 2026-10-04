Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934CC1D6DA9;
	Sun,  4 Oct 2026 07:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791098803; cv=none; b=QARK3jehm3+F+AZM2AMwmpJpp5JzocVl7wtcyfugqaruTZK8XO69Jg6nvW8d9Ym7D3YfSQgeFogbuSoAEARkT0AXTMLXJY5g50ofdpuY6b6V5dke9Dt1pr5bFCYA5ScKBeeBCBOOIkjwc3SppPD7/iAqQ4TA6dTRgF+oQdFQPRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791098803; c=relaxed/simple;
	bh=VHq+Xt/JtwMsfGBSvjM3m1W1JPpNGES8AGlkxECeziU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJRqkrkty2KwxMmC/wyRJsWwdEJ6DXEKELavP/3ame5UiNWdvhKb0QSlxLn42yFg7CIIxw+FsnC32PyOHiTsSw+oKocRY5h9ApULC03UODwkR6P80L8JPfDCsgnOvm1Yd2uSbMKskI4Kjst5bwCDf20tH+AhTciquf5HTLnyBbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nU5ReT3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nU5ReT3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761B31F000FF;
	Sun,  4 Oct 2026 07:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791098799;
	bh=cgIqnoufaHq6AdaBd0wZxGfVHkwrfWk/BsoFED6yW28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nU5ReT3jHCTKrC3vFlt6lFhBY2qzd5TcweumZDdG4PoYUxRdUjykUFoBgFNWA1PjY
	 T9Yu+RIKP64tp84D9IUIBtDjfeFi3o967G8MkqSZgLs5zg6QgwCaZo2Pxoykxskztl
	 biV5O05MJfDy50y8GDgflF67Yd7yP+x3fcZ/CTySFwAWfFHWKch8vNf6E6pnkc8Req
	 OzpDMqE/uOHVQp8wJMzmgk75NkJ+Q6sBYYfXWMn9gwMNio09Jz0A1FkvjaPxByIoTx
	 USuuhCbzR7WCiikqNFCVjzo7VO44aK7kcE+i2spiWR4WgjRoXKk74e4z7OK8rvjehn
	 Jk/eIKWbHt2nQ==
Date: Sun, 4 Oct 2026 00:26:39 -0700
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>,
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
Message-ID: <202610040023.A3865A6@keescook>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asEhEe0Urb5Wx7yi@ashevche-desk.local>

On Sat, Oct 03, 2026 at 06:36:49PM +0300, Andy Shevchenko wrote:
> On Fri, Oct 02, 2026 at 08:59:10PM -0700, Kees Cook wrote:
> > Several strlcat() call sites being converted to seq_buf need behavior
> > seq_buf doesn't currently provide. The return from seq_buf_used() is
> > not the length of the string in a seq_buf. Once the buffer is full or
> > has overflowed it returns the buffer size, which counts the byte that
> > seq_buf_str() replaces with the NUL, so a caller that needs the string
> > and its length has to call seq_buf_str() and then walk the string with
> > strlen().
> > 
> > Move the termination out of seq_buf_str() into a helper that returns
> > where it put the NUL, and add seq_buf_strlen(), which terminates the
> > buffer in the same way and returns that offset.
> > 
> > As discussed in review, don't add WARN_ON() for seq_buf_strlen() and
> > drop it from seq_buf_str().
> > 
> > Add tests comparing seq_buf_strlen() against strlen() of seq_buf_str()
> > for empty, appended, truncated, exactly full, and overflowed buffers,
> > checking that seq_buf_strlen() alone terminates a full buffer, and
> > checking that a zero-sized seq_buf reports an empty string from both
> > accessors without touching the buffer.
> > 
> > Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
> > and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0.
> 
> ...
> 
> >  static inline const char *seq_buf_str(struct seq_buf *s)
> >  {
> > -	if (WARN_ON(s->size == 0))
> > +	if (s->size == 0)
> >  		return "";
> >  
> > -	if (seq_buf_buffer_left(s))
> > -		s->buffer[s->len] = 0;
> > -	else
> > -		s->buffer[s->size - 1] = 0;
> > +	__seq_buf_terminate(s);
> >  
> >  	return s->buffer;
> >  }
> 
> Looking at this again, can't it be rewritten now using _strlen()?
> 
> 	if (seq_buf_strlen(s))
> 		return s->buffer;
> 
> 	return "";
> 
> ?

It could, but I'm vaguely nervous about the difference between
	s->buffer[0] == '\0'
and
	.data ""

i.e. we only force the return of seq_buf_str() to be _not_ just
s->buffer when s->buffer is weirdly impossible (due to size == 0).
I'd rather not make all 0-len strings return the .data segment's const
"" string...

-- 
Kees Cook
