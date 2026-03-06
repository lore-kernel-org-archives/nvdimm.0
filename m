Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40F626ED33;
	Fri,  6 Mar 2026 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772760506; cv=none; b=mZauMChpstgSS0lzZf7JJUiJvxEmHUQAqsKpVSo2L+eKouynEBMcsLLqc1mzj6rzYFnInDmJMSxVy0/GUI8GEPCqp1aoyHmprqdz2C9SrvS3VdRA/cBWwk7tO5otq2p2LRtAyr8S6FxRCLyxn7LNYhNlHlSH4nfNpphb9Uf/dlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772760506; c=relaxed/simple;
	bh=xoqtM6KgSSyBmEncwbFJBFIEM74nLDE4UHST+ZsEmS4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=PAzzu6Q1rAENrCD8TlJ3nJJVLA88X46geiPw+aupG1YqA8q+hBYn1wVhEsqBSbSQY7r7P5bcAnoRHStaXLl+irDud0SS27g8K8un7H2kgctuiZVHLzoA3+baeHKujuxqv6Zvdfhm+B9oW3Z0j04vE3L4j80rG7N2TftcRg8ZA2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GLd0s/ch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GLd0s/ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ABBC116C6;
	Fri,  6 Mar 2026 01:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772760506;
	bh=xoqtM6KgSSyBmEncwbFJBFIEM74nLDE4UHST+ZsEmS4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GLd0s/chsfmYvy+LIH62gG5cEGAEj5HMdsosVlCij4305RrtKNFRubz7oaemcCLGp
	 cYE1e6xHiziyBEv2LfZDfBA0YvxGjkdcmwIMHkbsWGB3BeloGCws11aDALA3BnxMIh
	 KTm0M6zqfZxOWL8K7hZizyGYcV4OsvQCT4Rk4jEc=
Date: Thu, 5 Mar 2026 17:28:24 -0800
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
Subject: Re: [PATCH 0/6] mm: vma flag tweaks
Message-Id: <20260305172824.fd712ae310748dc6338d6d5b@linux-foundation.org>
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Mar 2026 10:50:13 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> The ongoing work around introducing non-system word VMA flags has
> introduced a number of helper functions and macros to make life easier when
> working with these flags and to make conversions from the legacy use of
> VM_xxx flags more straightforward.
> 
> This series improves these to reduce confusion as to what they do and to
> improve consistency and readability.

Thanks, I quietly added this (and the -fix) to mm.git's mm-new branch.
