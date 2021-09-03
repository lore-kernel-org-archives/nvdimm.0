Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864253FC1
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 15:20:40 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="219148312"
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="219148312"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 08:20:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="467979065"
Received: from lkp-server01.sh.intel.com (HELO 2115029a3e5c) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 03 Sep 2021 08:20:31 -0700
Received: from kbuild by 2115029a3e5c with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1mMAzW-0000Zv-HR; Fri, 03 Sep 2021 15:20:30 +0000
Date: Fri, 3 Sep 2021 23:19:41 +0800
From: kernel test robot <lkp@intel.com>
To: Kajol Jain <kjain@linux.ibm.com>, mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	vishal.l.verma@intel.com
Cc: kbuild-all@lists.01.org, maddy@linux.ibm.com, santosh@fossix.org
Subject: [RFC PATCH] drivers/nvdimm: nvdimm_pmu_free_hotplug_memory() can be
 static
Message-ID: <20210903151941.GA23182@a0af9ae1a611>
References: <20210903050914.273525-3-kjain@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903050914.273525-3-kjain@linux.ibm.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)

drivers/nvdimm/nd_perf.c:159:6: warning: symbol 'nvdimm_pmu_free_hotplug_memory' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 nd_perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
index 4c49d1bc2a3c6..b129e5e702d59 100644
--- a/drivers/nvdimm/nd_perf.c
+++ b/drivers/nvdimm/nd_perf.c
@@ -156,7 +156,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
 	return 0;
 }
 
-void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
+static void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
 {
 	cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
 	cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
