Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C58F30D3E0
	for <nvdimm@lists.linux.dev>; Sat,  3 Oct 2026 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791041824; cv=none; b=isuWTrJ1o1wsPSCnOB6zytupWc39lz7KZlc1RxHKrkZmFEQ2Ag3unAZKeVQTsEp+PAASlr9xNtR0YwgbJnsTusNKzIJi67aZUlVPeveVi0tlGjyXfiT2oyPnd1gXDl/96+1RhsP7JabA1gu2JilhmQ6m9+CtqwAFK1shq3HE2PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791041824; c=relaxed/simple;
	bh=P+t00OnuGzY0L5xQoewWtaL++U09V2T+k7ZFg5Yjqtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYawimNwemrA+12vCe5vyDK20k589bhE/cJLjd0shihvbwqd4kcVo3vAek/h2aK7F+uoEl68iEtfA0c/P3V4/CccUQTnQ7eDgcYijV42X95OkgE0sMysCRzj6K/E6krIPSHm/aZYYRx7xkd8HlwWDR1045ig0rntYqkbAPeL8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ExrrNucL; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExrrNucL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791041822; x=1822577822;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P+t00OnuGzY0L5xQoewWtaL++U09V2T+k7ZFg5Yjqtw=;
  b=ExrrNucLni4m92ol4u70gyaDESoMNQnLJU/jVg9EbVQPQX6WEpCOArlr
   NMGKkfMHr0nfveNHgnf39/R0S5Wx5iLHY+U1nCyjuk1GlL6G7jfBFbM0I
   Kr3hWAqlTC4o99GfnMculhZe4HmiJF+oyKX3kvnJq0PW3mEmavU+p5+Uq
   u+po83QT3eiULr6Eox6S728SGHVCpiamLLiQCjQdYSfcW9klKnjM6I6Nl
   cSlCz+mQpSAGne1LL4BewCHwuiosmP72lo1sZgw9TQI/0zGz+aJGajfau
   64H51VPYf0IhtnnqO59Ko6Lkd8MVnpYgvBFxtNSM5lbII2+0URlvhd7K1
   Q==;
X-CSE-ConnectionGUID: 79oDunb8ST24OjKB0ojkLw==
X-CSE-MsgGUID: jeJpd6hpQPy+PC/rpVHw6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11924"; a="79338269"
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="79338269"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2026 08:37:01 -0700
X-CSE-ConnectionGUID: RYv1bP9xS7udNAN9jt62PQ==
X-CSE-MsgGUID: 2T49n9CQQDWkG0afqOemkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,138,1787036400"; 
   d="scan'208";a="280207548"
Received: from amilburn-desk.amilburn-desk (HELO localhost) ([10.245.245.78])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2026 08:36:51 -0700
Date: Sat, 3 Oct 2026 18:36:49 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kees Cook <kees@kernel.org>
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
Message-ID: <asEhEe0Urb5Wx7yi@ashevche-desk.local>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003035921.1918874-5-kees@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Oct 02, 2026 at 08:59:10PM -0700, Kees Cook wrote:
> Several strlcat() call sites being converted to seq_buf need behavior
> seq_buf doesn't currently provide. The return from seq_buf_used() is
> not the length of the string in a seq_buf. Once the buffer is full or
> has overflowed it returns the buffer size, which counts the byte that
> seq_buf_str() replaces with the NUL, so a caller that needs the string
> and its length has to call seq_buf_str() and then walk the string with
> strlen().
> 
> Move the termination out of seq_buf_str() into a helper that returns
> where it put the NUL, and add seq_buf_strlen(), which terminates the
> buffer in the same way and returns that offset.
> 
> As discussed in review, don't add WARN_ON() for seq_buf_strlen() and
> drop it from seq_buf_str().
> 
> Add tests comparing seq_buf_strlen() against strlen() of seq_buf_str()
> for empty, appended, truncated, exactly full, and overflowed buffers,
> checking that seq_buf_strlen() alone terminates a full buffer, and
> checking that a zero-sized seq_buf reports an empty string from both
> accessors without touching the buffer.
> 
> Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
> and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.2.0.

...

>  static inline const char *seq_buf_str(struct seq_buf *s)
>  {
> -	if (WARN_ON(s->size == 0))
> +	if (s->size == 0)
>  		return "";
>  
> -	if (seq_buf_buffer_left(s))
> -		s->buffer[s->len] = 0;
> -	else
> -		s->buffer[s->size - 1] = 0;
> +	__seq_buf_terminate(s);
>  
>  	return s->buffer;
>  }

Looking at this again, can't it be rewritten now using _strlen()?

	if (seq_buf_strlen(s))
		return s->buffer;

	return "";

?

...

> +static inline size_t seq_buf_strlen(struct seq_buf *s)
> +{
> +	if (s->size == 0)
> +		return 0;
> +
> +	return __seq_buf_terminate(s);
> +}

(Left for the context to the above.)

-- 
With Best Regards,
Andy Shevchenko


