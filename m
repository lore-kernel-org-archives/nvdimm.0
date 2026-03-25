Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA0632470E;
	Wed, 25 Mar 2026 19:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774465907; cv=none; b=tpfHaqpnYudXQSqQcFHPdPOjjpZOrXk3KnBtKrqjyxG3Qkl7VS1sFkrqx3RlkMR/9pfCDqf29O9Pna/v3M8uO/0aOA7g12DpO7Pu8iYmxi0QVqtPfJntD2UQXi5k+ICgcdKPui9c+uLNmT7n8hqOwGs1MVhVTm7yhEUrCBkTqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774465907; c=relaxed/simple;
	bh=R8trGOgutAbT9TZyCLIzQHNIqzASbQS+83BkcRfxwPk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZTPY3+KTFHeYGuiL8i8Dt1jNORWDjJMhmZMEJmF03etMcCGttujkGBvEopiKRbrIvI03VTJXlLPQyxIvWY/XVjv/RPttbWt2FBz4vl5hXgfE4VndxGgTVg/wQEPpU4j11MnaTRpMRTB//90wdR1qAkuVVzlq9TkvEbEWQdtLdIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n+B7jA29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n+B7jA29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F077C19423;
	Wed, 25 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774465907;
	bh=R8trGOgutAbT9TZyCLIzQHNIqzASbQS+83BkcRfxwPk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n+B7jA29HYBmodMSUv0jabYWqYQkkzI25KIVUfzjjK3zF1RxFmsERQAksEeZZEv1h
	 iDMFChCVfnLLUa7gKSv1HXmC8QYOQ2DoFFNevqSjWHHy7buMTrhvRcmzF6+Bru4h1/
	 SBYFb48e+BEYOYgHK10JdqzPoTkS++h4SrH0RokU=
Date: Wed, 25 Mar 2026 12:11:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, Hongbo
 Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-Id: <20260325121145.24f51861d9933f8577b7d6c7@linux-foundation.org>
In-Reply-To: <1ae3915e-19ef-4be0-aa5f-fd66a2e18179@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
	<20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
	<959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
	<20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
	<1ae3915e-19ef-4be0-aa5f-fd66a2e18179@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 18:44:13 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > : macro) always being inline, as we rely on the compiler turning all
> > : constants into compile-time ones.
> >
> 
> Well I think that loses the meaning a bit.
> 
> Something like:
> 
> Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> -macro) always being inline, as we rely on the compiler converting this
> -function into meaningful.
> +macro) always being inline, as we rely on the compiler to evaluate the
> +loop in this function and determine that it can replace the code with the
> +an equivalent constant value, e.g. that:
> +
> +__mk_vma_flags(2, (const vma_flag_t []){ VMA_WRITE_BIT, VMA_EXEC_BIT });
> +
> +Can be replaced with:
> +
> +(1UL << VMA_WRITE_BIT) | (1UL << VMA_EXEC_BIT)
> +
> += (1UL << 1) | (1UL << 2) = 6
> +
> +Most likely an 'inline' will suffice for this, but be explicit as we can
> +be.
> 
> Should verbosely cover that off.

ok ;)
