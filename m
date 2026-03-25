Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B2F3BBA05;
	Wed, 25 Mar 2026 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450411; cv=none; b=mK07xH2gzQLzz9uUPLiik8MY+V6AwgDbSaLmN4ePkzldlYAXp11H62CPTboekZWEyXJiwFZdjttvAqU3djUIHjeKeVlqE4QvXmvy1+928/CEDjUetAvkrQ2O/hbolW+WXy0Bkh2onjEw5HSdhiZdI0Ouz0zPSvvTfvX0p4iYQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450411; c=relaxed/simple;
	bh=pg9BGRjMnJsXPkM0swwEs/eI5ok+Dj8gFwFH1IOCh5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPvztXY0vqDgUBz1v6Lt/aDsjuZxvDLFsdHjBlc4kRQ06WqHqk32cKt6dfZIo+V9GIipoX9OfzcPF+3kddvJcPWoEF/hpBYQQn+Z1fB4vuBAtYIV8/liiJ4q3Uk97SePLxY9Cd2f8FNjDw6mFpRYA3QHfxPePXMijjDDssIdGp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvHMKGo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvHMKGo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1631AC4CEF7;
	Wed, 25 Mar 2026 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450411;
	bh=pg9BGRjMnJsXPkM0swwEs/eI5ok+Dj8gFwFH1IOCh5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvHMKGo7C2FvWUchrPoeFaP+aBjxBO1iDfBDPu1ftOdOR9CZZDLVUFhCz/c7WGA7e
	 why6Yw24IOjuRI1p2bP95VB6ClN3gKVLzT0jfMnfC6i/nYozQuCobhRSSwOyXF1N3e
	 byo4/RyWBj3jJuX+8109h+cusNOVoW1YRJJbnkzrjTlLtysvhWEr4e7NJhA0wos2+k
	 fx1cPkStcPHCC3jsOhMQDS1F6pwJ6xb82zQvvaulOqpwhrnvUJ/5TyvKvTmDP6MVMS
	 pJz6XV1MltczUwUgLDYNLrOBFtEIandUJarxRBC8UrloEnhtM8rgFwrglv5AFfDkkq
	 NMz0cLZrxbpPA==
Date: Wed, 25 Mar 2026 14:53:14 +0000
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
Subject: Re: [PATCH 1/6] mm: rename VMA flag helpers to be more readable
Message-ID: <f72132e1-a2a3-4445-80ec-adeb525dcfff@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
 <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>

On Wed, Mar 25, 2026 at 02:51:04PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On reflection, it's confusing to have vma_flags_test() and
> > vma_desc_test_flags() test whether any comma-separated VMA flag bit is set,
> > while also having vma_flags_test_all() and vma_test_all_flags() separately
> > test whether all flags are set.
> >
> > Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
> > confusion.
>
> Hmm. The names are getting longer. We should fix this One Day.

:) yeha it's a bit of a trade-off still. But for now keeping it (fairly)
straightforward.

>
> >
> > Secondly, since the VMA descriptor flag functions are becoming rather
> > cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
> > rename vma_desc_test_flags() to vma_desc_test_any().
>
> >
> > Finally, rename vma_test_all_flags() to vma_test_all() to keep the
> > VMA-specific helper consistent with the VMA descriptor naming convention
> > and to help avoid confusion vs. vma_flags_test_all().
> >
> > While we're here, also update whitespace to be consistent in helper
> > functions.
>
> Extremely amazing patch! you were truly inspired!
>
>
> > Suggested-by: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

:) thanks, I don't know who could have suggested such an amazing idea, well I
won't read the tags to check + spoil the surprise... :>)

>
> --
> Pedro

Cheers, Lorenzo
