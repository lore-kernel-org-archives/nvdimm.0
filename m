Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5411441D640;
	Sat,  3 Oct 2026 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791023489; cv=none; b=GCQ0lxT9tBoaVb+wD/PSat9g4SPJWVd/vKn3dgfP/BGa+MjcSBlBxpOHPmSLCHuZn6c7rdQmOKccO7t+dFkTYizjq81iGoFwQkQ3EvERwmomaq8z4YJF75QdIbksNYz98tGEYlq62KtCgHZ7iVuM78qalCfNJg/YM8sRRPv5VuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791023489; c=relaxed/simple;
	bh=ygUoJLCQKFWKOx+5CSMmis9wmbifBrGa+KU1TJomdPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYx3CGATF8Ey92F8+BHEobUvbnReWVpZvJM0qgfSRAc5aK6/h3Lv5rpeccD2iUqv6EFOlNsJEpySqpNXIVtHR4+fSRWWchn18cDhcptqD/r5E7baYiWLq0wEBjJU6qpNpCKhLeBZLwrDkYQTGUyd9etzPe7/fieqJQqfzWfuBM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJubNwg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJubNwg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230911F0089C;
	Sat,  3 Oct 2026 10:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791023476;
	bh=JD1KrrdpLVmHcYg9pYizr+EY3Jnx/IklgTtkuzFE98c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jJubNwg8UjkFZDFCgXganeVccWeCUC64B+nvX/QJCoMYXCR46IeLHcDEoC9WXNkcA
	 5ruXH4DMtVtjhNA3d7Uv9pKe+IwqKHYmShLEdJJbzIpK4vuV9dVpZIJ60E6msg+z9i
	 4ti2IfPt7tuWzkUfzzC3uOvSCdCs+N7Wy58NOZc9wgMz5chltNhTn0TZzkalwkJPMG
	 XYVBwyjFfZ1ZdXt14iY8a8VKJi/DAPbLmvDeLBF1DvlcoMfWEqbZ45BNIbuT/5yazm
	 nRU/EDsrSmIva7nHl/5b7LeLaGnBwdw1GGhmcVLS3nQJaKo9nu1Q/zcaFKDoywybDy
	 to4My81OLjUmQ==
Date: Sat, 3 Oct 2026 03:31:15 -0700
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
Subject: Re: [PATCH v4 08/11] seq_buf: Add seq_buf_init_append()
Message-ID: <20261003103059.9e0b86-kees@kernel.org>
References: <20261003035921.1918874-8-kees@kernel.org>
 <f3b5a05404cc45b59981e869a0203ed07497f6f6942e6d72cee63b37612b7cda@mail.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3b5a05404cc45b59981e869a0203ed07497f6f6942e6d72cee63b37612b7cda@mail.kernel.org>

On Sat, Oct 03, 2026 at 04:33:59AM +0000, bot+bpf-ci@kernel.org wrote:
> This isn't a bug in the code, but is the changelog accurate when it says
> seq_buf_init() "always sets the new buffer size to 0 via seq_buf_clear()"?

Yeah, fair. It's not worded clearly. I've fixed the wording for v5
to say seq_buf_init() 'empties the buffer (sets its "len" to 0) via
seq_buf_clear()'.

-Kees

-- 
Kees Cook
