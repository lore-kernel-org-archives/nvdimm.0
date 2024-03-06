Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E986960262
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709720960; cv=none; b=afsEEvIlFBjyLD2CP5I4Y8aTEPvRN6BDr8fsgrkaGk/Ap4n1nDAiYXfgsAvdK0yKxn+GJXSkFWt4fb1yzjTB2OpRaNtsc20O6YbLvoT2NOSiYNoL1H2PhW+uGmeRozlDiCy/mbt1/ILZyM7feU4Wio+6RM6eGtdeJv6ZMrFdF+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709720960; c=relaxed/simple;
	bh=XdN3aG00u/QsuyGD6b2X8W2/qtDpU1h/uB9UBsmVuQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mfJA4VBB3nM8O5xdmj+/MI3s+wKc5TROOn4rx3AVjkxjDYnmycH9FIZ+W5AkizYy5rBXuntxX/kMZRvAtoc0LjHYgD9mrAh/XEKhIayL5CPuURCEc55xmATBqIJrTu/y0kl+ErI1bISoCUkfxYpN26Nds/arGzEclTEzgTsLrcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=D8olPbgM; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="D8olPbgM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709720958; x=1741256958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XdN3aG00u/QsuyGD6b2X8W2/qtDpU1h/uB9UBsmVuQc=;
  b=D8olPbgMSPhINkwiQSpfLpO/MdhvR8OAA2heUs4lMMgNSaWDZDAaKrBs
   uuIS1xXN7EANMwngfKrRf9Nl9psk1BKF0310GFfwzJOgVb3F9tOyH9Re0
   SWCApwMV9eMFH4xyJEvdkfAKHAK2qmt50hn0ERFc4JYpDJRqotrkG/lij
   JJwYjjohgnV3vDiQBksVDl2sD0kkHKh8qxWkVInqrAMy59e3bYDkU++H0
   65m28OGSzdfW3JgzWfKUsQweykkav9LiSHEmES8n4yRPlUdooQd9aDMyG
   iUAWrLZ1vRbRdgao6h6FaXlHwkwNavvwG3r8WPnBqlN4ImfNSfItqVh03
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="153205397"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="153205397"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:16 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id ACC009D91F
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:11 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id E27CDFDA06
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:10 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 69C36202CB587
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:10 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 782981A006D;
	Wed,  6 Mar 2024 18:29:09 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: y-goto@fujitsu.com,
	Alison Schofield <alison.schofield@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	hpa@zytor.com,
	Ingo Molnar <mingo@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-cxl@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	x86@kernel.org,
	kexec@lists.infradead.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v3 5/7] resource: Introduce walk device_backed_vmemmap res() helper
Date: Wed,  6 Mar 2024 18:28:44 +0800
Message-Id: <20240306102846.1020868-6-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240306102846.1020868-1-lizhijian@fujitsu.com>
References: <20240306102846.1020868-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28234.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28234.006
X-TMASE-Result: 10--2.753200-10.000000
X-TMASE-MatchedRID: VGeBglENKylzKOD0ULzeCRFbgtHjUWLyPeYVUCg2LRwBLwIiWDU8ay15
	IFUNL+ETjx5X3FdI4UDmn3xyPJAJoh2P280ZiGmRcFEiuPxHjsXDCscXmnDN79P7VmP7Drr66us
	OKvlQZawRYCju0yIRX4Ay6p60ZV62Mhe627A+8aHdB/CxWTRRu+rAZ8KTspSzZ9zg/iRwE4LkAQ
	bstzNuLM5Iu+GqAiaI4D/GW2/5ILcxeNB9x03X8fQFNK0GDkNxsoGRy2pyHXLNTBw2qqp0+A7H6
	7Vl1o7oIcmnZRhVxyrE4HwnSlEuHInEpJmLAFfpC1FNc6oqYVV+3BndfXUhXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It walks resources registered with flags
(IORESOURCE_DEVICE_BACKED_VMEMMAP | IORESOURCE_BUSY), usually used by
device backed vmemmap region. currently, it only sticks to the
persistent memory type since it is only one user.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Baoquan He <bhe@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alison Schofield <alison.schofield@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 include/linux/ioport.h |  3 +++
 kernel/resource.c      | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 3b59e924f531..10a60227d6c2 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -332,6 +332,9 @@ extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
 		    int (*func)(struct resource *, void *));
 extern int
+walk_device_backed_vmemmap_res(u64 start, u64 end, void *arg,
+			       int (*func)(struct resource *, void *));
+extern int
 walk_system_ram_res_rev(u64 start, u64 end, void *arg,
 			int (*func)(struct resource *, void *));
 extern int
diff --git a/kernel/resource.c b/kernel/resource.c
index fcbca39dbc45..5f484266af07 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -431,6 +431,19 @@ int walk_system_ram_res(u64 start, u64 end, void *arg,
 				     func);
 }
 
+/*
+ * This function calls the @func callback against all memory ranges, which
+ * are ranges marked as (IORESOURCE_DEVICE_BACKED_VMEMMAP | IORESOURCE_BUSY)
+ * and IORES_DESC_PERSISTENT_MEMORY.
+ */
+int walk_device_backed_vmemmap_res(u64 start, u64 end, void *arg,
+			int (*func)(struct resource *, void *))
+{
+	return __walk_iomem_res_desc(start, end,
+			IORESOURCE_DEVICE_BACKED_VMEMMAP | IORESOURCE_BUSY,
+			IORES_DESC_PERSISTENT_MEMORY, arg, func);
+}
+
 /*
  * This function, being a variant of walk_system_ram_res(), calls the @func
  * callback against all memory ranges of type System RAM which are marked as
-- 
2.29.2

