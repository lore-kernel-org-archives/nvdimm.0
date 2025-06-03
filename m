Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE1F238C0B
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958623; cv=none; b=aoEp5Y5eByLoFbup7Y6aQNU7UrB/KFn4NeWyNyCPyROTfH8hFWIw/olg55k7NR+7U2fxqQz7dbuVXWMZetoDx3ChJo6sYB6mR+1WyNcGnhaddWHFhps3pGrylf8VPydGWVS8rLytvEq7X9YLq+zB60O+97Rl7KKeI3th3Y/DcVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958623; c=relaxed/simple;
	bh=1doqpPZBZdBJM8o+kHQlB7CeX2bycDJ6ijoRgFE2Vjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWUmAEh9fL/ovtfzIDBotjtbLJ+SIgkVW8ZeWHqEB1Itrcn7JyVySrgdgVzQANApqN9fcFEMcPWj5VCBccsNwvaooFz8jSg7QXQNoDUx/reiK/0KnWHB2Yq6hNomuaMJkJL1FN0q5MNMYoHoCRWA0oA9OwSBwfiWEnVzOHOOPJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=adVNCd3e; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="adVNCd3e"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4a43afb04a7so29710241cf.0
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748958619; x=1749563419; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YkymsPnXdQBda6JrJEhL1GWpprQuWSyxObGqKIJXWus=;
        b=adVNCd3e91rkJuHp3cVaXmA8kx/CsV4FgJRMfxh2uujZJqvSsxaOHL5+tjaJvK6Qwv
         SEYMAHw1D+9T1IC3SeSerBpHLzm5R73eayiZ/zVl+uhk9sCbiolmv4Q8yvjdwP65Ga6z
         YzjeW4c1qS4jPwnvMPJtw5fupQtzB6pXX3XcRP+LWaB0y4Y3ydzl+6ay5GRhKVOwfCBe
         FpalwPZqBE6WCy8CmVjcaNsfzL6mTBEGIN3yLv5bYn31n8gK2eFgD+nc2nBMlMRqk5NQ
         wnvOVC3dL9hQ9R0b1UJztRz9kWTx0oz+yCI+UgICYNzqnrYSWfF1dSNDJ+X8aSOquxxt
         9jRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958619; x=1749563419;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YkymsPnXdQBda6JrJEhL1GWpprQuWSyxObGqKIJXWus=;
        b=NKww/sD+BCAj50gzWKCi3VHFx2LuJn6d1080xL5XcHb88dyWNEUKiwqXciu8OCKRmS
         iDsDQDRhhCkMzByZVv8r4wsHGHulJx0632Y2hkCvVrUcH/eKXBaOCENuMH6tOGyFBKv4
         GMxtKEcYCgJ5hoij8JjzjQJXan+A0zG01wVNcHpLSFoy6TWlIt0iLrEVo9Jld3QwJi91
         3oY9gzPMLbp5fOtEexF2eIQgUsjXuX3qxQIJG9c5AC6hstDVkclWv4Pczg4tAetDdwBP
         rf2HMWo6asRAUsxaTd0t2KyiAx5bvWHLX2gt6si0q+X6RIeePVxzNYwniBZG6xb4GcSl
         R0Jw==
X-Forwarded-Encrypted: i=1; AJvYcCV5urOaBUTR4KraBgXaGdydseQtF0FqHXGYtrOAJMxAdKERiw937NYlGncbYk2jAsnHZv+DrOY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywd82WHt1ZghXHG+gOFT/10UwoB2PaBfypxyNhaWjPpMdtNr86n
	0JgFgHLcZpwKVj6i4w3r8cQ9t7vFZvgfUM/zdIfAAYZ4bQ62xgjvFOe72DHud8+83iA=
X-Gm-Gg: ASbGnctHfyHGpjo0184NvNJztMIvNeMGasSxAWhWHpNR70tsC63vc2UFZpbHiSHAUEd
	k9BL3wiB8FwltqmNNpA5X77Mk6GQ2HsLVKUtfW2r5i2fzOMfNfKrlWUu8m4zpKtjEV/B4Kh6IMm
	+vVb77RRY4cLg0/+KdEhRqtIgD3h7HxdVKD8EF4N2zL7FARYa/F6nSv9a8KHaN7NvZNphmVGPMw
	iea2ueSyVF40EZdI5wcuIpi8jh7U0sJQPiX71hYFcHHBOGLyQaalfvSSyrWJzbjNtQ6tEkonizJ
	0L0rUscO3vFRwPTk+CLKzEeAireusxAR3jlJQGE72hXXGb2awcl2txlLsPa7F91L1AqS9qpD5uI
	2a4bQyBWvqush2qFx0zBfBGgKsvM=
X-Google-Smtp-Source: AGHT+IFrQ3mNOrW6/ZBr5BKf2weoO3iOKbQMChhnKb6iKzSLwy4jyxYkXr8u6rUugOKC/0R4gbcrnw==
X-Received: by 2002:a05:622a:4d96:b0:4a4:3171:b942 with SMTP id d75a77b69052e-4a4aed86ba3mr229299171cf.39.1748958619327;
        Tue, 03 Jun 2025 06:50:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a4358eef6csm75933171cf.48.2025.06.03.06.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:50:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMS1y-00000001hCj-1MTz;
	Tue, 03 Jun 2025 10:50:18 -0300
Date: Tue, 3 Jun 2025 10:50:18 -0300
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
	John@groves.net, Will Deacon <will@kernel.org>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>
Subject: Re: [PATCH 10/12] mm: Remove devmap related functions and page table
 bits
Message-ID: <20250603135018.GK386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <32209333cfdddffc76f18981f41a989b14780956.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32209333cfdddffc76f18981f41a989b14780956.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:11PM +1000, Alistair Popple wrote:
> Now that DAX and all other reference counts to ZONE_DEVICE pages are
> managed normally there is no need for the special devmap PTE/PMD/PUD
> page table bits. So drop all references to these, freeing up a
> software defined page table bit on architectures supporting it.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Acked-by: Will Deacon <will@kernel.org> # arm64
> Suggested-by: Chunyan Zhang <zhang.lyra@gmail.com>
> Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
> ---
>  Documentation/mm/arch_pgtable_helpers.rst     |  6 +--
>  arch/arm64/Kconfig                            |  1 +-
>  arch/arm64/include/asm/pgtable-prot.h         |  1 +-
>  arch/arm64/include/asm/pgtable.h              | 24 +--------
>  arch/loongarch/Kconfig                        |  1 +-
>  arch/loongarch/include/asm/pgtable-bits.h     |  6 +--
>  arch/loongarch/include/asm/pgtable.h          | 19 +------
>  arch/powerpc/Kconfig                          |  1 +-
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  6 +--
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  7 +--
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 53 +------------------
>  arch/powerpc/include/asm/book3s/64/radix.h    | 14 +-----
>  arch/riscv/Kconfig                            |  1 +-
>  arch/riscv/include/asm/pgtable-64.h           | 20 +-------
>  arch/riscv/include/asm/pgtable-bits.h         |  1 +-
>  arch/riscv/include/asm/pgtable.h              | 17 +------
>  arch/x86/Kconfig                              |  1 +-
>  arch/x86/include/asm/pgtable.h                | 51 +-----------------
>  arch/x86/include/asm/pgtable_types.h          |  5 +--
>  include/linux/mm.h                            |  7 +--
>  include/linux/pgtable.h                       | 19 +------
>  mm/Kconfig                                    |  4 +-
>  mm/debug_vm_pgtable.c                         | 59 +--------------------
>  mm/hmm.c                                      |  3 +-
>  mm/madvise.c                                  |  8 +--
>  25 files changed, 17 insertions(+), 318 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
