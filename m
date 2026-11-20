Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795209243;
	b=q0tFj1JR2SPlVXwy/uS+UEIPiLd1J+/BfSB8o+3H1fZsuXLh5B53qgSoNbOiLgYatCSm
	 ouoKhbW7JS3ULN+Jx02BL3WF8+aWcb8f/XCY4bat7WFNLynwELIn4cZHwmxUWJxYXmx7j
	 0z/lvNVM9eRzVu8VlBLubX3SbUs4iFSTEoCTyoCrRJGy7XRiRyjsLBX6PuliNNDYzvftv
	 mU+ciPqWJiam2x9BXCgGMhaWF3gMgxvpIqX+Uj1H2TX0cHD2/jqsYQNLvxfpLGaETVTxD
	 T27GpYlmKTAtF2SOP9dvyAakKml5+LqCp1ekIh8oZ383j/uAuyr6cEDelu3q9M7IDYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795209243;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=rgi1aGfRJPjmX15dwsZZ/ym+YFuqjga+c6zIPHJVPJg=;
	b=uaJTm2Hx9CLuRQgkOuwSYiQUOtqPtKYFljmdeGWnJI1hif0GE8nyPOlGApvM3+ZeX9BC
	 XYKb1grWUV2yzdYxIq91KymgN+0Lcm3VJk1is64hOS4QlWwvHYYauhkYeyjyUMAaCLNAQ
	 7Gezvv2EwZ5EjwlBc1qusRWg2sj7Q+FYJnJLC60jstRsT4rD6cqtxs3ZVFkD8zxphP2Kq
	 Uy6tzc0o+B4ooJKzeic9Vfzw1GIkCKOEcD34d78lrXXJ9lRJQztvwIeExnHGY7qPcaA2E
	 k7HLY9HG7DuG5vVOMyW0sJiGH+5XlFtEBGdDEoeI9wVPuMmngxqtvknjD6pICHyG2ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gv2+Dmvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A77606A6B3;
	Fri, 20 Nov 2026 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gv2+Dmvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453D61F000E0;
	Fri, 20 Nov 2026 21:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795209243;
	bh=rgi1aGfRJPjmX15dwsZZ/ym+YFuqjga+c6zIPHJVPJg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=gv2+Dmvqihqedt8HXIdZSsiCvs7Pu+so708LYvSiiMJbnFhAOFonCVTXaOjxzqNtz
	 pPOq/TrZfzuqR3u1r7C/+a+6/ivwMP4tzHIWZOTMozKdLEK8/WITOLyaxJ3iTJJrZA
	 gavfZ1xGUlv4BdW6xPsgaCGhxnxC91wpunTEQWJSDPr/lMoqmH/hfQQ/0OgSxUiedV
	 7m/78LdVSNJaJx6faHiMqM/iU9RyuU/GRgs7SYQCSkAmry4u91aQxhCgtlZI2v2Zws
	 ZD6/ntPDNQb8NMsU2WXMvXVjBGlZUqTv5O3JYq9vd+BK6dYPXwEYdZ42140OhO3ch9
	 zy9TIQpGkLZYQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A395380A964;
	Fri, 20 Nov 2026 21:14:03 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM Fixes for 7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <awCfwssDI7SG4Bpc@aschofie-mobl2.lan>
References: <awCfwssDI7SG4Bpc@aschofie-mobl2.lan>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <awCfwssDI7SG4Bpc@aschofie-mobl2.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.4-rc4
X-PR-Tracked-Commit-Id: 5a277aa7eb4d4f1f05534d6c3dcb1a9fa4f6b8f2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a5242bd5b19c1270feaeeb596aee8b43ca3a44ef
Message-Id: <179520924189.792202.1762372008504188638.pr-tracker-bot@kernel.org>
Date: Fri, 20 Nov 2026 21:14:01 +0000
To: Alison Schofield <alison.schofield@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dave.jiang@intel.com, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, vishal.l.verma@intel.com
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

The pull request you sent on Fri, 20 Nov 2026 11:30:10 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-7.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a5242bd5b19c1270feaeeb596aee8b43ca3a44ef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
