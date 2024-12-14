Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C1815E90
	for <nvdimm@lists.linux.dev>; Sat, 14 Dec 2024 01:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734140183; cv=none; b=Yc8H6Q5ipS/K6valEDODT4N/NimRoiM6YbD+l1pUyn8ozFB72SY7CyrfiQ3jkDpzIaAfzeOdMbIkZRVxwDEs06x+j/idoAnY6+CzFtb9Ri+ieBijvUAw43iVAZgXJIKJjLjmorX5HV8uoLT5II85YyM4G/fdeLAVeWwDdBfNWrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734140183; c=relaxed/simple;
	bh=XxZuVVlV0GperiWLK3wxbz7cZxR/U7+SSW8fCEeZJIU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OuTj/odklZxl9cliB5Qn9d4MTam171AsLLxEbXvvLH8PwX30n8HdbFZQCb/zOb4OSSoAK4s4TVmtJ/mF5yluwPFY6gdCmNTveRIJJLoHI/nEFqLPDnG7hSP3OAZLYNXHj4qWf0wsyEYXiEMhj2Ui+BVjeQ9WPkeP7WOvjzj1+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFBR6YOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFBR6YOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86B7C4CED0;
	Sat, 14 Dec 2024 01:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734140182;
	bh=XxZuVVlV0GperiWLK3wxbz7cZxR/U7+SSW8fCEeZJIU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JFBR6YOzaj0T2sV+n+crBP/vKTKXTYKrhoMG6WIDtN7vvIaZdZYsUjduacIADjF+E
	 ExqN3i7MKaTBqoqjjK5pjXIAWTzrvSKHbNDWs6lGVIyGhpbCVH8wY3h5iL8Kzaymd6
	 BooP10J0BiFsNn5HBS5N5z97rCRJtmch9DEcQkI2MhLqnTPwO/M9LxerhYiU5sDcPt
	 EYed82P2uthuBvr6Sf1vniIGsXth3cjymgetygepWtnYbEaEfFx20h3uXm9mWkj8Da
	 0K/l/x1ngXKYQf5I/5mEJcBm8iFeYqkGguudECBpzYwNIvAoouSyqY4BqQD46g8g98
	 QNNZbi6r07vOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDB7380A959;
	Sat, 14 Dec 2024 01:36:40 +0000 (UTC)
Subject: Re: [GIT PULL] NVDIMM fixes for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <675c7e1f4ddff_24c59c2947c@iweiny-mobl.notmuch>
References: <675c7e1f4ddff_24c59c2947c@iweiny-mobl.notmuch>
X-PR-Tracked-List-Id: <nvdimm.lists.linux.dev>
X-PR-Tracked-Message-Id: <675c7e1f4ddff_24c59c2947c@iweiny-mobl.notmuch>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-6.13-rc3
X-PR-Tracked-Commit-Id: 265e98f72bac6c41a4492d3e30a8e5fd22fe0779
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1c021e7908cc6683a1fcbd26eb02bc8c7c880da0
Message-Id: <173414019923.3218065.15823338327157813437.pr-tracker-bot@kernel.org>
Date: Sat, 14 Dec 2024 01:36:39 +0000
To: Ira Weiny <ira.weiny@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Suraj Sonawane <surajsonawane0215@gmail.com>, nvdimm@lists.linux.dev
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 13 Dec 2024 12:34:07 -0600:

> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-fixes-6.13-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1c021e7908cc6683a1fcbd26eb02bc8c7c880da0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
