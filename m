Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7625487C;
	Sun, 26 Oct 2025 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761493128; cv=none; b=nFCCPu4MqbSohbSJPo221UksTfYrvkZYFPbF2JAdQQedF6oSSa4NiA2z86us19DHdgGdUh4LSaXlNfVQQssEHzXt0OecFym7w8/AZA4x23LZsSYuVtF1UaKm3wWz+yZ5yUtDGfLHhYsNUFfwf/0UopV79+mD8sECm5Cqn+4qhFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761493128; c=relaxed/simple;
	bh=6kgpDc8RniC71k0JLxpDkWv63PHKz+Ojr87Zsi5Zusg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mtpk+LDsCnXXMufhPZVyLxNG8WhnhytHdnX3gm8zrjHmJc+8ewh5MzE9sShDO2+W3G1mgIX8JXdUwC9HfsCUjfBiw3heIvXE0R5Yfl45PG8HK+4HXL9cHAHNC/GXCPIHmV5mtxA0i/036D8mXSR9ANaGROzHlXL/sX2+ijm1S1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqrTKfWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqrTKfWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9A7C4CEE7;
	Sun, 26 Oct 2025 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761493128;
	bh=6kgpDc8RniC71k0JLxpDkWv63PHKz+Ojr87Zsi5Zusg=;
	h=From:To:Cc:Subject:Date:From;
	b=FqrTKfWRjjVzJ6b8aBCiImqovP1o4gIpOnabjLpkx17sjEODvSr1/uOZAssscL0Ci
	 Jt/1XUni5Q+bcD8+8xNvRqT3C7p506tgkUjHu4cQtokkj3XlQWsIJmexThfWpyzg17
	 5/t/FgxEBAyVPw4IK/dvG8Ia3uFlKUMOtC7qzk1wFq9LaP53le4PwK14BOYlJg65Sf
	 oi1aecZX7jaUCF/27msHQ7gjWn01SqvxENDHEqevS0ZQggJW7g0bQXKVeZja/RoYtU
	 CaRne/oKKz8vgvhE8Cz6r7w7Fsb70Vyt+aO86CRMgNqqYMZwTEhxrZ8/s9LkCPjwNB
	 FCC59NMGxE+KA==
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
Subject: [PATCH v3 0/1] nvdimm: allow exposing RAM as libnvdimm DIMMs
Date: Sun, 26 Oct 2025 17:38:40 +0200
Message-ID: <20251026153841.752061-1-rppt@kernel.org>
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

v3 changes:
* Update Kconfig dependencies and help text
* Add manual check for of_match_node()
* Adjust white space for function parameters to match other nvdimm drivers
* Add Reviewed-by, thanks Dan!

v2: https://lore.kernel.org/all/20251015080020.3018581-1-rppt@kernel.org
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

 drivers/nvdimm/Kconfig  |  19 +++
 drivers/nvdimm/Makefile |   1 +
 drivers/nvdimm/ramdax.c | 282 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 302 insertions(+)
 create mode 100644 drivers/nvdimm/ramdax.c


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.50.1

