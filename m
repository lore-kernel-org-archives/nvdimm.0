Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074E397AF2
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 12:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778590756; cv=none; b=hCqbBSHsw8EpmrVLkjh0/pNE4O/VcPcv4GgA6ubIZd3kZAGCpqKgnh585Z8P4BdIgvJJVRxZFf6tqeNA8f9TCMTavGTWyV/GogJuDPPQKMSx2UbgtKQYK6xtm5dZvCozUUishftiqOUwJNuVW5pXdsritAcL5Zq9bvulAlmx6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778590756; c=relaxed/simple;
	bh=8k/X+GBcN3HecsH9d0ZY/G38JCz9EdOaVsc9Cwpw0Tw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pbBY4UDtL5ww+ncZsTwUzoY2cnBm6QJqporV1DezObxNEBxCySMnJRbG6MZCo9/NOs+y1UU8ZCPwt9jfkMOoY9rraMrlpxTcieVhxCYLbdsrM9feLuG/wnYQq8PO9RwtEaqe4KL0JiG6lUOoS9WxiM7+CgaKCdR1/obGwaFopHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=MAJLciFG; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="MAJLciFG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1778590755; x=1810126755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8k/X+GBcN3HecsH9d0ZY/G38JCz9EdOaVsc9Cwpw0Tw=;
  b=MAJLciFGlFvZ0C3jucCPpQToQJQweZhlQ1euG9PG22OZg7U+CixL0YIW
   s/sKsg9HmIztMnYfztnqZmG8F6UVNdFJ3LVhExOWf6hn0YqJYVv1pw/7u
   JchoAdTg2bQHXOZ5m0q22xUe4zE5rPrbZaZIIQU5PP1PFJ9/LW2FZtQ92
   EaXBBveEEN3rvrZ3X89bbTusGqJ+ysc5diTFO8uthMI63rsAYK2xrY4kO
   Ms+OGa/wtUe9AV1BdovVCfK09m/gkgLrF8ZCzVXmljBVRweg6GwjBecgs
   3mg677lA8LtKkdGTLy8MN6jW5lm251xQtU7iOJoukIWfMSIcJ6tHZXpBt
   Q==;
X-CSE-ConnectionGUID: qeRRgXx6SrK2gPblVSeqJg==
X-CSE-MsgGUID: rXe9IW/9SgC3Xi4y2XY07A==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="240098627"
X-IronPort-AV: E=Sophos;i="6.23,230,1770562800"; 
   d="scan'208";a="240098627"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 21:58:05 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 33D988200B1
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 12:58:05 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (az2uksmom1.o.css.fujitsu.com [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id DFC9A1400367
	for <nvdimm@lists.linux.dev>; Tue, 12 May 2026 12:58:04 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 88AB01800A41;
	Tue, 12 May 2026 12:58:03 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id D3033608BB;
	Tue, 12 May 2026 14:58:02 +0200 (CEST)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: tomasz.wolski@fujitsu.com
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
	smita.koralahallichannabasappa@amd.com,
	terry.bowman@amd.com,
	vishal.l.verma@intel.com,
	willy@infradead.org,
	yaoxt.fnst@fujitsu.com,
	yazen.ghannam@amd.com
Subject: Re: [PATCH v8 0/9] dax/hmem, cxl: Coordinate Soft Reserved handling with CXL and HMEM
Date: Tue, 12 May 2026 14:57:59 +0200
Message-Id: <20260512125759.30007-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20260416224618.12987-1-tomasz.wolski@fujitsu.com>
References: <20260416224618.12987-1-tomasz.wolski@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Smita,

Do you plan to address the remaining minor comments from Dan and Jonathan in the next revision?
https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
https://lore.kernel.org/linux-cxl/20260323181331.000018f2@huawei.com/

Best regards,
Tomasz
