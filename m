Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2D23515DD;
	Mon, 12 Oct 2026 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791766592; cv=none; b=enSrSU/U3mhbA/pZ3fb5WsNJ1KH4GHYpVI5ug+ZYqibRWkfkZ6qEubwa68SB7FYjawzOzbYYURYZCv3FYhPVdKq6hPNIGEVgleo83PHL/8ktWCyNTCOTH5IJIF9wqERQhNjtSRaYCAnALMPmA3F1dSjmAdumOMRb+mE0kLJIDrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791766592; c=relaxed/simple;
	bh=fgEYWGJ2o79ZogsVquNbtLGhVkZVUJInYR7e8viFy64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDitourqXx+jK9w4W3SwUwyiUMQ55gfocm/6Y2qJJtogTHAngkBTNh5BDVAlZBc8oJ31i9InerWBcRlpfjcHBfhiHXLtemkQAQwo1nBIAgc3tevPR9KYeysVnAzrE04hXNulGZB7G4cfW+Mv01wkXFJt2rMFqwDcUbEcVCdIezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Srp4lxTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Srp4lxTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FB71F0089B;
	Mon, 12 Oct 2026 00:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791766588;
	bh=hxf53qqklnBrLDOnVa563Rz7Xv1pTGUtJCKz14BmezI=;
	h=Date:From:To:List-Id:Cc:Subject:References:In-Reply-To;
	b=Srp4lxTvswzQGSZurZdIgokznIEj5wyrJNY9T77hd+9PMBPDY7gvvfunlGvn3ilAt
	 c3UqltVrr8pDMp7TpDjaT+8DWh+uNsnVzDM/cCacLNCkmQrqU91rplRALKRe2zQEwJ
	 jMlbkTkanGJ47er7L6/E5P3rPXC8cQsk79+DBESejMhm2sHhgCTx5z2mewZh/Q+eCS
	 F8OdoYFePL+Ri0/RcYD/MmZKZu+FdwiV3IGzDWFNxqUREJ9KJfdvF45vhgPbd5Rpxn
	 5C0t0G6buQIudJ3rTCmzqaMebg7XdlTR/4PYtBXFKymc2w62JaoqVSbDQu81sYb3fr
	 9hXGvCVno8tUA==
Date: Sun, 11 Oct 2026 17:56:27 -0700
From: Kees Cook <kees@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: Alejandro Colomar <alx+linux-hardening@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <20261012005620.466497-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
 <asOKvhT01aNb5-Dg@debian>
 <20261005155839.d5d200-kees@kernel.org>
 <asPSYn7sLqiH39Fu@debian>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asPSYn7sLqiH39Fu@debian>

On Mon, Oct 05, 2026 at 06:43:23PM +0200, Alejandro Colomar wrote:
> > Yes, though not often: the sched_ext debug dump builds a nested per-CPU
> > seq_buf from seq_buf_get_buf(), which returns a size of 0 once the dump
> > buffer has overflowed, and it handles that case on purpose (see the
> > "$s may already have overflowed" comment in kernel/sched/ext/ext.c).
>
> Hmmmm, so IIUC, it is a sentinel value, and not really a buffer size?

It's the real size of what's left. seq_buf_get_buf() hands out the
unused tail of the seq_buf. Once that has overflowed there is no tail,
so it returns NULL for the buffer and 0 for the size, and sched_ext
initializes the nested seq_buf with both. So that case does get the NULL;
the 0 is how much room it has.

> Did you consider not holding the size of the buffer, but rather an end
> pointer?  It also allows you to find how much you can write to the
> buffer, but has slightly better semantics: the end doesn't change if you
> advance the position.  'end' can only change through reallocations
> (which I don't know if you do in the kernel).

The size doesn't change either: it is set by seq_buf_init(), and writers
advance "len", an offset from the start of the buffer. seq_buf never
reallocates.

An end pointer wouldn't remove the empty case: buffer == end is the same
condition as size == 0, so the accessors would still need the check. It
also makes overflow harder to record. seq_buf marks it with len == size +
1, and the matching position pointer, end + 1, would be weird.

Changing the representation would also means changes outside
lib/seq_buf.c, since tracing reads seq.len and seq.size directly
(trace_seq treats a zero size as "not yet initialized", for one). I'm
not saying that's a good thing to bypass the API, but rather that such
a change should be its own series.

-Kees

-- 
Kees Cook
