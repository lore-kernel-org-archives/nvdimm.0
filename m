Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88513186E55;
	Mon, 17 Jun 2024 06:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604757; cv=none; b=C0RzpT1bzrplv6jpQeVWv2W57qH6K9VvbcZZj7eLKdw9yxSA4+rm83+eCzeH/hdoZzkmk0RcVGeNJdjvawv5qx3plImGjxybJ7x1GyJ+/1UkWciKdkPFZYrOCl0opUcSNbjUEvX9XsFBuU1w8jtpzv9UuE0vbil/sElXJ9lpowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604757; c=relaxed/simple;
	bh=LrLZKWXkRakpWI4/ueXizJXAwKTR991d/slvg583xhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIOAx38mLYQXjYVCJgxBu4UawAJHgfM+kQwDigN3mFut0g/S9cui8fxsRdTGYpwt53tgPBuliPVJzHanJD2j8fxh7NEtJ4hHEYo2QDAzni0sCBfbtoeGI/8QAp18UhCcQuTejQXFpH9TbnYM5ZCeR9JjnYAon4or58DhkTHwmrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFz/S8Pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFz/S8Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722E5C2BD10;
	Mon, 17 Jun 2024 06:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718604757;
	bh=LrLZKWXkRakpWI4/ueXizJXAwKTR991d/slvg583xhg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nFz/S8PqJ0x5s3Ny5I2evBmJDaO2EaUIuiWjAdtRmCQ/A6QpvJbLmjC0Fw7IXR1VT
	 uSNeYADsaTVxJipaBcqAsdKPSVVmorISGDB8ghzkIoBVgWELX0vnHVqN5Xf3bgHIW/
	 Jd7IHk4xFBOBn5HxiZsiAifRO0y8cGSStiGE0NqqwYZj3htvKjZ9JxGjZyZWwJADfE
	 WIUuoyvXMEqafkiqyCnfGPuXY7GxfWhCoyjXAFv1xdeTp+IRRcD16/M5uHMReQAzrM
	 yLcLncP795V2wNVqCHkdUBLru1ejkUmD3WFgvqGfKNm1zjEea2esQdxNT2nTdM/0yi
	 xUG82No+arhQQ==
Message-ID: <e4ce83ca-160f-4dd9-984a-842b6cd2b5c0@kernel.org>
Date: Mon, 17 Jun 2024 15:12:31 +0900
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/26] sd: move zone limits setup out of
 sd_read_block_characteristics
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240617060532.127975-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/24 15:04, Christoph Hellwig wrote:
> Move a bit of code that sets up the zone flag and the write granularity
> into sd_zbc_read_zones to be with the rest of the zoned limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

