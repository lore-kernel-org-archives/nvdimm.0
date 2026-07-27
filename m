Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD53DA7FF;
	Mon, 27 Jul 2026 12:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154564; cv=none; b=LQm3jrH37E5bnIR2wT7xDfSCuHhMpOBLkwzv0Cf9vumXh14nEhijxKGogaE3/vkzPGkqfGy9A7aQ9D7htFd8L5qWkPD62PcVHhneJDefYAgMKJ/5c3cLSECSkr7qRl8hwWfqpZHqM5kWxt8x/zndD8UKydnCoUlZdi1ejIB+kkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154564; c=relaxed/simple;
	bh=oAmYPXIyH5TYd/KCwOdQCs7+VKf7a7oYQ/54/5V1mTA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XA2LWniGMVkhhXiM4/MvZlwnNIjBpw5EWBkH/WDlr4Z0qiDruvj54M8EvT4EQk8zkWxE+8gu3fg5ilR5nWON3gm+jbtGHgssx7SqZDzQxpaOGLmO1b7v/oiEdajhl7pMiB3J5+GzQmNvzWr31f1MbznY/4ORUcnnY2OiA9bSdXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUtvLIdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUtvLIdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996E11F000E9;
	Mon, 27 Jul 2026 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154561;
	bh=oAmYPXIyH5TYd/KCwOdQCs7+VKf7a7oYQ/54/5V1mTA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SUtvLIdQpwpIi/pwo+awzLDXKaN9MsLOSjRtABpmRuEPU+GaSqJc7a3CdIbD+cQyP
	 LX8ruaUA11rKM9cpOlxJii5J+udK4ZhNXGbdRiJLjwpXLV9sFGFlD6zIMHV8ZR3/N0
	 qvwEnQaLzy7paL+M431+dFr/K5ri8sw93eNQ0Lcy7MXU/jnKE8SHNYdNqmPF1gZvXN
	 KwTf9Nlx9Ppmkj+ktmh9NORh8koPvysWkpkX60rTNLi1zoyrCuUsnyq/+Dzve34sqE
	 5UFMgk+6eHpQTiqpGM6dT2JQjYEO9QewqdfiCZ0YaBLjvUdp42jcSMKBOvXe9n5W5G
	 Ae08pxqocRE6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] ACPI: pci: drop unused assignment of
 acpi_device_id::driver_data
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-3-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-3-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:16:01 +0000
Message-Id: <20260727121601.996E11F000E9@smtp.kernel.org>
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
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D3

