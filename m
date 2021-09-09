Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5393FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 18:54:59 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id B172F610FF;
	Thu,  9 Sep 2021 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1631213699;
	bh=JfkkADgfyboE9GaKWTbTobF4Mqa/D3YZiz6kqNxDDZg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IBnq7qq91+s4+MoHvttNNoXav5uFVV/guYyJ5DdQ2Zj+thkB9touHEUJyAOGsTBbk
	 2pMyOembj1dT8SDL6UfXk50RzhBXgASw1cQu2OT//Ixc1hu2tzUJSERWbWYprcNbig
	 LMKFgVliYUFkJmkvMVpgmNoZkBidOS5ePLu7kIU6UoFNcPQnFMcwTHwVdBpm8eRQgG
	 QsaIRifqH4rHuD6l25jXD1hlghpeZqnLmfcLiVmPjNs5naCwQtMNHnidzFt/DW4WOv
	 xd2NX2xUBI6eVkEfgghr2/OPMdhf02oh99BMjA9oIVYMgPvUVrs7M2n4ghCLgeSug6
	 GEGQe99Tcn8dQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB9D4608FC;
	Thu,  9 Sep 2021 18:54:59 +0000 (UTC)
Subject: Re: [GIT PULL] Compute Express Link update for v5.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4hEtOuExY1+YdKPaffBPO6A70u+01NA4EPON2s6Ut3rHw@mail.gmail.com>
References: <CAPcyv4hEtOuExY1+YdKPaffBPO6A70u+01NA4EPON2s6Ut3rHw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cxl.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAPcyv4hEtOuExY1+YdKPaffBPO6A70u+01NA4EPON2s6Ut3rHw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.15
X-PR-Tracked-Commit-Id: 2b922a9d064f8e86b53b04f5819917b7a04142ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 70868a180501d17fea58153c649d56bc18435315
Message-Id: <163121369969.14164.15271605795362032236.pr-tracker-bot@kernel.org>
Date: Thu, 09 Sep 2021 18:54:59 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 8 Sep 2021 17:50:45 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/70868a180501d17fea58153c649d56bc18435315

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
