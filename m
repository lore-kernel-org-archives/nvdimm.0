Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC73182CC
	for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 06:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710915048; cv=none; b=tjRIP5HWCXQl289UtyLrdd0DitsgnogJraMvh1ZYoMzbt2PtHZ93zmukGb9+OuhihYT/FZ3ap6MP/zfgD5HBWTvxULcdsyWMrqOew9xW58PlxsHo8GNoa8bSDj4ov5fO6TfbysU1lODcCMH1k2GUAajogHF0uNdZvKaCQ8Ch6+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710915048; c=relaxed/simple;
	bh=VUlBmGcp8svVRc+YgVvPOifmDRnW+ZmwDpx4QVsS7Fo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=an33OsOWdigT8kr+ic2UyqqlUhjTuFPE6kdZDhS3/fKTVNxJGll242yn8VkNaKYsBMVOKhlCmoePaTzudPVuG+53vHUJ042trEA1yzXYBpV4StAHwNt78A1Yn7ine7993q9cNfGT63xW5rVYt60ZuXrn+94FhGANuBRjw/b+9H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j/fww5+6; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j/fww5+6"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-789e2bf854dso273606985a.3
        for <nvdimm@lists.linux.dev>; Tue, 19 Mar 2024 23:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1710915045; x=1711519845; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xCZgkB2SZu0i/tSjRR46WOtj0M+sNHf+HRU976J1PX4=;
        b=j/fww5+6ei9OWFtmN2x4QuFrzc9n40UvAn8vVMhwoT/oAIpW7HM++hreAMowHJk/RH
         O2evA2ecE0hnbPbWpqwjQo3VdGP2YfuQlC6uCRgF6HDVaQNzsj5kLw84Vh6tnpPbSYIK
         SjQWqPkoJfjoGHWu2UFkepUWUdYzl6Z0sKbHFvJf+umXjwX5kRG0pTdQE1FGURv7SAat
         O5vLKrWGWW3uJqX+V7JXAlzl1Wyk1U9yJ+O33KR0TiLctu1f89fQguVyVRx/0hPr5+CG
         MvNNs4GiHtScaSJwfiGIYFbStddj8JSKtaxOh1SvbpiaDs+iglIHR4GWtnCjdWBsk6W0
         U0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710915045; x=1711519845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCZgkB2SZu0i/tSjRR46WOtj0M+sNHf+HRU976J1PX4=;
        b=jv65jvyBhHDvv/N9F7VEAdBtnGc+Ikj87B2KjlUjwqoIxjGhzxveGA+/oV/pKvGuGm
         /hGg6DPE7bY4lAN6WXYzcgsBIBiwaSGbW9g+imexjNuE/ufTcCJn+hqitd92vkSMPff8
         LAOAYmIKgS9xUcI/8k/sxMP9YUfhVzKO/3GgWAsnUJz/d7MoS51O8pSr54nkrhbIHBZq
         LPoosZiJitRk/ZZ+Rruyo5KYLXOY4knB6Gr3tDW/Xdkb1mlvJEGIhcP9K+LolIA1+5se
         ayMQfO0TSemNwXd6vqg+4qIfHTt07sq3qdC4QgH4hOdQivgBwt0mRWiJFkVGzDRckat4
         7EJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFvhSJguMMn0hGCXbOp9I+glkg0bDlSuj90OGpWT8AsR1O5MG9tLNvVlsw9ucWMevli8iB2mQmI1t8yRy9MD7hfQWoshkQ
X-Gm-Message-State: AOJu0Yz0jkP/uiDHzGnlDkRq//21Px1IWcvGTsKHzxpUBQaFwjPIr2YJ
	SYCT1E6mKSih4/BuQq21+3SdzoqOcjsNPTqGrEGB7YautTwOQZI+BlG95YT1t84=
X-Google-Smtp-Source: AGHT+IFa111kisVq1eXAsilnKhEWjB1FxneYVefed7MzhMngJVWVGZbwSa2ElD7e4aapqGZS/vkJjQ==
X-Received: by 2002:a05:620a:5d8b:b0:78a:1c41:ac4e with SMTP id xx11-20020a05620a5d8b00b0078a1c41ac4emr2285040qkn.5.1710915045498;
        Tue, 19 Mar 2024 23:10:45 -0700 (PDT)
Received: from n231-228-171.byted.org ([130.44.215.123])
        by smtp.gmail.com with ESMTPSA id r15-20020a05620a03cf00b0078a042376absm2295914qkm.22.2024.03.19.23.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 23:10:45 -0700 (PDT)
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
Subject: [PATCH v3 0/2] Improved Memory Tier Creation for CPUless NUMA Nodes
Date: Wed, 20 Mar 2024 06:10:38 +0000
Message-Id: <20240320061041.3246828-1-horenchuang@bytedance.com>
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

-v3:
 Thanks to Ying's comments,
 * Make the newly added code independent of HMAT
 * Upgrade set_node_memory_tier to support more cases
 * Put all non-driver-initialized memory types into default_memory_types
   instead of using hmat_memory_types
 * find_alloc_memory_type -> mt_find_alloc_memory_type
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
  memory tier: dax/kmem: create CPUless memory tiers after obtaining
    HMAT info
  memory tier: dax/kmem: abstract memory types put

 drivers/dax/kmem.c           |  20 +------
 include/linux/memory-tiers.h |  13 +++++
 mm/memory-tiers.c            | 106 ++++++++++++++++++++++++++++++++---
 3 files changed, 114 insertions(+), 25 deletions(-)

-- 
Ho-Ren (Jack) Chuang

