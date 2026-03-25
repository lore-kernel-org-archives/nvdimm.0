Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C263F65F0;
	Wed, 25 Mar 2026 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450706; cv=none; b=RX7YWQ5g+BDWtSe5kJ4uKCLv1MI3Bv0oNOh/Yq3OkFPcX0HV2BoCCAiU1CUOj6W0CT8C7PYZHsFQAQjj0hF4kuq7SRJI8ht2NcXCvbTwJjuvNMGIh4juyYxhO1J/Zz3gUy48HbOJBHcU4BqVNxFLc0vhxWkg6lIy769DEp+Oz/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450706; c=relaxed/simple;
	bh=PJ66QebMQICZPHru+Ol9tC17Y8ZYviklyv0rvmLSZHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uR2qn9U9aCYthi5tHF+8a01cBUiCJk1IHtuvROe39ZtLd+qGdKSZiXwESEynW2eBysyd5dbhdngiawqDAnz0cAK/X+8XoSrjgzo74qSFC+hWIQQClwxP5TkIko4FWm/wSa4wkjyjh2+KgTl8vztuwO9sh5NwXkMyRW55CuwBF/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4H7nAW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4H7nAW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E62C4CEF7;
	Wed, 25 Mar 2026 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450706;
	bh=PJ66QebMQICZPHru+Ol9tC17Y8ZYviklyv0rvmLSZHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4H7nAW7M8zf238SiNH7LcqjmEdcm69QKxxl5QtoBGJ3JRpt98C6N4cv7bpBpqV4f
	 R8LDjFfBF3z2EguuCUL8pxrw34c6hMyFX/FEryKCamqgdgFnZ0jhdcjd+4e3FVTgt7
	 apBPGPVaF9c8DeWNz1pYn9IbEpEcV5SxRKlU3yt6Ss6/+nADVOXQbwxXIn0fN9JvJy
	 8UjP2CS36YbhgQgMfUXil2w1MkzCZ92GjJbbb7H//Cb0F5Y6GO2kRCAFiRSPudQGSB
	 hb5EasVzLPBeRXllpvhCNzLtyy4zucK4eYz8xXVySYjbaNxM+2eiXUaA3uGwmnrvRf
	 usaZbsHCKJTyw==
Date: Wed, 25 Mar 2026 14:58:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>

On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > macro) always being inline, as we rely on the compiler converting this
> > function into meaningful.
> 		meaningful what?

'into the equivalent compile-time constant code' probably fine.

Andrew - could you update that if there's time?

>
> >
> > Also update all of the functions __mk_vma_flags() ultimately invokes to be
> > always inline too.
> >
> > Note that test_bitmap_const_eval() asserts that the relevant bitmap
> > functions result in build time constant values.
> >
> > Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
> > inconsistently named versus other VMA flags functions.
> >
> > We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
> > about its new name being rather cumbersome, so rename it to
> > vma_flags_set_flag() to disambiguate it from vma_flags_set().
> >
> > Also update the VMA test headers to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> Is there an actual difference in codegen here? On -O2.

No, this is more about consistency.

>
> --
> Pedro

Thanks, Lorenzo
