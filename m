Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E054378D74
	for <nvdimm@lists.linux.dev>; Tue, 18 Aug 2026 06:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787032926; cv=none; b=phiyybvDJFtny6jbVNfO2fSdIjpOHunnvHRDgqM3NI96ei5geCe/B1+ejwqVJXYr7pVN37QtQ32ubxcZIfo5IEQiCZz/LN4YwtyuMrWGw7ilk+igmcQ1iIIIK5+d2FgDNR21Ku5ppm+p8j0UOILwSpg/6iFtyVXSfBGQSRE9B38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787032926; c=relaxed/simple;
	bh=s/bYCD+OzYjKPlNVJ4+18l6J2ygCPbXwrH3ACRVDmpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCZQHFQ0SOtxXjio1pLIfR6KldTtlcLFztRTUdOYKjRR3UZUGfsWIfZP1/RKns68JB8hrreLpq9qfovWbFDN/fMUa+5Wv7GdAy1tlfpfqmhC8GVMDCx98ghh9MaDINOGd9t0vtqvF5ZSt2/WgoQiPlfnBptO5Gctt0hjPf2nhGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-d4-6a83f55bd736
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Tue, 18 Aug 2026 15:01:58 +0900
Message-ID: <20260818060201.1907-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aoMv3OhqkBTzSfek@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXC9ZZnoW701+Ysg38vFCzmrF/DZnH38QU2
	i103QixO3Gxks1h9cw2jxfOtvxgtft49zm5x/dZKRov9T5+zWDxoWsVkcXzrPHaLdacOsVmc
	n3WKxeLyrjlsFvfW/Ge1ePPYzeJbn7TF/T4Hi5U//rBaHFm/ncli8qUFbBYdL++zWNyacIzJ
	YvWaDIvZR++xO0h67Jx1l91jwaZSj+62y+wem1doeSze85LJY9OqTjaPTZ8msXucmPGbxWPn
	Q0uPF5tnMnr0Nr9j85g6u95j/ZarLB6fN8kF8EVx2aSk5mSWpRbp2yVwZSz68J+pYJNkxa4J
	gg2MG0S6GDk5JARMJKb9XccKY2/8M4uti5GDg01ASeLY3hgQU0RAVaLtijtIBbPANlaJWxc1
	QWxhgSCJrunPGUFsFqCSZ8/fsIDYvEBTZn28CDVRU2LdxltgcU4BM4l3F36yg9hCAjwSrzbs
	Z4SoF5Q4OfMJC8R8eYnmrbOZuxi5gHo/sktMuNEBNUhS4uCKGywTGPlnIemZhaRnASPTKkah
	zLyy3MTMHBO9jMq8zAq95PzcTYzAKF1W+yd6B+OnC8GHGAU4GJV4eHd8aMoSYk0sK67MPcQo
	wcGsJML7cTJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK/Rt/IUIYH0xJLU7NTUgtQimCwTB6dU
	A2Nte0hHgP5Fv5JcFYmHxzzXSwvu+jyLte9ut/XvnadLr84LmR3gWnesfM+l6kPeF90m+Hlt
	KHv2W+i3yz3due4fZTWavuxb+kRw3Rzj917Xz10/Ntlk9qbNaZO0eLt9psz0tdrnvPPq+6Xc
	0tE2alOYToqkTNwh1zy78byjx/S0HVv2PK7zzXVRYinOSDTUYi4qTgQApXRiQ84CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXCNUM9Rjf6a3OWwcJlwhZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK2PRh/9MBZskK3ZNEGxg3CDSxcjJISFgIrHxzyy2
	LkYODjYBJYlje2NATBEBVYm2K+4gFcwC21glbl3UBLGFBYIkuqY/ZwSxWYBKnj1/wwJi8wJN
	mfXxIivERE2JdRtvgcU5Bcwk3l34yQ5iCwnwSLzasJ8Rol5Q4uTMJywQ8+UlmrfOZp7AyDML
	SWoWktQCRqZVjCKZeWW5iZk5pnrF2RmVeZkVesn5uZsYgTG6rPbPxB2MXy67H2IU4GBU4uHd
	8aEpS4g1say4MvcQowQHs5II78fJQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8XuGpCUIC6Ykl
	qdmpqQWpRTBZJg5OqQbGjCy/b6KOyqdvH9aQv/5v57TNjhuLfxRzzBUuc0v+05rXerGv7H1U
	7LvsxCaep4+XF8sV3LjP13F+C+tcvxJ5z5ux0nFqa+Lzl07szd35rrIzp2i9pGt59CIt0S8P
	3058Jv3ZffWH90nH7i6+lcN8JURSV9g6NJ1l4wEvB9kvS5+8ORdm66mixFKckWioxVxUnAgA
	s7DBg80CAAA=
X-CFilter-Loop: Reflected

On Mon, 17 Aug 2026 12:19:51 -0400 Gregory Price <gourry@gourry.net> wrote:

> The original attempt to handle cross-socket interleave tried to deal
> with this with a matrix for weights, but this was deemed too invasive.
>
> This brings back that matrix, but not for per-node weights - we're
> basically just adding an addition weighting to filter on.

Yes. It uses additional information to filter the nodes weighted
interleave selects from.

> I have some concerns with the now additional filtering mechanism
> introdced into the allocation stack, but fundamentally I think this is
> a *better* solution than a straight weight-matrix.

About the cost of the filter: when the toggle is off, the filter does
not run. When it is on, node selection needs a nodemask filtering
step, but in my tests the overhead was negligible. I will look at
this part further and check whether there is more room to optimize.

> I will need to chew on this for a bit.  It seems there's non-trivial
> sashiko bug reports here to address anyway.

I am working on the sashiko findings now. The valid ones will be
fixed in the next version.

> When worded this way, "Package" sounds completely arbitrary and not a
> useful distinction.  This really just sounds like an extention for the
> existing fallback lists to take interconnects into account.

Other reviewers also pointed out that the "package" / "socket"
terminology is ambiguous. I think the description needs a full rework
so that it explains the current state better, and I plan to do that
in the next version.

> I wonder if abstract distance either:
>   1) already gives you what you want (the secondary weight)
>   2) can be twiddled in BIOS to give you what you want.

I thought about abstract distance a lot as well. My conclusion was
that adistance alone cannot tell whether nodes are in the same
package. This is an area I am still thinking about, and it needs
more thought.

About the BIOS information: as I reported before, on the two-package
server I tested, each package had its own CXL device, but the HMAT
reported one CPU node as the initiator of both CXL nodes:

https://lore.kernel.org/all/20260330025914.361-1-rakie.kim@sk.com/

I will post an update on that issue as well. What this series uses
is, in the end, BIOS information too. But some of that information
has errors and some of it looks reliable, so I think we also need to
sort out which is which, and understand why.

> The way this is written it sounds to me like this should just be the
> default weighted interleave behavior.  We already know weighted
> interleave does not jive well with multi-socket systems - this just
> fixes that (in a more general sense, Socket => Package).

I agree with your point. The default is off because it was requested
during the v1 review; Jonathan asked for it:

https://lore.kernel.org/all/20260325123350.00004d48@huawei.com/

Enabling is also not unconditional. I added a few constraints, so it
turns on only in a specific situation: when the packages have the
same node structure. I think the definition of these on/off
conditions is open, and it needs more discussion.

Thanks again for your time and review.

Rakie Kim
