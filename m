Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5F82C15BB;
	Sat,  3 Oct 2026 04:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000338; cv=none; b=Mam0uGPoqaLJkNglZuWrNZTltAWS8td2xq88kEjK66eJ0n1C/pBxNNabaYh5io/cJPXYbC9Enkif0WObjCDO6RTOm0L2atnffngMRA1W3JmDTjB6KaENAdtRdTFU5Bmy1O0OBMZRY3FLlwx4qr+2ELT6GpqhZWjsW8jozfboI6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000338; c=relaxed/simple;
	bh=wm1LymwVT7XBEhPIohKLWSTsucHcXXNM8AgElJuJEEU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MpqW4HnT8zp9IomiEaaSknaxkhYbdEQ/tvh7X4hF/D2owXliYhDaw5d58blXSRQFTM/dfIbeRhDVCP9QNes48qwr5zpzo/pf4se0Lqz9bqCJeEWbLDKhazQuTBri0BcbL8TccQ6eENP+7OANbOENGSunMl7uxHEXoOyQ8Mxzw30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoyBTaO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoyBTaO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986051F000FF;
	Sat,  3 Oct 2026 04:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000336;
	bh=wm1LymwVT7XBEhPIohKLWSTsucHcXXNM8AgElJuJEEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LoyBTaO+HjW/NjlesA3BeZ3f3BcOeW6Izczv93Kcy4rUrcLZUr8C1InZPPbJPlqS/
	 QodB22yT6Uv7kOTxcTDXrcDCycOSDsdQq6fMYfzexJEkEGVWs36reFzHS2NyVjYxoR
	 XqhUZh04gZWrlquXIXUehwwzVyUnRA8z19k40w+/dQrflJB+msWsMYIlcTp7vX83Jy
	 qsLtvL4t10WHzsRzug3aEKjOmeFTVZOWldCrahTlLGvyu9hMETWGBQW+R8dGig+kpk
	 o0C1VxOhiiMFV3JZSoLONtAElVHfb68vV23lxCd/eJZbepgaJWIihRhp9CKGAvgoJ9
	 fbMGKh4JHmiGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/11] seq_buf: Do not pop from an overflowed seq_buf
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: nvdimm@lists.linux.dev, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261003035921.1918874-2-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-2-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:05:36 +0000
Message-Id: <20261003040536.986051F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> When a seq_buf has overflowed, its len is size + 1, so seq_buf_pop()
> decrements len to size and reads buffer[size], one byte past the end of
> the buffer. It also leaves len equal to size, which no longer counts as
> overflowed, so a truncated seq_buf then looks like a complete, full one.
>=20
> An overflowed seq_buf logically has no last character to pop: the
> length of what was written has been lost, and the last byte of the
> buffer may be the NUL written by vsnprintf() or bytes that were never
> committed. Return -1 for an overflowed seq_buf, as for an empty one,
> and leave it overflowed, as the rest of the seq_buf API does until
> seq_buf_clear() or seq_buf_init().
>=20
> The current callers do not reach this, e.g. trace_syscalls only calls
> trace_seq_pop() when the trace_seq it pops from has not overflowed, and
> kernel/bpf/diagnostics.c sets the length from strnlen() before popping.
>=20
> Add tests for the pop corner cases.
>=20
> Tests passed under qemu on ARCH=3Dx86_64 with GCC 16.2.0 and CONFIG_KASAN=
=3Dy,
> and on big-endian ARCH=3Ds390 with GCC s390x-linux-gnu 16.1.0.
>=20
> Fixes: 32e0f607ac6a2 ("tracing: Add trace_seq_pop() and seq_buf_pop()")
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D2

