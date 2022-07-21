Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DCB3C0B
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 12:12:15 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 63EB033B1B;
	Thu, 21 Jul 2022 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1658405528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=egR2joWkG1+t+z/IWkDo9SUageousK0DwRASKkHhVfU=;
	b=MKfAMXWymz/PeJ+Hj+TOowtdvYcslKgrLg9O9B52SBiSr5Q4s94nWiUreKNJYK4mt3Jp+F
	Ae2+3tyzG+B/5mhs9mBbqU54hX7W3N2bhXrTlsA6No+9kMvohw4D1356kdNuRULr7O+Yot
	DiDImJXw05Ux1QFcYcW2PG+s647bUcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1658405528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=egR2joWkG1+t+z/IWkDo9SUageousK0DwRASKkHhVfU=;
	b=5GqiOy0esk3vevbXgeq18R+LEEJiqAIn4/R7hfUrIZccvGqJhf83iximXo2tZmXigx1XQO
	AOhFWSYcLCFtxhCQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 1296E2C149;
	Thu, 21 Jul 2022 12:12:01 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: linux-block@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Wols Lists <antlists@youngman.org.uk>,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH v6 0/7] badblocks improvement for multiple bad block ranges 
Date: Thu, 21 Jul 2022 20:11:45 +0800
Message-Id: <20220721121152.4180-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v6 version of the badblocks improvement series, which makes
badblocks APIs to handle multiple ranges in bad block table.

The change comparing to previous v5 version is the modification against
review comments from Xiao Ni,
- Typo fixes in code comments or commit logs.
- The over thought checking conditions like '<=' are simplified as '<'.
- Some unnecessary condition checks are removed.
- In _badblocks_set(), if prev returned from prev_badblocks() is <0, set 
  it properly before jumping to update_sectors. This helps to avoid un-
  necessary looping.

There is NO in-memory or on-disk format change in the whole series, all
existing API and data structures are consistent. This series just only
improve the code algorithm to handle more corner cases, the interfaces
are same and consistency to all existing callers (md raid and nvdimm
drivers).

The original motivation of the change is from the requirement from our
customer, that current badblocks routines don't handle multiple ranges.
For example if the bad block setting range covers multiple ranges from
bad block table, only the first two bad block ranges merged and rested
ranges are intact. The expected behavior should be all the covered
ranges to be handled.

All the patches are tested by modified user space code and the code
logic works as expected. The modified user space testing code is
provided in the last patch. The testing code is an example how the
improved code is tested.

The whole change is divided into 6 patches to make the code review more
clear and easier. If people prefer, I'd like to post a single large
patch finally after the code review accomplished.

Please review the code and response. Thank you all in advance.

Coly Li

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Geliang Tang <geliang.tang@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Richard Fan <richard.fan@suse.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Cc: Wols Lists <antlists@youngman.org.uk>
Cc: Xiao Ni <xni@redhat.com>
---

Coly Li (6):
  badblocks: add more helper structure and routines in badblocks.h
  badblocks: add helper routines for badblock ranges handling
  badblocks: improve badblocks_set() for multiple ranges handling
  badblocks: improve badblocks_clear() for multiple ranges handling
  badblocks: improve badblocks_check() for multiple ranges handling
  badblocks: switch to the improved badblock handling code

 block/badblocks.c         | 1609 ++++++++++++++++++++++++++++++-------
 include/linux/badblocks.h |   30 +
 2 files changed, 1345 insertions(+), 294 deletions(-)

-- 
2.35.3

