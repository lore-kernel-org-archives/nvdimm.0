Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [5.45.199.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635C910F7
	for <nvdimm@lists.linux.dev>; Thu, 29 Sep 2022 07:34:41 +0000 (UTC)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:152e:0:640:f06c:35e6])
	by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id AC1092E0C4C;
	Thu, 29 Sep 2022 10:33:02 +0300 (MSK)
Received: from rvkaganb.yandex-team.ru (unknown [2a02:6b8:b081:8926::1:2a])
	by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id XPGRNAjGld-X0Pm1BYw;
	Thu, 29 Sep 2022 10:33:01 +0300
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(Client certificate not present)
Precedence: bulk
List-Unsubscribe: <https://ml.yandex-team.ru/lists/yc-core@yandex-team.ru/unsubscribe-click>
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1664436781; bh=QoOhqaA5P1eQp/lRTTQuWEea61CW+o2WukoZbojWlVE=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=w378qm718kVOKrNzYEkHn2J++0VIqQF73/5lyvrStUfhyvRfDcfu2j/sXDRMEq/y1
	 odxFS5wpU71BuKzVRvsX+Y9SeGAAwbWtctQIKUA5dda3whsMsG6rachxsgCpPPsiO0
	 1tksynsq5lEGFXkA89/TWSaFCWIs+F9Jneb2/5cg=
Authentication-Results: iva4-f06c35e68a0a.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Roman Kagan <rvkagan@yandex-team.ru>
To: nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	linux-kernel@vger.kernel.org,
	yc-core@yandex-team.ru,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] drivers/nvdimm/e820: turn off write cache by default
Date: Thu, 29 Sep 2022 13:32:59 +0600
Message-Id: <20220929073259.582822-1-rvkagan@yandex-team.ru>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When regular DRAM is registered for use as PMEM via "memmap" command
line parameter, there's no write cache in front of the backing store of
this PMEM (as there's no backing store itself), so there's no point
doing expensive cache flush on sync etc.

Mark the regions being registered with e820 as ND_REGION_PERSIST_CACHE
so that write cache is off by default for the respective DAX devices.
This also matches the assumed behavior of the flag
ND_REGION_PERSIST_CACHE:

  Platform ensures entire CPU store data path is flushed to pmem on
  system power loss.

for the only usecase where such regions actually kind of persist the
data -- across kexec.

Signed-off-by: Roman Kagan <rvkagan@yandex-team.ru>
---
 drivers/nvdimm/e820.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 4cd18be9d0e9..3af63b7b6d23 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -28,6 +28,7 @@ static int e820_register_one(struct resource *res, void *data)
 	ndr_desc.numa_node = numa_map_to_online_node(nid);
 	ndr_desc.target_node = nid;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+	set_bit(ND_REGION_PERSIST_CACHE, &ndr_desc.flags);
 	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
 		return -ENXIO;
 	return 0;
-- 
2.37.3

