Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3591159B57
	for <nvdimm@lists.linux.dev>; Tue, 12 Mar 2024 06:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710224278; cv=none; b=i6rf1NiuM1KELjRCIb+4nbZXjzkmx0rSI0KmSc6CzfjojvjQRALwSTZ+ko2zeNWMyx1hS5dChBRAp4I7Dv8ikMUR5G6y8wxarBwH54uslj6/3ceu7RjIhTGxVbNNq/73p9vTFO4ComnVCM/hG8JucXyz59wiNgp1lY4+Xmg4bFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710224278; c=relaxed/simple;
	bh=nmhtM2hCPPzOA3PI1UXfFRGQ2/QNiXyNuDJau9M3uBI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FNvUONbVWmRx0TaP8vZeRHUl7ygOeTyLN+95bBpIw0ZhM/zKxu7MPLWks55MGTVmTQkfAcc8gm4BeDGC839DdAK/fG95G7qe1P2/CeM6TeIcJZ+PUMhGd26ouIyij77QM5F38UJGfFqNHMZnHHAWqFHi/pv2vTJ/FskpVUtk+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j86oZmnq; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j86oZmnq"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-78831914027so153681185a.1
        for <nvdimm@lists.linux.dev>; Mon, 11 Mar 2024 23:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1710224276; x=1710829076; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fgGl/GezxVhRISLyx8tZ9PTH8m4h7yDB3m04Y7JMT5Y=;
        b=j86oZmnq6jNaVz/+1afuc7sB48IANhiusYGE/OlHvPcFOMfRJXTZXZbxY2S0G6iNaO
         XvzppfHiYjkMV2JFt+xXpU7h+ToCPJ5Gxh63VZzreE+9tN7ZTRCWbBowPuAZ0hxZ70RN
         AJ44d8l82UDG+kN6MnfZQMU256kTthaG0MBTEpSpQdE1kTGrbJ6h9e//dxJ0LMBPLXCF
         QD6CcWfKBwRmTbL/6jdKBGspQ43sT2iNTyf7Bl6kpOPTrH7jnR+7yMukOpRsxtMCnoqQ
         dwiJSoCpUvBD/q6sHR2qiJdws4HCp+XakbeTmljYQ4Ok3jFmNx6yUqkx6/a501wvZF6S
         yBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710224276; x=1710829076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgGl/GezxVhRISLyx8tZ9PTH8m4h7yDB3m04Y7JMT5Y=;
        b=EisvzF8j9Ghk7NASlJQ47av/3EEyMb5CytMMizQkRsSkatLhiWNBfrtP5XIxLjcEnb
         UuGnGS1So2QrJ3mpVs0vVwo+QxXT7w9grXYzYeib1DTFng9ZPk/JVA3uLcrzLMHx+TMZ
         72rcF5ogtEb563Rh9qiNMHAg2u4toGhXTO0e37EpBEqgKbxkPKj8Fwldp8gWTCKVtkNX
         i9QR+D2M09HqEGtu5jqhElv4bbSmNGmE+2mlX7PafRz37d5sZia1hfmmZyy5dH6jEHxz
         Oz30qGP4QzZedIBFB3VEfYS0GdfJYB6JuoC7sK38ufTC9W5w1NV210NHvso5Z8yND9pg
         W7Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWd2LbAMjUz3+DW19WeO2kEi+l88/gUfon5PG/ONBa+ooSPZv40L83h1SXjncYXqLROSCBGeY9RLEMeBaWn0m5T0NKxDWBh
X-Gm-Message-State: AOJu0Yx/APf65tDoAUPgrnGniAJXahs3YmiNON9hoJ5cTCkyltqEq6Zs
	VsLMBExg8jlSVHXt+MJ7HPaeUNtWWS7WOYHtsZezjOWEcYAnZzpjkQUcTL7rNgM=
X-Google-Smtp-Source: AGHT+IGQVjf55XaSaA7QRv11XERHDa0ikizCRigRPLUcQWIpU3ODAYNJ7IKwN9aaMW4bZrAoONZoqw==
X-Received: by 2002:a05:620a:4494:b0:788:7dc5:cf8f with SMTP id x20-20020a05620a449400b007887dc5cf8fmr499319qkp.35.1710224276179;
        Mon, 11 Mar 2024 23:17:56 -0700 (PDT)
Received: from n231-228-171.byted.org ([147.160.184.133])
        by smtp.gmail.com with ESMTPSA id m18-20020a05620a221200b00787b93d8df1sm3394396qkh.99.2024.03.11.23.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 23:17:55 -0700 (PDT)
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
To: "Gregory Price" <gourry.memverge@gmail.com>,
	aneesh.kumar@linux.ibm.com,
	mhocko@suse.com,
	tj@kernel.org,
	john@jagalactic.com,
	"Eishan Mirakhur" <emirakhur@micron.com>,
	"Vinicius Tavares Petrucci" <vtavarespetr@micron.com>,
	"Ravis OpenSrc" <Ravis.OpenSrc@micron.com>,
	"Alistair Popple" <apopple@nvidia.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Huang Ying <ying.huang@intel.com>,
	"Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Ho-Ren (Jack) Chuang" <horenc@vt.edu>,
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>,
	qemu-devel@nongnu.org
Subject: [PATCH v2 0/1] Improved Memory Tier Creation for CPUless NUMA Nodes
Date: Tue, 12 Mar 2024 06:17:26 +0000
Message-Id: <20240312061729.1997111-1-horenchuang@bytedance.com>
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
at boot time, eliminating the need for user intervention.
If no HMAT is specified, it falls back to using `default_dram_type`.

Example usecase:
We have CXL memory on the host, and we create VMs with a new system memory
device backed by host CXL memory. We inject CXL memory performance attributes
through QEMU, and the guest now sees memory nodes with performance attributes
in HMAT. With this change, we enable the guest kernel to construct
the correct memory tiering for the memory nodes.

-v2:
 Thanks to Ying's comments,
 * Rewrite cover letter & patch description
 * Rename functions, don't use _hmat
 * Abstract common functions into find_alloc_memory_type()
 * Use the expected way to use set_node_memory_tier instead of modifying it
-v1:
 * https://lore.kernel.org/linux-mm/20240301082248.3456086-1-horenchuang@bytedance.com/T/


Ho-Ren (Jack) Chuang (1):
  memory tier: acpi/hmat: create CPUless memory tiers after obtaining
    HMAT info

 drivers/acpi/numa/hmat.c     | 11 ++++++
 drivers/dax/kmem.c           | 13 +------
 include/linux/acpi.h         |  6 ++++
 include/linux/memory-tiers.h |  8 +++++
 mm/memory-tiers.c            | 70 +++++++++++++++++++++++++++++++++---
 5 files changed, 92 insertions(+), 16 deletions(-)

-- 
Ho-Ren (Jack) Chuang

