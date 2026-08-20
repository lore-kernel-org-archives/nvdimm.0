Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DAA3CF69C;
	Thu, 20 Aug 2026 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787255866; cv=none; b=MDtKvIo0vZNxYezGo+EIuOvugaHA9bdwAmbfCC5pG6lHgKvDzvAQQtAhr2A90qQsvHrNv3JsrqtFC5Z59S7db560jMyNgCqss3bl9o4xzxtmPLDGuQndfqkMMqMAonqolOYu+NNGB1xY1r3audzrxfhF5oFWqHkRd7RDxe50328=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787255866; c=relaxed/simple;
	bh=tNWe5URcxnDSR2hV+cFes5Ds8NbCdw1wZJgJfzqmDHc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eqvPm9w4ysnn1CAAQHgBcjbJ6d3kzPCNktKoAgw/teQWG1HfqRhhsZ570vdcMVm8rTGxoTnS93mgK2XmsxliB5O0mf4w4co1AU/MUGVSnBBYDPEM8MfXkKNViK3QJOjvOz2rOtQON8PzybEr2CHwuHlCDwmzP0sfIxkMlriSKHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZ4ymn9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZ4ymn9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683431F000E9;
	Thu, 20 Aug 2026 19:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787255864;
	bh=87Gzgu2LUNgTFGqvEqmhYdKt+VQRRFqFQQtSwBelkY8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=lZ4ymn9ZXemhOsyop8KhWvK5QsxogfjJRq6HXU2PaGVWvkPvWjnpHzVjWuLi+znXJ
	 2Am8D1DG6vMM1u1htPZsAEVl8NP5WgL9yUz9uH+MxbQLr6lN8Vsg13NLjQiGsr7IEB
	 W8jzfutvw3RIgcTUPj/RWP8fwAYPEMU2gZk7MGIWNw99FZUnWfXE4zY7TfiEUKSV/r
	 w8682Zc20PWOfUnI9WEBr54k+u8UknNzR6RbWNj4TEIyZC2++sHQ7hwhkUiHfrI4xb
	 lFV+J5e6DrZDMoVurIUC1KxOtMSnRID4xyJK9uI7b9EOgYjWX8bCokMmE60i7e2OxW
	 sH2eh1sDvAnkw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A39392445B;
	Thu, 20 Aug 2026 19:56:55 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <aoOPXFhuXrm0tQ6u@aschofie-mobl2.lan>
References: <aoOPXFhuXrm0tQ6u@aschofie-mobl2.lan>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aoOPXFhuXrm0tQ6u@aschofie-mobl2.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.3
X-PR-Tracked-Commit-Id: e99cb3ecd8334ca21e01ff9a79a916693f58f1fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62abb6cffd6bab44d430627043778ec157c32cce
Message-Id: <178725581446.459220.1683957213196322485.pr-tracker-bot@kernel.org>
Date: Thu, 20 Aug 2026 19:56:54 +0000
To: Alison Schofield <alison.schofield@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 17 Aug 2026 15:46:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-7.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62abb6cffd6bab44d430627043778ec157c32cce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
