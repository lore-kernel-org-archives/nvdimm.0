Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229103;
	b=X2PWVHvSh4SLzIzpfXswNp1I3S4KRjq9ktGdBP864EpF+9zjEEIDj6O/IjY5jv0nO7ls
	 LhSfyiEe2wT7PHacoEaM6PlXDU3TEOPbzH2VaJdVz/Y1+woXti/fqPD7OkbzJbu1Mp9RZ
	 s2ciAiui0ARGGLzB37eWSjzOqjxKPMm6k6iwwX82iRO/extEdnulN+CTlsD5a/13Oq/Dz
	 +3oOXiaz1i0WU2YyZNO8NOgtbwUrl6Cgl1Zr/OEobcrMP29D+dR5opvHVL09TjtNtMsnU
	 eupKeFToynavG2n3wuxInacKUDqjiUXg09YzaMdHtqYRwYZhoeYpKcYV+PEunXdULFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229103;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=RSimsWPOZBXQbAeQ2f3HPd3mk4s0VSZIzKVvoSmcClw=;
	b=4MoP6dGUfm9YoJmVRi9R5KCgcG0rqO0+lEFtFus0jE+iSpbfcEa2PQypefgfvkB2SL5A
	 lFGdw30H3n2x+iypUfm2cO8PS5U9nxf7Zi3VUjLAUAm161lxmJ4SIMEWtf+yut2zylZzb
	 bczAPuOfUfWPQG2Fguz7O8dh+vBcynw0Mj93dxy45QYCumfYO+aCBPU5wdV/twcisznqI
	 Y39qMX3erT8cHakJcBwqZXW1m/xdfiqB+p6GGxLsp82VjnHQ89r4qJx8xpY6+irzdoqIx
	 A4D5LB3byqs1Iujpp6tfWAIo9FiURZ6Yeq2ZLjDhC1oN4eZYrff1gIgEOUjPtqqDXlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMtUFTzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A7606A31C;
	Mon,  9 Nov 2026 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMtUFTzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1461F0089F;
	Mon,  9 Nov 2026 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794229102;
	bh=RSimsWPOZBXQbAeQ2f3HPd3mk4s0VSZIzKVvoSmcClw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EMtUFTzy81jxztIjs5l1INafd4UnMB4yWLOg8JrycpGzUSStaJHu6NpG/XazaW8hc
	 So+q40a2nZpEBVrYZ85AVxAGpAwhLFqpM19BLQ4IIPIs8cXbjPdo5RbiB+658116Rh
	 4ym76jQ7shpSd23Ph0IdqIc6YBcCK3m1+o2KL2OOp91htCTm355FvbJ679kLo7D6sN
	 1iAT6xDyER9rJILLxMDSbhgKgRFFhQ4qfxoW7c0tmwN9I1CDa6tpfRTbb2/Ek50voR
	 5pkY4GJANQDkumkqek8KvteWvAaPzqEOFrJPRvlhqKqjE2lhkxfz12VlP85Qr2ZVOr
	 qISOioNIlumDg==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
References: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
Subject: Re: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
Message-Id: <179422909975.6621.7905864498527659893.b4-ty@b4>
Date: Mon, 09 Nov 2026 13:58:19 +0100
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

On Fri, 06 Nov 2026 18:05:20 +0100, Konstantin Khorenko wrote:
> copy_huge_pud() adds the child's rmap of a device DAX PUD with
> folio_add_file_rmap_pud(). That helper maps a folio afresh: it updates
> NR_FILE_MAPPED when the folio becomes mapped and mlocks it in a
> VM_LOCKED VMA. Neither applies at fork: the parent keeps the folio mapped
> under the page table lock, and dup_mmap() clears VM_LOCKED in the
> child's VMA.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: thp-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/huge_memory: use folio_dup_file_rmap_pud() in copy_huge_pud()
      https://git.kernel.org/mm/core/c/f403b8aa

-- 
Cheers,

David

