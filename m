Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B092291E
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 22:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4093FC433D7;
	Sat,  3 Dec 2022 22:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670108192;
	bh=/EHaDLLjToS5E7UnFmD/Dr7X9Jc8W/rDMx8ISBfC2U8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QMg7XiIIYIhxbpPx2n401wIW5lE/s2GUWH4WCLhtlo3XQQpz3l/+wSHPHl8Lgv2fY
	 ipB46Ukf9DBDZWE9Z/Y7U4G6I3JeLT87QpmtaesWz3FdVoskoue/9NpqlF0dAAkpbb
	 X4xOmTIk7f8n6CvAxWV9QsvvmHob9NwjBriJanDdXlECeQLCdMnPxQzdY9hJ+ZFUVK
	 UcApBqjzXiww0OraVmUZ2tzAzNVuLAdEen9U/9j7upI2Tn4ja+xKyHeu/Ys5XtPSC+
	 MDCw6kI7y/Kt/syfVv4XH19yBryImVWqo1rBmaxSXHMCZ80ZLxgzN4fWOS8now/V7w
	 C800qZBwwKIqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C993C395F5;
	Sat,  3 Dec 2022 22:56:32 +0000 (UTC)
Subject: Re: [GIT PULL] DAX and HMAT fixes for v6.1-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <638ab8e291345_c95729417@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <638ab8e291345_c95729417@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <638ab8e291345_c95729417@dwillia2-mobl3.amr.corp.intel.com.notmuch>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-6.1-rc8
X-PR-Tracked-Commit-Id: 472faf72b33d80aa8e7a99c9410c1a23d3bf0cd8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6085bc95797caa55a68bc0f7dd73e8c33e91037f
Message-Id: <167010819216.27892.14565489712803195440.pr-tracker-bot@kernel.org>
Date: Sat, 03 Dec 2022 22:56:32 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 2 Dec 2022 18:48:02 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-6.1-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6085bc95797caa55a68bc0f7dd73e8c33e91037f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
