Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317464;
	b=LNaYYcV4Wq5L50PeWiAGkciIxglsnU0gcukpYHiUr20dSWTW6j6K5GN+FsQoccYGAf11
	 8/pagmuX8L64NyxAkec9cf6se7LObCZAI+k9T0X71AM9HrGtXfjeyqgAcOPKvQ4MsgBTX
	 wP5RzmHd/YcBbZsYTe5c/fQBfzh25dVGcovf7dl9We/BIsrnVN53KG5l/ub37/L7EN4gO
	 CBjZkrfN1GhX7eMSsBQB+C0RJzkEQKhlmdPHscaGpOdqFpefyoP2g0YRsoWBBoN7B4ehK
	 9Q0d2XaWBXhOj4jkqFucdoRIh/Dv6lq1xe5XXtwR0qGW5shBTdPhcZC9F/pPmYJWAJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317464;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+9zQ4PGHjKLcJtopkOYtI/UWThu+ajvfJ5K1oQW1g+E=;
	b=UzPoXMBRPlO4GHX/YqjLNLod4T3VWRbpXXcsktS494BrMrs9tvJXQBQVzfwcpzAjwspy
	 1ZHY73OcoByMQ9VG+caMkTmjEHM3XIfIZuc58aAXo6BdCWA1Gb5X23BRK6TAw0mdNDb4C
	 UyA5ELU+oRDJnuMsluFDoAZb3qcTm3F5/iqKJGhiymY4oRVeA5v3tf4AzP9BwKWMHAFp8
	 nTILU2pEC6xQ2gKYYzKUxP2Qq74Ho6BvSFanK6hf8TQoxcoZk9eLtXpFXEvYX1HE1Q7ww
	 ndRQjUhGdV4wNn5SWzl5u3eyBDuP9rJ8G9DKn0B20N6BHMW3cTRR2hJ/Xc0m8PsG4Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=(null) smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Z1UtbESY;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D2606A31A
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 23:44:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E15D2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Z1UtbESY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793317450; x=1824853450;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CGIhIIJr9p5CxoCvxCabQ5bynISqiBgg0CihSFweCS0=;
  b=Z1UtbESYdOwMKnM/OWjkIANcqN/CBURE5QemHdAb4HyhNMe0hUyUFMCB
   hOKdvecSVaF3GLg917t5O8mt0P1kPkBvf2eR0iFlu4qyaCawwVpGncdms
   6G6f/0aZwB3IDWJjjH4e4EgWAIoGax+TM5fdzgVyXlrR4Sxeayw/6NARm
   MQ9SVtM6OjZIb8Q+9v4J1cnAh37JLeOecWvIq5ltt22UqfwLCbVDlRZHD
   JGSnTwnCWV7PU2hMpbAoAfBVmq6Wguc0bBbAttWvnyzbYyg3kh/2r8LtE
   bwNehiXIlY8JX2ZY2waUmxd+FVFIUdbEDBeNzHmi4sw3tvCwjG2YFsIVD
   g==;
X-CSE-ConnectionGUID: NyMeviLMRrKm2+uAcMKDJQ==
X-CSE-MsgGUID: J1j8nqmCRquM7TlyrqU0+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2100437"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2100437"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:44:07 -0700
X-CSE-ConnectionGUID: KlOQNHhCRAK06RZAMnHjEw==
X-CSE-MsgGUID: RHcDlJwQTbGjmbN/Z9wbQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5385210"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.57])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:44:07 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 0/4] libdaxctl: Fix multi-range memory block handling
Date: Thu, 29 Oct 2026 16:43:59 -0700
Message-ID: <cover.1793315621.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v2:
- Patch 3: Reset errno before each readdir() (GregoryP)
- Link to v1: https://lore.kernel.org/nvdimm/cover.1792695259.git.alison.schofield@intel.com/

Review and testing of Gregory's dax kmem atomic whole-device hotplug
series[1] exposed an existing libdaxctl bug when handling DAX devices with
multiple physical address ranges.

libdaxctl identifies a device's memory blocks using a single contiguous
address window, even when the device has separate ranges with gaps between
them. This can exclude blocks belonging to the device and include blocks
belonging to another device in the gaps. As a result, daxctl can report
incorrect memory block counts and potentially online or offline another
device's memory.

Patches 1-2 address mapping reliability issues discovered while fixing
the memory block ownership checks.

Patch 3 corrects the memory block ownership checks.

Patch 4 adds regression coverage using a two-range DAX device.

[1] https://lore.kernel.org/linux-cxl/20261016214248.443247-1-gourry@gourry.net/


Alison Schofield (4):
  libdaxctl: handle mapping initialization failures
  libdaxctl: tie mapping cache lifetime to the device
  libdaxctl: match memory blocks against each dax device mapping
  test/daxctl-create.sh: count memory blocks across dax mappings

 daxctl/lib/libdaxctl.c | 98 ++++++++++++++++++++++++++++++++++--------
 test/daxctl-create.sh  | 58 +++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 19 deletions(-)

-- 
2.37.3

