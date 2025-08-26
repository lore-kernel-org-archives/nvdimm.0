Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E717B505;
	Tue, 26 Aug 2025 08:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756195477; cv=none; b=PNZPTuEonK6+OdOsq7sRApoT9/HiWSDfG5Y+r9kD9mTZA1+u9sfM/CzpecSdkdngW58g5poBYY/jCyuClLCHNSQhmlZ4Ul/tdaopGTfIpwRxOTOAxEvUnW+hP/D3XApWcII5GFKAEQ1vEXNT/iEwR1NPma2mY7Klnu5FdJXyNss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756195477; c=relaxed/simple;
	bh=shoTu+esopqHIc6P+YdSoFst4Go48ioz876/HXAmgCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZG3pT83N1XxqerJbZ6lcKSG1upYnH+QQqsVFnC0kYpTQ+yyjbEX85DYB1YH4wLqwqanWhgGHhcaKw2u4eJG3B03+Nn0kkdFz02ApgfiW/wU5A2nYl7qOQepI+8c24VPfk2H/iRiebF3qp1+BxR0lJFJLbhZf/2jcnoORWMKgv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhKh074v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhKh074v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72955C4CEF1;
	Tue, 26 Aug 2025 08:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756195477;
	bh=shoTu+esopqHIc6P+YdSoFst4Go48ioz876/HXAmgCs=;
	h=From:To:Cc:Subject:Date:From;
	b=HhKh074vWgwojZ1OU3U3JsJHephQ6IKUWPCFUxk9rB9B6AJF8T/Cf1smTLhmw1mgd
	 BgSpwLrEtLDd3wpkb9UaDvHBo5SDgzo9r+nP2wOeqxsjGbFfZDBzxizlmx3uHXK8yP
	 Zo0b3XCVkxdSDMSiUlPdYj/esCWsIQlB6X7tDVyuGVj9Jq/8JqK4RFjO/s2wOC06cu
	 V4l9izTb5mAuX/BHqxpV8QjpSyy8Z3MRffuFLqDwU/sidX2575YrZYgQG7CMjum+4w
	 tCgO65R2y1pwB3oWK4hBR5hgTUau4CqGeV3izqD7LPJA4d1N1sycAUD2TOuOzHkl/I
	 OjT00iETDozZQ==
From: Mike Rapoport <rppt@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: jane.chu@oracle.com,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 0/1] nvdimm: allow exposing RAM as libnvdimm DIMMs
Date: Tue, 26 Aug 2025 11:04:29 +0300
Message-ID: <20250826080430.1952982-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

It's not uncommon that libnvdimm/dax/ndctl are used with normal volatile
memory for a whole bunch of $reasons.

Probably the most common usecase is to back VMs memory with fsdax/devdax,
but there are others as well when there's a requirement to manage memory
separately from the kernel.

The existing mechanisms to expose normal ram as "persistent", such as
memmap=x!y on x86 or dummy pmem-region device tree nodes on DT systems lack
flexibility to dynamically partition a single region without rebooting the
system and sometimes even updating the system firmware. Also, to create
several DAX devices with different properties it's necessary to repeat
the memmap= command line option or add several pmem-region nodes to the
DT.

I propose a new driver that will create a DIMM device on
E820_TYPE_PRAM/pmem-region and that will allow partitioning that device
dynamically. The label area is kept in the end of that region and managed
by the driver.

Changes since RFC:
* fix offset calculations in ramdax_{get,set}_config_data
* use a magic constant instead of a random number as nd_set->cookie*

RFC: https://lore.kernel.org/all/20250612083153.48624-1-rppt@kernel.org


Mike Rapoport (Microsoft) (1):
  nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices

 drivers/nvdimm/ramdax.c | 281 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 281 insertions(+)
 create mode 100644 drivers/nvdimm/ramdax.c


base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
-- 
2.50.1

