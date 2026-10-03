Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E828D831;
	Sat,  3 Oct 2026 04:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000500; cv=none; b=bNy+92g8ekkOAjngKovX+TZLprrVSkpYgj8eJ5pdWvPmExCWfQy9aRfoeSenEKOKG07t0Ajh/xUF3Vm7yPYqj7epuasmKDXy+DJPoHLhQFhOCwKRG8h8aCGXkYJMfu058iaslgqGe7zke9fhQDGJe+isQPSLx8rI1wPZeN8OxxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000500; c=relaxed/simple;
	bh=b3CGu0TmSPt1Tyf6/KGEIXqWW84UpyfEGFFeEECH7IQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mpPLNrsvt6POyM7mdqzNzb8g+2e/RS906W+bkS0tNz5fhLmPtKnOGkjmX9hOQw24/HA1yNqZxZOd1uNwJPPwcyL7IFK/d2O6apG1m+Ybec5cWUbrelth3cRuEluPWJ1a7rK4yvMCMTaKdcxRxhkEnZGvwLSwrZOl9w/6/w4xl9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiwVsGvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiwVsGvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A7F1F000FF;
	Sat,  3 Oct 2026 04:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000499;
	bh=b3CGu0TmSPt1Tyf6/KGEIXqWW84UpyfEGFFeEECH7IQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HiwVsGvx2Z0MgW/GQuCKP6GrSqI/2nRODbs5nhreXq/J7lv5DrCKVRUTXR0m0Km7p
	 N71n5p1tz6j5prwsXlnS6/IgHK6imETLl7UIFYPDHLA8F75oZzl9xaboj2TQkDl91V
	 fJCyqQrPtJUa8hw3MNmUHqQmM7zSkIZ6OTELLYuU7mL96n5avV+IItL2SVoIOAHfmW
	 kxzQ/O6UZTfuwm5Zy9mkvE1jmtHENgjv6QhiAgPTqohPxyNB7rdRa4PJA+d1KssKWs
	 L9KbZfryrVP4D9OH9ZvJqZE5em/uEU3Hkq6Y68Urr6ay3FIbbbV7ZRpW+nqC8zH9hp
	 YsFp7fs6r4f3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/11] nvdimm: ndtest: Return the string length from
 flags_show()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: nvdimm@lists.linux.dev, linux-security-module@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261003035921.1918874-10-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-10-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:08:18 +0000
Message-Id: <20261003040818.70A7F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> flags_show() build their output with a seq_buf and return seq_buf_used(),
> which may include the trailing NUL byte when the seq_buf has
> overflowed. Use seq_buf_strlen() instead.
>=20
> The flag names are far shorter than the PAGE_SIZE buffer sysfs
> provides, so this cannot overflow today.
>=20
> Build tested ARCH=3Dx86_64 with GCC 16.2.0, built out of tree with
> make M=3Dtools/testing/nvdimm:
> tools/testing/nvdimm/test/ndtest.o
>=20
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D10

