Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177F21DE2A8;
	Thu,  6 Feb 2025 21:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875994; cv=none; b=bUiLOIP5rmytvVbH0iCQtB5ZP7dCfHQaIRFkXHCaZ6JAM1GFlcQwmzMTheEpNvM8O3RcL/mdlCTYaGeesc56f+FzikbCuKbpvQAC9dKQ8UAc3wPPrIHTZwQjQ6rfb6aXhtqz5rSb1Wqc4lUgQUoY57FexfSEJgRSE061IGbao+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875994; c=relaxed/simple;
	bh=WnxIsln6SeTusJyOWF0V7uWhxW3uWu/uAV3yLKwXn1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbKNG7Z3Kv+EVo+sPbAwCNKKyKVbVwx2KVgentKKUdQPAODbbar/ZYRHwEofet0ir2vYKch0Aj79Rk1KRiL4IWD7hhvsz4lnCXry8M9m74GGsDMn7xakl3LXJa2CJqf9gZOer7M9p1r1DkvKvVTWxxEQ95D0TST4EYeyoRRYAi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSHjW35n; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSHjW35n"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fa19e1d027so1019858a91.0;
        Thu, 06 Feb 2025 13:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738875992; x=1739480792; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BjMZZDjHtCceqfzd+zK9UkArZCmEsWhxxeyu2AQZCbw=;
        b=RSHjW35neliGr4djwZeoAxZTdahd/hHEUMwvwPubhmCqv+Yan02p8rFtk2hnwoTsV+
         ZRqA9hoSUJU6TadB80YnU1wIHPf9tujKXCKJNstqRAzeT/Ajq8+mbi6d7Z9XCYCHcJv/
         uTLMHpsgQsHevyjoO/o3RIdbhkdJdDZ5Kf21yPDogE1Rjx/mPGQ4uQ/lDJaaPzSQIeDC
         eOUfPXoCsM8AhoTjTsfDqKXp7kVbIPNzLNFHxq5wNyL7Cjd3P9W05O4FUSoMm5qaHu4r
         xejAznSQ716IvkkIImQ2YOmwgmzECeBIlKNkuOIug9w33TBtBUk5XKRzd3pNLbpKnDmt
         eyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738875992; x=1739480792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjMZZDjHtCceqfzd+zK9UkArZCmEsWhxxeyu2AQZCbw=;
        b=F4q0sMipmgLMfECY7QKdDeeCbtkQafpzviGqci/7pFRZIsLhWHiqktPC9kY6LOwAqQ
         Ci1NCYVI8a8nq4e9vA1PcPnyzdNatQOFwsWBrq64Ht6u5+SLJ+t6mJ8/BXTdabQB19Nf
         2xFpyel7S6bPiR9QMrKy9JBVuAHwIcwXMIWuFhJF/7YM8YsmHOg2PFOLgn3FSJjHnaVj
         k3mQWznbece7VBaT5TAUS7uHCPHbzynZsNiERGlGy7eH109pSLYRLH7SE0Ot2epY+/QB
         tP3OmEsfHN3jVCgpeHOj9eCSJpuBGEQrEq/KrjuFS4BSLTRIU2FkFGyAjKaLiwaDPZAR
         zp0g==
X-Forwarded-Encrypted: i=1; AJvYcCVo7sQ6kZzphQkl4408iofjVTDXSE4r+jU1HqSo7EaPTnL3+GcRvIRFkL0jYvkzXWIdeP0Ikutu@lists.linux.dev, AJvYcCW0HdM14vBDhWUXugVdHu1skPB0ivmTnvQr6CPNptsxZQ+r0kmbVO60U61gWZim3V+8o7XqfcvjEys=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2Q+6x8LQNa872aU6Mb8DMwYgSe/jpAEzUnBkfEqMomYUmRwQU
	QSizTJnhDwPCUmQg+U+SG0egAOqhUA8i8xSNqm0eC8Y4wiWnV9PT
X-Gm-Gg: ASbGncsv33SGBEFCAqL2LW30GahoBYeFX1U8eP3hsLFna/w0fKjWlnubkXwb4UxtLvE
	Nuyvb1GFICYDsRnz2twrlydQN1gl8vnBhTSXWgHnn8CUhmorBiFTOrpS+xJsVdRQOrcikw6fYLY
	HHMuZxA0XB+eLLeOZ3Gpl/oWwLF9Zvcg3VYqhB9/uU7s30nHJ9D6irGz2wZv3DrgEfi9Z1q8dAA
	w7WPaQFn3BfFGFIjlc1WR2NYbukFwdsk8xdupcGU80YrbMxMNnpWrqlE4zdnLjl2nJxAQ7BrIAr
	x63P4CpzpY4vrGpMQ4G0U6nUSO83
X-Google-Smtp-Source: AGHT+IH78/uCL9JiB7gG2UlgfTf9jp7yPy30ClKcc0/9tpp9zOrpumyNaOrCnZmQL5OMHTgXCvjCaA==
X-Received: by 2002:a17:90b:4b8c:b0:2fa:f8d:65e7 with SMTP id 98e67ed59e1d1-2fa23f43a0emr821750a91.2.1738875992197;
        Thu, 06 Feb 2025 13:06:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa17618064sm1089562a91.41.2025.02.06.13.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 13:06:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 6 Feb 2025 13:06:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, linux-mm@kvack.org,
	Alison Schofield <alison.schofield@intel.com>, lina@asahilina.net,
	zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
	bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca,
	catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au,
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v7 19/20] fs/dax: Properly refcount fs dax pages
Message-ID: <f5e487d8-6466-442b-ae97-a7c294dc531e@roeck-us.net>
References: <cover.472dfc700f28c65ecad7591096a1dc7878ff6172.1738709036.git-series.apopple@nvidia.com>
 <b5c33b201b9dc0131d8bb33b31661645c68bf398.1738709036.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5c33b201b9dc0131d8bb33b31661645c68bf398.1738709036.git-series.apopple@nvidia.com>

On Wed, Feb 05, 2025 at 09:48:16AM +1100, Alistair Popple wrote:
> Currently fs dax pages are considered free when the refcount drops to
> one and their refcounts are not increased when mapped via PTEs or
> decreased when unmapped. This requires special logic in mm paths to
> detect that these pages should not be properly refcounted, and to
> detect when the refcount drops to one instead of zero.
> 
> On the other hand get_user_pages(), etc. will properly refcount fs dax
> pages by taking a reference and dropping it when the page is
> unpinned.
> 
> Tracking this special behaviour requires extra PTE bits
> (eg. pte_devmap) and introduces rules that are potentially confusing
> and specific to FS DAX pages. To fix this, and to possibly allow
> removal of the special PTE bits in future, convert the fs dax page
> refcounts to be zero based and instead take a reference on the page
> each time it is mapped as is currently the case for normal pages.
> 
> This may also allow a future clean-up to remove the pgmap refcounting
> that is currently done in mm/gup.c.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ---
...
> -static inline unsigned long dax_page_share_put(struct page *page)
> +static inline unsigned long dax_folio_put(struct folio *folio)
>  {
> -	WARN_ON_ONCE(!page->share);
> -	return --page->share;
> +	unsigned long ref;
> +
> +	if (!dax_folio_is_shared(folio))
> +		ref = 0;
> +	else
> +		ref = --folio->share;
> +
> +	WARN_ON_ONCE(ref < 0);

Kind of unlikely for an unsigned long to ever be < 0.

[ thanks to coverity for noticing ]

Guenter
