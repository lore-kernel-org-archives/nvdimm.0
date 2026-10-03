Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07047385D78;
	Sat,  3 Oct 2026 04:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000479; cv=none; b=olDNfls+nnV0Za45a2vV+6a/fp3+tbxkKhAiV2FV+6M/VvivTSN7e7eiEhMF2/saM4nL4UrnKACmoXWGKYbf1UesoZRE2VrlHhdK8CNsFAPwaKqDvBqOIYfN71iTOrp2ty3bzzNrSLiEK1TsLpXvQmVsIpQoY+enxzkaymtTuG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000479; c=relaxed/simple;
	bh=HYb8mk/EvOHPOeThNKUC4CkN4izT2H0fXtwGDLDOOjc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IjQ2Hj712KlH/lXk0SYFfXMWeLlmnMJ9ah7IaRfg6/UE2N19dRxz6jxhG81GCJWuTDBprIc5Nj8wdzS/F63ZTZUlzEUi0nPs214Q03VxQtX7TuCmPAebnb9HbTEkI1YtMG543AZV8BDXRvVRzkeJaZIdv7XGEroRawFhEoi2zOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMqaNke6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMqaNke6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC711F000FF;
	Sat,  3 Oct 2026 04:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000477;
	bh=HYb8mk/EvOHPOeThNKUC4CkN4izT2H0fXtwGDLDOOjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMqaNke6hYUC7iB6bxDqJjZOY1PFmsG1xZZ6Ipso9EbBb0O9nn8GOrOwxLXVbYnX7
	 ekzs98JDypoX6rnRkFfF03DRCSppEwCpecep+sHPP9jm5gVONKobbmySH8ViIrKYNI
	 /vOz9eiu1lttj/xEgvYHDgl+YecUnpvjozgY20erRFdueE2hfWZke0m7r5y/7w/zDo
	 6hIo+frYD3UwGIgaHjiJ9O/rZEmKFdhBVW6AZd1ib4VybWn7/ZrAm70iLfz6hJv63H
	 YqbRg3P3233qtxkxcZ4p3e2upoHPXN+9xZA+3EI7om3Gg45bedMEnmRLB9Aj+TmKT1
	 RQrvpO+7E96KQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/11] seq_buf: Copy what fits when seq_buf_puts()
 and seq_buf_putmem() overflow
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261003035921.1918874-3-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-3-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:07:57 +0000
Message-Id: <20261003040757.9DC711F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> When seq_buf_puts() or seq_buf_putmem() is given more than fits, it
> copies nothing and only marks the seq_buf as overflowed. If seq_buf_str()
> is used, it will terminate the buffer in its last byte, so every byte
> between the end of the data and the end of the buffer becomes part of
> the string, though the seq_buf never wrote them.
>=20
> seq_buf_printf() does not have this problem, because vsnprintf() writes
> as much of the output as fits, followed by a NUL. Repeat this behavior
> in seq_buf_puts(), using strscpy(), and in seq_buf_putmem(), which also
> covers seq_buf_putmem_hex(). seq_buf_putc() needs no change, as it can
> only overflow when the buffer is already full.
>=20
> Each writer now records the buffer as full once it has copied what fits,
> so that what it wrote can be told apart from bytes nothing touched.
>=20
> [ ... ]
> test builds as a module (CONFIG_SEQ_BUF_KUNIT_TEST=3Dm).
>=20
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D3

