Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757F29CB24;
	Tue, 21 Apr 2026 21:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776808644; cv=none; b=Lq23Y/WipNiSPymlzCRtzmXWVl0R3b39N19F6lvraac/MJFlJmRRvrDryHaKXKbNRgY7liuOy8vdrMOZyfCbtAlyFwlHWF4GPUrRQHPrL9RW3ibRg6uYTLvosK793DORPEIvaHum6gJxPLfUjDAEgguftosmUZuDDv/puCefDy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776808644; c=relaxed/simple;
	bh=ftxDQpj+hYnznm0pw+8lcsK15tVTdGcEZoodAP2sde0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VVC9ptsN88AAC9wB8u8W4qiFnMYVgE8GeppIxCwKMluNP3rXuSf1ST7TjjAE9xlxRG638EQ6yJWv/44C2fH7daDZ5OL5siSLiMjNeBLiCSjsreTPySgi/vvL0EXIHxhFbnMgqtYWyz6Px5maE32tCC8KFYD/2uFfbklV3OJHIzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZM2C2SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZM2C2SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7286C2BCB0;
	Tue, 21 Apr 2026 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776808643;
	bh=ftxDQpj+hYnznm0pw+8lcsK15tVTdGcEZoodAP2sde0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tZM2C2SLoAbxGsmABzjOhEDkvKKUGkSAhHIifOAuWx2cgDrRiXp6XdBtZahtXgIUY
	 IqW2C4FBbyzsG00jm0gXsrGNX3lwS9pnvhXN6qYnDSbVewerlBX4rPhpDbw56YKOrm
	 bSSPxbaLJqaX65XxGsCkPYrNSwgFKfLuTbBliF61OMNpQ7y1x13Hl3MslZSos3vjeg
	 jkXm+WOV5VA/CsxepbxXvezxDPHHZnJs2lK4zgs4sQOdmSmUGutzx6DfwymR4RZPjM
	 Rq/FQY2AyHbztvc32Gotwy1w+Flpb0oDCfcAhavYECBUgDFI8SYYgEEiIIobiUOj9Y
	 fwibHNzRiWg0w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FEE6393020A;
	Tue, 21 Apr 2026 21:56:48 +0000 (UTC)
Subject: Re: [GIT PULL] DAX for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <69e7d1949ebcc_7d12a10098@iweiny-mobl.notmuch>
References: <69e7d1949ebcc_7d12a10098@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <69e7d1949ebcc_7d12a10098@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.1
X-PR-Tracked-Commit-Id: 45df9111692c62d5f09fc4345ae36dae31024797
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bb0bc49a1cef574646eb25d74709c5ff200903a8
Message-Id: <177680860680.3017017.17086247882973299190.pr-tracker-bot@kernel.org>
Date: Tue, 21 Apr 2026 21:56:46 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, Alison
 Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jic23@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 21 Apr 2026 14:35:48 -0500:

> git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bb0bc49a1cef574646eb25d74709c5ff200903a8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
