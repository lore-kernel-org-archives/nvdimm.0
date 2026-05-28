Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5831A807
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 06:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779950486; cv=none; b=JD78AaLpL8o57gb4jYn7psvMDoxyZapqTDSajLU6RVcC7x0OHxPPybQmGQnFp6RcoCTFAsiv+gSiwpjIHQ4SEBDBmygr9CIAEs1FqhUFpWK350szUlv/xnn3oV+A1xbmsiUmUIxLYy+b0XaqgI8Z2lPbTZh6hKMUyzS9hrMAcRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779950486; c=relaxed/simple;
	bh=Dzq99QaUsF9Zc98cd/Hd2hOxwzORJWSrqkCmv+Cz4vg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZOYvdeqrkOodb/sdnpn+go4K806rY9urHP8ufJ9bKM5wmUVng9i20dsMY873INKu+TddCQKMha5yJrHeMRPWckEYo5DwkCJBkW0P6lHIpIGXroMKKLTCTxW+JTI9nCIGeE6VUpkQ2z9/6ijCLo+b84KEoCKjMcxCButBySfwXK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=oqaGV0xo; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="oqaGV0xo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779950484; x=1811486484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dzq99QaUsF9Zc98cd/Hd2hOxwzORJWSrqkCmv+Cz4vg=;
  b=oqaGV0xoRx5Ebi6iikHAETrlsjfBMgztRue2jLFY0HFxnRS/JC6mGf0X
   gjGrx7BescoV6lPuRJA+k/jGvlfO/7B10hKVirC7KRwG3yQIKi1bbR3tl
   JP1jWRSk5wvu0K0475V64vNFZaPGltIyO7pma6B5KIUR6QOXE80+Z/0aE
   3mI0nYScUST8c2PZoTbRGsbdqaSVx3MCf6FdycNP51Tf3+njCpUdaTtSV
   B6y7+QfWKotU4mOIPWFeSKWR/dP9eBl41UpfW0fbtHV14SDGN24ti9Ust
   mPBPZkGXlyRwBdRSp9Kt3KW4icSDiLqu7zpfy++3VyQJam+4PpYVXwocr
   g==;
X-CSE-ConnectionGUID: 4XlaTu8vTyyhKjNDfx9XNw==
X-CSE-MsgGUID: zXX3mhdPQieCPMc/wsWQRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="221042641"
X-IronPort-AV: E=Sophos;i="6.24,172,1774278000"; 
   d="scan'208";a="221042641"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:40:14 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 019DA407579
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 06:40:14 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 9DD80197F0E8
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 06:40:13 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom2.o.css.fujitsu.com (Postfix) with ESMTPS id A9AF61400123;
	Thu, 28 May 2026 06:40:12 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id 4E39060A0E;
	Thu, 28 May 2026 08:40:12 +0200 (CEST)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: alison.schofield@intel.com
Cc: ardb@kernel.org,
	benjamin.cheatham@amd.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	djbw@kernel.org,
	icheng@nvidia.com,
	jonathan.cameron@huawei.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	nvdimm@lists.linux.dev,
	smita.koralahallichannabasappa@amd.com,
	tomasz.wolski@fujitsu.com
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
Date: Thu, 28 May 2026 08:40:02 +0200
Message-Id: <20260528064002.21542-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <ahc7h8zMaTW2XUMU@aschofie-mobl2.lan>
References: <ahc7h8zMaTW2XUMU@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> Hi Tomasz,
>>
>> As the person who caused the churn, I sympathize w you, but
>> as the person who will likely merge this, please send a v3 that
>> removes the Fixes tag, which was the other change in v2.
>>
>> It'll keep the history cleaner.
>>
>> Thanks!
>> Alison

Hello Alison,

No problem, I will post v3 :)

Best regards,
Tomasz

