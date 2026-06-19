Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D5C10F0;
	Fri, 19 Jun 2026 00:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827793; cv=none; b=pbtrVxt5+SriwIwF69nJsrUMaJwNaDr5s1HAOLzW63F+xRIYNiApQgZtS8cJ1w/guDCRaMKTqG4MgGhgBtIo8XKRuqqLsQ7hvU9WddijDEkifrFLTLxQGg/cGDWe0H40Cp6zPW/fc4Xr1UEvX+gZvojwDvcaFW8F8iFVfgM0w70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827793; c=relaxed/simple;
	bh=kW7yZm+xXpaVjcqJoh9CrN2RWRIXMLol16rzHKxl+hI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=F0s5a9G5Fz779Xa8xG/7kcgJjCEg2N0ERX70BhMfXbs6M49Pby5ZbjZ9Qx8zRyQviDXC5e2TFaZDW6ynbLvVg7rDaef0SDghr/uiXTSj8Yu5agrfxycpeMDoJXIcKz+SGLn0QDGL6r9A5CZ1wE2j1yMPR+TkoqNF/CUW/B6SdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5CIO1oe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5CIO1oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CF41F000E9;
	Fri, 19 Jun 2026 00:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781827791;
	bh=VCp1M1WBlxc+BHi27sal0mnlhHjtxnftSyLiwR8hV/0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=S5CIO1oeMM3f4hPmzjbbmcV32UFYGUoxctacIlQ5oqL12rb5PduR3dpeNSLgggn7l
	 RrfhrTANEmI997nw8SJREpOPpINmDSuWhoUzCTmiByvcKzLN+LipMHIE2jXjAzxA3K
	 tUQuqCI6uIIEDd0/xxyUAA0ZHqfprt1TtPMRNHlKwmQ5ztgc9BV8P4NDKbaALY02f/
	 7IdCUMd8/jIJFc6Rga+8/xL71yHtBUTO2sVIGJIUtrztz34t0LJRbjLHTnv9a4SCUZ
	 JnJ5mAT4hMiS6bolvIBaUnQYInpj2OPSzr9xIKgNnA9O49LntdAbMZj66WUMIjOeXy
	 Qzwy+AmauLkRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568A53A5676C;
	Fri, 19 Jun 2026 00:09:46 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
References: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.2
X-PR-Tracked-Commit-Id: 86e411b6ec277dbb8ac1f1d855dc337181a62a29
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cfd96ad1389cd6045a3af05bd34b2e52b291e365
Message-Id: <178182778495.3120511.840711900426249032.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jun 2026 00:09:44 +0000
To: Alison Schofield <alison.schofield@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 18 Jun 2026 10:13:20 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cfd96ad1389cd6045a3af05bd34b2e52b291e365

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
