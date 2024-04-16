Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E11E4BE
	for <nvdimm@lists.linux.dev>; Tue, 16 Apr 2024 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713304017; cv=none; b=aoI9J+WgJu9U/beBveas3OjaohjnywJiuCN+8MrV/RDaYlXlM/nRD6DjepC9/c27Ql4OrAVAzEq69S+L2TBg05nPC3nk50C6EBLFKaTYomtTmVWK9LY8NruWLMjM/p1BSU0gWqc8+p+zJQwB+nFp0OVwXr8mn1hDg66Q/5CuN9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713304017; c=relaxed/simple;
	bh=O3/Jn76Fpegg6CH3Hagf24WgpAT3a74CNE0jvqQVUBk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HCbFCamxx0nv2p/1gr4Tk8n/AnrFSLemsxDEBdiec1kowXWhNrgFYDLsflwy/b6z6KEyQbOfS6SNBLCeROft22tgyWSaG6Ly5FkGFEx6kSw5GFFPnzP8iycSscGEbbQmS9T9o+OLOYSDifc0T4Tq/LMlJ7DZ4ksnTCAV0qBKcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ei14sYoE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ei14sYoE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713304017; x=1744840017;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=O3/Jn76Fpegg6CH3Hagf24WgpAT3a74CNE0jvqQVUBk=;
  b=ei14sYoEB60aKEHWbKv0+uqAmsI87QQrp2ct2nDmLO07JBHnFGQY5las
   Ju39d2+anTP8wL7QkWx36TSqSAn80upuvO1owzzw+uTd6DnDf3CLHXJj5
   um7O5ueX2Ih/eEnC4SwR7IL2w7tvAZ3mZeaDcn7NcT4Ol5Vn2pqQyDEPo
   hKeiV4VgzXvYr0cG96pLLpsocZYnXRyYVvItNPHsvrv1pxahJVGztcztE
   xi8yg6BA8DHIBB93WdXNSMh2QNpB7RljjTevD3SwkJ4hiL1FQpqmNn8G5
   EkuFAtG19XfZIIM9IRtsJBF+RMrUVRoqVNoYgrifA7MymRPCWRYQWOU2w
   A==;
X-CSE-ConnectionGUID: 1rIP8SrcQNqpBgeOpNugQQ==
X-CSE-MsgGUID: hHQPP/MMRvq1XfaExrQNdA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12553084"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="12553084"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:41 -0700
X-CSE-ConnectionGUID: RBxp1uv0RlqAltlIgAc78A==
X-CSE-MsgGUID: FV1TOrCBTUya1nUrwBjR+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22464232"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.14.216])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:46:40 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 0/4] dax/bus.c: Fixups for dax-bus locking
Date: Tue, 16 Apr 2024 15:46:15 -0600
Message-Id: <20240416-vv-dax_abi_fixes-v2-0-d5f0c8ec162e@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKfxHmYC/32NUQrCMBBEr1L220iatiJ+eQ8pZZNs7IImJSmhU
 nJ3Yw/g55vhzeyQKDIluDU7RMqcOPgK6tSAmdE/SbCtDEqqXvZSiZyFxW1CzZPjjZK4ouv0xTl
 FA0LVlkhHUa3HWHnmtIb4OR5y+0v/jOVWtMJ0JJ3V6DQOd/Yrvc4mvGEspXwBPsvkDrAAAAA=
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=1472;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=O3/Jn76Fpegg6CH3Hagf24WgpAT3a74CNE0jvqQVUBk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGlyHzdtm/Lm7msBm8qMZQst+BptjdJfiNaZpWrGfNZY9
 +n621nZHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZhIXwzD/8Cac5f4XgRu6jlg
 /mzd4YXX7wntMf6eeGR+WcFpKy7Jj4sY/mnrRVyyvNBw5+OubvHCta8M0treJk5M+eq0MfZT0OW
 YjxwA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Commit Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
introduced a few problems that this series aims to fix. Add back
device_lock() where it was correctly used (during device manipulation
operations), remove conditional locking in unregister_dax_dev() and
unregister_dax_mapping(), use non-interruptible versions of rwsem
locks when not called from a user process, and fix up a write vs.
read usage of an rwsem.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v2:
- Add back valid device_lock uses (Dan)
- Remove conditional locking (Dan)
- Use non-interruptible versions of rwsem locks when not called from a
  user process (Dan)
- Fix up a write vs. read usage of an rwsem
- Link to v1: https://lore.kernel.org/r/20240402-vv-dax_abi_fixes-v1-1-c3e0fdbafba5@intel.com

---
Vishal Verma (4):
      dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
      dax/bus.c: fix locking for unregister_dax_dev / unregister_dax_mapping paths
      dax/bus.c: Don't use down_write_killable for non-user processes
      dax/bus.c: Use the right locking mode (read vs write) in size_show

 drivers/dax/bus.c | 68 ++++++++++++++++---------------------------------------
 1 file changed, 20 insertions(+), 48 deletions(-)
---
base-commit: 39cd87c4eb2b893354f3b850f916353f2658ae6f
change-id: 20240402-vv-dax_abi_fixes-8af3b6ff2e5a

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

