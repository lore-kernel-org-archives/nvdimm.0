From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] libnvdimm: nd_region flush callback support
Date: Sat, 13 Oct 2018 17:38:55 +0800
Message-ID: <201810131727.mgc0VdBk%fengguang.wu@intel.com>
References: <20181013050021.11962-2-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181013050021.11962-2-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi Pankaj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
[also build test WARNING on v4.19-rc7 next-20181012]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Pankaj-Gupta/libnvdimm-nd_region-flush-callback-support/20181013-152624
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: x86_64-randconfig-g0-10131621 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from drivers//acpi/nfit/core.c:14:0:
>> include/linux/libnvdimm.h:206:54: warning: 'struct bio' declared inside parameter list
    int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async);
                                                         ^
>> include/linux/libnvdimm.h:206:54: warning: its scope is only this definition or declaration, which is probably not what you want

vim +206 include/linux/libnvdimm.h

   159	
   160	void badrange_init(struct badrange *badrange);
   161	int badrange_add(struct badrange *badrange, u64 addr, u64 length);
   162	void badrange_forget(struct badrange *badrange, phys_addr_t start,
   163			unsigned int len);
   164	int nvdimm_bus_add_badrange(struct nvdimm_bus *nvdimm_bus, u64 addr,
   165			u64 length);
   166	struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
   167			struct nvdimm_bus_descriptor *nfit_desc);
   168	void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
   169	struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
   170	struct nvdimm *to_nvdimm(struct device *dev);
   171	struct nd_region *to_nd_region(struct device *dev);
   172	struct device *nd_region_dev(struct nd_region *nd_region);
   173	struct nd_blk_region *to_nd_blk_region(struct device *dev);
   174	struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
   175	struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
   176	const char *nvdimm_name(struct nvdimm *nvdimm);
   177	struct kobject *nvdimm_kobj(struct nvdimm *nvdimm);
   178	unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
   179	void *nvdimm_provider_data(struct nvdimm *nvdimm);
   180	struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
   181			const struct attribute_group **groups, unsigned long flags,
   182			unsigned long cmd_mask, int num_flush,
   183			struct resource *flush_wpq);
   184	const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
   185	const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
   186	u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
   187			const struct nd_cmd_desc *desc, int idx, void *buf);
   188	u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
   189			const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
   190			const u32 *out_field, unsigned long remainder);
   191	int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count);
   192	struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
   193			struct nd_region_desc *ndr_desc);
   194	struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
   195			struct nd_region_desc *ndr_desc);
   196	struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
   197			struct nd_region_desc *ndr_desc);
   198	void *nd_region_provider_data(struct nd_region *nd_region);
   199	void *nd_blk_region_provider_data(struct nd_blk_region *ndbr);
   200	void nd_blk_region_set_provider_data(struct nd_blk_region *ndbr, void *data);
   201	struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr);
   202	unsigned long nd_blk_memremap_flags(struct nd_blk_region *ndbr);
   203	unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
   204	void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
   205	u64 nd_fletcher64(void *addr, size_t len, bool le);
 > 206	int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async);
   207	int generic_nvdimm_flush(struct nd_region *nd_region);
   208	int nvdimm_has_flush(struct nd_region *nd_region);
   209	int nvdimm_has_cache(struct nd_region *nd_region);
   210	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
