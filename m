Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29210F2
	for <nvdimm@lists.linux.dev>; Sat,  2 Jul 2022 00:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70895C341C7;
	Sat,  2 Jul 2022 00:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1656720163;
	bh=biGyzp1Lglan+enLcCay5lxuk5YwGUhOpmrUOlyKpvI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rOsQ/PM/+sW+JJ4VnO0YWPQRwjN14EApB/tWQelg+TGo5dMtG2/OnOXo+J2O76tnS
	 twHIBw+5BL96lw85iTz6zDcD3esqEfIxSVvC+XygRsSA3xknfxk/KCb1FFYI4UEAI0
	 gDU8VVnofXuwjJyWLNhrZcZIMaEAuG1kilfXK3QdkUKCQY78gNM7RHVI0xv23xdxnm
	 rilSgOi2K7AWNTZavx3s/KN1VnSUZvRIgTqCJSWkGtslJ8v1aIwpcyhzPmDFsafwj4
	 daFlWz15x7nqXsW5Av0si3L9aqt4kPRzua2DcBBUXMiyr0uFgC3rA2aSv04vP0NryX
	 dH4F4WM5Znv3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59F9BE49BB8;
	Sat,  2 Jul 2022 00:02:43 +0000 (UTC)
Subject: Re: [GIT PULL] nvdimm fixes v5.19-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <02c021ee6306877ea63d6db0a314564ac7843882.camel@intel.com>
References: <02c021ee6306877ea63d6db0a314564ac7843882.camel@intel.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <02c021ee6306877ea63d6db0a314564ac7843882.camel@intel.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.19-rc5
X-PR-Tracked-Commit-Id: ef9102004a87cb3f8b26e000a095a261fc0467d3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 089866061428ec9bf67221247c936792078c41a4
Message-Id: <165672016336.25386.17573716042798881072.pr-tracker-bot@kernel.org>
Date: Sat, 02 Jul 2022 00:02:43 +0000
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 1 Jul 2022 23:07:26 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.19-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/089866061428ec9bf67221247c936792078c41a4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
