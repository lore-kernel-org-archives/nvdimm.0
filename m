Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55A1278E63
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975815; cv=none; b=OI9ckj1HVeS5w/dJepdqMt3FWLuO3jNox3X0lfuRPcIQNRLHSiy/osWWVoJoTx9TmWJ36eH1raM0xDXbDe1ep0kszq6dFIbrFdwiqR53qcQCgsRwa+OoaPqh8X5fbdlqwJdSNeXP+8O+jt2t6zboG8GwdTc/M0Sd+OMQ0XufRvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975815; c=relaxed/simple;
	bh=CCv29ioHuBPEaztDjypCZpSL1ZEuoaIx0rBLzpHAvqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbKS6vqUCK1hHbuV/L6g1gs6LaQkDoQWgAfhztGeF/psfBmwNS5Dd/Mm85m9OeZKVhL4MqmrDs0XXNsY2oBJHXgx9kwsNvYzzLCozZND8peAQsiRFv16Pj7gKONui4AoD4Qhqk5SInbP3AnSVYj1uETk8Kk60VF/B2CVfb4S338=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TjrnfX1U; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TjrnfX1U"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b25ed53fcbso7092585a.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975812; x=1763580612; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmy6EhUdgU0DNpQaVrJpBZ6lZ48+dr4nIpOCH6X0C1w=;
        b=TjrnfX1U1F00+PAxe6HQ1iCa3pUZhlZnV1uA6h3VMGIve3sxIgjV+YaqBrP1M32HgM
         D5SRqft1B88M8MQu7D5uPw3+VxjiARQ3TNgaORfbIxjPQseIMMo+9crVg8qFjTxZZzmh
         fonGqtY5/lkvBJcrypp5F2avrwUdhg5ekOQyZNtccU3J94tLPfY7urVk/MsSr9lKJCfC
         Li51K86KZa08lo7f3Gh8R3d2vICrQAFP9m1Og4VS4OT007Aws1H1ExUoFkhBvUq1i3Gl
         2zPF1zuZcneGnQeMoQ9J1l6YD10xh4onmizOkfn7VFlCAxjqKcsyzIsNp2yMpqyHD62w
         PJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975812; x=1763580612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nmy6EhUdgU0DNpQaVrJpBZ6lZ48+dr4nIpOCH6X0C1w=;
        b=IjFhNRGRKXeKuxb6PHE9qFElRAWVyKnwmQqUs+1e7XwLo3D9vpVW6ua7p0VeuCsN8Y
         8bBQzvvmdAweEZWlYjH/DsaFe9STi0VT2F9VwGWnSZ4YvHFj2UEOTun7+nPy1ssLtJ/L
         h6SID7AHkZR4xocRqcpVfKz1K5EkeWOuowuqefw7UBhkbn8lazF2EdkU17Jb0RA3tx1+
         TPraUcaXlmDVxaZGo9W+tDF7H23kAy3aAMXKJ+aRXSgBoIdkuIoz01RwWXoX8oN5Rj7i
         XRncUEeZ+JCK1vexike5Znw61jIdiEGwa17Q4WJbf/qnJ9AnocMqm337u6ZW9J/QI17P
         k4RA==
X-Forwarded-Encrypted: i=1; AJvYcCVUvsIof4ik3KQXW+scVcKVXGbx4+9oBomBDwp3Qcdd0ceeZyi1ZYKbVzFqq8CzLvgdFx7k9l4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3cpEmCXjf0U4Cs3i6PAER5+Zw0/RYGxyt95eHZYBCXMU0HFZW
	4vBa9mDV3a6KpKohkDbaxw9TWfTjQACsPAJxtOj58FE+nYa6SdCrssHMU1WSxz0+pro=
X-Gm-Gg: ASbGncuWBq+k7dZn+MY27CheLisQ3MpOmMj30GeQX6YVEtpw6xtnQ5TQvW0fS2C2mt6
	9f78NSiLK3UA93YSThkltS2ZNhvfFAsAPkXieMD0PuVEX6Mx186g8GjHUXUuRpCPdIXcL05ygwp
	4MVeISK3FyE8p8ZvsGyYVqcJo5Qvjy5Cfuyuj62eltRHfV4dZ5TyW5k+cIrJYCdPUSxk0R1fodi
	nIJ2yYaJJR+c+2lamNmQ507KxYRUodRn92y3lhwKqh4AUQB34PBh/HuMBHhYvxcvlR7F1PdcdDz
	UoWskis7GzFufAmk6U764XcV4XdZ72H4Eo8Ps2WSwgmfjJS98BE1AtPMfZPFD1lmbMhxlN6keUg
	iauslJD1QuU0VVTDqfxvprDs/6ywm5qE8RQaa6WK8Pt37eKVjg0VePyCIGMOaLJ4h7skW2fUz9G
	dxgQfcfsEiWhl6CE0xPcC/YRoj3Y0BEltX6lLRVHTYYAnryPoeyZU+wGBbgjhwNOAf
X-Google-Smtp-Source: AGHT+IHrguqekTBYRBdFA9dxH70A9CcZsL7BjLOY758kp78A0w22ToZorWvEFBPVQ4lklZwp+U9JIA==
X-Received: by 2002:a05:620a:29ca:b0:8a3:d644:6944 with SMTP id af79cd13be357-8b29b74d7c0mr602392885a.5.1762975812194;
        Wed, 12 Nov 2025 11:30:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:11 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 08/11] mm/memory_hotplug: add MHP_SPM_NODE flag
Date: Wed, 12 Nov 2025 14:29:24 -0500
Message-ID: <20251112192936.2574429-9-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for Specific Purpose Memory (SPM) NUMA nodes.

A SPM node is managed by the page allocator, but can only allocated
by using the __GFP_SP_NODE flag with an appropriate nodemask.

Check/Set the node type (SysRAM vs SPM) at hotplug time.
Disallow SPM from being added to SysRAM nodes and vice-versa.

This prevents normal allocation paths (page faults, kmalloc, etc)
from being directly exposed to these memories, and provides a clear
integration point for buddy-allocation of SPM memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 10 ++++++++++
 mm/memory_hotplug.c            |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 23f038a16231..a50c467951ba 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -74,6 +74,16 @@ typedef int __bitwise mhp_t;
  * helpful in low-memory situations.
  */
 #define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
+/*
+ * The hotplugged memory can only be added to a "Specific Purpose Memory"
+ * NUMA node.  SPM Nodes are not generally accessible by the page allocator
+ * by way of userland configuration - as most nodemask interfaces
+ * (mempolicy, cpusets) restrict nodes to SysRAM nodes.
+ *
+ * Hotplugging SPM into a SysRAM Node results in -EINVAL.
+ * Hotplugging SysRAM into a SPM Node results in -EINVAL.
+ */
+#define MHP_SPM_NODE	((__force mhp_t)BIT(4))
 
 /*
  * Extended parameters for memory hotplug:
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..488cdd8e5f6f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -20,6 +20,7 @@
 #include <linux/memory.h>
 #include <linux/memremap.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memory-tiers.h>
 #include <linux/vmalloc.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
@@ -1529,6 +1530,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	mem_hotplug_begin();
 
+	/* Set the NUMA node type and bail out if the type is wrong */
+	ret = mt_set_node_type(nid, (mhp_flags & MHP_SPM_NODE) ?
+				    MT_NODE_TYPE_SPM : MT_NODE_TYPE_SYSRAM);
+	if (ret)
+		goto error_mem_hotplug_end;
+
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		if (res->flags & IORESOURCE_SYSRAM_DRIVER_MANAGED)
 			memblock_flags = MEMBLOCK_DRIVER_MANAGED;
-- 
2.51.1

