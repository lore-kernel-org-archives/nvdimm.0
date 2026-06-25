Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9D30569F;
	Thu, 25 Jun 2026 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411849; cv=none; b=bjnyChHFxdGi0vWTx8yCAIrXckQE0KhJgCTEKfqdKWtxm6qPCLh+HAsiiF1Dv0341NwnAsdMzuYT17Ee7la/XHi/ZiMFkohNfl0Ml80J/bsBfV/QhQ6Cp2gsZjYONzjcP5oyNjzTbjeNrlNSozRH/HvHuHpFoW8h+yG4mijM0t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411849; c=relaxed/simple;
	bh=vWphCE8TVmWGV/5YXCXDkOifnwrx5dtWVTSwySYfkDI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RzQJCQUfdQwM+rgeNhQvSQmmTp1/NBZv548dZxpGJDN9UwA2EiLdV53WuS9bULRYKfmeb3WbQuTNnO/+/eV7HngLfpVxFmh/PHwhjUE/+DlDlNGruS4/WIECObJzEiVjC9Cm1VI8YrzBCLHSM4F7FL1Ns0TkPN7WKDTp8UVTg5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDxlbRh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDxlbRh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE71F000E9;
	Thu, 25 Jun 2026 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411847;
	bh=vWphCE8TVmWGV/5YXCXDkOifnwrx5dtWVTSwySYfkDI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oDxlbRh88UASv4VP5TnQi39Xh3M0jLm7hsxXM/BEMMmLpmPniFXbjAow7+ilmYZnu
	 HOZhycJsDgUoY3ChBXQ6JnpJ5EyIXDGXQw1SJffTXIzFCAUK2ByghPSjiNfwPij1n2
	 6d5Ws/mwMaiLZ2Wj9gg98RoEotlRp1uMBqL7EBYMziXRTV7oBYJXSpOLH9qQ9UfXY/
	 4HfqJS7z1G34qZKWa1hDK6YvNaoAq1LwXCPzRu0BTxXc5QW3qyUdZKwig6yWaV+jzF
	 4vI/Ir1edGVNX+5Ipir/nZtbXzJJXXMSnACOBboIYnAy3NmcfiOg/zwh+3Htt6/IpL
	 mqzjIQH84NAXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 31/31] Documentation/cxl: Document DCD extent
 handling and DC-backed DAX regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-32-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-32-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:24:06 +0000
Message-Id: <20260625182407.A8BE71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Typo in documentation: 'can by chained' should be 'can be chained'.
--

commit 06abcda7f883fa6e5d50becfc5150a117123a7a6
Author: Anisa Su <anisa.su887@gmail.com>

Documentation/cxl: Document DCD extent handling and DC-backed DAX regions

This commit extends the CXL and DAX driver-api documentation to cover
Dynamic Capacity Devices. It details the conditions for accepting or
releasing extents, and explains the mapping between accepted extents and
DAX devices.

> diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Document=
ation/driver-api/cxl/linux/cxl-driver.rst
> --- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
> +++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst

[ ... ]

> +Accepting Extents
> +-----------------
> +Extents are made available to the host from the device through DC ADD ev=
ents.
> +Event records contain extents, which may be tagged or untagged, shared or
> +not shared. Multiple event records can by chained together by the `More`=
 flag.

[Severity: Low]
This isn't a bug, but there is a typo here: "can by chained" should be
"can be chained".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D31
