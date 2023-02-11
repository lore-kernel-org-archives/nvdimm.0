Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A51A3201
	for <nvdimm@lists.linux.dev>; Sat, 11 Feb 2023 19:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02269C433EF;
	Sat, 11 Feb 2023 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676142696;
	bh=4tRpnWsPjg+qz8gi1CmjgGKN2KQMLKqIWA1vRJuP6mk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sk4s2TfnL/iYiy/A+TFXmzlKkxGwjE+IZP+xZmDeZPJaCcxSAu8z8DTlZagM4VmJV
	 RhcVrOE5yCu/Uc2q9XDxU5kcwhUsuHLgRyY6pI0eaglfWrprvAucylcwP8j3XmDMb5
	 C6mPWwewdRMlFAv8iSr2fCYpz1DEeiLQup6oDKO6YlqFoJT7tT+6S1eLlHrVQ3+vP2
	 u0jfXkL6Qybf5dcQ4cJYYsp3ZXXBXrnelF1yJIyPoFXUee9zoaBpt0hl0lSfuTo6Pe
	 3EKns9KNnMZi17+FLa3gOc+Iq0dcTb/jDoLgynJ/vfV1W7rG11fbcrdXWu1L1Gbf6E
	 +VPqZ326m9IUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1603E21EC9;
	Sat, 11 Feb 2023 19:11:35 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX fixes for 6.2-final
From: pr-tracker-bot@kernel.org
In-Reply-To: <63e6fe1b27ea3_88e129491@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <63e6fe1b27ea3_88e129491@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <63e6fe1b27ea3_88e129491@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-6.2
X-PR-Tracked-Commit-Id: c91d713630848460de8669e6570307b7e559863b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95232dd9ae13d6bb52ebd0c295e5dde30acd0d02
Message-Id: <167614269591.18613.10756799553053963987.pr-tracker-bot@kernel.org>
Date: Sat, 11 Feb 2023 19:11:35 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: torvalds@linux-foundation.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 10 Feb 2023 18:31:55 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-6.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95232dd9ae13d6bb52ebd0c295e5dde30acd0d02

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
