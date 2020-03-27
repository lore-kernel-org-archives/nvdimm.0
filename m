Return-Path: <SRS0=ElX1=5M=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837C5C43331
	for <linux-nvdimm@archiver.kernel.org>; Fri, 27 Mar 2020 07:12:41 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 58FA920714
	for <linux-nvdimm@archiver.kernel.org>; Fri, 27 Mar 2020 07:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="ZprMO5g5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58FA920714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=d-silva.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D09B210FC3BCE;
	Fri, 27 Mar 2020 00:13:18 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=66.55.73.32; helo=ushosting.nmnhosting.com; envelope-from=alastair@d-silva.org; receiver=<UNKNOWN> 
Received: from ushosting.nmnhosting.com (ushosting.nmnhosting.com [66.55.73.32])
	by ml01.01.org (Postfix) with ESMTP id 6D6CF10FC36EE
	for <linux-nvdimm@lists.01.org>; Fri, 27 Mar 2020 00:13:12 -0700 (PDT)
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
	by ushosting.nmnhosting.com (Postfix) with ESMTPS id 9F2462DC6831;
	Fri, 27 Mar 2020 18:12:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
	s=201810a; t=1585293142;
	bh=HPdDJ0enxYWuoioAjwzepK5FMG95uTKM1kU7cOk1haY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZprMO5g5LCg0oRdH2K3uXz8l4c6L9W1d9Mxd3y9LbAARGZu9kt6uIz9A3MEUOedWV
	 g7DqMLDrr2m/TH6d6yrJtFgEOg9BlrSv1R2NLozkVnU6OkgsrVmJx9BBn8aI/Sn62O
	 w/5CiI+YX0ODTMBr8YVhJA07fuOcUVGHda3b5a9mGukeXcANsMAjZc4Gg4MUBM/PoJ
	 Jnr9+eXE1sX7vtXdpSE1woIPFaLHakSy5NHhRbC+k3KhNv5RH6TZ6A/u+iDAiiRCE5
	 N06lRZtlEVFMlb5wR4Jid5B9ENUsU6ZZPEVYF/txRgiW4MKAS+CcjtkONcUOSmYaD9
	 ppYmaM2ef6S8tshDUjxJypHcy1+sz3bZZrRF+2nIuWjpwN2hZGDxRVKHsZfKZhVqQF
	 sblZp70rrN6e/kpXRz/acmkv2yO8Fa77dlC3P84DeB/nV2oDsJDuyI07z13vZ/Bmuj
	 o26AIi8KDpxo1HfGM10O/KoPFg3TtC7iqbL2WVTgVmat/MkiiY9qOLW8neZfNnPbUY
	 Yfawn1JU84te5v7VgBv+fKxvfyGbsXV1RLhC09q4r5qhGolccVrWWCbRAXVplfwLiE
	 ko6h2lMIzDuDXQc0NNcn6PH9aJ9muG0dIOvlWkH8pN4W1vzD3LNkEswpP0E7Hqf3M9
	 jksprRXa8oR2y8sUhkAlZwgY=
Received: from localhost.lan ([10.0.1.179])
	by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTP id 02R7C4Ab045934;
	Fri, 27 Mar 2020 18:12:14 +1100 (AEDT)
	(envelope-from alastair@d-silva.org)
From: "Alastair D'Silva" <alastair@d-silva.org>
To: alastair@d-silva.org
Subject: [PATCH v4 02/25] mm/memory_hotplug: Allow check_hotplug_memory_addressable to be called from drivers
Date: Fri, 27 Mar 2020 18:11:39 +1100
Message-Id: <20200327071202.2159885-3-alastair@d-silva.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327071202.2159885-1-alastair@d-silva.org>
References: <20200327071202.2159885-1-alastair@d-silva.org>
MIME-Version: 1.0
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Fri, 27 Mar 2020 18:12:14 +1100 (AEDT)
Message-ID-Hash: XTPP6VGPMVPOIHEPPTG4NZGOMO6ZRAH2
X-Message-ID-Hash: XTPP6VGPMVPOIHEPPTG4NZGOMO6ZRAH2
X-MailFrom: alastair@d-silva.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Anton Blanchard <anton@ozlabs.org>, Krzysztof Kozlowski <krzk@kernel.org>, Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>, Madhavan Srinivasan <maddy@linux.vnet.ibm.com>, =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>, Anju T Sudhakar <anju@linux.vnet.ibm.com>, Hari Bathini <hbathini@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Greg Kurz <groug@kaod.org>, Nicholas Piggin <npiggin@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexey Kardashevskiy <aik@ozlabs.r
 u>, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XTPP6VGPMVPOIHEPPTG4NZGOMO6ZRAH2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When setting up OpenCAPI connected persistent memory, the range check may
not be performed until quite late (or perhaps not at all, if the user does
not establish a DAX device).

This patch makes the range check callable so we can perform the check while
probing the OpenCAPI Persistent Memory device.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 include/linux/memory_hotplug.h | 5 +++++
 mm/memory_hotplug.c            | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f4d59155f3d4..9a19ae0d7e31 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -337,6 +337,11 @@ static inline void __remove_memory(int nid, u64 start, u64 size) {}
 extern void set_zone_contiguous(struct zone *zone);
 extern void clear_zone_contiguous(struct zone *zone);
 
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+int check_hotplug_memory_addressable(unsigned long pfn,
+				     unsigned long nr_pages);
+#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
+
 extern void __ref free_area_init_core_hotplug(int nid);
 extern int __add_memory(int nid, u64 start, u64 size);
 extern int add_memory(int nid, u64 start, u64 size);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0a54ffac8c68..14945f033594 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -276,8 +276,8 @@ static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
 	return 0;
 }
 
-static int check_hotplug_memory_addressable(unsigned long pfn,
-					    unsigned long nr_pages)
+int check_hotplug_memory_addressable(unsigned long pfn,
+				     unsigned long nr_pages)
 {
 	const u64 max_addr = PFN_PHYS(pfn + nr_pages) - 1;
 
-- 
2.24.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
