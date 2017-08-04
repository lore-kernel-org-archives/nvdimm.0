Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38CBD21E1DAFA
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 06:23:24 -0700 (PDT)
Date: Fri, 4 Aug 2017 21:24:39 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3 6/8] dmaengine: add SG support to dmaengine_unmap
Message-ID: <201708042117.FrtVVfMM%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150180314097.66052.10575410261412764679.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org, vinod.koul@intel.com, kbuild-all@01.org, dmaengine@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.13-rc3]
[cannot apply to next-20170804]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/Adding-blk-mq-and-DMA-support-to-pmem-block-driver/20170804-191719
config: i386-randconfig-x003-201731 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers//dma/dmaengine.c: In function 'dmaengine_unmap':
>> drivers//dma/dmaengine.c:1140:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      sg = (struct scatterlist *)unmap->addr[i];
           ^
   drivers//dma/dmaengine.c:1151:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      sg = (struct scatterlist *)unmap->addr[i];
           ^
   Cyclomatic Complexity 5 include/linux/compiler.h:__read_once_size
   Cyclomatic Complexity 5 include/linux/compiler.h:__write_once_size
   Cyclomatic Complexity 3 arch/x86/include/asm/bitops.h:set_bit
   Cyclomatic Complexity 3 arch/x86/include/asm/bitops.h:clear_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:constant_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:variable_test_bit
   Cyclomatic Complexity 1 arch/x86/include/asm/bitops.h:fls
   Cyclomatic Complexity 1 include/linux/log2.h:__ilog2_u32
   Cyclomatic Complexity 1 include/linux/list.h:__list_add_valid
   Cyclomatic Complexity 1 include/linux/list.h:__list_del_entry_valid
   Cyclomatic Complexity 1 include/linux/list.h:__list_del
   Cyclomatic Complexity 2 include/linux/list.h:__list_del_entry
   Cyclomatic Complexity 1 include/linux/err.h:ERR_PTR
   Cyclomatic Complexity 1 include/linux/err.h:PTR_ERR
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_read
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_set
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_inc
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_dec
   Cyclomatic Complexity 1 arch/x86/include/asm/atomic.h:atomic_dec_and_test
   Cyclomatic Complexity 1 include/asm-generic/getorder.h:__get_order
   Cyclomatic Complexity 1 arch/x86/include/asm/processor.h:rep_nop
   Cyclomatic Complexity 1 arch/x86/include/asm/processor.h:cpu_relax
   Cyclomatic Complexity 1 include/linux/jiffies.h:_msecs_to_jiffies
   Cyclomatic Complexity 5 include/linux/jiffies.h:msecs_to_jiffies
   Cyclomatic Complexity 1 include/linux/refcount.h:refcount_set
   Cyclomatic Complexity 1 include/linux/kref.h:kref_init
   Cyclomatic Complexity 1 include/linux/kobject.h:kobject_name
   Cyclomatic Complexity 1 include/linux/rculist.h:list_del_rcu
   Cyclomatic Complexity 1 include/linux/device.h:dev_to_node
   Cyclomatic Complexity 1 include/linux/dma-debug.h:debug_dma_unmap_page
   Cyclomatic Complexity 1 include/linux/dma-debug.h:debug_dma_unmap_sg
   Cyclomatic Complexity 1 include/linux/dma-mapping.h:valid_dma_direction
   Cyclomatic Complexity 1 arch/x86/include/asm/dma-mapping.h:get_arch_dma_ops
   Cyclomatic Complexity 1 include/linux/module.h:__module_get
   Cyclomatic Complexity 1 include/linux/module.h:try_module_get
   Cyclomatic Complexity 1 include/linux/module.h:module_put
   Cyclomatic Complexity 1 include/linux/dmaengine.h:txd_lock
   Cyclomatic Complexity 1 include/linux/dmaengine.h:txd_unlock
   Cyclomatic Complexity 1 include/linux/dmaengine.h:txd_clear_parent
   Cyclomatic Complexity 1 include/linux/dmaengine.h:txd_clear_next
   Cyclomatic Complexity 1 include/linux/dmaengine.h:txd_next
   Cyclomatic Complexity 1 include/linux/dmaengine.h:__dma_cap_set
   Cyclomatic Complexity 1 include/linux/dmaengine.h:__dma_cap_clear
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_async_issue_pending
   Cyclomatic Complexity 56 include/linux/slab.h:kmalloc_index
   Cyclomatic Complexity 67 include/linux/slab.h:kmalloc_large
   Cyclomatic Complexity 9 include/linux/slab.h:kmalloc
   Cyclomatic Complexity 1 include/linux/slab.h:kzalloc
   Cyclomatic Complexity 1 drivers//dma/dmaengine.c:dma_chan_to_owner
   Cyclomatic Complexity 2 drivers//dma/dmaengine.c:balance_ref_count
   Cyclomatic Complexity 5 include/linux/dmaengine.h:dma_async_is_tx_complete
   Cyclomatic Complexity 2 include/linux/dmaengine.h:__dma_has_cap
   Cyclomatic Complexity 7 drivers//dma/dmaengine.c:device_has_all_tx_types
   Cyclomatic Complexity 9 drivers//dma/dmaengine.c:dma_chan_get
   Cyclomatic Complexity 3 include/linux/device.h:dev_name
   Cyclomatic Complexity 1 include/linux/dmaengine.h:dma_chan_name
   Cyclomatic Complexity 10 include/linux/dma-mapping.h:get_dma_ops
   Cyclomatic Complexity 3 include/linux/bitops.h:get_count_order
   Cyclomatic Complexity 9 include/linux/bitmap.h:bitmap_fill
   Cyclomatic Complexity 7 drivers//dma/dmaengine.c:dma_channel_table_init
   Cyclomatic Complexity 9 include/linux/bitmap.h:bitmap_zero
   Cyclomatic Complexity 1 include/linux/dmaengine.h:__dma_cap_zero
   Cyclomatic Complexity 1 include/linux/rcupdate.h:rcu_read_lock
   Cyclomatic Complexity 1 include/linux/rcupdate.h:rcu_read_unlock
   Cyclomatic Complexity 1 include/linux/err.h:IS_ERR
   Cyclomatic Complexity 3 include/linux/err.h:IS_ERR_OR_NULL
   Cyclomatic Complexity 3 include/acpi/acpi_bus.h:is_acpi_device_node
   Cyclomatic Complexity 1 include/linux/acpi.h:has_acpi_companion
   Cyclomatic Complexity 2 include/linux/cpumask.h:cpumask_check
   Cyclomatic Complexity 1 include/linux/cpumask.h:cpumask_test_cpu
   Cyclomatic Complexity 3 drivers//dma/dmaengine.c:dma_chan_is_local
   Cyclomatic Complexity 3 include/linux/cpumask.h:cpumask_next
   Cyclomatic Complexity 9 include/linux/bitmap.h:bitmap_and
   Cyclomatic Complexity 17 include/linux/bitmap.h:bitmap_equal
   Cyclomatic Complexity 1 drivers//dma/dmaengine.c:__dma_device_satisfies_mask
   Cyclomatic Complexity 27 drivers//dma/dmaengine.c:private_candidate
   Cyclomatic Complexity 11 drivers//dma/dmaengine.c:find_candidate
   Cyclomatic Complexity 7 drivers//dma/dmaengine.c:dma_filter_match
   Cyclomatic Complexity 3 include/linux/dmaengine.h:dmaengine_synchronize
   Cyclomatic Complexity 19 drivers//dma/dmaengine.c:dma_chan_put
   Cyclomatic Complexity 36 drivers//dma/dmaengine.c:min_chan
   Cyclomatic Complexity 18 drivers//dma/dmaengine.c:dma_channel_rebalance
   Cyclomatic Complexity 3 include/linux/dma-mapping.h:dma_unmap_sg_attrs
   Cyclomatic Complexity 3 include/linux/dma-mapping.h:dma_unmap_page_attrs
   Cyclomatic Complexity 1 drivers//dma/dmaengine.c:__get_unmap_pool
   Cyclomatic Complexity 4 drivers//dma/dmaengine.c:chan_dev_release
   Cyclomatic Complexity 3 drivers//dma/dmaengine.c:dev_to_dma_chan
   Cyclomatic Complexity 3 drivers//dma/dmaengine.c:in_use_show
   Cyclomatic Complexity 4 drivers//dma/dmaengine.c:bytes_transferred_show
   Cyclomatic Complexity 4 drivers//dma/dmaengine.c:memcpy_count_show
   Cyclomatic Complexity 1 include/linux/idr.h:ida_get_new
   Cyclomatic Complexity 3 drivers//dma/dmaengine.c:get_dma_id
   Cyclomatic Complexity 4 include/linux/rculist.h:__list_add_rcu
   Cyclomatic Complexity 1 include/linux/rculist.h:list_add_tail_rcu
   Cyclomatic Complexity 12 drivers//dma/dmaengine.c:dmaengine_unmap

vim +1140 drivers//dma/dmaengine.c

  1128	
  1129	static void dmaengine_unmap(struct kref *kref)
  1130	{
  1131		struct dmaengine_unmap_data *unmap = container_of(kref, typeof(*unmap), kref);
  1132		struct device *dev = unmap->dev;
  1133		int cnt, i, sg_nents;
  1134		struct scatterlist *sg;
  1135	
  1136		sg_nents = dma_unmap_data_sg_to_nents(unmap, unmap->map_cnt);
  1137		if (sg_nents) {
  1138			i = 0;
  1139			cnt = 1;
> 1140			sg = (struct scatterlist *)unmap->addr[i];
  1141			dma_unmap_sg(dev, sg, sg_nents, DMA_TO_DEVICE);
  1142		} else {
  1143			cnt = unmap->to_cnt;
  1144			for (i = 0; i < cnt; i++)
  1145				dma_unmap_page(dev, unmap->addr[i], unmap->len,
  1146						DMA_TO_DEVICE);
  1147		}
  1148	
  1149		sg_nents = dma_unmap_data_sg_from_nents(unmap, unmap->map_cnt);
  1150		if (sg_nents) {
  1151			sg = (struct scatterlist *)unmap->addr[i];
  1152			dma_unmap_sg(dev, sg, sg_nents, DMA_FROM_DEVICE);
  1153			cnt++;
  1154			i++;
  1155		} else {
  1156			cnt += unmap->from_cnt;
  1157			for (; i < cnt; i++)
  1158				dma_unmap_page(dev, unmap->addr[i], unmap->len,
  1159						DMA_FROM_DEVICE);
  1160		}
  1161	
  1162		cnt += unmap->bidi_cnt;
  1163		for (; i < cnt; i++) {
  1164			if (unmap->addr[i] == 0)
  1165				continue;
  1166			dma_unmap_page(dev, unmap->addr[i], unmap->len,
  1167				       DMA_BIDIRECTIONAL);
  1168		}
  1169		cnt = unmap->map_cnt;
  1170		mempool_free(unmap, __get_unmap_pool(cnt)->pool);
  1171	}
  1172	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
