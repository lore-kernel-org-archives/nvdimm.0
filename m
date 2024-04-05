Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E98936D
	for <nvdimm@lists.linux.dev>; Fri,  5 Apr 2024 00:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712275633; cv=none; b=uP8ig3BqxYQ9kX4uS+dyPvPbNgLkrstMjjehuuW/a5K9GmJI0luZ8yupMMYiVbEw+zVQzHexf2nPBRU9JUzD00yTN3ZnJdo0lgltkdZ+HqvsC1oEwJTp6lC6x3NFu0s0MaiUw5LDBRiWt5c9BqLHmyqnJRv6/aJb8b/haSnBB3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712275633; c=relaxed/simple;
	bh=FDoinf5ATmma6u2gGG8DW8Fyy4C4wZjoT6NU9B/hgyY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iLCnGg/5UPS3q+cUyLGbf34EkOdKAK2Xe8XKB2kTtd7tofmuYcbdzIuHKEgwSfAZHcdLieS2DGg4clkuesyqVkP0gSuQ+fiwuHsA8Nrx4059kWTSPvCpdrtosbwmFzb6dlzpcG5cWJ9RgVdAHcM3DsRubfBt26ggVprA+995amo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Rka2VQ4q; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Rka2VQ4q"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-78d44a8ab6eso58948485a.3
        for <nvdimm@lists.linux.dev>; Thu, 04 Apr 2024 17:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712275630; x=1712880430; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=borPtC2Lw74++f4OJFhInHLKkc0dmWJsVuLGMvV8fMY=;
        b=Rka2VQ4qSCJpYPczQbnzyFlsJFlCfIdbi6XIQDxpvyQr34V2roRwQlXSS1nJXJR+qb
         VQMcfKdpQTmjwZHizRdsV732qARbt65i+uNQRAaf5hCpzEsLoDRp8IBjse88yv88wNpS
         Vg4NbZ+UIIKuA9Eyrm2nXQBvmB8gqqM7TLeQnVB3km7cZjdBoo1Niy7QvkukfqJ+PKR4
         nIWyqPcWQr65K4gokkQD+PSrxnqOAjFxGg5m8611YtUw0cgX15KiD0iqS7ju7pkcaBmA
         QzPxb5r8MvpgF4Jk/6ON1RIOMp0rCZEeVkDHWepGPtT2ju8wfue5uRzNgSc8eiuvIAI1
         A4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712275630; x=1712880430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=borPtC2Lw74++f4OJFhInHLKkc0dmWJsVuLGMvV8fMY=;
        b=ayrlnmhqbz+U2Nr9y5aC49ouNGIun95T0rUemjqa6Qan3AlMHwjCJgwOFQh2wdlaPH
         1sl7fTetuuJMnHEBt4GHJrOF2UYPjwHUC81Fr12Q6r7rna6mh+pdi5hgFg1rsKyyMvWW
         0GRRpXgJxHAIjdkuL58CMHvJqCJo9qJo2lDJlumxKfzn+Of3Vxy7rsrvJTOQl3grsnmY
         Zy85ufu0kfo+1+XUInQFWjRtCl4wuHyZLEdSklL160zlQt4ClWlSIHzY2mFIiUuGUgJD
         uTvyCNPRxi8TUS8RAx03Z/mU6NRllqZqo2U+Ir73YqtLDfkd+tgjZ6lhjAUmeHM9gOkC
         +eeg==
X-Forwarded-Encrypted: i=1; AJvYcCWUKd3PGXLzkaltRSdtl7rVQ+krBsGXALaWAkM2rvLBLSRSEnngPG/psHCKWIX23MeGnGmwlwSMGxEKulUK9aXM9cIBoorN
X-Gm-Message-State: AOJu0YxgqBlJOKl+5Iz7GAcXjufn3JrwpPzw5pxK8v03RwGvkEQiEsTu
	PwhVW2ERSHmoKXSTd4RA9nO/9nj/BOAzXB3tDEi2WJmy846X7s8kkIyQNE1EqEY=
X-Google-Smtp-Source: AGHT+IEZxsVQpcVtfVYtGZzcm88UlnMi4FCOp8lekdMsqoU3bR6MAdrGWYFbzpWmRgOIJsDUml+1Gg==
X-Received: by 2002:a05:620a:136e:b0:789:e524:933b with SMTP id d14-20020a05620a136e00b00789e524933bmr3831084qkl.31.1712275630015;
        Thu, 04 Apr 2024 17:07:10 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.212.118])
        by smtp.gmail.com with ESMTPSA id d4-20020a37c404000000b0078835bfddb8sm191433qki.84.2024.04.04.17.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 17:07:09 -0700 (PDT)
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
To: "Jonathan Cameron" <Jonathan.Cameron@Huawei.com>,
	"Huang, Ying" <ying.huang@intel.com>,
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
	"SeongJae Park" <sj@kernel.org>,
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
Subject: [PATCH v11 0/2] Improved Memory Tier Creation for CPUless NUMA Nodes
Date: Fri,  5 Apr 2024 00:07:04 +0000
Message-Id: <20240405000707.2670063-1-horenchuang@bytedance.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a memory device, such as CXL1.1 type3 memory, is emulated as
normal memory (E820_TYPE_RAM), the memory device is indistinguishable from
normal DRAM in terms of memory tiering with the current implementation.
The current memory tiering assigns all detected normal memory nodes to
the same DRAM tier. This results in normal memory devices with different
attributions being unable to be assigned to the correct memory tier,
leading to the inability to migrate pages between different
types of memory.
https://lore.kernel.org/linux-mm/PH0PR08MB7955E9F08CCB64F23963B5C3A860A@PH0PR08MB7955.namprd08.prod.outlook.com/T/

This patchset automatically resolves the issues. It delays the
initialization of memory tiers for CPUless NUMA nodes until they obtain
HMAT information and after all devices are initialized at boot time,
eliminating the need for user intervention. If no HMAT is specified,
it falls back to using `default_dram_type`.

Example usecase:
We have CXL memory on the host, and we create VMs with a new system memory
device backed by host CXL memory. We inject CXL memory performance
attributes through QEMU, and the guest now sees memory nodes with
performance attributes in HMAT. With this change, we enable the
guest kernel to construct the correct memory tiering for the memory nodes.

- v11:
 Thanks to comments from Jonathan,
 * Replace `mutex_lock()` with `guard(mutex)()`
 * Reorder some modifications within the patchset
 * Rewrite the code for improved readability and fixing alignment issues
 * Pass all strict rules in checkpatch.pl
- v10:
 Thanks to Andrew's and SeongJae's comments,
 * Address kunit compilation errors
 * Resolve the bug of not returning the correct error code in
   `mt_perf_to_adistance`
 * https://lore.kernel.org/lkml/20240402001739.2521623-1-horenchuang@bytedance.com/T/#u
-v9:
 * Address corner cases in `memory_tier_late_init`. Thank Ying's comments.
 * https://lore.kernel.org/lkml/20240329053353.309557-1-horenchuang@bytedance.com/T/#u
-v8:
 * Fix email format
 * https://lore.kernel.org/lkml/20240329004815.195476-1-horenchuang@bytedance.com/T/#u
-v7:
 * Add Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
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

 drivers/dax/kmem.c           |  30 ++-------
 include/linux/memory-tiers.h |  13 ++++
 mm/memory-tiers.c            | 123 ++++++++++++++++++++++++++++-------
 3 files changed, 116 insertions(+), 50 deletions(-)

-- 
Ho-Ren (Jack) Chuang

