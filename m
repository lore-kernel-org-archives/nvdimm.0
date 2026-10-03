Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA152236EB;
	Sat,  3 Oct 2026 04:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000473; cv=none; b=bRMgUJKxmq73hUYu/7p/9ptwoG4RK+AkYJyfV2rAtq5T0beO9CYyNNGXQ4QLFK9OvKW37uhXTjqEtPCPZ/SRNRv7+6MwYgreKQzwfvvk03mbiYlop2ISYiLYP6mBFPQqu7K1/0MQXy6857tBr1bPYeRimuW9ddD3Q2ONswg1kb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000473; c=relaxed/simple;
	bh=iNMVQr4JiJEnQgnxCl4gOOV9BZiwY3D+PAnSgKPaEaY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k131rIFv5Kls0r7nAOUuHmHtkIDXSi5iOCtUSuhH6ZBEH0VgdcrRhJ7ZDREjBhvdmYZPiMmRigehk8NFXktZbypVluL4n0zQ2+Ysp4Pv+DxPzIddgrkUiKijexQA/BY7rnk5v8y+yovv4m4/gi88+eD54o7SwCoA0S6DEQ68wWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFrJJbS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFrJJbS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08301F000FF;
	Sat,  3 Oct 2026 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000472;
	bh=iNMVQr4JiJEnQgnxCl4gOOV9BZiwY3D+PAnSgKPaEaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hFrJJbS8t5bHrpyvj83VnbPKJU+sQVS5D3JkzV4ZV3+V1vbOFfKWBuLWlJBv26Xi7
	 5tQuuW6IhKJuVQ96OhWZaOkeAoKMHtYwFoQ33mjfCCcAa5sabQ6r3CGTh3XyNkKqhl
	 u4zdRD5FHO5dq59wq5Mj6afMdTeZfcfZJvFeleX32/dZKFekMjcW8KUFDrlPMejYMK
	 +iybCzbaxT+R5GsPmkQ+Yl1FMHsXCa/aNRFWw1eufF3t4b4Qa6gU9+xsiRvKmZXlRX
	 iqo3IWm8G4WYui7c+Hwr6tZ9TBsGHzGf0qyTCJ36Aqc3CmzPMYPR4e1NEx6hP2g1Fm
	 kumq3lThY8HYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/11] seq_buf: Do not print an empty line from an
 overflowed seq_buf_do_printk()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: bpf@vger.kernel.org, linux-security-module@vger.kernel.org, nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261003035921.1918874-1-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-1-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:07:51 +0000
Message-Id: <20261003040751.D08301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> seq_buf_do_printk() prints a buffer line by line, then prints whatever
> follows the last newline. When a string has overflowed at exactly a
> newline, an empty line is printed since the pointer hasn't reached the
> overflow mark of the seq_buf. Switch to just check if the string is
> already empty and only print if not.
>=20
> The only caller is the memory cgroup OOM report, so this could only ever
> add a blank line to a report whose statistics already did not fit.
>=20
> Add a test that registers a console to count the records that
> seq_buf_do_printk() emits. It counts the records carrying the test's
> marker, and the records holding nothing but a line feed that arrive
> after one, so that unrelated kernel messages do not disturb it. Both
> states that reach the flaw are covered: exactly full, and overflowed.
>=20
> Tests passed under qemu on ARCH=3Dx86_64 with GCC 16.2.0 and CONFIG_KASAN=
=3Dy,
> and on big-endian ARCH=3Ds390 with GCC s390x-linux-gnu 16.2.0.
>=20
> Fixes: 96928d9032a7c ("seq_buf: Add seq_buf_do_printk() helper")
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D1

