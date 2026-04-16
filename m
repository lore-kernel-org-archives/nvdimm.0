Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB683330644
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776379663; cv=none; b=AdDqyaQDPN9ngraMWBe1rbht05DEvSkn7np6t301cXiSRm30Rb88q00HWlXwFwllRyDhNK1BDGLFNtm/s2CEN2CdB82ULiUl3n8U0FaP+2k10Vk7aT2IZOzHlJ5QGxUc9iGA/mRlxWoBqtOZs2SPNXqfMB24ut437k9FNsfE5ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776379663; c=relaxed/simple;
	bh=C13Jb6Kbsy+FPShsH2lJidLemQxpasQcKiM9wp8dEYY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sN9sadzSR/e0TpQe/Jy6yDvbTfVDeWVxVVwFWqSQ8h7mbeY2TXuuKaIds09DfaMfE2WUwdOTZAZDsoC3NI87RJDVs8deJRWEnsjU/qDVPyWsAAnfvijH2rG1OdjA/crjhXHj3I42dDNYct5n057WSWcEU3PyhEY+/rEUxkaiI7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=HSPfyUfR; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HSPfyUfR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1776379660; x=1807915660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C13Jb6Kbsy+FPShsH2lJidLemQxpasQcKiM9wp8dEYY=;
  b=HSPfyUfRPyP+CnL3iAoWfhQTsEI1x3uxzm9/SPB5amErqdz0aEVzQ7/b
   Bjp+QCrNqOqkkySpqLbuEW3HdrMbSsZ8XCL1SDqMS0hi3SmKW8V5Z19Ek
   gDMlqsyOrxVLXb8AM9OYZATODgvYbh3azzPd3XfuV2zcpx3mi2mSSFFQl
   d945oNMM0nkoJ1P6TLTuMiGkLlzLAkqu+l9uv+9bP2H+iuCnLhrA9d/3K
   0rvIaBVfLzsq/C5jn/QwZjLHhv4ghk8hQhPp1oi1e59LWkshJnRR78Yxg
   aAXlMWxtcMezZWOZ6/q7lU+AJEv6vl/xEopw2aychsIxALSYMKS8Yza9D
   g==;
X-CSE-ConnectionGUID: m2hCuh+ySYmo0Hqv/63lfQ==
X-CSE-MsgGUID: KpjvPjfYTuC++L9a5UGgRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="236687115"
X-IronPort-AV: E=Sophos;i="6.23,183,1770562800"; 
   d="scan'208";a="236687115"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 07:46:30 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 60E2E1002804
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 22:46:31 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (az2nlsmom3.o.css.fujitsu.com [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 172D7861274
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 22:46:31 +0000 (UTC)
Received: from ubuntudhcp (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTPS id 7B4CE1019066;
	Thu, 16 Apr 2026 22:46:29 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by ubuntudhcp (Postfix) with ESMTP id 1BAD8220477;
	Thu, 16 Apr 2026 22:46:28 +0000 (UTC)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: smita.koralahallichannabasappa@amd.com
Cc: alison.schofield@intel.com,
	ardb@kernel.org,
	benjamin.cheatham@amd.com,
	bp@alien8.de,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	dave@stgolabs.net,
	gregkh@linuxfoundation.org,
	huang.ying.caritas@gmail.com,
	ira.weiny@intel.com,
	jack@suse.cz,
	jeff.johnson@oss.qualcomm.com,
	jonathan.cameron@huawei.com,
	len.brown@intel.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	lizhijian@fujitsu.com,
	ming.li@zohomail.com,
	nathan.fontenot@amd.com,
	nvdimm@lists.linux.dev,
	pavel@kernel.org,
	peterz@infradead.org,
	rafael@kernel.org,
	rrichter@amd.com,
	terry.bowman@amd.com,
	tomasz.wolski@fujitsu.com,
	vishal.l.verma@intel.com,
	willy@infradead.org,
	yaoxt.fnst@fujitsu.com,
	yazen.ghannam@amd.com
Subject: [PATCH v8 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling with CXL and HMEM
Date: Fri, 17 Apr 2026 00:46:18 +0200
Message-Id: <20260416224618.12987-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Smita,

Tested on QEMU and physical setups - it worked as expected
(had to disable ACPI_PRMT/CONFIG_CXL_ATL on our physical system though)

Best regards,
Tomasz

Tested-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
