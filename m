Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA31A45A2A7;
	Tue, 21 Jul 2026 23:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677612; cv=none; b=jLRcGi0pCFUJbiOFsXKA8xBg40v3ll8I/z4Bm9tsTyyP7Iv25erGImf5N6dHvnXHujfM7lQh7xa9R/THnLgZ/gVjLY4Y85QIDiH2zDdYL6lAMBdjy+P4bHkSXhHnlnDgn6Njw5uJyo08DZd8t/JvkDmGD6o8IsuP4pZ1Nji0xl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677612; c=relaxed/simple;
	bh=USHYKM2tLy4Y2ztkLZF6f9FmqFRcbaq9wg7QuwUAQTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC4xp5/aVjCSZPCXMKUOrh81eeHWljJYoFknvutngFgcdALNLN4aqH7kK6aSMyPYh3hFr+EcKpgSaaarGxm8vUnH0fZJ+XjgSBKQhciKByJ+7pa22cVc/4TwleDT/Ok5/IEJJEyJEtpL9X2Pg9M9/Fipl33E9o4ZWnYPgkbStwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mf7XqWOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mf7XqWOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028631F000E9;
	Tue, 21 Jul 2026 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784677610;
	bh=+0XfbMYAs+xVo8YgwGz2IArIgBM63GjQWpuSMnFC4C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mf7XqWOi1rUqf2k7ey1aDXqzOKACKpcmAuKsBfr2jWONF2TMjeSDzMxVpjORRSRLo
	 tJLrP4Ev455HyaiuyA6vyf+G3mnH2UZZhuBZY5goVpKoGAXG741JRTws0gCCVCRoyI
	 iDsWfQ2T3xzfofEqGm4FFR1PI4AjbF6RuFR8pySoZwfx2gMG3Vh9pp2pwpXntxb7bE
	 X1TK5weGK4xyqJJ6Zjr0lnMzVsQ5o3Y2X+mdOu2HU0hX9kVQ5ylnFUDQy9TC37hUH9
	 cDRlgmF4QgxgkeN3r4i6WBCGdvrju3BwhQHkK2ItQ/gb2/mIWodaTaAr89dmjRF4Wt
	 CX+3VUR36PjOg==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON migration and pageout
Date: Tue, 21 Jul 2026 16:46:43 -0700
Message-ID: <20260721234644.149401-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720193431.3841992-15-gourry@gourry.net>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 20 Jul 2026 15:34:08 -0400 Gregory Price <gourry@gourry.net> wrote:

> DAMON operates on physical address ranges, which can cover private
> node memory. Skip private-node folios in both DAMON's migration
> and reclaim paths.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/damon/paddr.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e4f98d67461f5..c741a94319750 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -12,6 +12,7 @@
>  #include <linux/swap.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/mm_inline.h>
> +#include <linux/node_private.h>
>  
>  #include "../internal.h"
>  #include "ops-common.h"
> @@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  			continue;
>  		}
>  
> +		/* private node memory is not reclaimable by default */
> +		if (folio_is_private_node(folio))
> +			goto put_folio;
> +

"by default".  Does that mean it could be reclaimable in some situations?  If
so, could we check if it is reclaimable?

Also, what happens if we just try paging out the private node memory?  Will it
simply fail?  Or, make some problems?

>  		if (damos_pa_filter_out(s, folio))
>  			goto put_folio;
>  		else
> @@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
>  		else
>  			*sz_filter_passed += folio_size(folio) / addr_unit;
>  
> +		/* private nodes do not support migration by default */
> +		if (folio_is_private_node(folio))
> +			goto put_folio;
> +

Same questions.

>  		if (!folio_isolate_lru(folio))
>  			goto put_folio;
>  		list_add(&folio->lru, &folio_list);
> -- 
> 2.53.0-Meta


Thanks,
SJ
