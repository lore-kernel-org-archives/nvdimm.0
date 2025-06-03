Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95E62253EC
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957675; cv=none; b=SaFHZ69TNK3C48Kv6IjRtqV/o9Xg2fZqbG9vhOnCKS8DM0u1Yz2uXTbLXh/iuCXx0FjzKAVHxL7GrvE8sVvA8lTcLfmlZt6+b+dbo6zRqqedE7Bd8wsA+QrafKosnj1dmt6BQcQQxvJN+NJWmRe4UVJe9tGRS3lwYBSY+c7sYzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957675; c=relaxed/simple;
	bh=Lw5cSrf9yXELvBT6bTYGu3OBlBOa4jK7fmgeC+bgcao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUaCmlpP5Cu0iiIZVXOLDhx0SFT0dkrhP/JEFtMFzC8su37UXfMKdIv4IGatm3KK+Ee3W9QvrvitExgIgg1iiJbVYiEC0jcYL3Kie/svS8emjy0FT7UndYwOqroAr8LHCvwelqF+NWtusDR17mAij5IyjBLwbhE0bX442B8HiGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=JhUX/DDB; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="JhUX/DDB"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6f0ad744811so41001216d6.1
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 06:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748957672; x=1749562472; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o9eD6fBv50JvJ7Gx4KUjwD3EkSFG+lO7duRzw9dtFZs=;
        b=JhUX/DDBcBWmFh90125f0e9CnRBp5oVNNUdbBpQ4u5OIHnX/I7VzY7asIpHi/0UfCV
         xsKf3hQ5pf6+nagRcazGG7KzgRUWZgIWPdHG5asjrD1TOj6yw688Jos3JoKgAvcPpyX4
         R4qjXZ4emnMJbAdpqubFhiMGcCAUaeUn1X4tXloUrPaXDNYSeyBU9V75jJNvg3eonsk8
         alL2WRul5RV0IXa3u5M3lMRQpfOWMkl+I5ydHwEZaU8T3P0bt7YvI3rT3svi5yi8ZNgp
         Jga4IYnxIkJwbnGkpenyebBTtDfWGD0iFcmfKJG4E4KOEcWkWl4Fymi8TVuV2rXwlofL
         fTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957672; x=1749562472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9eD6fBv50JvJ7Gx4KUjwD3EkSFG+lO7duRzw9dtFZs=;
        b=YZtQ3uNfzQwvSQt0wbjYJkf+RyC+4KH/MpgoM5Yyjaiq8KKae0sHfcNLhMC99mheyf
         zwxYdNQTiZzOVZ1D2y33tQJ0p1nDjnfkTCVgEvkkJrfVBwwyCz3TiYbmNCOiW8eMERsl
         GN++QcmlqHVZxSXRNa++wy+v/d433URg03Fnj7NAsLoyHY82XtblnCaVjk43MxI1RsKT
         7vpEd/PMK/5qE5xclkVKWPV2ThbgcrMpOLC14lnYfGuMTjVVp9/KJTbocSyRpyOa6/OR
         9EK83/suDZSNBKcoR+VeMZ4pIiNQR1nutj4n71/UEtXv+SqnSH98Yj/8jozvf0n6V+IE
         Tsqg==
X-Forwarded-Encrypted: i=1; AJvYcCV+pY1jJz4vXOGW3Zw08M4aVm3rEKGk7tteT9d+1P3bmeUzygq2q7qPSYMcaVZVwvygVbAA91I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyexjVgJjiDeOUHksXOE7elzHC1BSLSOlv5CT8FnFYjIpDSWCXA
	6H634Q1w8Dqg4SlImlMkxmIMheiz8OMQTBJRbxWVVZn3gl8OOYbzMmoy4yIrPO9tB+E=
X-Gm-Gg: ASbGncuZX+gSFzYb0kFOMxWYiZBhel+BoKWowHZyEaea/JaZcDa6LJHUgs83bfVVbv2
	5j4hCaRCkJF9n9U3rnERdCChxXSoPUPPmQs4H3rATRhDPoMYs4NWqiuTcnoRtuz/Mkap5J0h8mt
	kzAyGR6JNeU3rIbkX7ug1s838HkyQvkR+ZwiLZmERll3feoKJ60P9hfvFxOOwr1RxeQyrYjx7Uf
	O4FZEsi1hsq6fT3OY2GvonlSniEa+XfzeC1YZD+AkuQbP/uNfIrx0sU6zeBdRsSX8TgWlUjpt52
	F2xWS8x0aup/wC1RstvbLv68TWFK8NXqmF3eaQ3AuVR6EdwYgPxq8dwR+UXBMUtFY8ZdQFmKIqY
	v+Pqd6QE1d0n8b1jxJz+QbJK+5Vw=
X-Google-Smtp-Source: AGHT+IH3/hKllTZ0eEK/dcuWTgO5QsHZ5LZ3JNRLIXTEioRhdRSPfL4GWfnU3eDieGqXq6aFnuzp+A==
X-Received: by 2002:a05:6214:5096:b0:6ed:1651:e8c1 with SMTP id 6a1803df08f44-6fad90aa622mr189063246d6.13.1748957671754;
        Tue, 03 Jun 2025 06:34:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac6e00b78sm80064216d6.75.2025.06.03.06.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 06:34:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uMRmg-00000001h3q-2scY;
	Tue, 03 Jun 2025 10:34:30 -0300
Date: Tue, 3 Jun 2025 10:34:30 -0300
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
Subject: Re: [PATCH 01/12] mm: Remove PFN_MAP, PFN_SG_CHAIN and PFN_SG_LAST
Message-ID: <20250603133430.GB386142@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <cb45fa705b2eefa1228e262778e784e9b3646827.1748500293.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb45fa705b2eefa1228e262778e784e9b3646827.1748500293.git-series.apopple@nvidia.com>

On Thu, May 29, 2025 at 04:32:02PM +1000, Alistair Popple wrote:
> The PFN_MAP flag is no longer used for anything, so remove it. The
> PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been used so
> also remove them.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/pfn_t.h             | 31 +++----------------------------
>  mm/memory.c                       |  2 --
>  tools/testing/nvdimm/test/iomap.c |  4 ----
>  3 files changed, 3 insertions(+), 34 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
