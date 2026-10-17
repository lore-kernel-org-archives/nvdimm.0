Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36204CF483;
	Sat, 17 Oct 2026 02:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792203673; cv=none; b=isci0y3ExUaOxuwSLTDpMer9+F25sDdtTIwLosSZfN+tw44O8dDVmT6Qt64hfffcHEHGHlOVK65wykc+h21Efw3vErrbBD7jwYvHJPSiN9fmRP93g9vb5nkt/BmCqQPF9SZlzaqqwR7OB/ZRXHXT8k/geITizuY1I6S/Eb7OYds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792203673; c=relaxed/simple;
	bh=0TfubNCRKx/nd4YIwWQ9zAA6YnSczDnzEoamyZzo2QE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RPyutydQvxuSmWdKdiwCVx4y11yxcHMElJlq6Zk+75GeKftUqDS4yZVDH6yV2FxjmMGIoZLEQMwJDx+5m6Ou5UkOi3kKFb5h8MT2ugqPSoWaUxj76mTpHZNGD5IuuATi6mZAsV4D2yCeZ0BeQYOD2mFXHfyifD9YA73xpNBpS2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oHkyY+Z5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oHkyY+Z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6271F000C4;
	Sat, 17 Oct 2026 02:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792203672;
	bh=9kRCw0sKehKRxmnkhA1oEqDkBNynw9yxGSEEeZ/1H6s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oHkyY+Z5Ymkq1XEoRDrm1unXQCYkIsRZyIk+AFZSJ8WFcZ2jRLLrTtiAYqX2wxxBf
	 /C9TjfiWVK5xpPlN2RPaq31PQTQZL3VsQxjp6HCa9nbL/STbOluZD+QFrFEDROKFfP
	 BuP+8UW1QgrBoxAXEEkjw7vavuoZzfdjbz1hrznI=
Date: Fri, 16 Oct 2026 19:21:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>, Dan Williams <djbw@kernel.org>, Vishal
 Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Joao Martins
 <joao.m.martins@oracle.com>, Ritesh Harjani <ritesh.list@gmail.com>, Muchun
 Song <muchun.song@linux.dev>, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: warn on unaligned compound zone device ranges
Message-Id: <20261016192111.cf4b6477a13a711248a8a079@linux-foundation.org>
In-Reply-To: <20261016131334.3419393-1-songmuchun@bytedance.com>
References: <20261016131334.3419393-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Oct 2026 21:13:34 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> A compound page of order N must start at a PFN aligned to 2^N pages.
> Therefore, a range used to initialize compound pages must start on a
> compound-page boundary and contain an integral number of compound pages.
> 
> Two recent Device DAX bugs were caused by ranges that violated this
> invariant, but neither was detected by memmap_init_zone_device().
> 
> Warn if the adjusted zone-device range violates this invariant so future
> violations are reported when the compound pages are initialized.
> 
> ...
>
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	if (!nr_pages)
>  		return;
>  
> +	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));

Would VM_WARN_ON_ONCE() suffice?

> +
>  	/*
>  	 * Seed the reusable head-page template from the first real struct
>  	 * page. The normal page-init and refcount helpers must operate on
> 
> base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
> -- 
> 2.54.0
