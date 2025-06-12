Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307EA2D3215
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749751357; cv=none; b=Gi+KZ7L/26DTUDT/fY1d8XtNAzocICQj8NTFras/axhinJFhJHxA9vsmuab1eE4ARYnwPVMbKpMNo+7WqjFCrBHjMgYa59scY20c3aauDXB1cpokbUoNBhiPHB03OWp+nw3N3OLiHeyT6ZK2RpNqQp6BtIy9XFOAwFPAX5Rypps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749751357; c=relaxed/simple;
	bh=S7r59/PIWkoTLIG07/E/jEWrNmZtWKxEaHN/jiSuqUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8rO0k/fp6b7+vaU9ZNHeB0Lf+HngenYZyVz+zaT9Vy8i04UHLEF8MVRx4N4hpUPOdEWdLsZQ3E/aa0v5pvsDFKxDoM1pLmLkQXsmvR3IGJZTjCD8jvD+XzUXT3xOX3qvHq69WxPuQbVKE+t6bRF3X2BSfBuHJmIZdKCDtuL9xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YgM3o0d6; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YgM3o0d6"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4a58f79d6e9so14938571cf.2
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 11:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1749751354; x=1750356154; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Men1Nv7TOAnztTuH0H3iBJJYmyP24ktCmwcSSGXFev0=;
        b=YgM3o0d6qh6p5bP3AFMJK/9i66sbCH5kUOGeV5DIw1ZBU7A7xRkTA3xJTar+PvszAy
         kje3uHS/SLTzrty7N4zxjfT0oie/wXk5PbDpxfn45lA19VwXa5MRGj+iWg/nbO2EMY2D
         M4aU39FgkxZ4uNY3GTgSKywaiso+lXNpy06Es6y0XT64ahswhh3P1EGGatBlayYWd52H
         pMVUCKODF3dIAEfv8GesXpdbGoxs0GR1qUcgXBvk3deOrOEAdzgw7djv732gpFSand9y
         QeHkEaS5dL5YQOACrDGo3vEkf+SX1wyGnsr0X4AhF3O+eaqYIyT3zp9eevp0yrEtL/KN
         oESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749751354; x=1750356154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Men1Nv7TOAnztTuH0H3iBJJYmyP24ktCmwcSSGXFev0=;
        b=JuHtJNvnkKTbMB262nrL90cfG5pK6UATLGmddPxIxldWMyosSDt6/YM6RLT7gfXRig
         Ku1wbtz9ti0WjUDmNGXCw0OzqzfC5UlALt29XzefVq5U0rTr8YhCQJvA5TN3Xm7s9k9s
         c2zTJcT1VlqowO77zS+o48hyfHawAYGIPghucL/XtNcRmq0O3IFJEX6XL65rU7rHw/H0
         IW5+jg8xPO9AduM1SOydAuBKZtNOLs4tLHsCfRQfXpZXZNDtUkZgNcPScYYzxOAsbs2Y
         RA3WdB3doO0mfuE4PRz/Ocl8If5+ElIL0xeOB5TxHY4Da7EHuIegAfvj3fWnj1innAoL
         xGVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoFCfF1ZSmMVb6dpuRJQyAvyCTqAi67DlH7YzPdt5BuQP8Td49//q4T0jDLNbmxGbthXT+8oY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxdo58e3kTd5Fi4Rgl228GIr0RJdnu31BCSwZibFZF1Dq5LZO2R
	EYoSHbOY3mm9cWG7bCsdIlwfZrELJYiUlJGKNv5cvqYs+o/YH8MCxD1hW24cRP6BRc0=
X-Gm-Gg: ASbGncuVIeR2XkcXVxrA8w36hq2OTOl8okSmDFH4M2IRH7CV5MBAhJZWZNg3EbKn5Qn
	CCbyUpbh9YbaFd/axdEn9U1RWquAnau8zqTr+tKe7eM6TVOFp3Qen5AT0EcmC0hY2jtDEON/8Qq
	V/E+SeXK49/OqO2fAorujB2Dyc0q4IKEPpoqlDbo/gipX/YwesPEn2jEKxFWf4E0EoaCNe3fKjB
	MSuFUP99vBqXfDsFrvbFbI3Gx+AD7wpJjuEuS1GCypECTT4dQZ6/j2yhGkqkwl8ngiSiUtTndXE
	mOqJVK++nUrPhPWdux6knvmrp+CDr/V9iuMoSmY5yLB/WzFndOcmLDOJ8037aEM75q4DK7312yx
	+cyv6VGOe9uTJ3Q0mbsETiJFNRGciqNNclDghrg==
X-Google-Smtp-Source: AGHT+IF2gHZ0WFh5VXAMyx6YiN8EJ/UWCFphfLEXmh1c3StoJxVby1YEDKi6l0heE4IvQIvOlyk6VA==
X-Received: by 2002:a05:622a:1f91:b0:4a4:3079:55e7 with SMTP id d75a77b69052e-4a72fe7a666mr2315081cf.17.1749751353871;
        Thu, 12 Jun 2025 11:02:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a4b0cb9sm6750981cf.50.2025.06.12.11.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 11:02:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uPmG0-00000004kgF-3F9r;
	Thu, 12 Jun 2025 15:02:32 -0300
Date: Thu, 12 Jun 2025 15:02:32 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <20250612180232.GB1130869@ziepe.ca>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-3-david@redhat.com>

On Wed, Jun 11, 2025 at 02:06:53PM +0200, David Hildenbrand wrote:
> Marking PMDs that map a "normal" refcounted folios as special is
> against our rules documented for vm_normal_page().
> 
> Fortunately, there are not that many pmd_special() check that can be
> mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
> would get this wrong right now are rather harmless: e.g., none so far
> bases decisions whether to grab a folio reference on that decision.
> 
> Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> implications as it seems.
> 
> Getting this right will get more important as we use
> folio_normal_page_pmd() in more places.
> 
> Fix it by teaching insert_pfn_pmd() to properly handle folios and
> pfns -- moving refcount/mapcount/etc handling in there, renaming it to
> insert_pmd(), and distinguishing between both cases using a new simple
> "struct folio_or_pfn" structure.
> 
> Use folio_mk_pmd() to create a pmd for a folio cleanly.
> 
> Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 19 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
