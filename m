Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520B3414DCA
	for <nvdimm@lists.linux.dev>; Wed, 19 Aug 2026 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787127136; cv=none; b=WKAkJGOd1qLd7HDN0g0Wtlgefk3UHXtRGvIrTJtHpe0/IX/MsPWPh3DtoBPKI0vM/dxjKyuISE6CR7lPwZPrOrOMBjwB76NVmegtWCkfRpUVBQ7nUUC95uwWsqQYmSGssF9Q0jgBUvQYIMu/z82jTDkQQ0UKR4JazusvOFFey3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787127136; c=relaxed/simple;
	bh=Jd1pko6eiJbpj7o09dHg1sf9K02NWy6eV6X/CDEzJBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFUjd5joAsXJUceg2z90FyuUzeR9aFlEuYBQ58aYjBlFatsTNZv1DljarPJ5N4imTNwgJB4mnTzNL2/sTm6zfxdaW8q8LmMOE5+zbgZnG15qn41DHV3e2oQTiqF6F2GuIafXS/3yYh0v33D+8G6jaggZblDN6EmJPeZYSUUInPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-f3-6a856537501a
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
Date: Wed, 19 Aug 2026 17:11:30 +0900
Message-ID: <20260819081133.1924-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aoRbDEn1sQ7b22dy@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsXC9ZZnoa5FamuWwYZZ7BZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4MjZeectaMF+oYvW5
	LewNjBf5uhg5OSQETCTmzHnJCmMffb6EsYuRg4NNQEni2N4YEFNEQFWi7Yo7SAWzwDZWiVsX
	NUFsYYEgia7pzxlBbBagkh1HvrOB2LxAU65tO8AEMVFTYt3GWywgNqeAmcSv7WfBNgkJ8Ei8
	2rCfEaJeUOLkzCcsEPPlJZq3zmbuYuQC6v3ILvGkBaJIQkBS4uCKGywTGPlnIemZhaRnASPT
	KkahzLyy3MTMHBO9jMq8zAq95PzcTYzAOF1W+yd6B+OnC8GHGAU4GJV4eCPsW7OEWBPLiitz
	DzFKcDArifB+nNyUJcSbklhZlVqUH19UmpNafIhRmoNFSZzX6Ft5ipBAemJJanZqakFqEUyW
	iYNTqoFxaearFzEnNcxdr2zm+3XCyt9W9ow3T7XjhtqVTROX1nr81/zFGLnYpT3/o1jp0w4b
	ycuiZqoWqzZkqV6MWTEpgW2SBPcukS1c1fM7cxPZP56NK/t5vSml0q98mkm7lssroQjHP/e+
	sC06G8nCYKF/yUSmUL5trn7t++chz/V3MC2axRw931qJpTgj0VCLuag4EQBOzVVHzwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+c7OOTsuZ6cleVBYNIjQ0GaYfYLIqGgfUiCRBGXqyEObzimb
	t4mZl5KyEptK6iwNo9QtzXmdWcbyTlmmaS68pOW0NCtD8wLlkMB/Dzwvz5+X4gie4q6UQhXH
	qlUypYjk4bzCfSGeh9mrkeKbpoOwpMZIwtGptyRs+XAa9uXrSdg9kk5Cw4gRQFvDKoAro11c
	OGytBHBx+hsHtn2x4XAiowqDXQ33uPDl3R4CVvdaSPimuBeHAy0lJBwz/iXg3NRxuJTjBsdz
	JLDyzzoBLUM2ArbXNGEw710ZCa/NjuPQmtuJQYNRDtcaK0io7xjjSoTIXDzKRWWmeHQja4CL
	6io8UHnrLIZMVddJZPql46LuwjUcmT/5oZm6IoBuZX4n0dJHhMpnfmCoQH8Z1dS/x9GiSRhE
	n+X5R7BKRQKrPhAQzpPXDs4TsaWCJENfPTcN9DtlAweKoX2YDtsDkA0oiqRFTOezEDs603uZ
	rEGpfcGhGwnG2u9u5530KSb7jg3YGd+YNLcvk3bmb1SGGl9gm0V3prrWitvZgfZlVpteE3YW
	0I7M1ydtYHO/g+kp+oxv9nczmQ16Ti5wLN6iireoMoBVAWeFKiFaplAe8tJEybUqRZLXhZho
	E9i49OGl9dvN4PeA1AJoCogc+SjoSqSAkCVotNEWwFAckTP/Z15GpIAfIdMms+qYMHW8ktVY
	gBuFi1z4gWfYcAF9URbHRrFsLKv+bzHKwTUNhMrLdRqnyoLhk5IJS98jzA8jyuLwFPHj+7Te
	NzMgbpQKW/ROPCc1Z0yWSqxu00IKCRZSp+pX5nUT7QXnj2xTzQUbdnXvSZ3s3G9ayU9O8dQO
	+YuPDnpLF5YDXfiixHQfN+Erj+lgTWpu+/ZWszjEeXZ5rMLzufZYS2voCZ0I18hl3h4ctUb2
	D0WG0FzOAgAA
X-CFilter-Loop: Reflected

On Tue, 18 Aug 2026 09:30:36 -0400 Gregory Price <gourry@gourry.net> wrote:

> Not concerned about the performance, concerned about how complicated the
> mempolicy - cgroup - zonelist - page_alloc interaction already is, and
> then adding another filtering mechanism on top.
>
> Today we have:
>
> 1) cpuset constrains mempolicy (nodemask remaps)
> 2) cpuset constrains zonelist walks
> 3) mempolicy nodemask constrains zonelist walks
> 4) memory-tiers.c nodemask constrains zonelist walks for demotion
> 5) zonelist membership constrains allocation access
> 6) a bunch of corner conditions that violate 1-3 for the sake of forward
>    progress
>
> now we're adding:
>
> 7) memory-tiers.c nodemask constrains mempolicy nodemask
>    except when it doesn't, because fallbacks occurred hard enough
>
> It's already un-intuitive how and when memory lands on certain nodes.
>
> To be clear, I'm not saying this idea is bad - either as-is or in some
> other form - just that adding another nodemask filtering path is making
> it harder and harder to understand what lands where.

I understand what you are concerned about, and I share the concern.

I tried to keep the addition minimal and to make it act only in the
intended situation: the filter runs in weighted interleave node
selection, only while the toggle is on. It does not change cpusets,
the zonelist, or the allocator fallback. Still, it is true that this
adds one more filtering layer to the constraints you listed.

I will try to organize this part so that it is as easy to follow as
possible, and reinforce the documentation as well. I am not sure that
will be enough, though - it needs more thought.

> Mostly starting to wonder if we're reaching the point where the page
> allocator needs to take something a little more descriptive than a
> nodemask to dictate placement.

This is something I think about a lot as well. Many users simply let
the policy use all nodes, and in the situation this series targets,
that is exactly what costs performance. To fix it, the kernel needs
more information than a nodemask carries. But as you pointed out,
adding that information also adds complexity. This is my concern as
well, and I think how to handle it needs a discussion.

Thanks again for your time and review.

Rakie Kim
