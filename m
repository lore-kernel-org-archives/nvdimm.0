Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E92040B6
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957921; cv=none; b=V1qqsrUZ3mMbFF6teGPQfamwlpXza2mDTWs7jL/wtbqKkrTmIvARYqGdzxXBQh+v0ciNZcMTrJWb8r0Z15zx+XX4D5NQT70OZ4GxdPjj98+c3CdTUfN5V90iAPbhu65DkU4Ag0QTdQYuMV+zw8m48FbxqJu0lFBCiu3QW7wiVSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957921; c=relaxed/simple;
	bh=FJcBKj5IOAP4zBarRXTdKou4i5eFgR4+RYmNBOBDDmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbXVAkjrSr2T+9nMGXF3us/5wV2TLFFt6cWnbBy82gov9ug5ThJZwuWcA4PFQSmdKV+hPX21InMb1n6BIwvxPXE3V5KH/Y7hVXt2QDwNadlut+EC4YgsqMtAexdTGeqUYLlxfwwY3ELjXamD7MgO5mgMPkQRwesR+qKh2iGYdRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LpUHmhuY; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LpUHmhuY"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fad8b4c927so24702516d6.0
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748957919; x=1749562719; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YoBzO9/Vr83m9kWgElnZwYJY0cXKTy7GFrgVmwfY4k=;
        b=LpUHmhuYKgPP8YLwvjLGkoFVfNPYFHGrQQ2HJ/9XAUQ/d1nHQGlpNsMjo9agXHmMBi
         asB7Qiaey5UcqQqTMoX42jDk1Bl5y5scFcS8Ov9t17R2c6Fv8Uizxgfrzsn9Oa3etv9R
         Sejll8E5HUojyVMv0Wol/sPPKnJF8yjxnNaMm2UKE4LN4Qv4azgoLOAgtbZrVOYYPWDk
         cVrGw42pXtRzD5v7LALLTvwHL+e7qGSblcpDjV/FExEYf08pj4svZGvexe3kGDGcwO/h
         yk3HppKuiXF6FI/YmcyP35uVIsL1/+rs7lU4NwqAh/a0hUifE01aMlwC18Ga/GGrOZT5
         eyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957919; x=1749562719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YoBzO9/Vr83m9kWgElnZwYJY0cXKTy7GFrgVmwfY4k=;
        b=VuhnAQ75CDDo6LsbR1RuDiydh83O69DdOwOoE5faAE0xVig48puiQ/69sQnmEaJZNH
         fRN30Y4jtEllb24NhWH11AOUWWgMGgb/GVZJ1pMms9LcUsYB+PgnSO5sxV6sq6Chh5M6
         v1hSJfKfdHOVXmFJrEl68nQn5pEr9y1omGoMNUwBUQvfCA+5vznejwmmwRVZaUciq1cL
         CrBiZ76q3XKGqiDxlK0Ea2jZMJCDSBhA4hfjiXS4dCCPyxx3ZszJ4DyzYTg3/DR9Y/qZ
         Hd+ZR5eKL6WHzuIzBPXozxSLqhClpNivy0axyyPc8qmR9ocOS6aU79zsIN5AqT/78pp5
         hPdg==
X-Forwarded-Encrypted: i=1; AJvYcCX7D9Zw1+birJjMKynGrWv9UKNfnviuGHCNnbZ6eGLM0ZiDCPKibLXNvV9m54pjQVzMwH3EEnc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrxpGkuIuh5V/Hlm5tWGWIdqFwg8iQZKMdZ/6OempRWQIKZVgj
	APxeTk5oafvM9ErDX43xc+CLMGDAoMDn/RtUMI6KyiOLP2C2/VeuuhnQfJbFCltHN8k=
X-Gm-Gg: ASbGncvRHhf+sFMv2Zk4Cju8o6VP4prtJP7FM3DSdC6d+OGuKCOehFB3ChOpEjhemtI
	bVrEIqom7LTEOWQ+h6fiIwY0Ty7Q/5pHltM/Tk4A4+hVYGNq7ssFLhB7Q92djV2kHHBhswwZP37
	ZkOOGWNRO9wxyMSacty4S00Juugr3sHLSzOBMGgZynRX/2ipwYKszhdU22rg3r5U3iNqEcKGhMX
	NlaQo6ttgq59cg5gWF9Qc0JRZIr2hQF8TaiGBjgs1xuwqv8Xt2JgWonwdN1phaRWqvQj/3JUlzS
	dD1g/ppz8FZnFMisD8DEJFYjPi50jhKTTYvc1H6fzI3DSuI4bkQoGXmvMa6yHj5DvCy9blyklZw
	sLUAxHJH+eJpcPWO7m6vKssZ6iTs=
X-Google-Smtp-Source: AGHT+IFNNgr1gOgNIDIKGgPc3bhuHOtoZeZOnCuhf1c+LALW25Lvqo21bVxhfooiSUL50e5IoEYUCA==
X-Received: by 2002:a05:6214:194d:b0:6f5:3a79:a4b2 with SMTP id 6a1803df08f44-6fad191b357mr264142056d6.14.1748957918424;
        Tue, 03 Jun 2025 06:38:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac6e1a681sm80140746d6.98.2025.06.03.06.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:38:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRqf-00000001h6M-29EG;
	Tue, 03 Jun 2025 10:38:37 -0300
Date: Tue, 3 Jun 2025 10:38:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
	dan.j.williams@intel.com, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
	balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
	John@groves.net
Subject: Re: [PATCH 05/12] mm: Remove remaining uses of PFN_DEV
Message-ID: <20250603133837.GF386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <ee89c9f307c6a508fe8495038d6c3aa7ce65553b.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee89c9f307c6a508fe8495038d6c3aa7ce65553b.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:06PM +1000, Alistair Popple wrote:
> PFN_DEV was used by callers of dax_direct_access() to figure out if the
> returned PFN is associated with a page using pfn_t_has_page() or
> not. However all DAX PFNs now require an assoicated ZONE_DEVICE page so can
> assume a page exists.
> 
> Other users of PFN_DEV were setting it before calling
> vmf_insert_mixed(). This is unnecessary as it is no longer checked, instead
> relying on pfn_valid() to determine if there is an associated page or not.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/gma500/fbdev.c     |  2 +-
>  drivers/gpu/drm/omapdrm/omap_gem.c |  5 ++---
>  drivers/s390/block/dcssblk.c       |  3 +--
>  drivers/vfio/pci/vfio_pci_core.c   |  6 ++----
>  fs/cramfs/inode.c                  |  2 +-
>  include/linux/pfn_t.h              | 25 ++-----------------------
>  mm/memory.c                        |  4 ++--
>  7 files changed, 11 insertions(+), 36 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
