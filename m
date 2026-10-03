Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D7337B002;
	Sat,  3 Oct 2026 04:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000338; cv=none; b=WbNvUKchbvwjC4WHdClCHEeETqdG31/QXQVY1WMMPf+UhINHbz2/LWOtwnyLLSbO3cr6ogS2VDOxOsiNWuwR99j4R6XsCeytlKIZgTrxngpi1+kWHGSbeQJb4QVv7HHIeJUnDSJ14hjWRzNsOStkGy3hjj0p0w8wMLW4MFXzLmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000338; c=relaxed/simple;
	bh=8Z1PevSi95K/CYoaWfFWTA3wPCvrjFgD2OGpv194XPE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FvX8nNJsS825P7gfODLE5qgSi7RRCOimbwSzqYR9jNz7fQ0+p7uzLVWry9lzuEJSSWcw4X6Al2C9AvY3Joz03/fzYKY5HQdWSh+PXc3880BKnRrZXAbcaMgiICEAWuIcWPQBjkg0SJlcl5hdrc1hQxkXvzOGPem1VBGa03M/nR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bg3oZCgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bg3oZCgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF851F00893;
	Sat,  3 Oct 2026 04:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000337;
	bh=8Z1PevSi95K/CYoaWfFWTA3wPCvrjFgD2OGpv194XPE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bg3oZCgxuYgHBnSQjXpC72fYdE63uz0MIO+CMIN7kEKYV30UKRKMRTiZTRdxU4RhG
	 UwMVzfJP/63BfWwiiLEJIPsm93V1uXyTr8JMF4pjaSXfY4A2pv+S6Z/SOQUjPDEVob
	 fwDBm26leHgIV/iHZ2wcIdawe47p+C3D2rMU4jhYz2TKKTfMOgPFEbGjEnux4KX0G5
	 9EQrH9H8TaRxk5yjeBccnPjGHcw1UBWosIZl4fwm/mIXhaCHTUNgin1Z5cUC9uSfzy
	 sSQDcyzz51lJvwRplsuxDSakAQBJQXOqC9SsQZD74CqC5RnNSZGClylnEzwtfW2Pu5
	 18x6Du30W9cmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/11] bpf: Remove dead newline stripping from
 format_disasm_line()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, bpf@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261003035921.1918874-7-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-7-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:05:37 +0000
Message-Id: <20261003040537.4EF851F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> format_disasm_line() strips trailing newlines from the disassembly it
> stores, as diag_print_insn_context() adds its own. Since
> commit 483a1bb0b6cf8 ("bpf: Do not print a newline after disassembly in
> bpf_verbose_insn()"), print_bpf_insn() does not emit one, so there is
> nothing left to strip.
>=20
> The strnlen() resync of the seq_buf length only existed so the loop
> could index the buffer safely after an overflow, and the second
> termination only restored the NUL that seq_buf_pop() does not write.
> Remove all of it, keeping a single seq_buf_terminate().
>=20
> Build tested ARCH=3Dx86_64 defconfig with GCC 16.2.0 and
> CONFIG_BPF_SYSCALL=3Dy.
>=20
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D7

