Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E987F346E7D;
	Wed, 25 Mar 2026 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774449057; cv=none; b=ac/9jbGNRCsAw74P62J5a5LpR9oHAFrejTPdj5bcVvtN/atUaqaj983C0bNKtqPXVFBC6nfIvxayfZhwq7vWF9X9MeQY+psM7l1+6idVDYD2DHs42D2+ZQoO2ndM8sW3MGtoM8MpfT5jeEoHfkPmolmtju2rz7wNC3skb7LAKOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774449057; c=relaxed/simple;
	bh=OQpFqKWwxd25pMaM9w94n955k1tKNdmUpjsCAsICsLw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WR9aZ4Fs1v1n/6vFoLB63/HoQ4Sg2vpnG/nXhYHg4kouIKsAUORTr4hxCVRwukYZd+dp3T68xkL0tkfatRZPp0L92P+lSMdOesaueX4R23ueH1SlfD3M+MCbCVhwA9oXf+opsZQ+rMN/1vEsA5CjczLWBdpBMdwq4vyVDlHeRtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TaQIHaHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TaQIHaHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B78C4CEF7;
	Wed, 25 Mar 2026 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774449056;
	bh=OQpFqKWwxd25pMaM9w94n955k1tKNdmUpjsCAsICsLw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TaQIHaHWbJ6OUKi24wqoY+iG7ETzPh3y8yky8t9lE2ya70DC44uMkF+BB78PCkwcf
	 dqGq2cXMEa/6DXJsiByERFpuL+S53MExhWTyLJBpj6fUQLDZazmgoAqEJiY/0w7QUu
	 IBdf/pwBSKOzYueJW79w0pMXQ0CEnoslYfFBmKGI=
Date: Wed, 25 Mar 2026 07:30:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-Id: <20260325073054.490f2e9658cbd75312732fbd@linux-foundation.org>
In-Reply-To: <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
	<20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
	<24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 07:08:22 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> > On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >
> > > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > > it.
> > >
> > > While we're here, update the helper function comments to be more
> > > consistent.
> > >
> > > Also add the same to the VMA test headers.
> >
> > fwiw, we have no review tags on this one.
> 
> Based on the discussion we had about this previously I was under the impression
> if submitted by a maintainer that wasn't required?

Well, it's a gray area.  Obviously it's better if people's stuff is
checked by co-maintainers or by others.

I'm not inclined to make a fuss about it though (hence "fwiw").  Quite
a lot of unreviewed maintainer-authored material ends up going upstream
and I don't think that's causing much harm.

In a lot of cases this is pretty much unavoidable because the patch
comes from a sole maintainer (SJ, Sergey, Ulad, Liam come to mind). 
But when the author has co-maintainers, perhaps those people could step
up.

> I'll nag people, but I'm a bit surprised if this is why you haven't moved this
> to mm-stable, given how trivially obviously correct this patch is.

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
shows my expected merging order.  It looks like this one will be in the
next batch ->mm-stable.

