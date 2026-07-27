Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1D400996;
	Mon, 27 Jul 2026 12:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154510; cv=none; b=YsIfNCw1MHJKy4bltgBOXTiChRmGClLUxJMiJlRgHgIhEYBAYvSJFs5/yhidosvguSmhxVF+TkNdEueFUhGmV12DbKzByZStbWyCH7GvKMcOODwtYDMey49c0p1BKU8t/Yjlgj5cbaxP9NjAvPS+H0UVPwHKzFMSpqJteiNLjRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154510; c=relaxed/simple;
	bh=ZZH7li2VbIeUMapyckCsMHkunzcQPJSfTjkEjO7pbiM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oWXOxbMjhuIqYkiQB9rwUpbrPI3KCsBcJiJQG5s3g+IS761Ob4sp8LfKXQubLK9fLodIcUaDhh6OEJ1qhM8miGkXcj3idltYgLUoqnh7RbkrEPdu6+ng38f/dnvgd64b7gSqpf6kZDD7lzjYcSIDXDv2BucHGdiPBeRDQnvmjTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJTbR2BG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJTbR2BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A325A1F000E9;
	Mon, 27 Jul 2026 12:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154504;
	bh=ZZH7li2VbIeUMapyckCsMHkunzcQPJSfTjkEjO7pbiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jJTbR2BGBjkluZDxXrxmUzCo6MSYlihYibYmHg2wJp2SYJXnBQtxnVTaKz3mKM26z
	 SC6bxDP0kr6WuE543U2clMbIRVlWMHRJeWMHd/REmlr4GOLYDkGyPfs8stXONVJcMO
	 W/lbxT10C6ZLx2lnk/A4x8qZUHanYfVpn3Szy4e6XQjevH6TpM61l8JFNqxtJpGE4g
	 rcHdOJL8lbYh5w1doAvq6GmwOqReLrJAF7ioqxMx6MYsGVe89CfZYQQLc3VA7tdyZQ
	 gUnA+I0QujNwa/G8Ut2xSBC8FkT5L7+XkFdaDgDlq5ERwuZP3ZKG9nKO0FzKZsXjrt
	 gWtCIm0d24IJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/9] ACPI: nfit: core: drop unused assignment of
 acpi_device_id::driver_data
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
In-Reply-To: <20260727-acpi-refactor-v1-7-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-7-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:15:04 +0000
Message-Id: <20260727121504.A325A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> This module sets the acpi_device_id::driver_data to 0 but
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
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D7

