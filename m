Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2128F1B86E6;
	Sat, 20 Jul 2024 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721500935; cv=none; b=IeELQrsA+ahGmqiQ0M1tOf0UAwwbxsXnKPCtFy2tFo0LvcnxYn/Dzo9kWN6MxFG+ED4W0yW+dheeN/0fY/wwBcTwqbIQt2FXrcgcJxs7DnoWUSG/f2vbiiqSD+J/E/3mAbtyEwRTiWMrJl8PZRr+wstOGDz/a2cxfvMTpuIF8Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721500935; c=relaxed/simple;
	bh=1EvaZCSIFNw++0eXYIXM53IyViGm0z0lt33BnKdHIjo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IbKOC2Bc1z/ndbFn6hIfJRkYyhXM5WHTQT/1PlgkdjX6y5BLwyxQ9iCDpsq55xv5OY38Pic0VsWhXN38+1SYppKP6ILfB5wfYr7K7wgvlbPsXANRKXKby1ihUcFXXSJ1YPRBEF5gW0tOtI+qsbPzoYEplbhWhveWipTkC+WhB9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s/Pu4Zhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s/Pu4Zhx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05BF0C2BD10;
	Sat, 20 Jul 2024 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721500935;
	bh=1EvaZCSIFNw++0eXYIXM53IyViGm0z0lt33BnKdHIjo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s/Pu4Zhx7vdkirVhAmOvP05Q5bR8+SEWNO4TZG3IJhCLimNbsrmBQC5ZQWQlGfQlT
	 uVrhE2JkRPX/TBmCvpYOcrgw6W12WleeSMMnNuw7Hv33TFjYm2As4YAWHUd7JTbpns
	 iRGtPsHt3tqDKaeddWE3KU39HAzqXp/ln5lWjplYi7xdZa2EujPLaFd0OmnX4EGKEC
	 hZ2dGl2jFlOyjXspwEX34CLpYp7HEsVE2SkB6LlC8r94zjZC7RTckHDd2yFsKxoiOc
	 T1IqUN7G2Rf7tPWu6yN4Dzwigg5b1T3KtsSiX9v4JP36r0vZ8J37moaBZnPcNVR/P3
	 LdiAFEzFzgGvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB045C4332D;
	Sat, 20 Jul 2024 18:42:14 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <669a922323f4d_173615294c1@iweiny-mobl.notmuch>
References: <669a922323f4d_173615294c1@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <669a922323f4d_173615294c1@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.11
X-PR-Tracked-Commit-Id: b0d478e34dbfccb7ce430e20cbe77d4d10593fa3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13a7871541b7f5fa6d81e76f160644d1e118b6b0
Message-Id: <172150093494.10199.1805679329865514888.pr-tracker-bot@kernel.org>
Date: Sat, 20 Jul 2024 18:42:14 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Erick Archer <erick.archer@outlook.com>, Jeff Johnson <quic_jjohnson@quicinc.com>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 19 Jul 2024 11:19:47 -0500:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13a7871541b7f5fa6d81e76f160644d1e118b6b0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
