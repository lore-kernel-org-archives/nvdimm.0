Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC347363
	for <nvdimm@lists.linux.dev>; Fri, 21 Jul 2023 01:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689903905; x=1721439905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4myecPwu5Ccazp290GdECvXjfGsVAVkoX8NsXNv5t8M=;
  b=FKGMW/N22cBrAlIUhPKXOVk6LOeicg5kiJpBNH6ixnGsZJz76QPw0z0e
   58LNGEeiFcog5NDpcB9G/Ar9rR4xrdWL9QucdiYrBvlI/7OQg0xskfoOR
   KSoXJc6wn29lvLKDE31clL9W6diFOUNxZ7AGmP8vs9ahNF8vCuaVPpPaU
   3V1CrOw6Rl5cRPOEEvhysLm6aFhE8x+1gpxERR+el8/fcwLcjkVuaLY3h
   eqmsXNxsVuTPOPb7qIiOAiMJvPxDKXkekLzZPWVn4iCSWPKqTB0mGkFEM
   pbUyKu4kLBn27uZ2mBf4k9TcGiopVk0OZj3vKcK257J/CciNOph1FIhaC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="347214127"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="347214127"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 18:45:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="724670858"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="724670858"
Received: from yanfeng1-mobl.ccr.corp.intel.com (HELO yhuang6-mobl2.ccr.corp.intel.com) ([10.255.29.24])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 18:44:59 -0700
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	Huang Ying <ying.huang@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Wei Xu <weixugc@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Yang Shi <shy828301@gmail.com>,
	Rafael J Wysocki <rafael.j.wysocki@intel.com>
Subject: [PATCH RESEND 0/4] memory tiering: calculate abstract distance based on ACPI HMAT
Date: Fri, 21 Jul 2023 09:29:28 +0800
Message-Id: <20230721012932.190742-1-ying.huang@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have the explicit memory tiers framework to manage systems with
multiple types of memory, e.g., DRAM in DIMM slots and CXL memory
devices.  Where, same kind of memory devices will be grouped into
memory types, then put into memory tiers.  To describe the performance
of a memory type, abstract distance is defined.  Which is in direct
proportion to the memory latency and inversely proportional to the
memory bandwidth.  To keep the code as simple as possible, fixed
abstract distance is used in dax/kmem to describe slow memory such as
Optane DCPMM.

To support more memory types, in this series, we added the abstract
distance calculation algorithm management mechanism, provided a
algorithm implementation based on ACPI HMAT, and used the general
abstract distance calculation interface in dax/kmem driver.  So,
dax/kmem can support HBM (high bandwidth memory) in addition to the
original Optane DCPMM.

Changelog:

V1 (from RFC):

- Added some comments per Aneesh's comments, Thanks!

Best Regards,
Huang, Ying
