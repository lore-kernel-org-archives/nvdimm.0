Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C6E2236EB;
	Sat,  3 Oct 2026 04:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000366; cv=none; b=EfeBMbhm+DoD4J0rirlnlOOGETeqAC5/23jm0uisQnL8GkQaSqQyaiRH8ciIgtnzL5V++phQthVPWHobNuuOuOwErvLNy5FTzDZ/YGr0OQ5rJZvlB7BJgNKZUdtFRwGkf48guoUSp/yK3wHxq5gFdqIqJcuj/upRsnFIIZKhacQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000366; c=relaxed/simple;
	bh=SW39hDPr0IbSAkXnmUkVoIxFwgsYyVacAW+p97dhef8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JhSnogYyQk7O20XteVAtvM7aSpVPoFWJmqjpXCQid8EjCC3FylwwP/ymtYf93EctGzkMHCWztZPiJynNvsuJoXBDRvlMuunbY2Urwbg7VhfiV9aDSN9/1Uj0T8qgGZH3ih1fFy+DMLKdIIxZ4wswPsay7kq6vU4QVTW/Zvbt+Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JExLFgAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JExLFgAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09BF1F000FF;
	Sat,  3 Oct 2026 04:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000365;
	bh=SW39hDPr0IbSAkXnmUkVoIxFwgsYyVacAW+p97dhef8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JExLFgAw+kF10A/I7STG4hf4XpVMOg55VDqwFYtRYwu7HbX9bgiuttwhknhqUMf1Z
	 PiiC5+IE6LHPyu2yrsI5MMNYx2gArtIUj10SBxIydP3pR/j1CLzGI54NJZL1C8ZA5s
	 0oPYUiGMB6HIezDxbx5aJK6SayrMjaJPL23fulhEWwNoKUodPA4QxN3ZoEHV+b9EIW
	 YtXAlxfOby7jVh8Y4UoXYsQaDVpqRsWpvH70gDzKSpkTxnLsPYkBTGfRh6GCgP+s0j
	 B+S0qBD3t9rlYyD+tMFH8q7QU2BDDFewnnYVuAE6fRbitL6piW3rwSMWnnKOxzFate
	 9mCeOb/bqjQAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/11] powerpc/papr_scm: Return the string length
 from the sysfs show functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, bpf@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261003035921.1918874-9-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-9-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:06:04 +0000
Message-Id: <20261003040604.C09BF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> perf_stats_show() and flags_show() build their output with a seq_buf
> and return seq_buf_used(), which may include the trailing NUL byte
> when the seq_buf has overflowed. Use seq_buf_strlen() instead. As
> suggested in review, use it as well for flags_show()'s check whether
> any flag was printed.
>=20
> Build tested ARCH=3Dpowerpc ppc64_defconfig with GCC powerpc64-linux-gnu
> 16.2.0:
> arch/powerpc/platforms/pseries/papr_scm.o
>=20
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D9

