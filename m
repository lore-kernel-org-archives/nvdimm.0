Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08EBD2095AE53
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 11:51:13 -0700 (PDT)
Date: Fri, 25 Aug 2017 02:52:56 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v5 7/7] libnvdimm: Add blk-mq pmem driver
Message-ID: <201708250259.fqck1Olv%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150334987495.55214.5621513659334023484.stgit@djiang5-desk3.ch.intel.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, vinod.koul@intel.com, hch@infradead.org, kbuild-all@01.org, dmaengine@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

[auto build test ERROR on slave-dma/next]
[also build test ERROR on next-20170824]
[cannot apply to linus/master linux-nvdimm/libnvdimm-for-next v4.13-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/libnvdimm-add-DMA-support-for-pmem-blk-mq/20170824-164932
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vkoul/slave-dma.git next
config: i386-randconfig-c0-08250030 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   ERROR: "dma_request_chan" [sound/soc/snd-soc-core.ko] undefined!
   ERROR: "dma_request_slave_channel" [sound/soc/snd-soc-core.ko] undefined!
   ERROR: "dma_get_slave_caps" [sound/soc/snd-soc-core.ko] undefined!
   ERROR: "dma_release_channel" [sound/soc/snd-soc-core.ko] undefined!
>> ERROR: "__dma_request_channel" [sound/core/snd-pcm-dmaengine.ko] undefined!
>> ERROR: "dma_release_channel" [sound/core/snd-pcm-dmaengine.ko] undefined!
>> ERROR: "dma_find_channel" [drivers/nvdimm/nd_pmem_mq.ko] undefined!
>> ERROR: "dmaengine_unmap_put" [drivers/nvdimm/nd_pmem_mq.ko] undefined!
>> ERROR: "dmaengine_get_unmap_data" [drivers/nvdimm/nd_pmem_mq.ko] undefined!
>> ERROR: "dmaengine_get" [drivers/nvdimm/nd_pmem_mq.ko] undefined!
>> ERROR: "dmaengine_put" [drivers/nvdimm/nd_pmem_mq.ko] undefined!

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
