Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124660;
	b=dXx+8Qv9k4M1z0k6/g1XJMe7tsRC3nKfx48mPSuttCNE+8Yywz4tfm61s2jiSLUARYBp
	 8tRAgg9anRTycnkM+fMMMgOfmON45jmS4u+3dhARoXGIjyE9/DHrB+O1He0W+j+eNpbno
	 63EIai3q8/dAWnwJmU+TjLwkBLfrjhfxVmWcEiERuUgCLlM2xXGgwP/vtDH+8sAIq+tzH
	 PyxnEc8H+vKfzcH+u4N8haA6nmnR81M29hVJiGzUwkbnhgwtblw09G3Bt5PhvwRYsrgtQ
	 F+dg0yxE5A/9mSMuRGFwLNYks0TNxtvupEB7mmV44PQgNdbdt8pewTCQKuoYI3eFH4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124660;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=4xcPhmuWH3Ell99Ath8YN024vZ3frwjF2r4bMzP1tVk=;
	b=jlPXnEqQtWvxdQbxZzszAx5jFsu5unZPNAPTvAHaK9yXYmX8gVDoAEPM3x6F+pp+phRS
	 /3Wiej859F09tO2rUlSjWMjMJrlSsGEEV2NLuMZWw9ajSRnRpnB5oezn9I24k3kdFmioE
	 Wc+MlAgU0uzDYm6p9LXm4fe0kdEH5MmDSq51kjrCGrV2C8uHab025TUz99tuOtayrR1Ju
	 vnNGnGgSox0onUA7ARS6uCQYMXKb6M5ZdXTxtfYuC93iOh/GWIDQ+2zamLlXXFu5BY26x
	 s0ngHiiGQ8esrCFhs1vffbaeJ5RbZyGnTQeuKBZajGcVy61rNuD9NmQ/S7LHPfhvoeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AO7iOF4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97881606A31A;
	Tue, 27 Oct 2026 18:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AO7iOF4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390411F01825;
	Tue, 27 Oct 2026 18:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793124660;
	bh=4xcPhmuWH3Ell99Ath8YN024vZ3frwjF2r4bMzP1tVk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=AO7iOF4+I+yfUIWhOGtNsEK2Na4BH8zQaWS69YlqBaBnnQunHxgzqgJZTaUPQtrra
	 xbXkxtsAPgKBtPT09Iu6NfJzjZqUlFClG9aZ8Ze37VN1wJX+P/TtIXiAhiCkge79gw
	 +2X9afrkW9SgrW3zP+9G5cKOx4ED9Xw0ibAd31d+eOsHFShfBfKGysbmLMWpRtKf0a
	 AKFj0dCDWoWy+T2Fmvv1XGzDjQgTa0M5RN4wV6qQQTTMcHkCdwpRvh6xhMA+wleDAb
	 jyeJsgVY8sgMSH+pqtubNGVQOz70dIe7ZNzTPoKxN6pfr6xuKJdLn55dYyEsxv4cYh
	 RmlJmJYThagaw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 075823AA9AA0;
	Tue, 27 Oct 2026 18:11:00 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <at7MCT6uhsn0B4ER@aschofie-mobl2.lan>
References: <at7MCT6uhsn0B4ER@aschofie-mobl2.lan>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <at7MCT6uhsn0B4ER@aschofie-mobl2.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.4
X-PR-Tracked-Commit-Id: 9b036546a02c6c9a5133f9c1e93503896595c6ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c60ebc3208b9ce1d8915318347962f7ce1dbd07d
Message-Id: <179312465863.244297.11949649813459837774.pr-tracker-bot@kernel.org>
Date: Tue, 27 Oct 2026 18:10:58 +0000
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

The pull request you sent on Sun, 25 Oct 2026 20:42:01 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c60ebc3208b9ce1d8915318347962f7ce1dbd07d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
