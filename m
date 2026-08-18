Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927B818B0A
	for <nvdimm@lists.linux.dev>; Tue, 18 Aug 2026 06:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787032903; cv=none; b=PcL1H/UxGfhOwVLH23R7lilKRLhhwiGTr/2jrCO+jdo3H1b/5gya/CXXHwOtiHuv4D/UKGNbhQpPQipI/m+CnjTEuFE5vgJfFZdzwZmlRYbFZmZMo5MBGDQ+gZJ4gyNbAhQiYFLT+mfBG2eT1Uj4LUk//i0wI5IOalSi1Wxie80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787032903; c=relaxed/simple;
	bh=2HWQ+1Hofy0TiNJM3gg9vufAVBmsJX2uYq+bDtHscK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHdyn0EYStQYHiL8XS2Q9OU0zNg17nPXMTzae/eVe0f0WhKVp4RVzu3L3/kS58NTIaQ87mBYINRRjw+QVG7aTcOHLNr1sAcNxJpyUEIidIrlU1j2+aao1Oit0le8VqNz85NKJhJUWcLYJItRRLUy/KNULetjsHpWoD2ssbY5rd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-84-6a83f53a1e00
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
Date: Tue, 18 Aug 2026 15:01:25 +0900
Message-ID: <20260818060128.1876-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aoJY53BJztPQYumw@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXC9ZZnka7V1+Ysg7svTCzmrF/DZnH38QU2
	i103QixO3Gxks1h9cw2jxfOtvxgtft49zm5x/dZKRov9T5+zWDxoWsVkcXzrPHaLdacOsVmc
	n3WKxeLyrjlsFvfW/Ge1ePPYzeJbn7TF/T4Hi5U//rBaHFm/ncli8qUFbBYdL++zWNyacIzJ
	YvWaDIvZR++xO0h67Jx1l91jwaZSj+62y+wem1doeSze85LJY9OqTjaPTZ8msXucmPGbxWPn
	Q0uPF5tnMnr0Nr9j85g6u95j/ZarLB6fN8kF8EVx2aSk5mSWpRbp2yVwZayYNpm94BRnxdbV
	vewNjNfYuxg5OCQETCTObo3uYuQEM48u38cEEmYTUJI4tjcGxBQRUJVou+IOUsEssI1V4tZF
	TRBbWCBIomv6c0YQmwWo5Nny2Ywg5bxAU9raRSEGakqs23iLBcTmFDCTuPTgOhuILSTAI/Fq
	w36wVl4BQYmTM5+wQIyXl2jeOpu5i5ELqPcru8T7qV/ZIAZJShxccYNlAiP/LCQ9s5D0LGBk
	WsUolJlXlpuYmWOil1GZl1mhl5yfu4kRGKPLav9E72D8dCH4EKMAB6MSD++OD01ZQqyJZcWV
	uYcYJTiYlUR4P04GCvGmJFZWpRblxxeV5qQWH2KU5mBREuc1+laeIiSQnliSmp2aWpBaBJNl
	4uCUamBMeF7oMPnf3KKPCsuZj37dvCTl6J9lQuVc1xb0RK2OlhTXaJ23beY7Uc8dZ7iMxGzF
	nwvVfo/Xdp3lJyTH/aI00tzkfd/N/b9lT2SeXHX83HRWs+pJjz8GrjjSU1O1x2qz4gEmz3cG
	OiKWXo7LTYU5Xhn8Va4MuL97n0eSisrHoqbrwg0vK24qsRRnJBpqMRcVJwIACE9UAM0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsXCNUM9Rtfqa3OWwa+HmhZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK2PFtMnsBac4K7au7mVvYLzG3sXIySEhYCJxdPk+
	pi5GDg42ASWJY3tjQEwRAVWJtivuIBXMAttYJW5d1ASxhQWCJLqmP2cEsVmASp4tn80IUs4L
	NKWtXRRioKbEuo23WEBsTgEziUsPrrOB2EICPBKvNuwHa+UVEJQ4OfMJC8R4eYnmrbOZJzDy
	zEKSmoUktYCRaRWjSGZeWW5iZo6pXnF2RmVeZoVecn7uJkZgjC6r/TNxB+OXy+6HGAU4GJV4
	eHd8aMoSYk0sK67MPcQowcGsJML7cTJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9XeGqCkEB6
	YklqdmpqQWoRTJaJg1OqgdFl/qbSS7d3Z2ccnMN56dGi5qMNUyWDVZqXLajcd27/Fx6BFXlJ
	T+8znPnGIiw6d5r0XNar6u6yM/r+Rq14uqRhI7O3D9fjs55KW49w2OQ7/7vRWnTBNztAaIF0
	e/aK83zTCjblpJaaXjwh8Ud7dtEF49bixnPl6rk9QV/k34WtEfKZ97nd7pASS3FGoqEWc1Fx
	IgCfDHa9zQIAAA==
X-CFilter-Loop: Reflected

On Sun, 16 Aug 2026 20:46:16 -0400 Gregory Price <gourry@gourry.net> wrote:

Hello Gregory,

Thanks for your review and feedback.

> I think you are over-complicating the explanation and that's making it
> hard for folks to reason about this.

You are right. I will keep my explanations focused on the key points
from here on, and the next cover letter will be written that way as
well.

> My best understanding here is for multi-socket systems, weighted
> interleave as-designed is inherently sub-optimal for scaled workloads
> that utilize multi-socket ("package") memory resources (DRAM, CXL...)

Your summary is correct. That is the problem this series addresses.

> I think there is also an assumption that total memory utilization is
> less than the total capacity - otherwise some of the assumptions here
> break, but that comes with the general weighted interleave story.

Your assumption is correct. It is the same as the existing weighted
interleave: when the nodes are full, memory is allocated from other
nodes.

> I'm getting back from vacation, I will take a closer look this week.

Thank you. I look forward to your comments.

Thanks again for your time and review.

Rakie Kim
