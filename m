Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113128C5B1;
	Sat,  3 Oct 2026 04:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000186; cv=none; b=j6v7Pz4LX0cliT1DXMdQXpS2/JmNp8gSL2HDQXe38+QpQBRbtC50YRwThRgZkRL29pHk3cBrOffbBAbTKHP4Zg3xRo8Q/f2r6nPfk7erMwLPIS+ZvPxqsfC0oJkxlWznK/PASPYUPvRLpSA5tiyh9h11cgD8q4h9iTK9+5/hpRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000186; c=relaxed/simple;
	bh=EjCj3RTrpk3QQfq4li6pp3S+WUCE+BwrVQUotCHlVfM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K4KlVOJJ+yRARjnuY5p7fH/Xt4V7Km0ZYz3rN/CLhu085TrHsJ+LPZHHq6X0jK4SyWOC4sPBz3kpM3m/xrRWY0+PJPM0CVFwyXkN7WGcYYN4NXF0gZjeCcI2wmwvuVSRa8n7ynkn2tXhdewCZfDZa6h/YGqYP0zem+BF1c/mKUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPfyzJRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPfyzJRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E471F000FF;
	Sat,  3 Oct 2026 04:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000184;
	bh=RhLrrCjq08tYZS8MlInJxSMGemytHgpcdlF6AV/89lI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iPfyzJRvmMnzypBfm7rn6Xjjg2ajIaZiWspisJvYe6pCw6xGkGJGuF23OHoosX8NE
	 BmO2lNynXD97s/3+Uetl4tyVd+ftSZ9/zAIPKrWgoxhpw0I8ENAqJs7WBHuAfT3YZ1
	 N66F8HUgxDibsLHiehavb9QdexUDl0DSrhE5ZzQ631SBo5NHitZTrUQZFRAbqTe78K
	 CgN3M0Z5RAfk4DPkR8IAsR7chLUzSfWSmEUtFZozlCtpYJyl8cuR0kOf0AuMGTjLy2
	 nLc8vGsZSGfr4eT+a/IDJx3AsXhx88JeUHYr2INpBYrtgwBIhh6cHoM1caBJ5C8nbV
	 ultGmi15ktlqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/11] docs: core-api: Document the seq_buf API
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, nvdimm@lists.linux.dev, linux-security-module@vger.kernel.org
In-Reply-To: <20261003035921.1918874-11-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-11-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:03:03 +0000
Message-Id: <20261003040304.25E471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> The kernel-doc in include/linux/seq_buf.h and lib/seq_buf.c documents
> the seq_buf interface, but no .rst file pulls either of them in, so none
> of it reaches the generated documentation.
>=20
> Add the missing kernel-doc for seq_buf_clear() and seq_buf_init(), and a
> Sequence Buffers section to the kernel API documentation. The static
> internal helper seq_buf_can_fit() is left out. Additionally fix
> seq_buf_hex_dump() indentation to avoid the reported Sphinx error:
>=20
>   ERROR: Unexpected indentation.
>   WARNING: Block quote ends without a blank line; unexpected unindent.
>=20
> Verified with "make SPHINXDIRS=3Dcore-api htmldocs", which rendered
> happily into core-api/kernel-api.html.
>=20
> Assisted-by: LLM
> Co-developed-by: Bill Wendling <morbo@google.com>
> Signed-off-by: Bill Wendling <morbo@google.com>
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D11

