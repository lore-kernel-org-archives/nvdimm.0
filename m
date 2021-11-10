Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0393E72
	for <nvdimm@lists.linux.dev>; Wed, 10 Nov 2021 20:10:03 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F5DF6109F;
	Wed, 10 Nov 2021 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1636575003;
	bh=zgSoZXh4JghCDy0RHBB6rHNjHLr7NwWX2Zu4O2OtSbI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hVXfI9xxxir73EQkATeN6WztwE5N1TxwNYQenxS9xMwH8SX16vgks3KBqGla+gnOJ
	 3E7eeXcrA1z4UxT/qcu2FSG3F0ca/Gnx7OMDXW1cS3db6vb4cSynfu2wwLPNqCpUZO
	 RmpQPV4bMhe7VLa+GdhOfUtP6WDSC5VaSDFimKEr3YshEn2IoUioLAtU86J2op6RO9
	 4E3PzVLHqg24IqySb1A7VHi6m/iqDrCy7p/fTxZ8J1WoGr3Ed8ioqx1ACM9shT1Gtc
	 ht9BEBLTLIT2Nzg3W6LRjoieXWKOuNPKbNPemM1i55JIobDPj6FmPgIdj9ChWW0DBD
	 3dgDoJzQNFW/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 988B760A6B;
	Wed, 10 Nov 2021 20:10:03 +0000 (UTC)
Subject: Re: [GIT PULL] libnvdimm for v5.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4jo4gsDVYRJFZY==-4gNY-B2yC7M-NWc4j+OnQYWYctKA@mail.gmail.com>
References: <CAPcyv4jo4gsDVYRJFZY==-4gNY-B2yC7M-NWc4j+OnQYWYctKA@mail.gmail.com>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <CAPcyv4jo4gsDVYRJFZY==-4gNY-B2yC7M-NWc4j+OnQYWYctKA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.16
X-PR-Tracked-Commit-Id: e765f13ed126fe7e41d1a6e3c60d754cd6c2af93
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4287af35113cd5ba101b5c9e76614b5bebf48f58
Message-Id: <163657500361.19350.11275052540955037903.pr-tracker-bot@kernel.org>
Date: Wed, 10 Nov 2021 20:10:03 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 9 Nov 2021 12:08:59 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-5.16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4287af35113cd5ba101b5c9e76614b5bebf48f58

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
