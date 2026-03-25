Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC65B318BA6;
	Wed, 25 Mar 2026 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774464265; cv=none; b=sTST3uzFwCZETY9ECu1C3rNfLoPIYCZi5s8PgSh+tEtv0gXyKhrlL5ycM59/6oBXIdY/eUSule6adGhBjrFjkwZ+Jf9MJ/ygZdVtTpyBRVpg/PR7Px++BpFI+2LG1v8FwJ5z16NTbd40C1XVwlnRZcda3eRsM/7M8aqbnSVbQdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774464265; c=relaxed/simple;
	bh=Q4Vizb1B1cpQvvFYrjV9Str+6hi34rpWBD8aY9TqbfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOOwNJD5vw/6VDucwaT923z0cviITfQiuzQLUs8C2fVcuE2tmGme5aTmcurRxrQi7VbyZQ3cPY2KMwMHUkewlQAXd3ZDm5qoTc2aUKLQxJmzcOMtFuvgiNafbPI2ow8kyDJxhaxxAZm/tbuz/tMaa8ZLG7MRUzv0/3YFCoL474k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/v6i8fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/v6i8fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24946C4CEF7;
	Wed, 25 Mar 2026 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774464265;
	bh=Q4Vizb1B1cpQvvFYrjV9Str+6hi34rpWBD8aY9TqbfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b/v6i8fo+vCDTuurUcBJ6vIdUXSzqxb7B/H+jyR7aziWaxChVparkP1xpzHA4L+Kh
	 0+1G6NUJO+VCs044hBHbYry3sea3INNqk7t0OXSop7kK5AFE6+TV1USZMWYfrTWg8j
	 jChBK3dgjXD7onzbUo4rew4EgiAnImaScdAATampyOermEf2S4+tueQT1DEeySLNN7
	 +C1nJXrvxSmvCUSUxc3imsiO1O/XlT+bAFM9byzYzFr3UcRgxYAzPP3U9yE3FGbBEn
	 f3QXzFPLvC1/nhdJGTidMO1E4V+YOCqWwK6fYm8qftH9YVIwmMVgXEjBHRRNEV3si6
	 nbeb1Qgql8q2w==
Date: Wed, 25 Mar 2026 18:44:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <1ae3915e-19ef-4be0-aa5f-fd66a2e18179@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
 <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
 <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
 <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
 <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>

On Wed, Mar 25, 2026 at 11:27:55AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 16:23:53 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > Maybe 'into an inline constant value' is better?
>
> <bikeshedbikeshed>
>
> How about
>
> : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> : macro) always being inline, as we rely on the compiler turning all
> : constants into compile-time ones.
>

Well I think that loses the meaning a bit.

Something like:

Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
-macro) always being inline, as we rely on the compiler converting this
-function into meaningful.
+macro) always being inline, as we rely on the compiler to evaluate the
+loop in this function and determine that it can replace the code with the
+an equivalent constant value, e.g. that:
+
+__mk_vma_flags(2, (const vma_flag_t []){ VMA_WRITE_BIT, VMA_EXEC_BIT });
+
+Can be replaced with:
+
+(1UL << VMA_WRITE_BIT) | (1UL << VMA_EXEC_BIT)
+
+= (1UL << 1) | (1UL << 2) = 6
+
+Most likely an 'inline' will suffice for this, but be explicit as we can
+be.

Should verbosely cover that off.

Thanks, Lorenzo
