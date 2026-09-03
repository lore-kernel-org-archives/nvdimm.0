Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189393E0093
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 06:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788416262; cv=none; b=XX+7hwyElnIcjhRY4YzJr38PMOcQG//Q7hrn2HIYjode4JKe0fGXIvkt1Uop08g+L8Po+Uo7qG7eydAseJLNIOoonqh1KKgx9MihH6Rkrfrr0EnH7bS5MsqCXZAXjy+bJSvbzyGOd7bmIa3qkwE+VHMnoXQ6noqjw2Hdb30+ymQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788416262; c=relaxed/simple;
	bh=qfDv57uIWsnOlT1w0+UzNsl5Tfmu4rytKxkaLXjRnNY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=B0ljKHbe3yC+5SmvjHzA3Gtg6gm7SzazgwifbMhq6BtTGcBNrN7s87pVYEDa/h+Xd1ZovSoUhAVFigEHNhc8/GfJj2sg1iW1v9Uua7qQA9SlvfLhTMwnVrljeTWLPcEg0usv1N9NMDI/KfUcLQ4nRwjziQnxVSepmJubL+0KgvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=COF3tCID; arc=none smtp.client-ip=91.218.175.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="COF3tCID"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qfDv57uIWsnOlT1w0+UzNsl5Tfmu4rytKxkaLXjRnNY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788416257; v=1; x=1789021057;
 b=COF3tCIDTOSDXzADGQry3tyJwYwceLvp4DXycmm/DJ0ob1i22DzIw7kTMSbS8uFek0eb/SS5
 kTVU9vywrF3yeaZXpR+yWeEQGOFEUPP+hXU2YAuh8dUGasnmsfOkgF2hnqZKqwvOuI1890sy1RR
 gLJnaiDRLizPVyw3H7yiaNmw=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id 015fc451421f2d60;
	Thu, 03 Sep 2026 06:17:36 +0000
X-Mizu-Trace-ID: 015fc451421f2d60
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260903053535.17611-3-kaitao.cheng@linux.dev>
Date: Thu, 3 Sep 2026 14:17:19 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <iweiny@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <E350C4C9-ECB1-46D7-B712-351D01C06C71@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 3, 2026, at 13:35, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
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

The code becomes simpler.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

