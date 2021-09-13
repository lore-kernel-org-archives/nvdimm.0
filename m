Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9A3FD6
	for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 16:39:45 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 442AF22028;
	Mon, 13 Sep 2021 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1631550642; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Dfx9ZUh8IlSB114cbG4XVpLALI8W+1SZrDn37ByerEE=;
	b=kXjOO0iCMoAKWnt6Opb8FFJugDUYZQ7DbzsDLuetsyrCbmiPllf/mkVR8VmNl9tWNWifs5
	AoAoMzVmklJPB54/L4D4Nt4WVKMicnbLDU0dz1hPR58BymiqSOPOwFmy/LivFcuSEnZXFQ
	kL2G2EhSzQDHiZwB4Uru3KeH19XW7Gw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1631550642;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Dfx9ZUh8IlSB114cbG4XVpLALI8W+1SZrDn37ByerEE=;
	b=p64ujeY8XFsknqbEvjCTX1PfdqHjFQyxjmZkXXN2V0N30oiXhDFZdJNuK4dhWHt2m/z6RN
	c/ccMMs18608KnBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id A9A4BA3B81;
	Mon, 13 Sep 2021 16:30:36 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: antlists@youngman.org.uk,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/7] badblocks improvement for multiple bad block ranges 
Date: Tue, 14 Sep 2021 00:30:09 +0800
Message-Id: <20210913163016.10088-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the second effort to improve badblocks code APIs to handle
multiple ranges in bad block table.

There are 2 changes from previous version,
- Fixes 2 bugs in front_overwrite() which are detected by the user
  space testing code.
- Provide the user space testing code in last patch.

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
provided in last patch. The testing code detects 2 defects in helper
front_overwrite() and fixed in this version.

The whole change is divided into 6 patches to make the code review more
clear and easier. If people prefer, I'd like to post a single large
patch finally after the code review accomplished.

This version is seriously tested, and so far no more defect observed.


Coly Li

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---

Coly Li (6):
  badblocks: add more helper structure and routines in badblocks.h
  badblocks: add helper routines for badblock ranges handling
  badblocks: improvement badblocks_set() for multiple ranges handling
  badblocks: improve badblocks_clear() for multiple ranges handling
  badblocks: improve badblocks_check() for multiple ranges handling
  badblocks: switch to the improved badblock handling code
Coly Li (1):
  test: user space code to test badblocks APIs

 block/badblocks.c         | 1599 ++++++++++++++++++++++++++++++-------
 include/linux/badblocks.h |   32 +
 2 files changed, 1340 insertions(+), 291 deletions(-)

-- 
2.31.1

