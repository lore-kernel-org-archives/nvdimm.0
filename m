Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EEB37646C;
	Tue, 22 Sep 2026 04:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790050757; cv=none; b=EoIbVvaW7fTrFAMktdwhYZ5RY3Esmf4QzPMPZWGcHlKXavV1gMoum3oRoafY54gBKj+r1ZsNDCU5/0GOcItZ58ZQuqiRCNZHRKdw0t3Z7NUT6hTCkmKY9Ui3NoKjp9e+Jzxl9SciznIz38O5L4/kMHpRqp7RbPlEa7QcOcpo8pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790050757; c=relaxed/simple;
	bh=RSkNLe7Sg4XW5hNedsHvH2OlF9gD0i811YKpi50IXHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6kLYP5dDiCsRDRfUZ9oxBCAP1MeMDNYW7mgZuJtzugLC6l2rNyfuxxEyPi8koWdLujXqZ4BdxDf2rFd1x42SY7umwG/6cKVdxgICsULAnmJILgTzPZ7T6KTzY7GO2ssIHHXQT9hLUYSwOsi67CHrYperVpnZ9OJ3h4HzrC7Sb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmENK7hI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmENK7hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E0E1F000FF;
	Tue, 22 Sep 2026 04:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050755;
	bh=k3B9ThvTz5RGopdNhG1qzUIIExt5TxIgr3PrinYt/7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmENK7hIfI4nkqA98Oh/niUu0cIYksY6wSgej1XD5+GYL6UXYorVaivtQlNyJiSpX
	 nivALJV8ZrE7rhhAByx7cYv653GwJshpUX47k6uUQFnx5+BhDo2hnkqJvqBaKu8Kcw
	 5kMLFDuvGBAw1GqmMdPK2hMzY6yraEn+9mzKbOYvqVjynlIICrYbanO4a00LJ1hKGf
	 gt8roYO5nUtNDUk5yGSvSZ1FAZ0JvgPEoiMFQBfEzxCb3Y4jtyqy5ZbqMnBE30e7v+
	 Vt6XOWIKes5R7kUjN3pLm25oTTAPCGJ+vkJy+7XIE9X0KXiGe2DEjJC1NPnNwKtQDv
	 uQYg1gExUb+SA==
Date: Tue, 22 Sep 2026 06:19:08 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
Message-ID: <arIBvO3cFQ53ivG3@localhost.localdomain>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903053535.17611-3-kaitao.cheng@linux.dev>

On Thu, Sep 03, 2026 at 01:35:35PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> TestClearPageHWPoison() is now defined regardless of whether
> CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
> handling is unavailable.
> 
> The test_and_clear_pmem_poison() wrapper duplicates this configuration
> handling and has no other pmem-specific behavior.
> 
> Call TestClearPageHWPoison() directly and remove the redundant wrapper.
> This also removes the need to include page-flags.h from pmem.h.
> 
> No functional change is intended.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Nice cleanup, but as David noted, please squash patch#1 into this one.

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs
