Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B26219C2
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 17:06:59 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id A0CB71F8AB;
	Fri, 11 Aug 2023 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1691773617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iHnKv3R8FRp1JKe/shgKndAzwEVVnXwp0wuUgPENc4Q=;
	b=gV/cxDQ1+6/RIsM+/9zoI0YMKJUCgUDIpo1yjqEvMoJaOwbykzlF8xCQzptANS9Imy8R+7
	PTyAg5oeTRlgYhGc4fq7UV1A/WwsbD3cHV6GzojIFJ+Jdel9jMG5ywJAPwZ92plhDujaUR
	0cisNmtbfLpqliYcw3qEIAjES8ssyEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1691773617;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iHnKv3R8FRp1JKe/shgKndAzwEVVnXwp0wuUgPENc4Q=;
	b=nF5r7UpN6D3gROfXa9ciN6TgFx3UnhcEI3noff9yebo9vJ+LjzEQ2CsTU2zohxU+fUG+mw
	QseVfrhPqTr1gFAQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 16A072C142;
	Fri, 11 Aug 2023 17:06:47 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Wols Lists <antlists@youngman.org.uk>,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH v7 0/6] badblocks improvement for multiple bad block ranges
Date: Sat, 12 Aug 2023 01:05:06 +0800
Message-Id: <20230811170513.2300-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v7 version of the badblocks improvement series, which makes
badblocks APIs to handle multiple ranges in bad block table.

The change comparing to previous v6 version is the modifications
enlightened by the code review comments from Xiao Ni,
- Typo fixes in code comments and commit logs.
- Tiny but useful optimzation in prev_badblocks(), front_overwrite(),
  _badblocks_clear().

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
provided in the last patch, which is not listed in the cover letter. The
testing code is an example how the improved code is tested.

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

 block/badblocks.c         | 1618 ++++++++++++++++++++++++++++++-------
 include/linux/badblocks.h |   30 +
 2 files changed, 1354 insertions(+), 294 deletions(-)

-- 
2.35.3

