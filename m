Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EAF2FAF
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 18:55:00 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 096D46113E;
	Thu,  9 Sep 2021 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1631213700;
	bh=dA/PAuYz1IgXBj1BWQs4/4BfdGnHCVW6oAmdVwQ+w3s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HS6getuDbDVUH/HK1i02+y/HiwgIgqk3E4u6g7hEWToJW2vKYD0WU3b8Z0oz4UQ6Z
	 E2J70+XqB7DX2dXYgw5KojVtxzVlJpV2LdKzDI72BCYurXXNFJUhDWl7ZVsKPNsXoU
	 Hv7RAbOArvNbVzJl5leLDsb1EFCk0figMRMVi+gqv9YHMRiqCLiHXtxabJsMrirAh1
	 bcbYvfK7OfoOGbaHnqtXqD3QOl/avzCWD+bEjPAdNaTYpJEP27dLrkkh4M1Qt2WTfu
	 He7g8xZ3+LHPMGlKWJfJqO5Ijz4sEok5r+XOe+cKLvZAklRVZEWwLnwwRNhzC0g9Qe
	 oSI7nokX0Qm3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 045CD60978;
	Thu,  9 Sep 2021 18:55:00 +0000 (UTC)
Subject: Re: [GIT PULL] libnvdimm / persistent memory update for v5.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4hvzS1c01BweBkgDsjg=VGnaUUKi7b6j+1X=Rqzzm961Q@mail.gmail.com>
References: <CAPcyv4hvzS1c01BweBkgDsjg=VGnaUUKi7b6j+1X=Rqzzm961Q@mail.gmail.com>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <CAPcyv4hvzS1c01BweBkgDsjg=VGnaUUKi7b6j+1X=Rqzzm961Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.15
X-PR-Tracked-Commit-Id: 3fc3725357414636d91be1558ce8b14f228b4bda
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e5fd489a4e5fcc97b035c03ace724c1d481a4c1
Message-Id: <163121370000.14164.4088154375380243727.pr-tracker-bot@kernel.org>
Date: Thu, 09 Sep 2021 18:55:00 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 8 Sep 2021 16:18:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e5fd489a4e5fcc97b035c03ace724c1d481a4c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
