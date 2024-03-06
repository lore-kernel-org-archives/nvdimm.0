Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB260BBB
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.37.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709721032; cv=none; b=D/HFYWqnLbXrMnlPO3uU5L0ylyFm7j6oWnCHLDodkgPfrL7R5JUAp14jPLQFs3FOs0doQavwUcOzwTBzQCbNiJbuU3yCrN6ga6ykXCc0As7NK4O37Kx82DCHHCCkoeD7zKbSPA4BsinMfENHhzl1ip8pTFY6ATmQxbc5IgA0Pgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709721032; c=relaxed/simple;
	bh=Nq7SMqNBqa42A9Gw9it0V4iEBEk255GCXGK0EU8r0Nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ILO4zbjo8+ylHnZpeZ6S47AJZv5b5jmXjzwAhGyFl7aTOJo84iRvU8NUdCr6PAoMtgUNXgKSRKF2cGPJHRPV7fUF8vWbP7Pyq5Q2U3XJj7uxa59M9JiinFCKk85vOtz5Rznwlwe3apPdYM01zD0RddafFV6/tcXJ9pV0xBC7IVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=XCRrjxiS; arc=none smtp.client-ip=139.138.37.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="XCRrjxiS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709721030; x=1741257030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nq7SMqNBqa42A9Gw9it0V4iEBEk255GCXGK0EU8r0Nc=;
  b=XCRrjxiSIeXxmUi3QHdV1aE4qlSYSjWA75CQ1Vi31I/GoCQ/ICrGVgDH
   9uBUq5xVMehxqCw7wlF7kU837CdTnkm5tlcMfSFofk4Ji2oTY28LJk8Jl
   493ptmBiczT/tF4ugAXzIuGdCj4Uh5JDFT/VKDtzGB1BdNH1iNWea1qk/
   XGmu71VonYPL5T0vWWEiD7a69k4S8JMmejPyGz04bnNUh6m8rzWZgzWvW
   OdEmcQ9ddOAdfbVgiwDlDxy5rD7dFZRze7Bkk2RGGWbez1Ft0YNIEE8jH
   6JaPsWxIWf6KCxElEN4gxMrS0lVEVNZAUxIN4EGdkYbepPascXCJSe5cU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="130699037"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="130699037"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:17 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id DF814A31CE
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:12 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 224D4D5E8C
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:12 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 421402030C7E9
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:11 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 4A1AE1A006A;
	Wed,  6 Mar 2024 18:29:10 +0800 (CST)
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
Subject: [PATCH v3 6/7] x86/crash: make device backed vmemmap dumpable for kexec_file_load
Date: Wed,  6 Mar 2024 18:28:45 +0800
Message-Id: <20240306102846.1020868-7-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--8.255800-10.000000
X-TMASE-MatchedRID: Eprm7pA/VZ5ZxhI5bGrNsjiEPRj9j9rvSdIdCi8Ba4AiqRodPpseIRwE
	EIVsM/kp/lneBjailE5V00+whwxVQy/7QU2czuUNA9lly13c/gH4uJ1REX4MHbs3Yh2IOCYzJti
	zbkLGoS92PULLZTziuytFAV6Sdl32oFf+7ciBzQpYKMMlFh4BncnlJe2gk8vIMzT8XBPSpdajxY
	yRBa/qJXcsDK2xBHh7jaPj0W1qn0Q7AFczfjr/7LEnb/1qBW++QLtrZDNFv46p+VAyfOE7vP5i9
	RGEpFvIT2g+olvABKw=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Add resources with specific flags to PT_LOADs of the elfcorehdr so that
these resources can be dumpable. This change is for kexec_file_load(2)
while kexec_load(2) setups the PT_LOADs according to its parameters
by the callers which usually rely on resources' name from /proc/iomem

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Baoquan He <bhe@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 arch/x86/kernel/crash.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index b6b044356f1b..b8426fedd2cd 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -146,6 +146,8 @@ static struct crash_mem *fill_up_crash_elf_data(void)
 	if (!nr_ranges)
 		return NULL;
 
+	walk_device_backed_vmemmap_res(0, -1, &nr_ranges,
+				       get_nr_ram_ranges_callback);
 	/*
 	 * Exclusion of crash region and/or crashk_low_res may cause
 	 * another range split. So add extra two slots here.
@@ -212,6 +214,9 @@ static int prepare_elf_headers(void **addr, unsigned long *sz,
 	if (ret)
 		goto out;
 
+	walk_device_backed_vmemmap_res(0, -1, cmem,
+				       prepare_elf64_ram_headers_callback);
+
 	/* Exclude unwanted mem ranges */
 	ret = elf_header_exclude_ranges(cmem);
 	if (ret)
-- 
2.29.2

