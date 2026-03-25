Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E9316902;
	Wed, 25 Mar 2026 18:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774463278; cv=none; b=Rzcm1t2KJtMN0njE6HXcDGzFzQl/zaXsH+i5M9PbW5VxWtHRU5XDkdCFmFEnptBfskB44cjYhwmN9pSCiK6P1+PjWAR+Mu63rg+iGj+oPE2vUYpZbu6w6PLMfuv64jcY4oDRT/Dq3yBUTJK0prJoDWlLTVkGtSZx+AgnGEZ++os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774463278; c=relaxed/simple;
	bh=hpBw4RUY8JjxM8HYPYakB9zRBXoDbpL5Vame81dIANQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=R7tRQs9f2WQOp0ytXe6eD7TyAaouSzHvQi7+abW+7XDJ2Ah47RzXKeuI1oxANC7MRgjkv8rJg1uavSke0oI5b0gQauF1mPL2s7BhCF8rKRiH2Hmp2RDtiex1Xr0N+lWCMP/nyU/H7A9fXQpDgbBr81T0zOGQpIsisduMM/J22BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ahl4PxDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ahl4PxDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DC5C4CEF7;
	Wed, 25 Mar 2026 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774463277;
	bh=hpBw4RUY8JjxM8HYPYakB9zRBXoDbpL5Vame81dIANQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ahl4PxDMAZ4buO2ISagSICzQMCXJfWkl7I97eQ6yR1mOWfRwIu5UCh/gTbztrdxGC
	 fyA4HaqEAQXvNkPRoB9oqv1WPgBs8xAqNMYN0V08jI/FvWZ2bJt3m2qa09whBmgni2
	 JtFJg0xwVqAE8hSGnxFjcSYieb7qyA4v+ZsDWGt0=
Date: Wed, 25 Mar 2026 11:27:55 -0700
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
Message-Id: <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
In-Reply-To: <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
	<ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
	<d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
	<20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
	<959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 16:23:53 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Maybe 'into an inline constant value' is better?

<bikeshedbikeshed>

How about

: Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
: macro) always being inline, as we rely on the compiler turning all
: constants into compile-time ones.

