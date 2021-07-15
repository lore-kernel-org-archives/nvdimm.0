Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3F0168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 22:40:41 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id 8D5E720B6C50; Thu, 15 Jul 2021 15:33:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8D5E720B6C50
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1626388404;
	bh=s6BF9OzycHJ2bieeu7MOwCHzcn2HUtzWagjsyZtJaNQ=;
	h=Date:From:To:Cc:Subject:From;
	b=gGdvnjAk649Dtq1F8gcIFN+tpEjuFsDmsV+BYe1UrlnDIwqPZMQJ8uhLbUHaJJxaS
	 t3nwz53uEXFI7C1S4M+/YDS7WrLdBffNJ3gIRqB8o1lKU1UZqkf9NgoYrany/PHOMP
	 ziHf7M6jneicFGUK0wtRqLk+CiHczf5ps2WSpZmU=
Date: Thu, 15 Jul 2021 15:33:24 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev, apais@microsoft.com, tyhicks@microsoft.com,
	jamorris@microsoft.com, benhill@microsoft.com,
	sunilmut@microsoft.com, grahamwo@microsoft.com,
	tstark@microsoft.com
Subject: [PATCH v2 0/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210715223324.GA29063@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)

Changes from v1 [1]:
 - Fixed a bug where the guest might touch pmem region prior to the
   backing file being mapped into the guest's address space.

[1]: https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg23736.html

---

These patches add support to virtio-pmem to allow the pmem region to be
specified in either guest absolute terms or as a PCI BAR-relative address.
This is required to support virtio-pmem in Hyper-V, since Hyper-V only
allows PCI devices to operate on PCI memory ranges defined via BARs.

Taylor Stark (2):
  virtio-pmem: Support PCI BAR-relative addresses
  virtio-pmem: Set DRIVER_OK status prior to creating pmem region

 drivers/nvdimm/virtio_pmem.c | 27 +++++++++++++++++++++++----
 drivers/nvdimm/virtio_pmem.h |  3 +++
 2 files changed, 26 insertions(+), 4 deletions(-)


base-commit: e73f0f0ee7541171d89f2e2491130c7771ba58d3
-- 
2.32.0

