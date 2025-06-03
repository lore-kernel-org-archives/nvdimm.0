Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B9326290
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958471; cv=none; b=ElPpQUCj5YB3S4UlWSrLGUAiZByKafHR+EjEFfsWyoEUxAXjDG63838T7UDCdyu8SzD/fsandMJQt4VMg57STnZW6Rp8hrod+gPx84hB7+HOJ1+yIj2X4/SH+AQ/5UGVJNs2TOVRo2aktadgRy5FXP82GiiJBajoRdBJagU5Dm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958471; c=relaxed/simple;
	bh=QuA4bLScr7zZl9oRdPCFKpAujll0Lr/hMN/nG963i68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0++ZD0INEg/avDLUFusl52kqqEX+EZH0C1mXlQ8K47bBHPAqknQcCPsnq/yBmMFtS3dkobHmZvVXK8GSivpKVC7aNxwlZ2eFisiGtzvZOYk+QusAoJYo3ky+OT8r4OYyIfUhWwyDejZH388uHMPSRNwAx1wwbx10mgP6uRC3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ynj8+9k9; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ynj8+9k9"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4079f80ff0fso1948906b6e.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958469; x=1749563269; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UpF3njOJtHrMyikmrAfZ4zzOg2YUvEVFUbKoE3kb2rM=;
        b=Ynj8+9k9tvKRF5bs+6kOn4qWRMSbCLKlIGZK009WKAPvN8mVcgAiZn6SVENBWHgli7
         TI4uDfTVluWAW7lkBAHGllbvlNb1JQlucmj/s5PS3rz1e/fAkT0BKR+zJ5xSHs7ChWit
         Ix4LBt/4o9I0QKPZgcsu4J0ksaLFRWTCIFtQPicBI8Hm84si3R781mne9UoK0SrFE+wK
         yrW6n3USnZqZhpkuV38lOhz1teoWcN0tE4rJ6VHjAEJ2mkloECdeGY8FYDLHF6JQouHl
         kHJus7yom2TEapn1jZ5RsQG7Sp442lLrUuMqbJpM/ezfEXd/DaRh49FcbSMSJAkxP8Vs
         66Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958469; x=1749563269;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpF3njOJtHrMyikmrAfZ4zzOg2YUvEVFUbKoE3kb2rM=;
        b=D3pYOGsrESwsZPDRK7Rk/wuIvWolQiIK7t/Amra34WhERLj80MigXnVg208MxcztGC
         abqVEDG/u+gwT5ds6kup2GAlxARrPm3Hyvh23przFcvmefRC97uwKbL283S/0GTyK13z
         qJlW+a8NN5iOkR8yGmZg/nHYSkGVVMh5cPDvX47uXIGOXX4R/cR5ojBNvaz1J/OfI07N
         k5BOv4BxwY4+LIlMkuvCeAm2bQFPhX77Hn+U6Er02TZaSwG5NWlzsiREYdP00EH0cS1K
         rtdmx4XbYlPNXb4dq/lTNlizFnuBd6Q4lmiuw3YeIDojc83Xa7K/inRIpZhVzO2ddccu
         95VA==
X-Forwarded-Encrypted: i=1; AJvYcCU4MgcAUKsZJYzmfcmmTxn9yEiUkK7DsKxGcVREVvQaYN2gLz68DGkLJkJsU4aWx5Cf6EOay70=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUlV0YxPAbg7tHz1tzsccuZPCK79aI2nCZP/E2BvyBLsfmw14j
	3wZdG4EYmBzAWHnZpDOkhoBmEE0aX+pvGAl0yqQm9Oyhw2n+sTFIV54eyygVhmaxcBIH5Q+7b8z
	VKFr2
X-Gm-Gg: ASbGncvdT/sqeTZJqF4szJIWq1TJFHJTVJtTkRYLP1IMvBDXvNQOOhTLLkCIuayoMYJ
	hauFBRnel1F7+XI6eUYKNcKJoermudtMFqO6k5Nzb32q+0ja4g9+pk1z/0k3MMMt0hq6C9bSIa/
	76PeZ6pb2Jj3oOsCqagQV+x2o+WXYZSyC/XAro1eLpJADlG6XjhwIro4voLMqdUWyEMFanF7GW/
	N/xSnhopfSNDUNFbnYMksgDAPulQA/ghR5gFjyFlVqJnahLJMm3YWXABs7WuXY1G93XLCESGj0S
	WyoawJC07DVkVLCaZCVwpFo7VQKQZ33q0nWhdlvMYhWA0awCBqy5AXJjFlumJ4qt7su1cthaNag
	tMwI2yVf73J7ujkeTQ0jOhNRNjA8=
X-Google-Smtp-Source: AGHT+IEn/uCXnqGk9mGrQEIlQbsguMg4s70jmRhOs28+dV79kPuZtTFgI19mnXFgGkPMbOXTAF/Qjg==
X-Received: by 2002:a05:620a:278d:b0:7c5:d71c:6a47 with SMTP id af79cd13be357-7d211676724mr394455585a.8.1748958459265;
        Tue, 03 Jun 2025 06:47:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a195d7dsm840098585a.78.2025.06.03.06.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:47:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRzO-00000001hB3-1CmA;
	Tue, 03 Jun 2025 10:47:38 -0300
Date: Tue, 3 Jun 2025 10:47:38 -0300
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
Subject: Re: [PATCH 06/12] mm/gup: Remove pXX_devmap usage from
 get_user_pages()
Message-ID: <20250603134738.GG386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <c4d81161c6d04a7ae3f63cc087bdc87fb25fd8ea.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d81161c6d04a7ae3f63cc087bdc87fb25fd8ea.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:07PM +1000, Alistair Popple wrote:
> GUP uses pXX_devmap() calls to see if it needs to a get a reference on
> the associated pgmap data structure to ensure the pages won't go
> away. However it's a driver responsibility to ensure that if pages are
> mapped (ie. discoverable by GUP) that they are not offlined or removed
> from the memmap so there is no need to hold a reference on the pgmap
> data structure to ensure this.

Yes, the pgmap refcounting never made any sense here.

But I'm not sure this ever got fully fixed up?

To solve races with GUP fast we need a IPI/synchronize_rcu after all
VMAs are zapped and before the pgmap gets destroyed. Granted it is a
very small race in gup fast, it still should have this locking.

> Furthermore mappings with PFN_DEV are no longer created, hence this
> effectively dead code anyway so can be removed.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/huge_mm.h |   3 +-
>  mm/gup.c                | 162 +----------------------------------------
>  mm/huge_memory.c        |  40 +----------
>  3 files changed, 5 insertions(+), 200 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
