Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B1C23ED5E;
	Mon, 27 Jul 2026 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154657; cv=none; b=NbtRqAywAcrLECTBT5t4y7LjuPzYhzxld56m7aF9susVrV8cfaKra3mABNF+2lRns3ZzCa61cBI4jsjD4l3YKBgCOkFoZBmJgUS+n/LzdGj1nUhZO5QMST0WoUl2CyN//aQjEZYo2LAYM+QqhOLRDUSM5wt+DVJ+MScPT4zaOT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154657; c=relaxed/simple;
	bh=fxVWN4+5u/Dr35SIrCvSumNfZI8FqPsW5r3VxNOZ1QM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=imUWVEjoEmjHXYkXRmnAep0Dgaajl/xX3RAvJaAMwdur4rqgz8+Z+oPxBP94LWjnZmRX4I4ghhAPe2VosO//ZVDUtPvwuVejujca17ykpmMq+xw/ThOszTvBcCa64lQq7D5WfmEcrVSpD2ebi1jznlyLV8Jg3JA5gDX9Grf2sHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOqRK2O5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOqRK2O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963911F00A3A;
	Mon, 27 Jul 2026 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154655;
	bh=fxVWN4+5u/Dr35SIrCvSumNfZI8FqPsW5r3VxNOZ1QM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZOqRK2O529bmgdUr11iItz15jxGGqctDutLsJqtolIjjfAy5ghh6g32EjWdqJLhZZ
	 3S0Te/pt6QRg0j8eg7UrxchMDOEG1QJPPjz4juK+2+kqIXUEkwtPBJzszK+QplB0k9
	 P4uiP5joBYWKJcSPdFwV52l/kOEzSNNprCsSRs1yCNqj/Oh3dz7Q+o9ZoA/6odhqDN
	 PJUuHIwK2YBcxaNksTQT9rQrOjg/y6g21DmQFvhUnngnqVx5colFHP9swLka6+axTq
	 t+K0RHrmR5RlGX0L1f7w4Rr/pftpNjcz1/NOFc39yWtFt9IPVBx4Z6Hb+LwOWDwGrQ
	 765kSKvHzm4sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] ACPI: use a named initializer for acpi_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-1-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-1-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:17:35 +0000
Message-Id: <20260727121735.963911F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Use a named initializer for the acpi_device_id fields which
> makes the code more readable and consistent with how lists
> are initialized in the rest of the kernel code base.
>=20
> While we are at it - unify the list terminator to have
> a single space between the brackets.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D1

