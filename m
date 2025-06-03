Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8849231828
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957713; cv=none; b=hEjPw72iYCYfQaPs/8dDTSlYoOGppWyORKCqmLyRKpwGNz+F5+fTW7IWHykgiB+z+Xfr2EIJ5kcJr9qRPSIUtAd9+hqwIPV17KoFzu/MhLxO7mwR3uYIgwGAOPcnRf5Q+PggvHnssc7lljqqgxePitO42JHY/QtSLp1Wl2MrggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957713; c=relaxed/simple;
	bh=6aXyILyNFzvdfLvnjhe+7eEg65vKZaS3Xgt9s4P7IoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVPSzxg/90x/ktirQ2yBZXiYUnZxxOcCDWh487NDkfuvWMLS7DdY0yBtROgNlYZwyqWIFbv4rl6iOUv+1l5ldKpIzMCjaIznTINf8RvXZWpW0Vpkr9CuY1UfpQsr1h1WA6Xnw8hQD+/hxggZb0K/sKbvpUY31VgjHLS24n6yq2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AqBk526a; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AqBk526a"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6f0c30a1cb6so36690616d6.2
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748957710; x=1749562510; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=csMjX6EgdDvsoUroDDkC2t6M2H8xOJU7irccfVA/OHY=;
        b=AqBk526a//JAq/kt6wPZ4f7CLi33A9X6k4kw45eET+ZyytTB+rlg7WvnB9Bn71catM
         U00xRQlyieIRQrMcVOCTetqGgZwat+6Ly3bQCUdetOKfV7IWCm8oX4jVMPmDxD3bFU+v
         mo/EN9cGo3J6hWwv5pgNBo5yseBXG9yoZx9AQrFVafS6qmj8ucLHTKAzG0/3NwLmW2A/
         4i2k1OsHGn9EFphOYaZu71RfhY4ZeOez195wc34d/ZGw0Lv984nl/lGRkGXts68r7pTe
         FHjgFgGWk9J7NosWewsZgCWFA43xJ2bceDJiXF28zjz7zdDH8BaheMMLsHamK++Bmhe/
         iWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957710; x=1749562510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csMjX6EgdDvsoUroDDkC2t6M2H8xOJU7irccfVA/OHY=;
        b=QShuA8ZT4EReYqnJBIZ1atHvChXQ31TmKBz89qjCy4sL/Vjz41k3Nkud+hnJb/PlEr
         AYJZeZq3XX1QH1W9t4Ey5qB6pahcf6g1MBzZV3+pZczFhCLDCuGfsuwhHqXsvcCs/X/c
         xkNPsGKTsaBOIyG2UYMYWpqma3N7NoSR63uUtwzMQ+4qAH3ijJoGFlwAgCO2RKwAis09
         NrwGPhglacCTmeIqvcyie5McxA+VwgBHb+QcDydqc4WYsPLA7rWm+7nMwLTXSnXC2/Zl
         b9oXP9DmIVl2a0VBs5wdlOR4rzFpyWRtHiE+vTwdEbgWVKKN2R0n0mnqa+oGuzbgGgiV
         /L1w==
X-Forwarded-Encrypted: i=1; AJvYcCXpYVDKJWo+I+TyLsjQkKwDm0hbg07Vwtc/6cEYPbbrNv2m+rutJlbokFA4JrMZftOroyCHT40=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzc4ydoCl26siwgw3W5WhHCerE+nC6oSErHtKoTzEw5UNdbbHcL
	RxeW5lFwAwfStOhcUyVuODz4SL98cgFvaYPr2ejOeWtUUJ33P15NMOi6hyHiI0QW5mc=
X-Gm-Gg: ASbGncsYK7+VRcXHT/XXYx8R16oqhUTIeGUgncOOwwFBmZPDGxjk/AA45fOQ7uQEoGb
	/adSRo95505azukS+KNsa2yhMOacg6RpjKalr7QpvSWOdWisKKemSTGM51bKyWHhcv2SlAZq+mb
	DiRdJv0gFc+88R67bSyttPySvDoqwBy146UeDhyGEpvJW04mJmTbcf9fbSFpthWn2ZQbjQRAch5
	NCigXH8w2LEx9Ii1h413Ve5yqp57p0D1d/5+Ec4uezrjWfqcPDC9tbCF2e75wFgSzNV3PSctQNW
	cXRhDU8PciiC6vWCN59BGuDRUaTmU3TE8OA8uH2EBOLvvTV1ewM9LHU2NC0odCiRuBsfWmMTnzm
	lTCyDSMPZeiVYmBvqs/T+8Arhi43ZWLBb60tYQA==
X-Google-Smtp-Source: AGHT+IGTO1Uq6qWKkHjHjzXPtbeutCQLStskBTpgABiXf8IiWIF7+BRGzTPM/WsKdaJBbv1DscVTNw==
X-Received: by 2002:a05:6214:d87:b0:6eb:1e80:19fa with SMTP id 6a1803df08f44-6fad9090760mr153489766d6.1.1748957710547;
        Tue, 03 Jun 2025 06:35:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac6e2fc45sm80639296d6.122.2025.06.03.06.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:35:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRnJ-00000001h4R-2OPU;
	Tue, 03 Jun 2025 10:35:09 -0300
Date: Tue, 3 Jun 2025 10:35:09 -0300
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
Subject: Re: [PATCH 02/12] mm: Convert pXd_devmap checks to vma_is_dax
Message-ID: <20250603133509.GC386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <224f0265027a9578534586fa1f6ed80270aa24d5.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <224f0265027a9578534586fa1f6ed80270aa24d5.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:03PM +1000, Alistair Popple wrote:
> Currently dax is the only user of pmd and pud mapped ZONE_DEVICE
> pages. Therefore page walkers that want to exclude DAX pages can check
> pmd_devmap or pud_devmap. However soon dax will no longer set PFN_DEV,
> meaning dax pages are mapped as normal pages.
> 
> Ensure page walkers that currently use pXd_devmap to skip DAX pages
> continue to do so by adding explicit checks of the VMA instead.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  fs/userfaultfd.c | 2 +-
>  mm/hmm.c         | 2 +-
>  mm/userfaultfd.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
