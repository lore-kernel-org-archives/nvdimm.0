Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54A0620
	for <nvdimm@lists.linux.dev>; Sat, 15 Oct 2022 01:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46CC3C43141;
	Sat, 15 Oct 2022 01:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665798282;
	bh=y/waUCrSLIoQj9RUaRN0g5eGyCFtRYAVDVZFQvwMGjw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=e1GVVXl4XDQqaIKt15r1niB17g6Us61TMRIp9e2DbCCbEZ/Yp8YRw4Y9nHTCn9/61
	 LrQIKghEiTDn770kSv7LVAo716QoYQoa7TDBVc6umYjBJm+Q/EPH7pbURIu2iZ0IHM
	 HJgXhMUrNVksuu5RztS0dU9IhMqTE0GhK4OEIKUUidHaX/3c3kCjiEBsSydGZE5YcM
	 fEglEKr6Qa7E5dOGI/Gr+/YJ5s7TqxE7JqfQGIOnxmPMRsPPmhV6+TNBzCk0qzCnqh
	 ZvgTkTp8qys7xKqKvl3iTnUBh6GIfnSNhK0N71UxC3JykBV0YAHLxQwNgXRmzrPS2Z
	 a8E1Fl+ICl4Lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31167E4D00A;
	Sat, 15 Oct 2022 01:44:42 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM for 6.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <6349f4435df76_7ddc2943e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <6349f4435df76_7ddc2943e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6349f4435df76_7ddc2943e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-6.1
X-PR-Tracked-Commit-Id: 305a72efa791c826fe84768ca55e31adc4113ea8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 19d17ab7c68b62180e0537f92400a6f798019775
Message-Id: <166579828219.8004.8423814278538619083.pr-tracker-bot@kernel.org>
Date: Sat, 15 Oct 2022 01:44:42 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: torvalds@linux-foundation.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 14 Oct 2022 16:44:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-6.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/19d17ab7c68b62180e0537f92400a6f798019775

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
