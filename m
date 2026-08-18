Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54CC377AA5
	for <nvdimm@lists.linux.dev>; Tue, 18 Aug 2026 06:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787032910; cv=none; b=a3OVer1dtSkBBudyjjqE2QdMHKnVO6FP9epzPRFOZd5UfDntxjhLOfaZrRM+YCdmmp44xrS0vqiCzx5pvhPUKa+QvDHIpzaNsBvDKgTM9dLYua1RLJI61QYxsKCOoa/bUTbRXVemykn4dygnw4JrnYRNAvzOvD0w+x7gP5OQ0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787032910; c=relaxed/simple;
	bh=HgewIRpkemtGNOuhpM62yzSblJpWdOMvsCDjbtIDozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X86x1UKX7Kc9wMC7et8U9860w+Fu39jDRY7jKo4z9TLzPozOT5KzigR3cByWb9e53HAp4g8ohy3K/RZUFq3KLlr7h0ZIavFMBz1GqoFKdkDPnW5pB1tclhu3Eax71u75Yv530lXxnFCmGf9Mm8akMSmVDhKd5UppLIpgHisJIwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-b0-6a83f54c0ffb
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
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
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Tue, 18 Aug 2026 15:01:42 +0900
Message-ID: <20260818060145.1890-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260817045225.1807518-1-joshua.hahnjy@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXC9ZZnka7P1+YsgzUtMhZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4MpraTzMVTOet2Nou
	1sC4jauLkYNDQsBE4s0JlS5GTjDz2Z/DbCBhNgEliWN7Y0DCIgKaEidaJzGD2MwCB1gldnbF
	gdjCAkESXdOfM4LYLAKqEv1fNoPV8AKNmbFgKiPESE2JdRtvsYDYnAL2Ek9PTGYCsYUEeCRe
	bdjPCFEvKHFy5hMWiPnyEs1bZwPN4QLq/cgucfjNZBaIQZISB1fcYJnAyD8LSc8sJD0LGJlW
	MQpl5pXlJmbmmOhlVOZlVugl5+duYgRG6bLaP9E7GD9dCD7EKMDBqMTDu+NDU5YQa2JZcWXu
	IUYJDmYlEd6Pk4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeY2+lacICaQnlqRmp6YWpBbBZJk4
	OKUaGB1szc0vrmxX8+Ovd5PW/HzNt7g2TVRrwgcPjqpLVqwqPaXvMvb7/r6e++N1XM4JXYub
	E/MLXdo2cNjICzfF1LRyHL3h8GvC9krBR+KeJfqhy9YK+vQdkf5TJbWg9vGkL27HnhVI3k9o
	V2uMqw6dvuZoVYxZ2LKzEwQmJRQ//SK+VljhycRrSizFGYmGWsxFxYkATuQ3sc4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXCNUM9Rtfna3OWwdETvBZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK6Op/TRTwXTeiq3tYg2M27i6GDk5JARMJJ79OczW
	xcjBwSagJHFsbwxIWERAU+JE6yRmEJtZ4ACrxM6uOBBbWCBIomv6c0YQm0VAVaL/y2awGl6g
	MTMWTGWEGKkpsW7jLRYQm1PAXuLpiclMILaQAI/Eqw37GSHqBSVOznzCAjFfXqJ562zmCYw8
	s5CkZiFJLWBkWsUokplXlpuYmWOqV5ydUZmXWaGXnJ+7iREYpctq/0zcwfjlsvshRgEORiUe
	3h0fmrKEWBPLiitzDzFKcDArifB+nAwU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzusVnpogJJCe
	WJKanZpakFoEk2Xi4JRqYBRkNbLNOectwD5H+MJBh/U6i7z3We/0uJ30Y0Wo0+r0RxuUcwRy
	mzn/NPkfCF78xL7ZtnH3lubZ0yIWNn35wVx+N3R/TOb/Y8d+P9oboBfuw+qwtvFGh3ri5FqR
	BuHTk88Khuq+Vojpl/MNYLHXn3FIVSxQ/pXIDtkpxtsmzm4SiImS8Ji2UYmlOCPRUIu5qDgR
	AKUhhf7OAgAA
X-CFilter-Loop: Reflected

On Sun, 16 Aug 2026 21:52:24 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Hello Joshua,

Thanks for your feedback.

> On Sun, 16 Aug 2026 20:46:16 -0400 Gregory Price <gourry@gourry.net> wrote:
>
> > I think you are over-complicating the explanation and that's making it
> > hard for folks to reason about this.
> >
> > My best understanding here is for multi-socket systems, weighted
> > interleave as-designed is inherently sub-optimal for scaled workloads
> > that utilize multi-socket ("package") memory resources (DRAM, CXL...)
>
> I was thinking about this and I think Gregory is right here.

I agree. From now on I will keep my explanations focused on the key
points.

> I wonder how much of the framing around this series can be preserved /
> simplified if we just say "prevent tasks from allocating memory
> cross-socket".

I think this is a good suggestion. Even if it is not this exact
wording, I will look for a shorter and better description that
includes your idea.

> I also wonder if instead of limiting this to weighted interleave,
> this can sit on top of other mpols and just nodemasks against
> cross-socket nodes.

It does not have to apply only to weighted interleave. Patch 2 simply
groups NUMA nodes by the package they belong to. So the same grouping
can also be used for interleave, not just weighted interleave. I have
not applied it to interleave because I could not find a clear use
case for it yet.

> I am also out on vacation this week : -)
> I'll take a closer look along with the code next week as well.

Thank you. I look forward to your comments.

Thanks again for your time and review.

Rakie Kim
