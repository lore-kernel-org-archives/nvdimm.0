Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA361101
	for <nvdimm@lists.linux.dev>; Thu, 31 Aug 2023 04:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B35AC433C9;
	Thu, 31 Aug 2023 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693456209;
	bh=Uezw268IlI2ncqkg6nwncMxImF/dZgC6hLzyvH2pNgA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BB+J+/Hq67oYbtMsbGxKsD4bbdYhsLeA0lKdFV6KMvW+2WZReP7O5+eGxvyS7ZnVK
	 wvzUMbzPym4/lkiNZpjT3GirLGTcWv3XG28ZXfkAKF/+Ptg/sFSX5zp9PVN5jGXNg4
	 z+n0X8xux3RF496aeOz6hetVZxvATnoNKcjIqon4sKL7jferaGZUTEUpT3qS9Iwfe8
	 Yw4OzF6X4tq1fox0C1RCuvSv+S+i4h/wO7sW8/kILRBbeXSARv9+qRl7k4OcGtOAW6
	 WfvG5Xluw8UK86SPnRVdwzBSPjLOYkvf2UrTBlPsu37ZDA5j++9yzW1rhkal0OIKDJ
	 lwyC5JgAC+j6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47399E270FB;
	Thu, 31 Aug 2023 04:30:09 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 6.6
From: pr-tracker-bot@kernel.org
In-Reply-To: <12c76f8e-aae8-2cab-4ab0-571a8c806423@intel.com>
References: <12c76f8e-aae8-2cab-4ab0-571a8c806423@intel.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <12c76f8e-aae8-2cab-4ab0-571a8c806423@intel.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.6
X-PR-Tracked-Commit-Id: 08ca6906a4b7e48f8e93b7c1f49a742a415be6d5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 47d154eb2ac4e508555937207031ba062119e371
Message-Id: <169345620926.29893.16589404508854183628.pr-tracker-bot@kernel.org>
Date: Thu, 31 Aug 2023 04:30:09 +0000
To: Dave Jiang <dave.jiang@intel.com>
Cc: torvalds@linux-foundation.org, dan.j.williams@intel.com, vishal.l.verma@intel.com, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 30 Aug 2023 10:07:56 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/47d154eb2ac4e508555937207031ba062119e371

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
