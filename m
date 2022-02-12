Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1457E
	for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 07:11:35 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id w20so6385500plq.12
        for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 23:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJWv4+1FQbvdMw4wXNISW5YNlFR3GL+Z3R6+p6cC0cc=;
        b=lBgkmU2opob3nAv4YJBAi7Ijhve5HmiVL/lIxW0/7P6OzFU0/Mh7ex2JlOG8luGs9H
         vpjykZkjt7W94Ni7KqUspWHtN0L5VfYJUQ6phxdGKl9TOmkLonCs/8g3SxsKgxnXkgg/
         98AuFJIy06P4vmrsYPVECQD6zZr2m0qsGsckeq7Gm07FVolyL+RUyS+S7sZO//Mogi0I
         c7NLtPpNMxJPNtdtESHGMhmKK1WUwjRkY+w+bo3Muco4+Uqmh5sgxfbAqEVlDOKbhPHq
         un2XdxIQXPyIezyPpk0phRyLImFAy8rDceBn5Mzvr3Hk1YuuCGpDpNYxuxOi5/HeyHDR
         vpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJWv4+1FQbvdMw4wXNISW5YNlFR3GL+Z3R6+p6cC0cc=;
        b=IOCBqRyL8X2BLBMcoZ0S+xgQ4GGlm+I3IHYr8ME9sILf/DxSQuFkBzbv/uV8vuf3xX
         JxZ55Q20sIU9cKPj9VGWomGF9dv0R7/Ko6MlYCCi+hJptbSNq39aeyWRmiQxmYlW8c16
         3FN52jr0yFPuIuyovbk+OxBXxRAzAc8SO36XQAz2eGXpQ3UDwvQ/Ffvd6sB1ASyvJJFk
         1tRnt9JexgtpUrGaj3+2fMb4ioq26XDrw/40RUMBrDj8hrPjW3zEF6s5u74DVo2cTgKW
         udGVXhnETYi0WrEAKxq1KWcRalHv64DLrlUB4z7Xe7+3i/iKqJlexzr3uApOJSi5SW+z
         20yQ==
X-Gm-Message-State: AOAM5307uezQdNQdR9QoXpjQzaUP7CRmoi1zEJp7HdAVMnOLEEAjY1qu
	uAO5vBQSZFUIimkAPrIpByk=
X-Google-Smtp-Source: ABdhPJwTA48YczQpfo6bhiUx1wcqZqvTgPvQut2lcZVm/LMuAOj6LdjJVrgHXf106G9P5rpFlGKCZQ==
X-Received: by 2002:a17:90b:4c06:: with SMTP id na6mr4015192pjb.62.1644649895097;
        Fri, 11 Feb 2022 23:11:35 -0800 (PST)
Received: from tong-desktop.local (99-105-211-126.lightspeed.sntcca.sbcglobal.net. [99.105.211.126])
        by smtp.googlemail.com with ESMTPSA id l14sm7773309pjf.1.2022.02.11.23.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 23:11:34 -0800 (PST)
From: Tong Zhang <ztong0001@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH] dax: make sure inodes are flushed before destroy cache
Date: Fri, 11 Feb 2022 23:11:11 -0800
Message-Id: <20220212071111.148575-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A bug can be triggered by following command

$ modprobe nd_pmem && modprobe -r nd_pmem

[   10.060014] BUG dax_cache (Not tainted): Objects remaining in dax_cache on __kmem_cache_shutdown()
[   10.060938] Slab 0x0000000085b729ac objects=9 used=1 fp=0x000000004f5ae469 flags=0x200000000010200(slab|head|node)
[   10.062433] Call Trace:
[   10.062673]  dump_stack_lvl+0x34/0x44
[   10.062865]  slab_err+0x90/0xd0
[   10.063619]  __kmem_cache_shutdown+0x13b/0x2f0
[   10.063848]  kmem_cache_destroy+0x4a/0x110
[   10.064058]  __x64_sys_delete_module+0x265/0x300

This is caused by dax_fs_exit() not flushing inodes before destroy cache.
To fix this issue, call rcu_barrier() before destroy cache.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/dax/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e3029389d809..6bd565fe2e63 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -476,6 +476,7 @@ static int dax_fs_init(void)
 static void dax_fs_exit(void)
 {
 	kern_unmount(dax_mnt);
+	rcu_barrier();
 	kmem_cache_destroy(dax_cache);
 }
 
-- 
2.25.1

