Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760B6248F5F;
	Wed, 11 Jun 2025 23:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683286; cv=none; b=fpkHtZlagLAbi7LgNZwc0EnYabvvELskKYWViLPwCsXnABVEjaLa6JcxIutIK7eFPdi2g6lMpR4IQHJirJi48/23nHgNaOA4XGQiRTiota6k5Sb0+w3kRLnf+u2RHRUhy1pMaxR7ef5LMNngdkHnOQKKRQ7b2itFplMBKEKA/Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683286; c=relaxed/simple;
	bh=iI0Kj0iMx9/gwAzrpZC4Q+nF6kk89nBYnME2MFD72CM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kzrHNCVn680LDOHfIUa+ETDrdzIcevKXpZBPsqLS+kH9nNH/Oj+ZghtJgOLbvuRA0duDCT+9rgh/bEcA47zu0j7xyLUM/tOTTZSenzCKjCkQ8VvJzne/p9BZHyFZEq6I2fxdKZt98WQslsO+rmweCF9U6IrklWdduQxw50lRUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SY/GHK89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SY/GHK89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BFBC4CEE3;
	Wed, 11 Jun 2025 23:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749683286;
	bh=iI0Kj0iMx9/gwAzrpZC4Q+nF6kk89nBYnME2MFD72CM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SY/GHK89FXr8Uvif53wRdWKd6NAI6EnUtId5643s2rBEq9cvqXxgWQ4xB8FRdXn1E
	 LT8tcUNB3wmpUUkETQuY2Ps7PWhppAcPBiKkrnX3r8Pc0sUhov4SoH4OSozrWGelGR
	 X6qAaCdLB/hHevrQvWx3YBJRepuxlNYn/cByC6ks=
Date: Wed, 11 Jun 2025 16:08:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, Alistair Popple
 <apopple@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>, Oscar Salvador
 <osalvador@suse.de>
Subject: Re: [PATCH v2 0/3] mm/huge_memory: vmf_insert_folio_*() and
 vmf_insert_pfn_pud() fixes
Message-Id: <20250611160804.89bc8b8cb570101e51b522e4@linux-foundation.org>
In-Reply-To: <20250611120654.545963-1-david@redhat.com>
References: <20250611120654.545963-1-david@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Jun 2025 14:06:51 +0200 David Hildenbrand <david@redhat.com> wrote:

> While working on improving vm_normal_page() and friends, I stumbled
> over this issues: refcounted "normal" pages must not be marked
> using pmd_special() / pud_special().

Why is this?

>
> ...
>
> I spent too much time trying to get the ndctl tests mentioned by Dan
> running (.config tweaks, memmap= setup, ... ), without getting them to
> pass even without these patches. Some SKIP, some FAIL, some sometimes
> suddenly SKIP on first invocation, ... instructions unclear or the tests
> are shaky. This is how far I got:

I won't include this in the [0/N] - it doesn't seem helpful for future
readers of the patchset.

I'll give the patchset a run in mm-new, but it feels like some more
baking is needed?

The [1/N] has cc:stable but there's nothing in there to explain this
decision.  How does the issues affect userspace?
