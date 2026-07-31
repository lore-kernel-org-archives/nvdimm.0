Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA3E48986B;
	Fri, 31 Jul 2026 09:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488467; cv=none; b=LodAy+myECbtb9cOXvPfkFbzkujhKTVSO0fxGiF1mPs0P8a3jQmFe1U8j64+lEIr+eTj/qz8hs9rOlUQRdmwoW89s4xohpBAQmUzxvB9OWi8H0nmgxRm+C29Jx/7JcQACT5LFrXXqIy3l5PReQoZnLZvc2uMiw2VT0FJejbyAOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488467; c=relaxed/simple;
	bh=R//0P+LvyTvfIPHAi6PlVnsDMFvGmcihSqPE2Sf6d4o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bIPATEMh/18/uKCZNbYIVU4IvXiiodgRYDzT6o1WeRiNEH4Oz+cgUhxm8/hR+MkVFknxlqcIXmetNJ4HTthhD8/+dg2NCwyrwxYwl2gnigkJ9wN5eEo0IyKl/hM7x5rWSqjyiUdTEMcSA0tS9YbofBQLP4ko6t3tlwy8TXEpjNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnwuYAfI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnwuYAfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1472D1F000E9;
	Fri, 31 Jul 2026 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785488466;
	bh=3ELG8pZx9Lag7hhsBUf3lUowZSJdZZYIb5V3ff6dLhg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gnwuYAfI6O0QjksAC/zp/D4zw0aYMlo00jL4EhdFirERxj8ZPBCx7gLSAZq6qfY/b
	 x+SvpvETMVZzjoXgqU5bjCe2tXAmPMr+GtwU48cEenuJAQULU4Mz06fxf9X418ruJP
	 lPUu9kl4jhnDKGjF1sgxLbQNTOq+7SmZpPNg00PirNb5yqyBK5nGGOeyvzjMO5QvFu
	 uM/5kViXLE1v/oYwz/z/E63u/BOFI+nkc35KNGxD0hbVcnCwKlAYaoNgOY8K3GqL0K
	 Qoj74uqlXHNwR3evsgKolyeGzIEpynA5YpvNdy4pw09C8oTu/xd63Ck5wjwD3ztoA3
	 o1NKQNiuJufvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260731084901.1512819-3-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 09:01:05 +0000
Message-Id: <20260731090106.1472D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] False-positive error logging and initialization failure when a d=
evice has 0 dynamic capacity partitions configured.
- [Medium] The validation check `is_power_of_2(blk_size)` truncates the 64-=
bit block size on 32-bit architectures, allowing invalid block sizes to pas=
s validation.
--

--- Patch [2]: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration=
 from the device ---
commit 7a0233410b5ae133da2a756fa11cf61b2145cace
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Read dynamic capacity configuration from the device

This commit implements the Dynamic Capacity (DC) mailbox commands to read
and store the DCD configuration information from a CXL device. It reads
and validates all partitions but configures only the first one.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info=
 *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	u64 blk_size =3D le64_to_cpu(dev_part->block_size);

[ ... ]

> +	if (blk_size =3D=3D 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> +	    !is_power_of_2(blk_size)) {

[Severity: Medium]
Could passing the 64-bit blk_size to is_power_of_2() cause silent truncation
on 32-bit architectures?

is_power_of_2() takes an unsigned long, which might allow an invalid 64-bit
block size that is not a power of 2 (but whose lower 32 bits form a power o=
f 2)
to bypass the validation check.

> +		dev_err(dev, "DC partition %d invalid block size %llu\n",
> +			index, blk_size);
> +		return -EINVAL;
> +	}

[ ... ]

> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{

[ ... ]

> +	do {
> +		int rc, i, j;
> +
> +		rc =3D cxl_get_dc_config(mbox, start_partition, partition_count,
> +				       dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		if (rc =3D=3D 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index =
%u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}

[Severity: Medium]
Does this code incorrectly fail initialization when a valid CXL device has 0
dynamic capacity partitions configured?

Since this loop is implemented as a do-while loop, it will always execute at
least once. If a device has 0 available partitions, it will return 0
partitions (rc =3D=3D 0), which causes this path to log an error and abort
initialization with -EIO.

> +
> +		num_partitions +=3D rc;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731084901.1512=
819-1-anisa.su@samsung.com?part=3D2
