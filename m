Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F1221546;
	Sat,  3 Oct 2026 04:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000437; cv=none; b=GWjWoF6wVYIXATzKVJlV+wcHwwvIyw409r3NG2hfSdtE+nFh8WwZ4Qcwd+fHdnc34YhsAeNLvtXMF0JJ0MVlitOeVF5bo1vZFFwhvKsSjkUnd101urKoEJX2l567uLvYaJMjP3YxSo6MdRN0qUlS5hxR6BQgENq3qgGjATXIpkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000437; c=relaxed/simple;
	bh=WjYPITp9sYkfHPNDYmvGMCh6Buc7i/4ie4AuHNn/zxg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ufabk9Pm1H+Qj82PGTNc9z2rdA0tOrHFzUVwLveScjk6MgIajnnIWrrOEJs/ruBA94ojy2ayrcn0a79J8vTt65AIFLSkDxk4gOUUBbrw85FaDqtXR8ug8s5MfucQSwO50F1UJuBILlV/8O6a84BrrJAxxW3so8k7Dv3r2IjPzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYFgi7qD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYFgi7qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5E41F000FF;
	Sat,  3 Oct 2026 04:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000436;
	bh=WjYPITp9sYkfHPNDYmvGMCh6Buc7i/4ie4AuHNn/zxg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aYFgi7qDXOrCig6aCY35AGVOnpuNAAPAIqo7WuxhgTVonSKr919w/48DjNUpURvhR
	 r8pUfJi/XQAsOa4KlT9CnKmiYd1XaQ4SliTNZu2dOtrbDmBM/SxOKUm35RA8UNEt7O
	 alQw1GBLRreCyIbtjb3tyyZvsQTlYN3YLgamsNz3R49eICgrpIIEsGlPI2j1WlXKO2
	 Fl/dct8vTSAemeHjIuGw720wZ52tBJL7mGCv4RR0EiNe3XZ23xuQTx7ykAEgGIf5fE
	 i6rN9wsI+g8t9hcV+OMB8Fx5UvIJ9wDyithtJ/PTbSmGFLKljq1BfHOIX0idtEqv6j
	 XUe0KXM1UMG2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 04/11] seq_buf: Clear what a writer did not claim
 when a seq_buf overflows
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: linux-security-module@vger.kernel.org, nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003035921.1918874-4-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-4-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:07:15 +0000
Message-Id: <20261003040715.EC5E41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Using seq_buf_set_overflow() would leave the bytes between "len"
> and "size" untouched, so if seq_buf_str() is used on an overflowed
> seq_buf, those bytes may be exposed. For any paths that don't claim
> partially written bytes, by setting "len =3D size" before calling
> seq_buf_set_overflow(), wipe the unclaimed bytes. The seq_buf_puts()
> and related APIs already claim those bytes now, so only the unclaimed
> cases remain. A specific example of this was seq_buf_path() which uses
> d_path() and would write to the tail before discovering it was out
> of space, and would correctly mark a seq_buf as overflowed, but the
> path fragment would be left over.
>=20
> Clear from len to the end of the buffer in seq_buf_set_overflow(), which
> every overflow goes through, including seq_buf_commit() with a negative
> count.
>=20
> Add a test that fills a seq_buf, leaves it too little room for a path, and
> checks that nothing of the path is left in the buffer. The tests run befo=
re
> anything writable is mounted, so it takes its file from shmem.
>=20
> seq_buf_path() was never exported, unlike the other writers, so the
> test failed to link as a module. Export it.
>=20
> Tests passed under qemu on ARCH=3Dx86_64 with GCC 16.2.0 and CONFIG_KASAN=
=3Dy,
> and on big-endian ARCH=3Ds390 with GCC s390x-linux-gnu 16.2.0, and the
> test builds as a module (CONFIG_SEQ_BUF_KUNIT_TEST=3Dm).
>=20
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D4

