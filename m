Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CFC1DA22
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 07:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524455; cv=none; b=VWq5Q4sy2xd+O6CKozcam7mMRoShClRh22dJB4iRZpprtVBBwyMqhxm/8rJ0G37RFV1Br2n5ofLBazanHsuDAdsHF+UqwCwOMU/98eF8A+vC8d+tfYrkmOoLpFNCXuYe+7ND+9NhQNmmh7rsSNKNs9ybc9o07gnXOTacH/Q1zuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524455; c=relaxed/simple;
	bh=KtYBOfLAS9jI/2y5IiX7IJwAU7SeTsDBTVcOkJvVnBk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YZQq9sI8OkP4HW8g7xHhDANujDV3dJR1+QWyiLZdvPil+unskIMgfXUQbY9kfRAVf68d/+qVNcUA+jQdm05KcQKPf0li+VqRGaEiDKI+oJ++pqKkjd41P+PnI+Yc5hcd0DcBiQlNvCXxSP69Bvk0CbhnB55cNH/mpStmbI2Z7Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Myz5ZeDl; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Myz5ZeDl"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-430a7497700so42498601cf.1
        for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 00:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711524451; x=1712129251; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IldNgoyaPcCzFmZ/bstRqOq1SS9MI1jIO9UfiXXSAU4=;
        b=Myz5ZeDlcOwuP1QTSYSNFKQp4rcqI6KsaL8AqcouLrLDUwrqnpuXlog9jZR8QANyZi
         39pPYyeSmdIacSxL8dbVGcd5oxsqMycGG/mr4MBSEut0g+qgefwDrp1iaMNhLwkpJRp6
         EV3aUz/Vr+dcHcESCUXYUXf/7T88iCPFnMq9jflzpRImgY5INLKWvALPK8zgJj9wHIlV
         N4wZgl1Wd1W0qjkys67J1hr/scfkGUvZUwFYUzgJKGQPTnI9n9YqzOm00voG/RaCcz81
         yxDy4IVwvHoaADgvA4WpvZwVFGzkYaFFRcyEjSOeH4gmTUWN+9QQ5TsHvo6NdqlW1HR0
         iHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711524451; x=1712129251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IldNgoyaPcCzFmZ/bstRqOq1SS9MI1jIO9UfiXXSAU4=;
        b=cMlMQ7itytTyTmMk6UpdU9mTrF1CTQegkD8SsHa3zR8dEQ9tngbJUE63Ds+pvI/3kJ
         +8cP7WcMwHzifzt+hxNIpsliNwM6Eu+Wrzjv/GGEIMYF4jLjsx+RDRAvdt2iZgISdEDF
         5PoJz41XEILncQKXyjRato+EwLqPfD94VqdudBpcvb+9hcJjPWuzAt+Lwa9YTgl0ztks
         bml1zGnFupiwhmw7eHy6Wkbdn49jS68IwEjbYigtSLpHj5+8hdy4M9PlaVD1ESCjr2fl
         Uu47tBs1g3C9nZlLMxPlWIlvCQXqVIt6XIKUx2U29sBETxNWgLeGXFeoWeanAk7ydWyx
         L8rA==
X-Forwarded-Encrypted: i=1; AJvYcCXeH3upsZ6LBkjvk6YugllAvSPNaH+3F3bf5PHirIt2Ci2k69ztuVA7gTW79mkfPP75ZEHiq8BBy6rNPfu7Cjogb2RZLO7w
X-Gm-Message-State: AOJu0YyM27dgKC6qscXp06YxaWN0BF8Jq/KcVIbWUWDf8UZPhz+iuU9C
	RThpPAZWAYbCImp6bpemsk2RL3VX0/NSZ0F9EL6qYt8jdvUdZdgsoCEQbGo8UGo=
X-Google-Smtp-Source: AGHT+IGtqBvkGEFUH7xveuxcSGh3Y9WoJxG4fW6RKgQd9gCeDvnBocFndsK1ZVijAA2duJEKfAsBiA==
X-Received: by 2002:ac8:7f8e:0:b0:431:5f0e:bfa9 with SMTP id z14-20020ac87f8e000000b004315f0ebfa9mr5633221qtj.34.1711524451618;
        Wed, 27 Mar 2024 00:27:31 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.212.102])
        by smtp.gmail.com with ESMTPSA id bq15-20020a05622a1c0f00b00431604af3c1sm2383555qtb.20.2024.03.27.00.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 00:27:31 -0700 (PDT)
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
Subject: [PATCH v6 0/2] Improved Memory Tier Creation for CPUless NUMA Nodes
Date: Wed, 27 Mar 2024 07:27:26 +0000
Message-Id: <20240327072729.3381685-1-horenchuang@bytedance.com>
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

-v6:
 Thanks to Ying's comments,
 * Move `default_dram_perf_lock` to the function's beginning for clarity
 * Fix double unlocking at v5
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

