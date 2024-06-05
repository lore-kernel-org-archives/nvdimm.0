Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114341553AB;
	Wed,  5 Jun 2024 20:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717617949; cv=none; b=TxA7G8OY2u+roxcV+FUVNV10gmy3kGtiJcGNRqVZmAtNUOy4Mylk2HnBhCN6m0EmjqFbUSQ5F2FaPCeY9KFIklsS2PTKdG2lnR2wOV+0jE841zTsupqlC5QePY/a42H4qua3rfhtw0tAWodH42OvJzYGOFG6nDsKnd47aOX19eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717617949; c=relaxed/simple;
	bh=WIESEa30dZ/hQw4soSdWvR9FvT6kULeFPhCVwwSmx90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NL4WKlciv/g1DtCSKCoIbd4p4fUySGrY0o11HHziMa4AoDDUVfjYVLV6JYxPKCL/liY6fTV4H+pTvPR2XgOVNVg/tk5iIZNLjaZ/oN/DCRagMfeELGGwFQRfXvcIhQ/5FkNIw7pGPgvFjjFQKgrWLHDN5Bnn32prgtnP7UD0YXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEPruOEj; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEPruOEj"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f944cae15cso497641a34.1;
        Wed, 05 Jun 2024 13:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717617947; x=1718222747; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2sovYnnLqu3ePNoGdykaYCzoGX/KrvirZkk+6UfwMw=;
        b=YEPruOEjOgWuaoEu3dpsmbYxPxyQpimaYJAG72HxmN0m7dqC/EyUJ51x3aqXz07rYM
         jM63cwBr7R6b5lU9uMTKGt2iZ47r0gzrBy9kdkgRgBDeJv9BXJXFI4iQ1aZDuF1vMNzt
         Dwf9bo1MPgXRAkWMNVLrFWmMIyVUpzbj8gZF63HcIjyzHWWyRo7reOtm0ygPXJtREkQr
         pGk/zb5hd3FNQpinjNphXj6p7Z7JQcRP+qtkjcZf3wHwIX7Wzm4Ws9NHAHzCBhOPeJLV
         gTL0WZvpdHppFcAlDAhUCq0bQYqiyXCfdUrBVOdvJ6lZehyOyVujoAiIaETTniMY/vAd
         PJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717617947; x=1718222747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2sovYnnLqu3ePNoGdykaYCzoGX/KrvirZkk+6UfwMw=;
        b=Dkl8VVOFzmXoqdo8rIEOY4v85wFKqbMp+sv5OeC1Sqy0Ukh8aFO+lpkocmZsjFBQ1/
         Hhxpz0QLqioa9VwdC5zFO6sdaWE8dxdT3ax2Z5yuzg6Q/zewGTj4sw8qAwcCzqAnzNI5
         BX02+F/Oex/N0u37OlaeCnEi2whRuNjeOjWWlAz+rY+Y4E8tgEF0cjW1MIXKl7GOYM0l
         5Ph3W1tXR9Wom7Mpo9UXL575a5ZOB48O5ZjJHEQRAk01MUDhrJRKti7JinBFnu1Eg07P
         w7yBlIrfk1MM6ASbDvUWWiTAYe/wodFX9PTLlTPLI2p4wmFClxZXd0QzTdEGBquscQER
         yddQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYP/IWeKnTBh0Y8cjLyWoCUMY13Bvk+TUFYz0IHfhnXRwR2WEJSETZMEJ1QWwmE+MpX8F6mb20fsYVgLVG3YbMp9yRePTitxGnPHg1DKl/fd2o25UEE/c40rILnuVGIU8=
X-Gm-Message-State: AOJu0YzmVSGiYPVDIV7VDDQX182bAmTQ67Jtc9JdxdbUb+ByIeY97qgp
	TyD4o58vbRs44rkN3YhbkIc51qnrIpJJqmwhkY+XdDH/2mC9vWGlv4dD33NGjy6c7gxWcVdMGGv
	gs0xkS6o9d8thRECO94g8as9tTH0=
X-Google-Smtp-Source: AGHT+IGyVhO7rSQAoGDSB+vjloBrx705BG5D6fs1Cr4EcslfrxplrQUigFncTawwbH2U8MnF7SOq8ImGhCk8Gp1b7A4=
X-Received: by 2002:a05:6871:738f:b0:24c:4f83:48da with SMTP id
 586e51a60fabf-254407aeaf0mr366594fac.16.1717617947176; Wed, 05 Jun 2024
 13:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-5-hch@lst.de>
In-Reply-To: <20240605063031.3286655-5-hch@lst.de>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Wed, 5 Jun 2024 20:05:20 +0530
Message-ID: <CA+1E3rJn3uNfkoFtm_am9qwQmwWvhu3nPVMaM63AJ2GBdxZTmQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] block: remove the blk_integrity_profile structure
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 12:01=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
> @@ -446,13 +446,14 @@ bool bio_integrity_prep(struct bio *bio)
>         if (bio_integrity(bio))
>                 return true;
>
> +       if (!bi->csum_type)
> +               return true;

Changes look mostly good, but trigger a behavior change for non-PI
metadata format.

Earlier nop profile was registered for that case. And the block-layer
continued to attach an appropriately sized meta buffer to incoming IO, even
though it did not generate/verify. Hence, IOs don't fail.

Now also we show that the nop profile is set, but the above
"csum_type" check ensures that
meta buffer is not attached and REQ_INTEGRITY is not set in the bio.
NVMe will start failing IOs with BLK_STS_NOTSUPP now [*].

[*]
     if (!blk_integrity_rq(req)) {
             if (WARN_ON_ONCE(!nvme_ns_has_pi(ns->head)))
                     return BLK_STS_NOTSUPP;
             control |=3D NVME_RW_PRINFO_PRACT;
     }
