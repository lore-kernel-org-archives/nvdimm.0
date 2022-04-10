Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DD2EA9
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 04:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 139BDC385A1;
	Sun, 10 Apr 2022 04:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1649566399;
	bh=QUlkjxGabqdjQu49II4yKPjzZHFDXEa04u8sZIQqzwA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VRqW7oOk0MfmLkt/uuV1cyU45R6FIh0WeNMMLvVyeL+kHWCReoOu34Ie3O3qBjhWn
	 CIuYF6bGJd1ffR6t9qRO325vsRh5qBNZ2IAp4dyoQosPJAjo5PrQueH9R74iVFAW9Z
	 KhywWqJggs6ZTndG+8zUuxlnxCZdnEsW/Qs2FAA2/cuM3if5AqP3Vd9eNogArMrVxO
	 T8oKZB8ycL3CgQY/p+DVyFEBfSOHht/Yuyhk2d515JDfzztRj/5Ks45y2cRWsKtFiz
	 Ymbq7kQzR5UEJUJ1mG5paCKtG9+X9ANZ6I3gYI0GJEZAu9BIzC7mvOSG5KehG6UyXk
	 y0KKUQdDZ1tOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F28F3E8DD5E;
	Sun, 10 Apr 2022 04:53:18 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM + CXL fixes for v5.18-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAPcyv4gLVHZSJNPcxcb6tDD3z8DO_X49OvV-cudeziKfG_08mw@mail.gmail.com>
References: <CAPcyv4gLVHZSJNPcxcb6tDD3z8DO_X49OvV-cudeziKfG_08mw@mail.gmail.com>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <CAPcyv4gLVHZSJNPcxcb6tDD3z8DO_X49OvV-cudeziKfG_08mw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm refs/heads/master
X-PR-Tracked-Commit-Id: d28820419ca332f856cdf8bef0cafed79c29ed05
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 94a4c2bb7a1fb95bd7105ac5685377f57c13daf3
Message-Id: <164956639898.12943.7218088356733601584.pr-tracker-bot@kernel.org>
Date: Sun, 10 Apr 2022 04:53:18 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 9 Apr 2022 16:46:56 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/94a4c2bb7a1fb95bd7105ac5685377f57c13daf3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
