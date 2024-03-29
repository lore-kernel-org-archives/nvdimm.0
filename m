Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B0F9CC
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 00:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711673300; cv=none; b=M2HicEEAe1+FIKiTMMYAHrTzrghduvClH1JoeOn7m4pkeVwV6p9Hj/LKB/O31IjrihVBnTZouz9H+C+t/myCcCt515ZLgaX8fzbL9D+5liXKPG5bAsdkKeagUx7nTnimm5a4N3B5JSVVlMEiotvKE9VSpuAzGy0YDPwb+4gimdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711673300; c=relaxed/simple;
	bh=BYAWbcqYa0A0cVmahF00vDwW4k9AUFK3Rpix9FCNLWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HHXbgli55KjCjlH0XkTR915MaNQPesmQ7UUfZnpu97vW6sG4sjLjeVqF+swaH5EKUt/cJAy1sRS+aaACrcp4vQlWsgDEBydJv+36F68Sw36tk0ia9+89aQVU/VtbOKMwzTcTrslM/KoomdOcjucwzhXS4bRh0oKTYmZ/nOQEsPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lERLj9X5; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lERLj9X5"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3c3bc867eaaso1078169b6e.1
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 17:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711673298; x=1712278098; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r556gW/Cfi0wJ9ucfJUvxgAelZ5AC4EcYQSPPpoFGLs=;
        b=lERLj9X5AlOQkqs+KnqlRSBeiqXcb1yipNqeuOiGY0tulYbGAhlLA2yGI4EqIpPr6C
         mBU2RXP0U+Rr7/MkL6gJwUt1hE1k1TZgoTDVsYa/8l12ZBUev3YFKHf8q99JhaiQ5mBo
         KTwewuXroXYNEsjHhtURQj97eubEDMpzD9in8pD75rh0YoZR3hJ78udnoayBE4RJybjW
         AcQ7ngS3KpN92fYNG0noPlsr7bB144A4SogBdypfndhqJm8oTex+Tf9PI04ioS5LfUEN
         uyyXDHbW3KtNC634NgEmHm+9VShBl+o9jS4I/3ojIOozkJXyFSEExXXrsg9KmXz0x0lC
         KiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711673298; x=1712278098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r556gW/Cfi0wJ9ucfJUvxgAelZ5AC4EcYQSPPpoFGLs=;
        b=jUhPRlu7cevtt+znUUYnocF12uYytR0MCDSBuSqW9m73rlJ/KqH8NRTptRVZ5ovadq
         e6cXVY9zRrvPIh6NjyqebF8hlnRL+TdsHhiDdVNmIctvDlyL5CmcQwUmsAvc1jeC+zCY
         3EqgA0C4YPrfPuz2vgJ+2hqUdHFxNME/qM0bvjS84HWrIxuVGK+P1bw81gOcH2E21dnQ
         OUiSFN62Zwa+k43+jGZp8goIEV+KIILKBAd8X4aTabCPd1mMyp99Vq3Bkwng1gvd/O39
         89Fuvo2XupUKDb3kTxO+It5mutXpH9RfxTqBnVtAVgZ3LBUWw8JDXhvtjiVV3S/kpULf
         3Q5A==
X-Forwarded-Encrypted: i=1; AJvYcCUiKh+o+Q7BxFsV/qm8WtkXJkD/UEfk8GaquA+SllsAHO/13g3u+Vgpk5SQ91n346mZJ8hUR8KXbBqb8H1O8MEc6TWEFJaZ
X-Gm-Message-State: AOJu0YzGMSAmaa9B7HNFl/j+AuhaiI0lT7vwJZrYGdXZSyWdgyFPiSwg
	luDCQbGrUSQb4KPiU2BksA3txsg74RqyjlnFxyoOQkQJnQfVx3qhUAvX2mXXZfY=
X-Google-Smtp-Source: AGHT+IEX7ShIC6O0vfmTE0ZHpiq/z8ldFe9ie+KXByR1IhyG1uQYPhwvYFTlSXbY2oXF2FX4Szjvow==
X-Received: by 2002:a05:6808:3093:b0:3c3:ca2f:33ce with SMTP id bl19-20020a056808309300b003c3ca2f33cemr997529oib.52.1711673298139;
        Thu, 28 Mar 2024 17:48:18 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.212.125])
        by smtp.gmail.com with ESMTPSA id v26-20020ac8749a000000b00430afbb6b50sm1102414qtq.51.2024.03.28.17.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 17:48:17 -0700 (PDT)
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
To: "Huang, Ying" <ying.huang@intel.com>,
	"Gregory Price" <gourry.memverge@gmail.com>,
	aneesh.kumar@linux.ibm.com,
	mhocko@suse.com,
	tj@kernel.org,
	john@jagalactic.com,
	"Eishan Mirakhur" <emirakhur@micron.com>,
	"Vinicius Tavares Petrucci" <vtavarespetr@micron.com>,
	"Ravis OpenSrc" <Ravis.OpenSrc@micron.com>,
	"Alistair Popple" <apopple@nvidia.com>,
	"Srinivasulu Thanneeru" <sthanneeru@micron.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Ho-Ren (Jack) Chuang" <horenc@vt.edu>,
	"Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>,
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>,
	qemu-devel@nongnu.org
Subject: [PATCH v8 0/2] Improved Memory Tier Creation for CPUless NUMA Nodes
Date: Fri, 29 Mar 2024 00:48:12 +0000
Message-Id: <20240329004815.195476-1-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a memory device, such as CXL1.1 type3 memory, is emulated as
normal memory (E820_TYPE_RAM), the memory device is indistinguishable
from normal DRAM in terms of memory tiering with the current implementation.
The current memory tiering assigns all detected normal memory nodes
to the same DRAM tier. This results in normal memory devices with
different attributions being unable to be assigned to the correct memory tier,
leading to the inability to migrate pages between different types of memory.
https://lore.kernel.org/linux-mm/PH0PR08MB7955E9F08CCB64F23963B5C3A860A@PH0PR08MB7955.namprd08.prod.outlook.com/T/

This patchset automatically resolves the issues. It delays the initialization
of memory tiers for CPUless NUMA nodes until they obtain HMAT information
and after all devices are initialized at boot time, eliminating the need
for user intervention. If no HMAT is specified, it falls back to
using `default_dram_type`.

Example usecase:
We have CXL memory on the host, and we create VMs with a new system memory
device backed by host CXL memory. We inject CXL memory performance attributes
through QEMU, and the guest now sees memory nodes with performance attributes
in HMAT. With this change, we enable the guest kernel to construct
the correct memory tiering for the memory nodes.

-v8:
 * Fix email format
-v7:
 * Add Reviewed-by: Huang, Ying <ying.huang@intel.com>
-v6:
 Thanks to Ying's comments,
 * Move `default_dram_perf_lock` to the function's beginning for clarity
 * Fix double unlocking at v5
 * https://lore.kernel.org/lkml/20240327072729.3381685-1-horenchuang@bytedance.com/T/#u
-v5:
 Thanks to Ying's comments,
 * Add comments about what is protected by `default_dram_perf_lock`
 * Fix an uninitialized pointer mtype
 * Slightly shorten the time holding `default_dram_perf_lock`
 * Fix a deadlock bug in `mt_perf_to_adistance`
 * https://lore.kernel.org/lkml/20240327041646.3258110-1-horenchuang@bytedance.com/T/#u
-v4:
 Thanks to Ying's comments,
 * Remove redundant code
 * Reorganize patches accordingly
 * https://lore.kernel.org/lkml/20240322070356.315922-1-horenchuang@bytedance.com/T/#u
-v3:
 Thanks to Ying's comments,
 * Make the newly added code independent of HMAT
 * Upgrade set_node_memory_tier to support more cases
 * Put all non-driver-initialized memory types into default_memory_types
   instead of using hmat_memory_types
 * find_alloc_memory_type -> mt_find_alloc_memory_type
 * https://lore.kernel.org/lkml/20240320061041.3246828-1-horenchuang@bytedance.com/T/#u
-v2:
 Thanks to Ying's comments,
 * Rewrite cover letter & patch description
 * Rename functions, don't use _hmat
 * Abstract common functions into find_alloc_memory_type()
 * Use the expected way to use set_node_memory_tier instead of modifying it
 * https://lore.kernel.org/lkml/20240312061729.1997111-1-horenchuang@bytedance.com/T/#u
-v1:
 * https://lore.kernel.org/lkml/20240301082248.3456086-1-horenchuang@bytedance.com/T/#u


Ho-Ren (Jack) Chuang (2):
  memory tier: dax/kmem: introduce an abstract layer for finding,
    allocating, and putting memory types
  memory tier: create CPUless memory tiers after obtaining HMAT info

 drivers/dax/kmem.c           |  20 +-----
 include/linux/memory-tiers.h |  13 ++++
 mm/memory-tiers.c            | 126 ++++++++++++++++++++++++++++++-----
 3 files changed, 125 insertions(+), 34 deletions(-)

-- 
Ho-Ren (Jack) Chuang

