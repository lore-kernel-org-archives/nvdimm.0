Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65473FC2
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 05:43:43 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6E7A6736F; Fri, 20 Aug 2021 07:43:40 +0200 (CEST)
Date: Fri, 20 Aug 2021 07:43:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: can we finally kill off CONFIG_FS_DAX_LIMITED
Message-ID: <20210820054340.GA28560@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi all,

looking at the recent ZONE_DEVICE related changes we still have a
horrible maze of different code paths.  I already suggested to
depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
architectures have anyway.  But the other odd special case is
CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
this driver still see use?  If so can we make it behave like the
other DAX drivers and require a pgmap?  I think the biggest missing
part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
