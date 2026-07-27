Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232981B87C9;
	Mon, 27 Jul 2026 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154656; cv=none; b=BePg+CzqBaIAvLcZgJZcscEO5H0x5mlVr7oyRgkqxkwu+tDGRH9g3vr0WpnAaIe1SIR4hh+ASdyGtkV3xary49BVEcu66M3ileZrIPFetEvU2NzwNHqORaKADTNo2O8GqvgKjMQKNe04UroEul6KFFIg9a+fPufmEcjmHNZv6ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154656; c=relaxed/simple;
	bh=CtyHVC9HSDoSgUy5hQ4y2GRPLZdgSZ+rtU7mGxN+JeU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f9jh49piWlaNE4PD6ne9F8bNN3j4lDZS15CUChk/3o/Jjtc/ZIx2E55ryiNBANJEJiyof17Mtvu1IPNZ0wIyEgCZBonbIPEWRjOTzusH9coiXCkDT7d4WsX7eFGp6g76wMzvWhbRctw+WBHGqsxidT68nJ5ZioKFHd+iJQQ87PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wb06UY6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wb06UY6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A501F000E9;
	Mon, 27 Jul 2026 12:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154654;
	bh=CtyHVC9HSDoSgUy5hQ4y2GRPLZdgSZ+rtU7mGxN+JeU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wb06UY6DCKM+yjuJOOTjCktlCv/M1napD85YHIFLVwnAgJx3aLQ4YhtNwC9PjpG40
	 n3c0K9SHvgMoiBlBMqXZ/i5jD9vP2FBCGmJBpx+T1o2AJFwQe2C/xf83/jAofY1OD2
	 g22pQI2qLaOFL4mhWnYz/mmsQV5rlH5LdJzrxp07l3VCy4I8XdUw6bNoleMWyLjtCo
	 QI4oTDWIrzZ+6dJYKGdKrOA6IA+0+u0txQzJpDptOvc8g+hGto30QueiFC8SvQ/nqO
	 EERT88wc6K7jtHt/7g+PrvbTQDTgdq/JWAT57L2L6mRWgUCYqBPzddLpdPHBuCgPoE
	 ScHcS1PJiQA0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] ACPI: drop unused assignment of
 acpi_device_id::driver_data
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-2-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-2-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:17:34 +0000
Message-Id: <20260727121734.96A501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> These modules set the acpi_device_id::driver_data to 0 but
> the field is not actually used within the module, we can
> just drop it from the table.
>=20
> While we are at it - use a named initializer for the
> acpi_device_id fields and drop setting the list
> terminator fields explicitly as well.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D2

