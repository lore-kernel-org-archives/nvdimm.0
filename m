Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012068;
	b=DUe91uaLGW3AQ8qRl1/mIzRK0NgjYj745jlzTluU+bGSgEKPA6TifNrFR72H2Leu47go
	 rd98h75GKEbvrr0EyvffAR2NEt+wwclfA0VyG6cuAJdT8CtAAZeHw6rGwmkgpJR8CGtS7
	 J7e89BRGqYwiqJHYcjeV90Ebn3YxZdS54qMGOm3pCaMPuJ2ZuPMY811g4/ct7NPGZ5UJ0
	 PyxtUgTdoTbd/TcYmCwDsIDxSOhck7GXkf0TmCZJAIvn55RZzEm/rSshg8U6KqXQgQ4Ko
	 xXj0dIK7oeSKQVSrcRtSlyCbhNuB44Nn4oOLA6WmqMqCVZ6B6+VIwZV7cIH3SxiSX6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012068;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IrpiBrM7liH8MKiWPu8fuzT5T22D0j2HTUUXtUQY1FQ=;
	b=vm9q3TmsrDWrYfr6py/6UXPw/kB/BlG/m8EPWHCuqeIHTbrmhbzj29m6DIkxzQSsCIpM
	 CyDEORPHedrvBhiBylB1ZL8z0XzZBBtrdh+s8SpIXD5V8efq4dEgN54AK1Qbx+gQcWYUY
	 l0WUXYSu2nVVxPJYiT2bYCrBcW8cToO54wfvXk4WfxNx7qCIAzp0XMONzzYPYe2EhynM/
	 ZoXj9B7Th/UqpY1IhWVl0dapdYNMK8gNELPCTYlTYWFVpmpXTC3FuOaX66GAY3uFO/w91
	 lFVt7SfQHh7eAH+gUy77jSvMVm3Mv8pPGZqy2knhqTMdVSObhPY1ZxUExZCziHFYmPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTdaO141;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9837606A33E;
	Wed, 18 Nov 2026 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTdaO141
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BDB1F000C5;
	Wed, 18 Nov 2026 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012068;
	bh=IrpiBrM7liH8MKiWPu8fuzT5T22D0j2HTUUXtUQY1FQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fTdaO141iKava4U02bGsRcWshGkeb9ovgA4WkCWpAKecLl5TZxk0dnh8ZaYWicMfZ
	 tpbO0jgTXFuMb9gqtXs1H3JL505BuGEObSktbtHlRonX1W+CnBnXBsQQKdpF5NjgxT
	 4BLOudDQw+d5Ihmvy3SgJD22ccc1D3xe910LaQOMSsqSvecT0uhV/Tkh3KO0Mrpigx
	 Cq2MLRMR4vv3b0hfX8qa4KKZ1bLLx8uheVq4Jih0emKGKUSl+e1/MTBWVuvnv5z7zL
	 VbyQG7yDGok9QASvRPGIMJzdLQXa6NbzFfnflirjCDTg4o/9IjvADxQgGNfz8dNXlE
	 QdB9MSGP5/qNg==
Date: Wed, 18 Nov 2026 14:27:41 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
Message-ID: <av21s_WAXAzEtLyX@gremlin>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>

On Tue, Nov 17, 2026 at 05:58:34PM +0200, Mike Rapoport (Microsoft) wrote:
> On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
> maps a page, compares its PFN with the page being inserted and upgrades
> the PTE to writable.
>
> Since guard regions are allowed in file-backed mappings,
> MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
> after the DAX fault handler found that PTE empty and before it inserts
> the page.
>
> vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
> WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
> expected on access to a guard region:
>
>   WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
>   RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
>   Call Trace:
>    <TASK>
>    insert_page+0x6f/0xc0
>    vmf_insert_page_mkwrite+0x31/0x60
>    dax_fault_iter+0x3be/0x5f0
>    dax_iomap_pte_fault+0x1b8/0x390
>    ext4_dax_huge_fault+0x1a4/0x2f0
>    __do_fault+0x34/0xc0
>    do_fault+0x179/0x610
>    __handle_mm_fault+0x8ca/0x1250
>    handle_mm_fault+0xb4/0x290
>    do_user_addr_fault+0x15f/0x730
>    exc_page_fault+0x83/0x190
>    asm_exc_page_fault+0x26/0x30
>
> Return -EBUSY for non-present PTEs on write faults like it's done for read
> faults, so that the fault is retried and handle_pte_marker() deals with
> the marker.
>
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Seems similar to some of my recent work :) what a hive of alien facehuggers
insert_page() and friends are...

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967..a80925c61706 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		return 0;
>  	}
>
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;
>
>  	/*
>
> --
> 2.53.0
>

--
Cheers, Lorenzo
