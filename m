Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1722135AC;
	Thu, 31 Jul 2025 20:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753994988; cv=none; b=WXgja8yeyQSsazEzdLGsw78PJt/f5ViwqbQhhSmFRs0R+20aIpH5GyZr6nmjMsYsCzW4hag0tddnb+iWDTivdmpwebv1TXayLdvQBj2+UBcU2+okIVpe8iX9tJGMb2Ej2+b9f6zV4paUibARQ4Y28zcGoBD7YHVMWfaV1pvGV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753994988; c=relaxed/simple;
	bh=WxTQV/ECfbhxnqQvL9BG1zNEZsYOWiEoxVNr4+8Bgno=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Zj1KNd6G5taaRCHahBrjByX6ySSuLM9OUhiGThujCTVgH25vwTfQqH26guijbtFjVnX3vo3frdyIP6w0ymJecB4HUv4Ju1UkD0t3JJHqmA77avC2E2vPLhVmMKP8scUgWroX/v8EmqeVYxu4+tEKhNa/flEULYwV23uBQ9IpFTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7z4rf63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7z4rf63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69567C4CEF4;
	Thu, 31 Jul 2025 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753994988;
	bh=WxTQV/ECfbhxnqQvL9BG1zNEZsYOWiEoxVNr4+8Bgno=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=u7z4rf63K0B0vqXHS2zYeobBrebdmYid3R99DbEWv9wlzdwCEXQp9Ee4YwzzDYvTO
	 eXIBCi4HWpRWNKbMZG4Kwe6M3K1hRvtOn8W0pCPlmNrro11LmZSx220gUhZUEGY4RX
	 2fmvV9VyTwpsT/CBsTOXlYzyjTMNeEd1AEqhKa2nSv5lDPCtN8wnkJyk51Dd0gVq3R
	 tECGElrHDlTKdM5Ut2LjoIDqgHWZ2NLK5DEL02nRHtBvDyPlAlrsfpnS1iruVB+pOg
	 wcG+ehfh3dbOigzn3CEXhScuRvYIz/vzSLE3iGINCzXIeP374FhKL2tQM/RZBQONEv
	 vtfYTjYCXzkSQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 338BC383BF52;
	Thu, 31 Jul 2025 20:50:05 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <688a7934c0caf_1028b3294db@iweiny-mobl.notmuch>
References: <688a7934c0caf_1028b3294db@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-cxl.vger.kernel.org>
X-PR-Tracked-Message-Id: <688a7934c0caf_1028b3294db@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-for-6.17
X-PR-Tracked-Commit-Id: 9f97e61bde6a91a429f48da1a461488a15b01813
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27152608dab9afe748d6b5fc3437a1831dac77c7
Message-Id: <175399500391.3294421.23561433782865777.pr-tracker-bot@kernel.org>
Date: Thu, 31 Jul 2025 20:50:03 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Nathan Chancellor <nathan@kernel.org>, Dave Jiang <dave.jiang@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 30 Jul 2025 14:57:40 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/ tags/libnvdimm-for-6.17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27152608dab9afe748d6b5fc3437a1831dac77c7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
