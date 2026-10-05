Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8422AE65;
	Mon,  5 Oct 2026 11:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199337; cv=none; b=tlFEqoppe93eQ2gdDhAVGXT3hSKAHDEvESP6c77y0nvjtftuhN6Gr1QNFPfaACjm2q6In2d3QrwiZXInMNgEwMc6qARZeS2qGCWgkrmM5EaVyCNx0MUPUPtpVhnUnSaIJi94ztQqMC6IGEpmuk+1NoX0EqYVffIwu8eChuZbxdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199337; c=relaxed/simple;
	bh=PJsoRRt69vasCHp1KnmhjyOMsfFhuS565W12waJqkX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViM3uk4s9GPCF7TMBElldKaYcXhajX/rU1R4tEqcz8dtCcgJTs+KzRwUkGH5+XWJAv0MhlEMX2kRS1juYBzdnz259SJ/Ilr8Fpq8GF1l2mxqJxWgTe3vdbh1j5qJTGcyAbsLCJoRG5hRJKhlDzAwc7ONvQKJfdZmevR3Et1rjRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuZWN5Us; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuZWN5Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8451F000FF;
	Mon,  5 Oct 2026 11:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791199335;
	bh=+Ur16o5EMFLYs3ii15Ilcb6PLqZ5R/+UrvQP8v8yGf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HuZWN5Us1odcgFzPDx1TIFTAMYvOaGXTqYoEoTbeWe2Om0hHL+qOzldtkgSBWUYZh
	 QCUUJkrhwU+0MTe4I7ItSH1rv/dlyns16z4yuAikMzmF68O3Z9KaxB/LMd5tOBcu4u
	 gL00QF+vSno8AlPdZNroFRYsvR7cqfamI3Yv5UdenzxyytF2m6YmcTY4A6049w3BH3
	 NRQNtQI4WVy+e7ywsjNosabc+4bm9TynYJW0RG579Sf/+2uH2UmUVqWC0Lz3gre1A4
	 KOFyx3X6NZxA7USIyXaeyKqNwwFJO6dhpM1FgdABIWZ0w+42yWAAM7DXAKkAr/h03P
	 WlA/xczcpYn6Q==
Date: Mon, 5 Oct 2026 04:22:15 -0700
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
Message-ID: <20261005112209.1e47fa-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asIPlnb0noMd33rr@ashevche-desk.local>

On Sun, Oct 04, 2026 at 11:34:30AM +0300, Andy Shevchenko wrote:
> On Sun, Oct 04, 2026 at 12:26:39AM -0700, Kees Cook wrote:
> > I'd rather not make all 0-len strings return the .data segment's const
> > "" string...
>
> Good point. Perhaps then to add a short note to the kernel doc,
> so we won't see patches based on the suggestion like I gave?

Yeah, reasonable. :) For v5 I've added this to seq_buf_str()'s kernel-doc:

 * A zero-sized seq_buf has nowhere to put a NUL, so the empty string
 * is returned instead of writing to @s->buffer. Any other seq_buf
 * returns @s->buffer, even when it holds an empty string, so callers
 * always get their own buffer back.

-Kees

-- 
Kees Cook
