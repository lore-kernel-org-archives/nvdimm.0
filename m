Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36156238C25
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958528; cv=none; b=KtTsNBV3T66QJA5mvYyVpe9kwvAiOSLgAnqec7sS/NrEouUrdu9kIuiSIAQ/JugyTS2Q94iUp7S3PA3qt4yOUo4wIpKANuZG1N2gbRdtsTAgC59GdnN17lmGGpB8smQvCEtk07wp1+2yAynVnuwIbUXWAxnAvM+cswxQ9bBT9Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958528; c=relaxed/simple;
	bh=RcXEhllfDG955BJXEN1tqIgpRJ2MsHzTBep7rZd+naY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTGgyiKs3O0JhV60KAblLba8UU5t4RA0De2NWgmHgN5TBWEWygS+Ywh9izZASx5+zf6kBB2Uk+w4jFUvp+MHoHFqJLlaEcs1UeTrC+pUfo77/0JXsQRO5lfY4i8+Etl0aU9a4S6wJSIG27KVRgpKZ4JF3ewftajmlWHCcLMG4bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Es8e9jL7; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Es8e9jL7"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f0c30a1ca3so55273416d6.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958525; x=1749563325; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSTZfPDDH1MLe7AQH4Yed2Uaqt/hLn+gokhyp0JhueY=;
        b=Es8e9jL7rhZaGyamxnh2Pd5rj9ilH0QeA/GCY7k9ztSuIHjn1IGGdV1t/suUmDBmSK
         +sQiQvurxrLuZ24Q8LfrWvs3RW/Ev/W/AvFPK/ZSx8rDrYcHpyY/o+PhRR9YK99gd8EU
         7bB4dqQ3qEXP4FgGyKu3//zh77BPObS6BkOzCo+JYw/D9Ew/n/q0xnZ035CbXUoXz0VA
         DI8TPIxYv+y91v6PTNgrRazWHY/EF0nXvrT5wGP12rTeUOsrp9Zy3X6UHG2o7Y5gvA+b
         1cxFt7NU/fKC5eGdR8YhTJ0Gcx6DjU9IwgENmgubLdd5iWXzFeR7n59Na858aWtPo9jl
         OFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958525; x=1749563325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSTZfPDDH1MLe7AQH4Yed2Uaqt/hLn+gokhyp0JhueY=;
        b=wjyYMENz8eSBQYLkFd8VvdkpL4PGhPuSxL9Un+4vKTD77lKcLgdLFacblKKG3e+VAk
         dyWi/sCR0/N4s8G4VUsLxPYKqX/9/2SIl4bBeMiPGP3yG4P3KTVxIFO8cMObfCvMy/IG
         LHhwnT7IHSFo4JmeASoA6mabB0wggeYbgLZtH8RPNb1DZQrSlmSQvdv7pehx9SbcSI/W
         Hce45lL3e+Q4mD3wXMInux8nRN6GDNN5n33uvI5/GLH6MhLR2BPQK8haTBEqXMjTDnLE
         uFxbN0x80xEloITPZJUAebMaub/pzujfCEHl/epIIaFEDhAgu1oSP30YK+KbBnlhBJRK
         rwMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6O0hf5pFqYlpVL3RMqaQjdj3UpEyqfj0W1sP0oYuhVtoKB9wQ1wg89On1OQaW9TsmVHCv9yk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNGExb7tqJq3yYAuGjW/lfoqB95DtzwnIOQ8ORI0FZsRE+3AUc
	d/Zmhii7yrLRV/2xz8obgJmAykV3sAnxzq9QukO5bpKEs2ew11144bXeY9Pm8XccpTQ=
X-Gm-Gg: ASbGnctsCORU7urQZ/B8oIp/FBgJyOaTQxgGMyplls3tlCeheBSJHAdZ8S3O/MT4edL
	GY2WNDViCdMxQ9Q3gOSZ2wM5CYSiU8hh9QegBFw9DWhZQ5wQwEMkuhzikEHUJWsEpPpkxJjIYlJ
	fQT95b6gCIeRwE8bhJF4Pjh08hKU2/ZcMYkCf7dKfWTj0SZlIQnbR/c3iS4s9Mdbs8idxsWtBzc
	kx9MteRHu1A41lhYL9uNmjuS/2FUSOK7nJaIqOGBpkiPQ3OnJJ42tkIt+LDCQHWjL/bELD9lnrB
	2dyo8XTS6u2s62UB5FFKc0F2jlg4mW1eQJghypC/Luvl+oiWbCgypZGsNC1oVDUkyIhVg8EN01u
	bzf6hQbf8/ZQjOi6y/jmkjDFrP8s=
X-Google-Smtp-Source: AGHT+IH3Vn4y24ccOnNjvyrMKRdXMvoXmINXxWtKUHHRDjsnlypx2qCEJce143rhCfMATkU1PKi1PQ==
X-Received: by 2002:a05:6214:27cb:b0:6fa:acc1:f077 with SMTP id 6a1803df08f44-6facebef794mr265266426d6.35.1748958525108;
        Tue, 03 Jun 2025 06:48:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a10e844sm842209085a.49.2025.06.03.06.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:48:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS0S-00000001hBt-0o7d;
	Tue, 03 Jun 2025 10:48:44 -0300
Date: Tue, 3 Jun 2025 10:48:44 -0300
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
Subject: Re: [PATCH 08/12] mm/khugepaged: Remove redundant pmd_devmap() check
Message-ID: <20250603134844.GI386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <2093b864560884a2a525d951a7cc20007da6b9b6.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2093b864560884a2a525d951a7cc20007da6b9b6.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:09PM +1000, Alistair Popple wrote:
> The only users of pmd_devmap were device dax and fs dax. The check for
> pmd_devmap() in check_pmd_state() is therefore redundant as callers
> explicitly check for is_zone_device_page(), so this check can be dropped.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/khugepaged.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
