Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28661FD2
	for <nvdimm@lists.linux.dev>; Fri, 25 Mar 2022 01:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9D95C340EC;
	Fri, 25 Mar 2022 01:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648172148;
	bh=EfccCXCDP9v3AWrkINxr6QnCr0Zhsre9PjSPa2Y6WM4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=X5geBuMWoA/whgbBM7byqLXiguLQ4wS4qINeB5sDqAG/51qbp7rUA6jCUYLXjDaVg
	 9W+1FvfUWE4CpFNiWWTdHaJ+4PyWA6ChtFQkL9hghxP2WgFKxJ/ENSGOvywCkUGNP5
	 J+506tCFulzuhNsU/IeU3weu6LXpHp4VRD/C3facp4r7mSardcfWow0b0csmQ03ark
	 Iydr0SG57qNbtGFTu0jSeBenqYUlRksaEJEsx58/sc5U5GnonxMcnJUXx7KVp/nIKK
	 i7mX3E9rwl8e9YTprwzZpwGN46c3DC66Gs2pI9MRvBbK/gG+AwyBAow/3y8P4188rv
	 N/6DLOBB1EQog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6739E7BB0B;
	Fri, 25 Mar 2022 01:35:48 +0000 (UTC)
Subject: Re: [GIT PULL] Compute Express Link update for v5.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jE=wfmfWS94WyMWhHwub0jJ4Vm6hnz8G3HJ9rd8pXKSA@mail.gmail.com>
References: <CAPcyv4jE=wfmfWS94WyMWhHwub0jJ4Vm6hnz8G3HJ9rd8pXKSA@mail.gmail.com>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <CAPcyv4jE=wfmfWS94WyMWhHwub0jJ4Vm6hnz8G3HJ9rd8pXKSA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.18
X-PR-Tracked-Commit-Id: 05e815539f3f161585c13a9ab023341bade2c52f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b9132c32e01976686efa26252cc246944a0d2cab
Message-Id: <164817214874.9489.1769734777447328707.pr-tracker-bot@kernel.org>
Date: Fri, 25 Mar 2022 01:35:48 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux PCI <linux-pci@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 22 Mar 2022 16:36:48 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b9132c32e01976686efa26252cc246944a0d2cab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
