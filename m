Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC8C68
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 12:53:32 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 7E9B2212BB;
	Thu,  2 Dec 2021 12:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1638449610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tozQ3FNeLVowsYJRhf4dwsswyJBrxvHat2NWcE581HQ=;
	b=P21t5RA/efJHAtipUyrFbPNOA6SefEdPBMUWOQZzhpvmiF54kniCdn6o9bgDmGEWBJirEO
	vF1JbUIRncfspL3RmNq/PLY8Nwpr9mw/05l+jo9yDcw/8H7NrAMpbwV7SE7PXELOhZ8Udh
	Onbhj7kVktR+y+fczgqFopIQr22K0k4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1638449610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tozQ3FNeLVowsYJRhf4dwsswyJBrxvHat2NWcE581HQ=;
	b=EyfHgnFC/DpTfyvre9Z4D4S4Jn1yAub5zpiNUctGnEpeIb+xG2N/Lg0uapK0y9QLfNkjb9
	FIq7d51ZQEdPhEDg==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id D62F7A3C0C;
	Thu,  2 Dec 2021 12:53:24 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: dan.j.williams@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 0/6] badblocks improvement for multiple bad block ranges
Date: Thu,  2 Dec 2021 20:52:38 +0800
Message-Id: <20211202125245.76699-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Dan,

This is the v4 effort to improve badblocks code APIs to handle multiple
ranges in bad block table.

Comparing to v3 series, the v4 series modification is for code review
comments from Geliang Tang,
- Declare local variables in reverse Xmas tree order.
- Drop orig_start and orig_len from struct badblocks_context.
- Fix typos in code comments.
- in badblocks_set() avoid one unnecessary loop by setting variable
  hint by prev (was prev - 1 in v3 series).

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
provided in last patch. The testing code is an example how the improved
code is tested.

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

 block/badblocks.c         | 1602 ++++++++++++++++++++++++++++++-------
 include/linux/badblocks.h |   30 +
 2 files changed, 1337 insertions(+), 295 deletions(-)

-- 
2.31.1

