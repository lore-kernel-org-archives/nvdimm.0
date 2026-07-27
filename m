Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E233FCB05;
	Mon, 27 Jul 2026 12:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154470; cv=none; b=O2IEcMGCUbzbxtUZlJ2kPFfqnujX1hYkR2psDPhOW1EbgiNovktDesqI2X+T1R42UYpzEVlJRU1Coubn70ABHWu1yHSTe+PWiYeWlSAYa1ZS/mAf1V1s4PgUYcdBQLJHkk9oK091lIiIiAzQxIXO9pfcYxNdwReSTgninLUXQ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154470; c=relaxed/simple;
	bh=SIWqgL7SWdS1oYNtNN1b1a94ckcVJotHFsTsGzgKM1A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RAT9eIt5lHFTFtF9BTJjKmXl7Dp0jePr9pj4oVExBSrjnSzdJCBM3sO/3oyMDCacaVsLNFi4nt887B93R164byShNEVfKYnwnOQ+ky/ftw8gsR8rUL+TgUrmASjshtVtA+/aQF/1OuUZo46CnxfP7G6Ol91te/SofcrjHIHBZco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeLQ0l69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeLQ0l69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC6D1F000E9;
	Mon, 27 Jul 2026 12:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154468;
	bh=SIWqgL7SWdS1oYNtNN1b1a94ckcVJotHFsTsGzgKM1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eeLQ0l69boE+UdV/JWVToUKMudcE50JpKQa0CSPJb31JT4l69YAnOPDQMy6LV8gmh
	 BCzGSG4VQkkvgE6AoT/GBk7uMUi1kvgiLIXb6H4FR8Njx21ZC+aNRCYzkLwfT6SnGi
	 B+B04CzAsw3stj7u8x78jv+sZfANSj6Vln8xBM60d7Yu+xsvRlmb0G6j2gW0hC0d9m
	 9k/vJ0VAASeEJqF1yx9eIPrXsAAmqFANUl3fYpEb9iQHHlN/hjSig+aVz13/Z9AfnQ
	 3BgsH15s3j7F4ca3lqgOSmFTnK2359evAEodsb747M3Wh4oARz4OZ4+NZ1M+YhkBgX
	 Q4Vp907MPtTsw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] ACPI: dptf: drop unused assignment of
 acpi_device_id::driver_data
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-6-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-6-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:14:27 +0000
Message-Id: <20260727121427.DCC6D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> These modules set the acpi_device_id::driver_data to 0 but
> the field is not actually used within the module, we can
> just drop it from the table.
>=20
> While we are at it - used a named initializer for the
> acpi_device_id::id field to increase readability and
> drop explicitly setting the list terminator fields.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D6

