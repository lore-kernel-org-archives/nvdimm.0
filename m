Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F28B2194D387
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 03:48:50 -0800 (PST)
Date: Fri, 18 Jan 2019 19:48:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/4] Allow persistent memory to be used like normal RAM
Message-ID: <20190118114846.hmmcagscyjeycyfy@wfg-t540p.sh.intel.com>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <x49sgxr9rjd.fsf@segfault.boston.devel.redhat.com>
 <20190117164736.GC31543@localhost.localdomain>
 <x49pnsv8am1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49pnsv8am1.fsf@segfault.boston.devel.redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, akpm@linux-foundation.org, bp@suse.de
List-ID: <linux-nvdimm@lists.01.org>

>With this patch set, an unmodified application would either use:
>
>1) whatever memory it happened to get
>2) only the faster dram (via numactl --membind=)
>3) only the slower pmem (again, via numactl --membind1)
>4) preferentially one or the other (numactl --preferred=)

Yet another option:

MemoryOptimizer -- hot page accounting and migration daemon
https://github.com/intel/memory-optimizer

Once PMEM NUMA nodes are available, we may run a user space daemon to
walk page tables of virtual machines (EPT) or processes, collect the
"accessed" bits to find out hot pages, and finally migrate hot pages
to DRAM and cold pages to PMEM.

In that scenario, only kernel and the migrate daemon need to be aware
of the PMEM nodes. Unmodified virtual machines and processes can enjoy
the added memory space w/o knowing whether it's using DRAM or PMEM.

Thanks,
Fengguang
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
