Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6223E4921BA
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576138; cv=none; b=EljMROiLBC+HVTSIWegdVCwQA4PgvdbKShzD6TfYBVy7hNsJrZsCLWg7qcGK44YFnenkMbXWR2JE/79nFmdmUz2zB/CIRHrokz4TzFd11eRJgOKBsiFHDhyT58xBrvht3vV5XcVOCkl3Av/cOzd86NURmRpd1ak+g8oU0zT0mCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576138; c=relaxed/simple;
	bh=g/xiGWfO3mFmUtpjiaOltFkKmHg7U6hIcXuOmsbgzC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pf2Lu4pmLERM0YKFHpcrngXqPTS7B2SyRgW8pTVMxzDhQuqnejq0fTub2oeyWugASq6pHDtoJtsRaCOpWXsj0Sys3lx234zozbAqlVqbu7yZWxWLIMc9hwjgVNRAQotGrfP6SSGlLDBcti021vRjOcdh5HVqqSDVELB8VLomksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=IZaGPdXE; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="IZaGPdXE"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8eefd4a8057so64827886d6.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576133; x=1785180933; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+bbISnSBqmxoccJ9u0omFuHBSz5EtUsg09tULZikjEs=;
        b=IZaGPdXEgJygyzxoVV3eVz3YBY3m11N2YzApZq1koPX11IlRMJzzMa2Hp60UmjSlva
         4Cq2GoiD4Wm4VdU7D0jhnq+2RBuqebk5gzbof5r5tilQtVDPyj+5J8qOnm7gX3WAD6nD
         5thBwJ2KM0L6cohVgKv0Jp9oAxZHJUHxHfzrZScwU0lR6Hcpdh43IPuxUgQbEBqt45O4
         7Dgb+DaMH68IdrHhdhpWtuUHy+cff+MDcO648VpoQWxBmvk0fEUprOoJ2oKGjYMXb9aQ
         B2sE/mMGNr98kK2urmQLFoem6ui+dbj7y4/KVvwWiFgOtoClR1YCPiU5Bu3nZxX0N8HK
         b/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576133; x=1785180933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+bbISnSBqmxoccJ9u0omFuHBSz5EtUsg09tULZikjEs=;
        b=UGtMwkeUruDRoBhpl+CBFAtCuXS3qOJLYn/pGe7GGVevdfRlr7KXeCaLlDimepT0Hp
         /O9L4JOhTx4jUaguLuND2vYf0NavjJoa7RSqUCMNuovXrRScAEGk36R7KJrAJO61z5N5
         1vq67ubnIxS4T2U5zg9m24Z9FTtPscyiIKuEzTdScHsM7/g7hz80GjBeVNRbtX5dUguJ
         LI2WQXsth7AlsLur58zilHwTQu2LqvAqXGekbI2z9tUk2qicTiw48ydQwh/O4Ie/9p6D
         meqVC5oek4IKHMaduWESixH5uuAJ4Qj7F4kpps6VYgTnWw8sNhZXm2E3iDOHEP79HauE
         /zkQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaWELnad5JlJ6S1PysPZZxK/QXTZeYElyHjfAnM2BJ488FWr8lUWgKsMQziltM8iQbbLbWqEA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdNiuB0SXfIKGccjrGJSEDreK89fYQ71PCS2h/9sdUnTi2Vew3
	WMmveBQk4xlFGb8s4Jium5Imw8MFQxceGBWFAVco8NaYn2WJhAC0n33gu08bGKNRqm8=
X-Gm-Gg: AfdE7ckO+/ha6fEAqztXpAvPh1ni32uLfRsgD3NCABfQSQC1+GlfTj1TuUg7t1kikeW
	V/psNTsGWvSjGXBi35yo2bIfqPj4kQlgx0M+tT4gcmgnBxRiUxh9cQdpodqYz92E4+0TC2KSATs
	cGNVsn3NLLa6/UFwnWfpaqqnfFmT6tMLe3U8QeYFVOBWKoHcO2NXbKCJAh+6LM+Wa7voc5wrgko
	U4uVNdbCYeOPmd3KjV2v1s6j4offHBQ1H/mEkqR6pWKZjYcnhiOgG+uHdZWdVld6f6kivx0djXe
	qJzTAYPZYW1M/R3+yWNI/brTglcgSjvQvzyhTA+h5Yx3tMSz0TnE5MVflYRIcrfEvhR5UqfjQsE
	YiShP5h5Hafq5ZkezRa4IJ7D5Tt5mHbUXoD01IqxCveXwToprdypUC7YdnhMCeZ1is5dRaTf3pF
	5R7k2WRKJvzHO+PuxHUPgbHgmbdHrmokyQtBdOFFOb19t12Ufn0j3cwRDet/4t7UE=
X-Received: by 2002:a05:620a:1a21:b0:930:9afd:e98b with SMTP id af79cd13be357-930b434f8d4mr1589642385a.88.1784576133081;
        Mon, 20 Jul 2026 12:35:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 21/36] proc/kcore: include private-node RAM in the kcore RAM map
Date: Mon, 20 Jul 2026 15:34:15 -0400
Message-ID: <20260720193431.3841992-22-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kcore_ram_list bounds its scan at the highest pfn in N_MEMORY.

As a result, private nodes placed above the last N_MEMORY node, which is
the common case for device/CXL memory - is truncated out of /proc/kcore.

Include N_MEMORY_PRIVATE nodes in the scan boundary.  /proc/kcore is
root-only (CAP_SYS_RAWIO), so this exposes nothing new - it just lets
a debugger read private-node memory like any other RAM.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 fs/proc/kcore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 390547b992acd..f67194dc2a9b8 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -251,11 +251,14 @@ static int kcore_ram_list(struct list_head *list)
 {
 	int nid, ret;
 	unsigned long end_pfn;
+	nodemask_t mem;
 
 	/* Not initialized....update now */
 	/* find out "max pfn" */
 	end_pfn = 0;
-	for_each_node_state(nid, N_MEMORY) {
+	/* Include private node memory in the scan */
+	nodes_or(mem, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+	for_each_node_mask(nid, mem) {
 		unsigned long node_end;
 		node_end = node_end_pfn(nid);
 		if (end_pfn < node_end)
-- 
2.53.0-Meta

