Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCD937B
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 00:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711672840; cv=none; b=RA3m1DynqLMqEfcjPJE9NoonMGhs/1UVSZNMJMM/IYmiE4EdYuthga1FJbudKPN7H3s1hFhYEW3UX6g2jNNQJmUueqXgJAxduhl+ftWcvy0hoEgW14fR83sCEQXBFeiS8gtjaovzMy8kZD2pYV5suZumhzxoR1TYJv3cwNLj3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711672840; c=relaxed/simple;
	bh=HD6NA1VgjuxE+aTElOuBi+wXSVUi3DV91i08SVrmsWs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JvUuNhifzRtEBf1kJ8ww0Yj80immK3JjcZKZouryr/5egH1uKlInZxqUCI23CA5A/kreSMr+KAQRlNA4qqiw05lDJ07EzW9DGO2PAqJz/NXrZnV5RqOV7kKjqFlabOFNnuSIKy+vtkDSYotjODl58fROT+ilCzHuzLVrAUaJWaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=PTCKTQhH; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="PTCKTQhH"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-690bff9d4a6so9095206d6.1
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 17:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711672837; x=1712277637; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ATOisTRRjQB4sgxy7npSq+e14hDk0Gnp420OOaz5yog=;
        b=PTCKTQhHGMkv3CIyXssImlNiDi3XzhRM5Dovca1MHHZF/m5qDzRSYRxTDCt7E/vpit
         +Ozh0KhgrzP24KQazldMpUKGt8UWKfEMBmLoAI735qYBSw37lD5mCvB3LoK9fEOU35d+
         DDKHWYkJdLnDuh8f17ZngYxFChXWnFy8NTvnNNXzEzpFrBuylKInK1VwxGzobsWZIC0M
         uT8MoaTa5mvrp5yPIXHV+D2OWKq9wfGHTDLXx656EnVSg2ygKEfIkOlH7vBDcfezavxw
         FTiKA7dn5ND/Xq1Q+SoAet1UbYc4mn6m67uOJ5HdbRN1Bt+nH5sfZ5EVHPnpOVe7EPYF
         J1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711672837; x=1712277637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ATOisTRRjQB4sgxy7npSq+e14hDk0Gnp420OOaz5yog=;
        b=e6HiJaJ4trAbvWYrktqaXyZvPBY8XlMFy2L97Bqoqd7r46ILTblflb1HHS4MMckOZ3
         OZ2fEjkPdqrWUdV7GaVfPRBr8mKcvRm8nb5tUHP9bLVqOXTtYhzxxfa9uqc7e4hgNxsc
         d2bM2SUCCyaCWt+lq+umnGPFOu3Z8vHeCiFOPvIqw49aDAD4S93OVpSNtCL2eoeh1wnB
         ocKadFztU4t3VJBIBQaLI8i723zC0Y3T0pWx6/sdZYL87h3p4cQIFLwqBQZ5Fa2Cf0h2
         H1niyv5AiPpcHdgSpsfbqYI6JV9smHo4XH5b7MZdbgUOI0gdVwLJpvFiNaK2+Wacy3Vg
         WXKA==
X-Forwarded-Encrypted: i=1; AJvYcCVz+slNy5a48puI/lsoQRAPlJZlBoJgYen1D7a1gbAxwst3fX8cb4spnhC6+Psaxt9/w+NCdJe/C2v19u+BGtDe+xGgxHTO
X-Gm-Message-State: AOJu0YzwfAc1stE1eSxXapulcmmxWSHe+ecNMiIFi6SPastsFIlaOCXc
	gfwOMtu7xiQpRm9+guQOj9qN9CRSOy8k4e77oNWNgDKabHrts4SvjaTOa9iSvxE=
X-Google-Smtp-Source: AGHT+IFGFZDh45AZa0PZbpCZ5KKj6jHei4/t/LDFVey2btcJI7NSFvNMp99+UdXTyXt83plS1QEmoA==
X-Received: by 2002:a05:6214:bd4:b0:696:4084:d6f6 with SMTP id ff20-20020a0562140bd400b006964084d6f6mr965534qvb.8.1711672837688;
        Thu, 28 Mar 2024 17:40:37 -0700 (PDT)
Received: from n231-228-171.byted.org ([147.160.184.85])
        by smtp.gmail.com with ESMTPSA id gc15-20020a056214230f00b00690fc99a836sm1113530qvb.105.2024.03.28.17.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 17:40:37 -0700 (PDT)
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
Subject: [PATCH v7 0/2] Improved Memory Tier Creation for CPUless NUMA Nodes
Date: Fri, 29 Mar 2024 00:40:33 +0000
Message-Id: <20240329004035.191601-1-horenchuang@bytedance.com>
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

