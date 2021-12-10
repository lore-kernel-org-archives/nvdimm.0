Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A873173
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 16:05:15 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 3AB5E1F3A1;
	Fri, 10 Dec 2021 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1639152313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jjPtiexGkN3NZLjX3LwKoZF566v6QWUX9HxDUptVdfU=;
	b=iDf4n02B9snfo446+wymbxvl9Ca+v2nM/LPUsAgjcJnmtzqclKXcQr6xT+G8Xvat/jwIWF
	oLueuBr2iT/inTHxlcsoSgBWXOrveAc4gdGMqSLJBAYqtOU0CHEx5w9k2+cw/oWEWMYuU1
	AgAqV7FQZ2gqNmcMotIvbinWkJ+eeS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1639152313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jjPtiexGkN3NZLjX3LwKoZF566v6QWUX9HxDUptVdfU=;
	b=I44wiUMOB0lrQfSN826Wevbfr2yDp6wl3wflj7gNuMbREFQB2hEMaNaKI3Tpj+cR9XotbJ
	a77h2IvLneNxpbCQ==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 2F480A3B92;
	Fri, 10 Dec 2021 16:05:07 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: nvdimm@lists.linux.dev,
	linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Wols Lists <antlists@youngman.org.uk>
Subject: [PATCH v5 0/7] badblocks improvement for multiple bad block ranges
Date: Sat, 11 Dec 2021 00:04:49 +0800
Message-Id: <20211210160456.56816-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is the v5 effort to improve badblocks code APIs to handle multiple
ranges in bad block table.

Comparing to previous v4 series, the changes in v5 series include,
- Typos in code comments which are pointed out by Geliang Tang and
  Wols Lists.
- Drop extra local variables in helper routines which suggested by
  Geliang Tang.
- Change the user space testing code with all above changes.

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
---

Coly Li (6):
  badblocks: add more helper structure and routines in badblocks.h
  badblocks: add helper routines for badblock ranges handling
  badblocks: improve badblocks_set() for multiple ranges handling
  badblocks: improve badblocks_clear() for multiple ranges handling
  badblocks: improve badblocks_check() for multiple ranges handling
  badblocks: switch to the improved badblock handling code
Coly Li (1):
  test: user space code to test badblocks APIs

 block/badblocks.c         | 1604 ++++++++++++++++++++++++++++++-------
 include/linux/badblocks.h |   30 +
 2 files changed, 1339 insertions(+), 295 deletions(-)

-- 
2.31.1

