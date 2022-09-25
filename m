Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA8A7B
	for <nvdimm@lists.linux.dev>; Sun, 25 Sep 2022 16:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02D22C433C1;
	Sun, 25 Sep 2022 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664122136;
	bh=aCmJm5/OBtsDYS5j+Pt05LgGCHAVWzfjsg6zg5utEzw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=msP8NOpMrwdlaZ68/ktyV+S3JQrG8/37PptaYB4gZXB1XPZ8rRdOVONy4FlauMten
	 MLsw5smOirTvR4f0fXuT9dwQ87O4JlJrlce3q96NyYY2u+o5FGt62GbiXesRNgx6ns
	 /mgBSvHNrFrf2PTuu318xqENxCAmQala99XwFqT7ALcyR1dU8u52eBBtLy4P4+kp0/
	 xyywG1sECkAHX+wTEc/Bq28Fr/wWFTdhgz2WkHAoj4DOGLMa/O4L+YcBfQW2kUhJQA
	 UHFWLc/C83WGF8yQy60nd0wTd299+ep7prhDhWkcJ/5PQ5WLBuIcktfE7h7tTQtJVb
	 /Dclcd+nhFW5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E012EC73FEC;
	Sun, 25 Sep 2022 16:08:55 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX fixes for 6.0-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <632faffe84f7c_746b294d1@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <632faffe84f7c_746b294d1@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <632faffe84f7c_746b294d1@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-and-nvdimm-fixes-v6.0-final
X-PR-Tracked-Commit-Id: b3bbcc5d1da1b654091dad15980b3d58fdae0fc6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4207d59567c017be284dbebc5d3fb5a2037a5df5
Message-Id: <166412213591.26660.13541178879382385096.pr-tracker-bot@kernel.org>
Date: Sun, 25 Sep 2022 16:08:55 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: torvalds@linux-foundation.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 24 Sep 2022 18:33:50 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-and-nvdimm-fixes-v6.0-final

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4207d59567c017be284dbebc5d3fb5a2037a5df5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
