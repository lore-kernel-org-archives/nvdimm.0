Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 850732194D3B9
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 20:11:12 -0800 (PST)
Date: Tue, 6 Nov 2018 12:10:35 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
Message-ID: <201811061228.iteFLO2p%fengguang.wu@intel.com>
References: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
In-Reply-To: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, bvanassche@acm.org, linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Alexander,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on driver-core/master]

url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/Add-NUMA-aware-async_schedule-calls/20181106-093800
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:1001: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   kernel/rcu/tree.c:685: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:375: warning: Function parameter or member 'init_valid_mask' not described in 'gpio_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
>> include/linux/device.h:1056: warning: Function parameter or member 'async_probe' not described in 'device'
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   drivers/mtd/nand/raw/nand_base.c:603: warning: Excess function parameter 'mtd' description in 'panic_nand_wait'
   drivers/mtd/nand/raw/nand_base.c:603: warning: Excess function parameter 'mtd' description in 'panic_nand_wait'
   include/linux/regulator/driver.h:227: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   include/linux/spi/spi.h:177: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/class.c:1: warning: no structured comments found
   include/linux/w1.h:281: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
   fs/direct-io.c:257: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/file_table.c:1: warning: no structured comments found
   fs/libfs.c:477: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:646: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:254: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_gfx'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:302: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:382: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:383: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'end' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:848: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3096: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_mode_config.h:869: warning: Function parameter or member 'quirk_addfb_prefer_xbgr_30bpp' not described in 'drm_mode_config'
   drivers/gpu/drm/drm_fourcc.c:112: warning: Function parameter or member 'dev' not described in 'drm_driver_legacy_fb_format'
   drivers/gpu/drm/drm_fourcc.c:112: warning: Excess function parameter 'native' description in 'drm_driver_legacy_fb_format'
   drivers/gpu/drm/i915/i915_vma.h:49: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:554: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
   include/linux/skbuff.h:862: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:238: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.rmem_alloc' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.len' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.head' not described in 'sock'

vim +1056 include/linux/device.h

^1da177e Linus Torvalds 2005-04-16 @1056  

:::::: The code at line 1056 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
