Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B987F23815B
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958664; cv=none; b=tTLODT2oQQIyIC1/401AYdpo9p0WniL2j3uLToxUVW1OJMSitG3HYJwOjHSYnA0Egpjbakbu+Gm6vlBEzF4gp4/bEzT3CtaFLf2OhLNIwL3yS92yYUYizaAXw+IT9rnUzTccNZmuZJlKHianCRCxYpIR4hWnh/LuAsHkEmbT9ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958664; c=relaxed/simple;
	bh=TpMwl2oz7EgmR302mml/BLJBQvaM57yfpZzI6Z7p75c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcrfRbl6NVrpSbC57fU38iHpgueqAAIXv481za/jI5xmGz3RvS4S52F6KrW4/ggDHnHmzzEB+xns3yPPmf8pPKlUhOiZZqCUp7CeTGvu/SYJogQI3/wZsA+5EHswUOWS8Gheipc+dJVzuEHKCUr2nWWSywDEfuyXUOfvjh27/Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=L8z3pE1D; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="L8z3pE1D"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6ecf99dd567so65991626d6.0
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958661; x=1749563461; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjoJn2Zm/22QHFjhWW1StoVgQrArf1QtKVAZNo0G9LI=;
        b=L8z3pE1DteQNnY3xoDAAZ/kEYy5bB8esF0LyXJANof66a55/E4iXJKhmMpmhlURE1O
         wvHC1OMwOkWFL8kz41K0DbXE4uJXr+zVF8+p2C8dF+IQQY6xK84YKPd5jWpTxQbdrllN
         sb7Ji2aX8aHLi1qKVNt4TJkal34Gv3QBS39vTvK3J6M01ZTielOvX6vshNSpcP+R+dvj
         p0/9U2IcxHoWj0pVv8xTLdjAicU5byeayuuBKjFEMjTj7/LpGcvUIUdop7xBBTRuwZjs
         fEEluveumWMRc1xD/X87Ub9rUwSugy+j0FWCicSE8HHDgx75TH+4gOdvLFoJiTtOTFcd
         zFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958661; x=1749563461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjoJn2Zm/22QHFjhWW1StoVgQrArf1QtKVAZNo0G9LI=;
        b=swR5I9GSHn/343fdh78hGHS7kmCO84OaK4fjue+JXzC27t7z6IqX4oI4izac1Z8M7I
         Q5VdzdvLwEplpLcGY/kaC2mgR8pWPGIJ+Gpt2djG4WJnrsV0hYdVlpnA0FzEflwVgffb
         HuQ85kSt8fOCfW0NrOpO2ccqmUx9ve4aCUF92ZECWP2xMZnVnHmagqxdXEImaX1m2Gwx
         zNLv5jVd1DS/+OqfOXRPSBddxbyNaxBzFyp/Hk54rKJdJPzka7irqWaGuqIG/KJwTAYd
         GgkteoxyNKPPZ6AZVZEZ5l+NBbqIlKjM4zMNRZ8oLdRjcKcCqlguxxCV4GIV2EwuHQZD
         +/TA==
X-Forwarded-Encrypted: i=1; AJvYcCXfCOPKQR7eOv+49WSbUZ8jsKScXy9LGqr7xli0+y69nrn2/jezSMds7S8dI7CYJ7nYt7bPOBM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy583pVnlhyUkLT+QDO75OylbeJOPcZATfGVMlFfwDQP9XQiBOy
	sAbTPxuk3j3pxQi8hNJV0xEQajPPK69APg0ipqUS3GNBLoGdgiwG1s7G81gfXKYq7BeCMthhOIR
	ukShU
X-Gm-Gg: ASbGncu4wVUCxrVZ0ezfBudSBI9yrzLI4q+J4bop1raPP6MeSv51MvUmCsdc92gJGPA
	5tZCA7AxoipeScYysXhw+nmvXzymTSQtTyEtrtXz6WNLsXGT04qo2h3E3/kcW2kQ9+h8Qqqe/Mv
	NlaNF2oy++UbKmQi+5LIxt6UAEpBlArCsdysfCxNJFcd4v/8LfiAMOCHni8dQCDxV/PTAhYoPWw
	PG7hndVUIgufxER9hyAVM4GWght9oBXYJul32Fna/jEz9NB6vOI7rBrluheFGz17y+iPgadeVcm
	Vw4xkcSjMH2hcYXpUwqs5iQySf0Qatit0P7AxEkP5WMyKslP8YwpsYvwtqPibm7KWLYSLQGVPP2
	G6duyU3QkNTj4mwby5edl4UKLwog=
X-Google-Smtp-Source: AGHT+IEFP32FP1kWWCcJZHDROTyLVsjrCtV3bR6kiIwGVnTYe5RPt72l9Jyf9JX2LfFifGppycDP9g==
X-Received: by 2002:a05:620a:4629:b0:7c5:3c0a:ab78 with SMTP id af79cd13be357-7d0eac62c8fmr1708400485a.14.1748958650816;
        Tue, 03 Jun 2025 06:50:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a0f9925sm841658185a.41.2025.06.03.06.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:50:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS2T-00000001hDC-3YG8;
	Tue, 03 Jun 2025 10:50:49 -0300
Date: Tue, 3 Jun 2025 10:50:49 -0300
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
Subject: Re: [PATCH 11/12] mm: Remove callers of pfn_t functionality
Message-ID: <20250603135049.GL386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <4b644a3562d1b4679f5c4a042d8b7d565e24c470.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b644a3562d1b4679f5c4a042d8b7d565e24c470.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:12PM +1000, Alistair Popple wrote:
> All PFN_* pfn_t flags have been removed. Therefore there is no longer
> a need for the pfn_t type and all uses can be replaced with normal
> pfns.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yay!

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
