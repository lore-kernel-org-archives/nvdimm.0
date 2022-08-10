Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540CE17D3
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 18:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E63FCC433D7;
	Wed, 10 Aug 2022 18:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660156416;
	bh=nu3/4wucfMbw2XJ4m+k79mE7y1Zmw5W34t31Svmzzsc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UK11geE4Npr0OvId9PAUVQlN4X+PwoTVJpTVnwmmXrIFsvLnHf2331AWcYXQYHJA9
	 vA7f+qOexALBopiIdc3em8c+rtrSU+f+dXAn63WWwfqxMYUeAtlPSjhyTGvG9EG4WS
	 76HO1mW/2UYg6HYUvXDxE/MnSeAlfSgfN1EWM4HCSskptwEgEtwRDocW3oCGGdMfaz
	 j6l3kos/TPz/qI+5sF3n9pF57JcGk6Jj27RX7a8QKDFM6+HBqh+vWoWHoLlo6/1PMv
	 iE+MIM2W5eHMefH2/2XbpiPggsgaJFxEqqyM1hc7yZhVlyhpsD7m7mOUbBHIQxGPka
	 BqIeQ75M6oz9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D828CC43142;
	Wed, 10 Aug 2022 18:33:36 +0000 (UTC)
Subject: Re: [GIT PULL] Compute Express Link for 6.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <5b0d82d63ebd24f454c5459a0ff9e2e12f1e37ac.camel@intel.com>
References: <5b0d82d63ebd24f454c5459a0ff9e2e12f1e37ac.camel@intel.com>
X-PR-Tracked-List-Id: <linux-cxl.vger.kernel.org>
X-PR-Tracked-Message-Id: <5b0d82d63ebd24f454c5459a0ff9e2e12f1e37ac.camel@intel.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-6.0
X-PR-Tracked-Commit-Id: 1cd8a2537eb07751d405ab7e2223f20338a90506
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c235698355fa94df7073b51befda7d4be00a0e23
Message-Id: <166015641688.32353.7521362432322200356.pr-tracker-bot@kernel.org>
Date: Wed, 10 Aug 2022 18:33:36 +0000
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 9 Aug 2022 23:22:05 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-6.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c235698355fa94df7073b51befda7d4be00a0e23

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
