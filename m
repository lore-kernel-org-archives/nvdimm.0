Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C91F2C11C9;
	Wed, 15 Oct 2025 08:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760515228; cv=none; b=SEbpgCMdMWD1fxL3CN2gRQ5EwJ61Y2R6Xh++KWFOTmi3OuoqVYqzq6WF5egXyJDT9Sd6EHet6yPgI7fxpVgcyje3oE7RY/HL+5vuFcpU5G04THLf9P0nRM8t8uQzIpCeLTYADaAEujDyFPTmyslYZtDdGPH9Zu/FPLpBmS7uzq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760515228; c=relaxed/simple;
	bh=RNrrJqa56pWAbo41aiG9jd+Ywovn3AVFWvtfkggn8p8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f7nonEPF1k+xOdEbZmXr6LXJ4PJjurv9Jto2mTl+NJbXTkZrk4YZwaXW4BBpLGpBc2SrDmn6bA6UblU1STkrh7BEpq+wl+XUgv2KiGpHWHM6e3ljNbwk1UeYOEaSiTufWQw1q1tnBswgT9Mi5m7F+vkO/z3GlMe93LXEDSppKLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exqAfd4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exqAfd4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA17BC4CEF8;
	Wed, 15 Oct 2025 08:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760515227;
	bh=RNrrJqa56pWAbo41aiG9jd+Ywovn3AVFWvtfkggn8p8=;
	h=From:To:Cc:Subject:Date:From;
	b=exqAfd4Sb99/xQT02RBtFP32VOcOX/wzoFjxKIzTnEIRiWrFTEpwV4taWKaPg6Fud
	 abjOxYTJRxuRWKA68hMHiOIujwt+eJEs5fYERQPd2m+/9o2ORsvVZ0ZpDW5DnmgW4L
	 UK6kohUn7QUCq7pT5+tWqfU2UmNfyO7MekH2QD8JFvouL40fvv6I0Q1lLChcZCdPAM
	 Fh193BByRXTRsBY0/vtleHkb59KUU0RvXPqqHajSqp1X6cCExLRudIvVVK6jx0U8qA
	 P9sWUl4z5dqEPaYrU17INKM5vUOVPWgNdmFjnLHzJeSsjGPpDgLs/3WBY/0Y9jyyCU
	 03LArymegIx3w==
From: Mike Rapoport <rppt@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: jane.chu@oracle.com,
	=?UTF-8?q?Micha=C5=82=20C=C5=82api=C5=84ski?= <mclapinski@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH v2 0/1] nvdimm: allow exposing RAM as libnvdimm DIMMs
Date: Wed, 15 Oct 2025 11:00:19 +0300
Message-ID: <20251015080020.3018581-1-rppt@kernel.org>
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

I propose a new ramdax driver that will create a DIMM device on
E820_TYPE_PRAM/pmem-region and that will allow partitioning that device
dynamically. The label area is kept in the end of that region and managed
by the driver.

v2 changes:
* Change the way driver is bound to a device, following Dan's
  suggestion. Instead of forcing mutual exclusion of ramdax and
  nr_e820/of-pmem at build time, rely on 'driver_override' attribute to
  allow binding ramdax driver to e820_pmem/pmem-region devices.
* Fix build warning reported by kbuild

v1: https://lore.kernel.org/all/20250826080430.1952982-1-rppt@kernel.org
* fix offset calculations in ramdax_{get,set}_config_data
* use a magic constant instead of a random number as nd_set->cookie*

RFC: https://lore.kernel.org/all/20250612083153.48624-1-rppt@kernel.org

Mike Rapoport (Microsoft) (1):
  nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices

 drivers/nvdimm/Kconfig  |  17 +++
 drivers/nvdimm/Makefile |   1 +
 drivers/nvdimm/ramdax.c | 272 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 290 insertions(+)
 create mode 100644 drivers/nvdimm/ramdax.c


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
--
2.50.1
