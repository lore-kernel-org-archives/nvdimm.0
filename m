Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36201350A17
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975799; cv=none; b=WyTOSasKcg/WI9x2vxamJwE1DbF4qEP0+1Gp1QheAVIesC7+5Y3R7fEDelV6NHXWCy/B0v7zq8ToZMVmuTMdnsn8J8ol4roCFGT082OlRQOZIe1uPUr85/AZRru92W+0ro0drvgSBawkqXotvjeUXYbDosLRLgBxpB1FhJ87ny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975799; c=relaxed/simple;
	bh=0RDVQa7L0OnIu08nxQH3yL1ogWBg2dkj/2taZUo7yjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoUOkGuO3W8N5Lrky4Ocmrznxxv7RLpyUmg6o3xrli137Z0zacwsQmOAxo7sP7oXeEG9GuC393Dkt/6mTV0obv9jdO3KnSHFv+HUYab9xowavvTgWEyn1w+prgB27hh+l8Ahb54haEiJvv1WR+vtcXtHA2sPS+ty7FHal/KLzR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=t8PcBfwq; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="t8PcBfwq"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b28f983333so4543985a.3
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975797; x=1763580597; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nze/QytclSTH4fFVa9JSQZznz6m85tFFzurTQmWSt3g=;
        b=t8PcBfwqPecC38VdP93hrp833dggaetoChVIatkkjMwUsZvSRArIo9FNu5O0p15GDV
         fgZyszxMPGHB/adgO9PxQezi5nxOjyf2E9LTRR7msrKb9PPhA7pKHTZJ5Tv1Md8Yz9rp
         OJTjvej2AmcMLwlTYQxEl2lULH7oQo6iGxqfpu/GpIPQfgX5s4HbEONp+DY3f7PQsTuZ
         LNQucHxn5BOnAyo4fLZOoID0aDuh8mXrRg+OrWWngzB4hQo4TDlhwiZM7ydkEy/gk7+o
         Ype59EbsGd1pJhI01iFciYGzzyMqFO5CUThRn49lvqq1R3QdBvck0uywf/y0xPFrvwKt
         zNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975797; x=1763580597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nze/QytclSTH4fFVa9JSQZznz6m85tFFzurTQmWSt3g=;
        b=OxKU5lw/3GTc6O0eh7xrHDKw3H3HzXyH6HPa/9S/ly/CYFt2ffgHsYFIPSTOChVclI
         USCiXyngxLT2gaJU7lx85jfw3eGbygtrzwqtGomuHE9urasQKUzVREps6nC4dSNEjRy2
         Be1eBom0gHewoqOfH1wHNAcgdrfBi4WESidDefMCHI9ah+yUrTVUIFmfWJw6nGvuZAgd
         GsfwEBgaZXZaZAU8w5gvipdNMNKOy6t7A6prDqFbpqsQMWuErY9iOWGgvo1Ca5veXQ1I
         hldkJuG+xsyHG9Cg1RjS6R1MpecAyWLuX85udQlfgaRr29svKlVfn8BxZ0trwVL2he8z
         6lbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKP4uAdnzksJL1QdnFX8psS+BSro8TEL9jKaYaFT/b2mQ8XcaKhGQiOHUaSgNOVmBUrYBTn9I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMNDVR1dRBAWgNOHHtfdDm2h9O5jjJelor7UTpKtixjlINHg6n
	F0GVCLrHsoB0WQwtrnd9MaX1gwKRE76G4IJumBl74b84PXnPER73VaS7Hsnbpt9UzWpiU/CeJDL
	DCiNZ
X-Gm-Gg: ASbGncs/UdXTek4nV/sAYtv005v/n4U/3NdyB55EG4Anhfb/xfgQDy39C1AXGTZ3zdW
	qwSQxTbHRoz7UGiU7aVuhumStTXrBERWjXmInObyqyz9u7H0sVRffH6ReybEwmKrgZq9azny2x9
	+xfhSYx22rKLsciT5YNKd4k4A2y9z6ZwkgsAXtJRS9YhQZJimLIJ/c9wvC/ihwG4ujons1x/9RI
	HAtLbud5sZK86DZjkA2/VyEIdxWxihg2lHQ/vEWnoSiWfUQ+A5HsQEtZ7AXdQm6TBrk+OUDmrye
	LXGFvB73W8uDlBUc2zX+1ZGw1/uF+oMoKK9JsbA4yd2ce84BihqAqTxs+ce7e3Zz1g/v870dw5l
	O2UP4e+I1ng9qQfLO+ZCHH5H7Lm6p5tPiSZ2lfql+nYFaI/j8MY+4NeUPqRuSdAgtBw1qQbS+ot
	rp51gm1i66cZxJCSoUZLFPgsHQv9omn6xga/uNMgBWVlaDdrsYneXN9gwlLmPzlw2+
X-Google-Smtp-Source: AGHT+IH1lDcByGDzgs1svKTRXfQs8NRaQexk4Q0+NImfdOthU+jf0vqFA5hw/PqFsiRTGmnVj1m8eQ==
X-Received: by 2002:a05:620a:1a0f:b0:890:2e24:a543 with SMTP id af79cd13be357-8b29b77b3c0mr590594985a.34.1762975796840;
        Wed, 12 Nov 2025 11:29:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:56 -0800 (PST)
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
Subject: [RFC PATCH v2 03/11] gfp: Add GFP_SPM_NODE for Specific Purpose Memory (SPM) allocations
Date: Wed, 12 Nov 2025 14:29:19 -0500
Message-ID: <20251112192936.2574429-4-gourry@gourry.net>
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

GFP_SPM_NODE changes the nodemask checks in the page allocator to include
the full set memory nodes, rather than just SysRAM nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp_types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f905..525ae891420e 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -58,6 +58,7 @@ enum {
 #ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
 #endif
+	___GFP_SPM_NODE_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -103,6 +104,7 @@ enum {
 #else
 #define ___GFP_NO_OBJ_EXT       0
 #endif
+#define ___GFP_SPM_NODE		BIT(___GFP_SPM_NODE_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -145,6 +147,8 @@ enum {
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
  *
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
+ *
+ * %__GFP_SPM_NODE allows the use of Specific Purpose Memory Nodes
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
@@ -152,6 +156,7 @@ enum {
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
 #define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
+#define __GFP_SPM_NODE	((__force gfp_t)___GFP_SPM_NODE)
 
 /**
  * DOC: Watermark modifiers
-- 
2.51.1

