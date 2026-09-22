Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB1A3955E8
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 02:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790044458; cv=none; b=CqjYbfVaOZW/p1Zrgm+J8V4TeSlz2DE4v8637Yi+oaUBAHpPWeblAF3d9m+EnDGWS0iwihah/Dn5/6S0iL/KN5u43Db3quStoGCu0t3fjzMga/ligsVUAljf60SsRp33SPaAtF6KSwVE+GqOthmGNSpjFnMD9IPeVpkIetWo850=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790044458; c=relaxed/simple;
	bh=zmvXUaUh0x7Iq7a1F/nNLaoOJ/x9bsxphrerv34hNIk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Wri8oZouERn/wHZVE3vxVgxIZtECBW7Nn2CsuFvLvYyAubf4aA7vUfyVG2rHkcZzZHVGuNIevW9BwsEYq5gaL9OZXlRbvNeTsM5nHB45ghsNXHN8egdzPAHxaTGji296so8dOqY3YWdsaR3HFP35gglvBi5N8gwacHDzdJGtOWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IQDyPBvy; arc=none smtp.client-ip=95.215.58.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IQDyPBvy"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zmvXUaUh0x7Iq7a1F/nNLaoOJ/x9bsxphrerv34hNIk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790044453; v=1; x=1790649253;
 b=IQDyPBvytySjDtCrm0L/kZS6IT9oghsQWxh6du6fIYDq/Vs2yd5ecuSKT8bRupknQYcDeszY
 RsEseuz9+szDTReT2pIAcA2IgIbVqlFTF+Mx80+zcO0A9HjbVmEQJYtTKxQsEA2iFK2K0J5nQFA
 uUofquzRY22nEVeQaGHLX3DI=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id 8af55bfa8c8b6846;
	Tue, 22 Sep 2026 02:34:11 +0000
X-Mizu-Trace-ID: 8af55bfa8c8b6846
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean
 pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <arEovvqEpquODZ6X@localhost.localdomain>
Date: Tue, 22 Sep 2026 10:33:54 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Williams <djbw@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Mike Rapoport <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Ira Weiny <iweiny@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E55DD139-7B33-4269-8854-3469375AD587@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-3-songmuchun@bytedance.com>
 <arEovvqEpquODZ6X@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 21, 2026, at 20:53, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Thu, Sep 03, 2026 at 08:21:25PM +0800, Muchun Song wrote:
>> pmem_mkpage_present() is called after persistent-memory poison has =
been
>> cleared. It only needs to clear PG_hwpoison and undo the MCE nospec =
state
>> for PFNs that are still marked poisoned.
>>=20
>> For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, =
but it
>> still performs an atomic clear operation against struct page flags. =
That is
>> unnecessary today and conflicts with the FS-DAX vmemmap optimization =
added
>> later in the series, where clean PFNs may be backed by shared =
read-only
>> metadata.
>>=20
>> Check PageHWPoison() first so only poisoned PFNs update the page =
state.
>> Poison recovery keeps the same behavior, while clean PFNs no longer =
require
>> writable per-PFN metadata.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Then change itself looks good to me, so
>=20
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks for your review.

>=20
> but any reason not to hide the PageHWPoison check within =
test_and_clear_pmem_poison()?

I indeed hadn't considered this point before. But now I find it
unnecessary, because a patch [1] has already removed =
test_and_clear_pmem_poison().

[1] =
https://lore.kernel.org/all/20260903053535.17611-3-kaitao.cheng@linux.dev/=


Thanks,
Muchun

>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


