Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC252C15BB;
	Sat,  3 Oct 2026 04:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000349; cv=none; b=VzBRmbt5xP1lOXdgZKxIIF/BTdNNWUxzgolrXHd8e0Jx+qESXnx18y65aZYJv/BLlL1PLUbm8VUDuw8c3bxgWn2g1V0oxtMqjutK3mTRiq8wHI597mOw10sP39kdrEIs2OVKn043VByPYg6tleu/LQWu3pP0R+K8WP1y4dX1U28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000349; c=relaxed/simple;
	bh=NiXLJEyOtRV65T9UaUugs4dflbMeOVGPIeiOvnfDEQc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qsx8t2PriCTSw9e51etPlbWBvroekZqU8N1gn83HsaX9ueuF0sDVNRnJvQNCguXzhx0sbY+lj4dF4iNGq4JtQoWdnBlnsV1k8WWyVhbP+M3syU+kRoeCakEGvabCUPtavG7U3ELUAQ+5H1ZXfRWRKGbMBpzj7ckTmYtfMP7VNzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2HQwhf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2HQwhf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30AA1F000FF;
	Sat,  3 Oct 2026 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000348;
	bh=NiXLJEyOtRV65T9UaUugs4dflbMeOVGPIeiOvnfDEQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P2HQwhf0mcF/kan44AijVbQlgwqy4eQpEhWxxYQSPu2Ie4uz+Zt/0Bi7sN0PRu/cQ
	 QqBnzYjMWlug0cHWZKRI2JjRfol63IwOaMhffrt8bD4BlDr9kPoIZxup+MN89jti3N
	 4UANnXw6atTrMiJ8VGno7Z7QnPFT6gJZIjMiAOM4Ga+78Rbs+39FlplxhbGUeesoMj
	 3nvOn3Zg7OcbRMobmLoqmh2o4gKTevF5MkLnyk48gTDsQHReRgESmefHh/IHvNhsLN
	 jdO/5zO0mOdRJKAybNZGg64Lgp1zK4NcPdtAcFDOh+Hxa5cEdOkDblrrEqW1TRQpI/
	 dZfIcCK1/dBkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/11] seq_buf: Add seq_buf_init_append()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: bpf@vger.kernel.org, nvdimm@lists.linux.dev, linux-security-module@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261003035921.1918874-8-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-8-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:05:47 +0000
Message-Id: <20261003040547.E30AA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> From: Bill Wendling <morbo@google.com>
>=20
> Several strlcat() call sites being converted to seq_buf need behavior
> seq_buf doesn't currently provide. The normal seq_buf_init() always
> sets the new buffer size to 0 via seq_buf_clear(). Code migrating from
> strlcat(buf, ...), which appends to whatever buf already contains,
> can't use seq_buf_init() without discarding that existing content. Add
> seq_buf_init_append(), which preserves the existing contents and positions
> the seq_buf to append after it. A buffer with no NUL within its size
> starts out overflowed, as strlcat() treats it as already truncated.
> Add KUnit tests for behavior coverage.
>=20
> Tests passed under qemu on ARCH=3Dx86_64 with GCC 16.2.0 and CONFIG_KASAN=
=3Dy,
> and on big-endian ARCH=3Ds390 with GCC s390x-linux-gnu 16.2.0.
>=20
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Co-developed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D8

