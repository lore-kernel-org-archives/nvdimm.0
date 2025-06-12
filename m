Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8B1EC2;
	Thu, 12 Jun 2025 08:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749717120; cv=none; b=EHxjClTQlz0Te41yRxa4IYOb8ERLoAKAcYfw1o6aIIH8APKRhL9kSU/Q/gZBhPHnH9JRtvt5NXF3nlYLw7R9ZZuvQ7nncaxiJQ5jucalrbQMQtAqDW6MkkPCW6Dw19bHaQ0r+Jsct3mJ7xHiPmF2enS5s0DAxn1FtVEuzpKVmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749717120; c=relaxed/simple;
	bh=hKzDfjPFyE7FkrOKpdz2aNzsnqNmvCZQW5nLnhks5/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O10vRPsltBOcSKlZ7r6cKn2NNGvP2tiaUtCnWV9K0rI25bdkYYEE1r7AoUsMM0SZm/jGHdKVuOmPlCx/kBJkK0H0S9likbPBPUmPNWK2KKl1g+z4vvaYgiKkzBbpYXV+G4LWNl289IsKK9gy4D+8YRqkgKSbOJfQcIYxSSzmyQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEP78VRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEP78VRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A62DC4CEEA;
	Thu, 12 Jun 2025 08:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749717119;
	bh=hKzDfjPFyE7FkrOKpdz2aNzsnqNmvCZQW5nLnhks5/A=;
	h=From:To:Cc:Subject:Date:From;
	b=MEP78VRzZFms56P8n9/JNflwLEZix9jCUXNBIT7HO+eTbPrQjZSOHExYCrYQC11T6
	 nQP6193V1GsJs7eX3FOk8jluFRtfNWt7oHyeLyUw35gzwkcHE6etYUX+h5cMEA36zq
	 VOtr39nD2kFPIS6qnkZuEqPfEoflrCpwr+/Y2PGOwCaA4B+UtsXtOkgg5hFbkuO4M4
	 vDVVqgHnwZUSeB7BNOtCHhfndgcU1WTqzGcwBetGJ2Bsk3gyXBgPqv8cbhpPrEwwEP
	 QPWByBMBQBFNk9nplpn06uGbbdz4s07dpBBv9GX+Ktr6oJYYSlfMR7ZXjPt51TovuN
	 /xDvDTZURvZ1Q==
From: Mike Rapoport <rppt@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [RFC PATCH 0/1] nvdimm: allow exposing RAM as libnvdimm DIMMs
Date: Thu, 12 Jun 2025 11:31:52 +0300
Message-ID: <20250612083153.48624-1-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
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
system. Also, to create several DAX devices with different properties it's
necessary to repeat the memmap= command line option or add several
pmem-region nodes to the DT.

I propose a new driver that will create a DIMM device on
E820_TYPE_PRAM/pmem-region and that will allow partitioning that device
dynamically. The label area is kept in the end of that region and managed
by the driver.

Mike Rapoport (Microsoft) (1):
  nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices

 drivers/nvdimm/Kconfig  |  15 +++
 drivers/nvdimm/Makefile |   1 +
 drivers/nvdimm/ramdax.c | 279 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 295 insertions(+)
 create mode 100644 drivers/nvdimm/ramdax.c


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.47.2

