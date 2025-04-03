Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B7533993;
	Thu,  3 Apr 2025 05:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743659184; cv=none; b=TMnK7YcC3BaPxz25qf0Y49nbth1HkyMubCfZyNbP56tl9tBGrLLHLirdXdRW1IV9ZIZq51eMLJVIBDDSUhRXJB/jniQAErSLZZ6Z0f9rlK7cr7fGZLxNv5ofBnjbWD0txVy+vowxXkqyao4sV6kMJhAAZouBWuje1X47ydcMDMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743659184; c=relaxed/simple;
	bh=AM3/IOQ3Is4XXfN/QphYEpNsplJeAppAJuFB8iqn458=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UqCNqh75Qfa9PtBgKB1Lq3wwSVMrfL1cOMHflQKzoVH1dL4JNVoEu7lCNNrZsCZu4AMJVfawxZEu3/GLDSUhPqFgQJ6yKbeikUmABWwqx9ZkXU25i3zRWsdaETi/opZfGQney0kS+GLVtnQ+wrPcoHzBpZWMSiF01zkgLV3BfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQpVqKW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQpVqKW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B28C4CEE3;
	Thu,  3 Apr 2025 05:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743659183;
	bh=AM3/IOQ3Is4XXfN/QphYEpNsplJeAppAJuFB8iqn458=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oQpVqKW5CgnUgHaErlBZkFIYJkD4SNm7yONKE2pf+NvPNSWrRm5fAymuQ/fqKFG0i
	 7kYwK3lS83hlT5VPSrB/gHPBzwd+uESv+qEK1PxZgko1cHivtGvs+mjHt/Vy1rHnCG
	 HZarylP6oGJujZM+ds6TLNCBrmqSJ8wYhWxHCIpxv1I75RJpxAGxzrWHxa0eFX9EQw
	 UtOuY0b2YexGiiDgLKivJn8MfR+HtRdh3mSxX3jWO5gSbtdPSu4msNRZcDRx0o7KHX
	 lZ9awy/kC/IwOH0VNt02eudzA8EEWMuuUWL2mstsZ71SQWdV3q642yOgjmk2N4o5Bb
	 yLjoZBF0iiZHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AF8C9381090F;
	Thu,  3 Apr 2025 05:47:01 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <67eb0638e6f4c_3b58229447@iweiny-mobl.notmuch>
References: <67eb0638e6f4c_3b58229447@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <linux-cxl.vger.kernel.org>
X-PR-Tracked-Message-Id: <67eb0638e6f4c_3b58229447@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.15
X-PR-Tracked-Commit-Id: ef1d3455bbc1922f94a91ed58d3d7db440652959
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 447d2d272e4e0c7cd9dfc6aeeadad9d70b3fb1ef
Message-Id: <174365922031.1797294.11570841472354160754.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 05:47:00 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Lukas Wunner <lukas@wunner.de>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 31 Mar 2025 16:16:40 -0500:

> git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-6.15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/447d2d272e4e0c7cd9dfc6aeeadad9d70b3fb1ef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
