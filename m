Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013787;
	b=tR3pyQjXtmNBz0FXibyy2BUH7m3I1lOCOHtBKPrQmMuqESF1U7SrLkaXTODsuBGf672W
	 n9AbF45jnwGcqZFIG5sbxrMybQUoFi9encjFie6dRyroWJEimRQH2PzVS0bD5aNYe06qe
	 CeB7WJS3//TsSF6I14zz24+P5uKUoSjGPiNxaMB2YL1W+qGXFFeJMxD91UVSO0ftT89fr
	 FtjN4HqotBbQ6kU1oYkFs0KLZnjOgYs5R14bBfLHwzM0uN6riGTMAL79b/5IinPPFkj9e
	 InYSgCWfFRQ0pedrkRsy5pNwWd6PBf3Spf81QnaaxnZnesrM1tIFVF+VwCvYCDX+ntA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013787;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=AfmHFHPccB7lfpPsxP2zwN+ffoQn2aS0RlA9LBjrJMM=;
	b=tjr8FABrwYvas8xHH8RDjTFHKKEeup+e70E763+UfOSa+1I1DZvHLdVbIUaaNLeFwNd0
	 dUZeuh/mgs6xsh+OSvguFsdIJiapCeCcPvn99rHB9eys8ZSR1ZjaktcxuvtCkV5ab9DWy
	 rUsIh4KpvJAxvkyEIpQQWrxy0+3V3rB20aNoYLIaaXe9w6Uj53gJvXgfoOgdJHey1454H
	 bP7Y6/dNGTibBeOjcVh+/N7jsBYZk2bfMJkiXVjU8bUgKTOgpvGC8bCXEkFYCOxcLIN8c
	 ZTwUMsyD6PpDZbZXLKOt+sGCH3s0EPUmQYjny7V19RmYUL1WWTRtz030IzZYffGpJwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAROiEXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E057606A31C;
	Wed, 18 Nov 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAROiEXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3561F000C4;
	Wed, 18 Nov 2026 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013787;
	bh=AfmHFHPccB7lfpPsxP2zwN+ffoQn2aS0RlA9LBjrJMM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DAROiEXl/uBEjFrbVmJW1e/aAc9Qw3sYEQhfet8uq2R7VAv9EWfteSAsL96KEdtwq
	 don0DD0FM8uwX3AIRJHra0yYM3r7AOC55Z2n5caoOAQrgcJzB0shseGNOQyWwTAZh0
	 5+9KTQFc5p9AWagn8fbjPNFUuh5m/W/ciqOdTqrP4GyPZpvVcpqwHmSYJMa/rpaDvi
	 2XwZOFGbE1AdcZrdFSz5UIqn3oG25NeSaCUh6cU6cp8EJ5gP0vjqo25eQsJQmxYsmP
	 i7hJdnolkk9NcnMUKWI3B6laPesoat/dfAIZWRT9v7gkgwzOqDSWWV3zAEm7byKfzJ
	 kwea6dZ0nlEaQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, Peter Xu <peterx@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
Subject: Re: (subset) [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
Message-Id: <179501378200.5042.13914562022654307180.b4-ty@b4>
Date: Wed, 18 Nov 2026 15:56:22 +0100
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0

On Tue, 17 Nov 2026 17:58:31 +0200, Mike Rapoport (Microsoft) wrote:
> Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
> refaults on reads and SIGBUS on writes [1].
> 
> The root cause is that insert_page_into_pte_locked() treats every PTE that
> is not none as a present mapping. Besides uffd-wp markers, this also
> affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
> concurrently with a write fault.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[3/3] mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()
      https://git.kernel.org/mm/core/c/3fa9917a

-- 
Cheers,

David

