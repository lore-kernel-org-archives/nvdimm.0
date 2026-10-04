Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E422411A08
	for <nvdimm@lists.linux.dev>; Sun,  4 Oct 2026 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791102886; cv=none; b=TWt45NKCumVhSgisxcf5AgH8+kBsIrKAdbk1mWnxcxbbeDldeXwiWpZ28U1IFTGjMw0nygtUPbD/v96pADtBhRMBIGUYUgbyC9L2rSJ1Bmc1T5dTZvxMamqG8yWkvvViJNMh5Vc1MbQ8c4DcgiTqNlTjoDRDrTmQLaqK6cE1YPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791102886; c=relaxed/simple;
	bh=Mhi7+Hi041UrB2MzTnYXKOXt0lQgzO82otWdLKr7WgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9F19MeZiPcaLQ4bjsFRt4HGg0G97eo4gmSmzr71euC72QAZlGC1RmlOTmpqNYMFpu44Nsbg4m1RxsfZHle4tB4mMP6ZQ+SCRS4IWutN+naZvusxNl41k2wBCMWVAMI6vxaulKHqhQZtKUp+9lSPBwnwvjGSL75rDbd9gTleVEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SMAXZKsr; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SMAXZKsr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791102884; x=1822638884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mhi7+Hi041UrB2MzTnYXKOXt0lQgzO82otWdLKr7WgI=;
  b=SMAXZKsr7NM6Go6b3A1Mcr+c8U0Z5KCCsY3qjoUO4/0tuLcU1jVaEF0W
   2kk0+U+FKPkRsS2AfiLkCLbQs0stivwfiMQV3bAf8+gw9YnQetdqcDlgH
   e5i9eJAwSDJA6b8BGFH0K4gkjcZo2+vqIh88rkHX/pQnXLLD50M31+wA/
   IOfr+cfD/4FMNh+/DbSO3+AHa8cg5ErXoQlQMlD7oGKIU9LQaXvySu9+b
   tHV+egzUP1OqYT9mr1ZJ2KZakkb/qOknX+YsSpZAMofyqoZtXts8L80ES
   oGHDZUI0OcULIrQRtq3qr0wLWd1iR4I/SDU7WFrnSnzRgqcSK66l0daOt
   A==;
X-CSE-ConnectionGUID: mcVx6VdqTCmBO5rfXIW4yw==
X-CSE-MsgGUID: AutdGkcwQJqPDFAbUr81kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11924"; a="90834722"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="90834722"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 01:34:43 -0700
X-CSE-ConnectionGUID: nrUIyO1XSTCYN10HdI6xtw==
X-CSE-MsgGUID: HOGC8YPlQBeD01aSwPqHdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="275678711"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.100])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 01:34:33 -0700
Date: Sun, 4 Oct 2026 11:34:30 +0300
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
Message-ID: <asIPlnb0noMd33rr@ashevche-desk.local>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202610040023.A3865A6@keescook>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Sun, Oct 04, 2026 at 12:26:39AM -0700, Kees Cook wrote:
> On Sat, Oct 03, 2026 at 06:36:49PM +0300, Andy Shevchenko wrote:
> > On Fri, Oct 02, 2026 at 08:59:10PM -0700, Kees Cook wrote:

...

> > >  static inline const char *seq_buf_str(struct seq_buf *s)
> > >  {
> > > -	if (WARN_ON(s->size == 0))
> > > +	if (s->size == 0)
> > >  		return "";
> > >  
> > > -	if (seq_buf_buffer_left(s))
> > > -		s->buffer[s->len] = 0;
> > > -	else
> > > -		s->buffer[s->size - 1] = 0;
> > > +	__seq_buf_terminate(s);
> > >  
> > >  	return s->buffer;
> > >  }
> > 
> > Looking at this again, can't it be rewritten now using _strlen()?
> > 
> > 	if (seq_buf_strlen(s))
> > 		return s->buffer;
> > 
> > 	return "";
> > 
> > ?
> 
> It could, but I'm vaguely nervous about the difference between
> 	s->buffer[0] == '\0'
> and
> 	.data ""
> 
> i.e. we only force the return of seq_buf_str() to be _not_ just
> s->buffer when s->buffer is weirdly impossible (due to size == 0).
> I'd rather not make all 0-len strings return the .data segment's const
> "" string...

Good point. Perhaps then to add a short note to the kernel doc,
so we won't see patches based on the suggestion like I gave?

-- 
With Best Regards,
Andy Shevchenko


