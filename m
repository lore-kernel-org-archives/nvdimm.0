Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C45AAD4C
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 18:08:34 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id q11so323677plx.5
        for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 10:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m72Q2LX47Fd2G4iaDSLuBTewGnVaLRCtRzAf9b4ENNs=;
        b=b1j5BY26QzYIYtMCqc8aI9cayDjo7BLHSsQTdXXDbVpy213+FRBffqwpa5cgjfTFsi
         0UMdE5BJ/az0tkLJZkhK9SaQ+uJyWnyXETbDXxOb0SKg1WLzW3NWkpqKE0i5xn+h2M+J
         a3Tjsg331glowVh4x/HkDAYH69BxY3jtkQ8pPFSmXqvwHyb3FiBgKJfZ4VC7s596HhlG
         jqrYQ0pdYsxtRZDSOWnzyReo7UqZjaxV538kG/0JenwPXaGfTEwRshHqsqK6ZSYsIDB/
         ohQosBIdwAnDlINb1eeDpHiMDoj7FTNEk01tc3S/gXiM2IQeQyf92BBzjYfEyO51fDz/
         5x4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m72Q2LX47Fd2G4iaDSLuBTewGnVaLRCtRzAf9b4ENNs=;
        b=aVNXQMm4rSIRxmuI/aUlGXPlG3mRvEZSEQb5vUAGiBqNrJtSHw+m+Va6ON9ZI6i/eC
         1ugMqv37tNgWC2JqBFffhTWN8woLwmKoS8PiDnucStaiNFNbGEE8rFikcx5M8IK0C/cg
         qHSkqDlTn07J7cxG8uvu2bCbSAyyrmYBwB55MMLRBIl1rtbb1Xwup2S09CwJDdzCoozC
         eZuYJIUiXqGbYMbj537EQ1PgEoKV3PYL27z8yC0DgWgbanrO28W4ljrsVZLYHl+uyFL4
         cKMEmh+P+VR3+vgmrwy76pJ/mNdSWYV5NidDwOPqmyiV4S4tufPyCT0Toe2B3UACkAoo
         APsA==
X-Gm-Message-State: AO0yUKUA7IWlrpydepWLuIA6xrQI/r/v2ObNPVJiUutlQ9ZpGkctcWW0
	g+9tovGbAq6dtclKP9+4QCg=
X-Google-Smtp-Source: AK7set+mBPXWiSYdy3wx0nDD5e0+7kXz92Qx/gA/ZaSt6Z5eoQf4tVRCeVyeYwSobJBqFyJ4dHGa9Q==
X-Received: by 2002:a17:90b:1c10:b0:234:1621:3792 with SMTP id oc16-20020a17090b1c1000b0023416213792mr18669402pjb.4.1677262113689;
        Fri, 24 Feb 2023 10:08:33 -0800 (PST)
Received: from pavilion.. ([2402:e280:2146:9e0:378e:1cc3:a44a:c5ba])
        by smtp.gmail.com with ESMTPSA id mv11-20020a17090b198b00b002376d85844dsm1828612pjb.51.2023.02.24.10.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:08:33 -0800 (PST)
From: Saalim Quadri <danascape@gmail.com>
To: vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com,
	maddy@in.ibm.com,
	peterz@infradead.org,
	kjain@linux.ibm.com
Cc: Saalim Quadri <danascape@gmail.com>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH] Documentation/ABI: sysfs-bus-nvdimm: Fix sphinx warnings
Date: Fri, 24 Feb 2023 23:38:03 +0530
Message-Id: <20230224180803.21285-1-danascape@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the following warning from "make htmldocs":

Documentation/ABI/testing/sysfs-bus-nvdimm:10:
  WARNING: Unexpected indentation.

Fixes: 2bec6d9aa89c ("docs: ABI: sysfs-bus-nvdimm: Document sysfs event format entries for nvdimm pmu")

Signed-off-by: Saalim Quadri <danascape@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-nvdimm | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
index de8c5a59c77f..8564a0ff0d3e 100644
--- a/Documentation/ABI/testing/sysfs-bus-nvdimm
+++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
@@ -18,9 +18,11 @@ Description:	(RO) Attribute group to describe the magic bits
 		Each attribute under this group defines a bit range of the
 		perf_event_attr.config. Supported attribute is listed
 		below::
+
 		  event  = "config:0-4"  - event ID
 
 		For example::
+
 			ctl_res_cnt = "event=0x1"
 
 What:           /sys/bus/event_source/devices/nmemX/events
-- 
2.34.1

