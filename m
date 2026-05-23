Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2713876CA
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529449; cv=none; b=DnM4H+1zPtsMk+VzQmL+sWUh44vEcwfcGmq2lGqCUp8lqBkbGpu5ukoVa46UdZrRWI2brWCMTKfNdv/7NoPMYQ/dKUaEFa2mTpRjvVgz5kgymOvWjGC5/QvV54Czb/BG84RpJYQMUkqKTP1jJhyfmIp0bPfXQ3cOw9/+ADFGWSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529449; c=relaxed/simple;
	bh=WjyLoGSIFNUpwvHMOZu5vAsTWSXjF5U+cHQ9JDs0GLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fo3IdEyXWP/or906a06OKBfE2+w4Y7Xm1Jxp4BdslA/H4eLewXBziWIdBgXI+JU38LwGDsHJx4l7F04Y/CJCLoCxVtK6RXeBo9aVaiR7f2FdCpXpnx+6k0pVAmRWF3Zjy69lVGQonIahwLhxcGuwFG6gL4AFdErfUDxpJAQa+FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Djyc+Rvg; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Djyc+Rvg"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1329fc4bf77so2963818c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529446; x=1780134246; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zm5D4zZV0MwCvac4jjfgUUR1LIZ7RrjaKcvPmfxl/f8=;
        b=Djyc+RvgdyvnhMHewBvlep95z+Rzm0JD5R5ry/R3rX+t4hTqmV0g2FszdayZAih451
         xg2l42ycrdCCmlbEfb8vq9JQltYYX1wszVqDBMYQL4mtlIZ4b2ufAGCBYKKVYBe77CAo
         hK8eq3lrRNqB8Xn3ySyUoLBzCJTKetgL1iNIRMsfA215sUxRsgaBF0A9FCeNRzs4771I
         oxvrMhN48Znck0iUZd7Ud5VIbSQ9BIcmYkX90VGWTspfiR0VvJkC+CLwBBypyHCKiU9Y
         LXD8GyFM0XkmLoSCEVJ6u2kG51VtN9Ink2tXH7GS7hQJ/S3sRwxaLU12pElLLn4ju2kD
         2iYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529446; x=1780134246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zm5D4zZV0MwCvac4jjfgUUR1LIZ7RrjaKcvPmfxl/f8=;
        b=fFP3pEMeyiOwgC29q2vdDUUZsnTSfY2nlTerpbDAuEwzm2sPACPzk3sLa2PxkXlN3+
         HvgU2d6Tavp2gSlespUs+ygkq5O+EDW5wIiB/cv19F3gU1VEHo0EAken81h71Zom9rmm
         ACDF4VOr4+6MoN9wr7Dg93pI8bAmDZngTQrvnoQabYL/eSP5I++sa+05UFaUhRDc6o/b
         zzLqGyP5UI9lF2cfmcJgJdV/Mraeo+s1tBWHe358Z+6nQSGJ5uMJ/dhjLPCbAsBV5BQi
         yvqvVTEYtN6hyIza7g0QZZUelJvM+mp58MiV7SW6qRpxRWxFNZBgk9XVhMS98peUGbDt
         1XXw==
X-Gm-Message-State: AOJu0Yw25TJHPv1aUrgNLkJ9vuVeR27jn5s8YIWGxhSyiVaaWDlBgDb6
	Yph8mvGvTrMn3+CNFtwVH3MFvVZxDokXX6OBUcBFQGSuZGpBK2V1w8r3
X-Gm-Gg: Acq92OHSyYlRpK5sjVq0ODERNU8YGPljnZea+P91I/OXlj7ozBS2qbyTmMN60xiR+WW
	frqw5mKP2vKx5eTLRR0uxC7YjC99wDVSUgf1tfxkjv7uCPBnc43ZJpUT5sc0N7OcrmYAiF28Y5q
	wXdDGihF7Av0iuaTZdm8/6VHWP4QMI9+4lragSs/CV3aHki7emmWy7QaNNYgV43dB/qgFJrlViK
	uktcVgeKGPZah/ZrQvGYOY8TQwwiCI3t+UdErYz96woNF2Q3preeQvLt9IQ1N4TAHpmClbzw0xZ
	ha2BEbA+ZcNCR3wj9OAtFOYFHRZ+2O3nZUs8f+5mqllqxeKvkbojKXctX1XxqMfnULPcUcmirb7
	lJ6NR2f6nbVWWWAbvDLj5REGISOu18a0msmvyJ5vVO/TU0nqFQ8OewWhCeQjfqKztKdYNL+HgfL
	CxuGtJtxRjLt0+aefW8OwnRNvIwtd54+TitmileWrPTRPyhfs3wdKdZSleRHq8wcxBWFo8hWJzH
	1n6d4vN9pLon4Gdtw==
X-Received: by 2002:a05:7022:1286:b0:11a:e426:911a with SMTP id a92af1059eb24-1365f821ccbmr3116310c88.15.1779529446232;
        Sat, 23 May 2026 02:44:06 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:05 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 15/31] cxl/mem: Drop misaligned DCD extent groups
Date: Sat, 23 May 2026 02:43:09 -0700
Message-ID: <60e23199f7ef7dd3008bb3275c40d242334275c9.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add an alignment gate to cxl_add_pending(): every extent in a tag group
must have its start_dpa and length aligned to CXL_DCD_EXTENT_ALIGN (SZ_2M,
the minimum device-dax mapping granularity on every architecture that
enables CXL DCD).  A misaligned extent makes the resulting dax device
unusable, so drop the whole group rather than accept a partial allocation
that would surface a broken dax_resource.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Groves <John@Groves.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: split out as a separate validation step]
---
 drivers/cxl/core/mbox.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index e5edc3975e8f..421bd716a273 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -7,6 +7,7 @@
 #include <linux/unaligned.h>
 #include <linux/list.h>
 #include <linux/list_sort.h>
+#include <linux/sizes.h>
 #include <cxlpci.h>
 #include <cxlmem.h>
 #include <cxl.h>
@@ -1280,6 +1281,24 @@ static int add_to_pending_list(struct list_head *pending_list,
 	return 0;
 }
 
+/*
+ * Device-dax requires extent boundaries aligned to its mapping granularity.
+ * Use SZ_2M as a conservative default; a tighter check that queries the
+ * cxl_dax_region / cxl_endpoint_decoder for its actual alignment would be
+ * strictly more correct, but SZ_2M is the minimum device-dax supports on
+ * every architecture that enables CXL DCD today.
+ */
+#define CXL_DCD_EXTENT_ALIGN	SZ_2M
+
+static bool cxl_extent_dcd_aligned(const struct cxl_extent *extent)
+{
+	u64 start = le64_to_cpu(extent->start_dpa);
+	u64 len = le64_to_cpu(extent->length);
+
+	return IS_ALIGNED(start, CXL_DCD_EXTENT_ALIGN) &&
+	       IS_ALIGNED(len, CXL_DCD_EXTENT_ALIGN);
+}
+
 /*
  * Compare two extents by shared_extn_seq (ascending).  list_sort is
  * stable so when shared_extn_seq is 0 for every entry (non-sharable
@@ -1352,6 +1371,26 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
 		extract_tag_group(pending, &tag, &group);
 		list_sort(NULL, &group, extent_seq_compare);
 
+		/* Alignment gate — abort the group if any member fails */
+		bool aligned = true;
+		list_for_each_entry(pos, &group, list) {
+			if (!cxl_extent_dcd_aligned(pos->extent)) {
+				dev_warn(dev,
+					 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %u-aligned\n",
+					 &tag,
+					 le64_to_cpu(pos->extent->start_dpa),
+					 le64_to_cpu(pos->extent->length),
+					 CXL_DCD_EXTENT_ALIGN);
+				aligned = false;
+				break;
+			}
+		}
+		if (!aligned) {
+			list_for_each_entry_safe(pos, tmp, &group, list)
+				delete_extent_node(pos);
+			continue;
+		}
+
 		u16 logical_seq = 1;
 		list_for_each_entry_safe(pos, tmp, &group, list) {
 			u16 raw = le16_to_cpu(pos->extent->shared_extn_seq);
-- 
2.43.0

