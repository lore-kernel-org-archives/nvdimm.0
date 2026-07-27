Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA7C36EA84;
	Mon, 27 Jul 2026 12:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154560; cv=none; b=Xs2Y2e/vctYzNAVbS4PMBomHAoKaAkIA5SBuuBmlITO0mFKtXkXGKGc5oYk1rCWFVOmIdSHA/PmFalpoRNwatfHxezzQ/rhGI8WItKOF2niIirDESr5XqVuMPXTRyv+kPDxovh6TraGLRhWelEwz306EMfOOMYc4qO7NXSvXnd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154560; c=relaxed/simple;
	bh=wEX59cvVuHHb3wT9EeaVO5yak6R4GmdxnQYePOI/Fe8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OAX3OzLx4uOXOZS66pqHiUSwP/GTuwPTrH6X/l4vcQAwJjvM8gClIJANu9FNcctSfrPrihXj4WIaN55tscWwLgb5Wb3FEHJScJSFE+aP+Y3adRrX+saJZK1pEb26kNo2u/50hUo5lnJhofonoqob88rwfreAAHTHAYzT5PQmZBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izORO0pz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izORO0pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C491F000E9;
	Mon, 27 Jul 2026 12:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154556;
	bh=wEX59cvVuHHb3wT9EeaVO5yak6R4GmdxnQYePOI/Fe8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izORO0pztS0tDVOf+uwGoulkVLTCwqR1OJSJNNq4CLLd+K533eleotsXgvoNIHWPs
	 u1BSeXYR45mUO4vCrXv0HmZY2rTB2GNWu7V8gJJIKJt9WsTlr822bkxRaUrgKFEsY4
	 VgEqj/okC9K6dXh58gMC2bGOifJ7f+h/Yj0W+P9fPa8yn2qjFLv/qT6CzDJb5NXjXJ
	 fQ+6uO5N4QzdbGgvQMBQr8ctg0hBLWa1CjIWGo0CMF8/plPQSlhdM4bSUmyiAzx1zR
	 Ip9R3/sYZzQsU0czdk/kxGiEG39Yk7T+KYNw3NdQtlBIky00WGfiPpx3O2MHOx45k7
	 NFDGfngt8AZbQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/9] ACPI: x86: use a named initializer for
 acpi_device_id::id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-8-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-8-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:15:55 +0000
Message-Id: <20260727121555.B7C491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Use a named initializer for the acpi_device_id::id field for
> readability. Also drop setting the list terminator fields
> explicitly and unify the type of the list terminator to be
> a single space between the brackets.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D8

