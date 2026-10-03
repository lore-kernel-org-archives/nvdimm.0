Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F87E384CC2;
	Sat,  3 Oct 2026 04:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000355; cv=none; b=bUw0x63R/MJuzkzbm++cFLv+2oBZ9izsimXQffAvV3myKhPdQZlRs43TRRndRqhP6kru6SuO+gHqIbLK3gBGud2SwgCuNKbdIAgYOy2P+2uwqEQIXTnJRE8DM2cWwkTt71qP8ceXIfB4QYEfyl6QOYzeyBhKIwFiudHDBGwGLYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000355; c=relaxed/simple;
	bh=1x7r3TVIro71cPq24CEGRW7hdiJOUn5htsc+QRVJwCY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QUwbDkV3r65GtSK6MSEwxPiLz4KpUxzLv0jfubtPocCG1c1yCXKGr1G3wq33YZgp6d1OVr54uW2uNC51mmtlC/m5FPDDwL7V9zQv5pxG2X06mWZJf5h/dcppIR8i6lgWWmLFaAkSI9vNxEXPxrTML3p+bx53Ro1CTTlVxIKd94c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksBIGEjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksBIGEjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984D71F000FF;
	Sat,  3 Oct 2026 04:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000353;
	bh=1x7r3TVIro71cPq24CEGRW7hdiJOUn5htsc+QRVJwCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ksBIGEjw04VR0eWqoaiU7wqiFFHpbTV0YAjAO/4oANaIve6RyoXh6rQwE0AUeKvXc
	 GePFtO5+ndhhE1k5Cx1KMjGdyVxRxMyRcA2d2zyzTSPVSE01NMZ2hasoHdpILlzI1a
	 N3LA/5Sj29fnLUmHAd/4SJFBsXTDkM8Ct9KkOSFICiF2zrYOdDulk6Sj3Ufiz5/Hp/
	 OcV/Oo/bJ01m8PrVp99bEZ+P+w83+WsDMzD+MzT7NEfDRSOdPSWwXocr1F49d03rqj
	 MwFaD3IivQm0qJqycBOOTHQpHY7AAjlCKj3CSVcNvfsU3dXSrEqm5BhoUMz+HilQ/l
	 awqQg4GWHlNmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/11] seq_buf: Add seq_buf_terminate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003035921.1918874-6-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-6-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:05:53 +0000
Message-Id: <20261003040553.984D71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Seven callers call seq_buf_str() only to NUL-terminate the buffer,
> discarding the returned pointer. Two of them need a comment to say so.
>=20
> Add seq_buf_terminate(), wrapping the __seq_buf_terminate() helper that
> seq_buf_str() and seq_buf_strlen() already use, and convert those
> callers. It returns void: returning the offset would just be
> seq_buf_strlen() under another name. A zero-sized seq_buf is left
> untouched, as in the other accessors.
>=20
> Add tests for the three cases: room for the NUL after the data, an
> overflowed buffer where it lands in the last byte, and a zero-sized
> buffer that must not be written to.
>=20
> Build tested ARCH=3Dx86_64 defconfig with GCC 16.2.0, plus
> CONFIG_HIST_TRIGGERS=3Dy and CONFIG_BPF_SYSCALL=3Dy to reach the converted
> call sites in kernel/trace/trace_events_hist.c and
> kernel/bpf/diagnostics.c. Tests run 24/24 passing on ARCH=3Dum.
>=20
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D6

