Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73D752095DB92
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 09:13:12 -0700 (PDT)
Date: Fri, 4 Aug 2017 00:15:17 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/3] btt: remove btt_rw_page()
Message-ID: <201708040050.bRY4Rqpb%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20170728165604.10455-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>, kbuild-all@01.org, seungho1.park@lge.com, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Ross,

[auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
[also build test WARNING on v4.13-rc3]
[cannot apply to next-20170803]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ross-Zwisler/btt-remove-btt_rw_page/20170729-165642
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: i386-randconfig-h0-08032208 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings

All warnings (new ones prefixed by >>):

   In file included from drivers/nvdimm/btt.c:27:0:
   drivers/nvdimm/btt.c: In function 'btt_make_request':
>> drivers/nvdimm/nd.h:407:2: warning: 'start' may be used uninitialized in this function [-Wmaybe-uninitialized]
     generic_end_io_acct(bio_data_dir(bio), &disk->part0, start);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/nvdimm/btt.c:1202:16: note: 'start' was declared here
     unsigned long start;
                   ^~~~~

vim +/start +407 drivers/nvdimm/nd.h

cd03412a5 Dan Williams 2016-03-11  340  
3d88002e4 Dan Williams 2015-05-31  341  struct nd_region *to_nd_region(struct device *dev);
3d88002e4 Dan Williams 2015-05-31  342  int nd_region_to_nstype(struct nd_region *nd_region);
3d88002e4 Dan Williams 2015-05-31  343  int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
c12c48ce8 Dan Williams 2017-06-04  344  u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
c12c48ce8 Dan Williams 2017-06-04  345  		struct nd_namespace_index *nsindex);
86ef58a4e Dan Williams 2017-02-28  346  u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
3d88002e4 Dan Williams 2015-05-31  347  void nvdimm_bus_lock(struct device *dev);
3d88002e4 Dan Williams 2015-05-31  348  void nvdimm_bus_unlock(struct device *dev);
3d88002e4 Dan Williams 2015-05-31  349  bool is_nvdimm_bus_locked(struct device *dev);
581388209 Dan Williams 2015-06-23  350  int nvdimm_revalidate_disk(struct gendisk *disk);
bf9bccc14 Dan Williams 2015-06-17  351  void nvdimm_drvdata_release(struct kref *kref);
bf9bccc14 Dan Williams 2015-06-17  352  void put_ndd(struct nvdimm_drvdata *ndd);
4a826c83d Dan Williams 2015-06-09  353  int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
4a826c83d Dan Williams 2015-06-09  354  void nvdimm_free_dpa(struct nvdimm_drvdata *ndd, struct resource *res);
4a826c83d Dan Williams 2015-06-09  355  struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
4a826c83d Dan Williams 2015-06-09  356  		struct nd_label_id *label_id, resource_size_t start,
4a826c83d Dan Williams 2015-06-09  357  		resource_size_t n);
8c2f7e865 Dan Williams 2015-06-25  358  resource_size_t nvdimm_namespace_capacity(struct nd_namespace_common *ndns);
8c2f7e865 Dan Williams 2015-06-25  359  struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev);
5212e11fd Vishal Verma 2015-06-25  360  int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns);
298f2bc5d Dan Williams 2016-03-15  361  int nvdimm_namespace_detach_btt(struct nd_btt *nd_btt);
5212e11fd Vishal Verma 2015-06-25  362  const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
5212e11fd Vishal Verma 2015-06-25  363  		char *name);
f979b13c3 Dan Williams 2017-06-04  364  unsigned int pmem_sector_size(struct nd_namespace_common *ndns);
a39018029 Dan Williams 2016-04-07  365  void nvdimm_badblocks_populate(struct nd_region *nd_region,
a39018029 Dan Williams 2016-04-07  366  		struct badblocks *bb, const struct resource *res);
200c79da8 Dan Williams 2016-03-22  367  #if IS_ENABLED(CONFIG_ND_CLAIM)
ac515c084 Dan Williams 2016-03-22  368  struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
ac515c084 Dan Williams 2016-03-22  369  		struct resource *res, struct vmem_altmap *altmap);
200c79da8 Dan Williams 2016-03-22  370  int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio);
200c79da8 Dan Williams 2016-03-22  371  void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio);
200c79da8 Dan Williams 2016-03-22  372  #else
ac515c084 Dan Williams 2016-03-22  373  static inline struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
ac515c084 Dan Williams 2016-03-22  374  		struct resource *res, struct vmem_altmap *altmap)
ac515c084 Dan Williams 2016-03-22  375  {
ac515c084 Dan Williams 2016-03-22  376  	return ERR_PTR(-ENXIO);
ac515c084 Dan Williams 2016-03-22  377  }
200c79da8 Dan Williams 2016-03-22  378  static inline int devm_nsio_enable(struct device *dev,
200c79da8 Dan Williams 2016-03-22  379  		struct nd_namespace_io *nsio)
200c79da8 Dan Williams 2016-03-22  380  {
200c79da8 Dan Williams 2016-03-22  381  	return -ENXIO;
200c79da8 Dan Williams 2016-03-22  382  }
200c79da8 Dan Williams 2016-03-22  383  static inline void devm_nsio_disable(struct device *dev,
200c79da8 Dan Williams 2016-03-22  384  		struct nd_namespace_io *nsio)
200c79da8 Dan Williams 2016-03-22  385  {
200c79da8 Dan Williams 2016-03-22  386  }
200c79da8 Dan Williams 2016-03-22  387  #endif
047fc8a1f Ross Zwisler 2015-06-25  388  int nd_blk_region_init(struct nd_region *nd_region);
e5ae3b252 Dan Williams 2016-06-07  389  int nd_region_activate(struct nd_region *nd_region);
f0dc089ce Dan Williams 2015-05-16  390  void __nd_iostat_start(struct bio *bio, unsigned long *start);
f0dc089ce Dan Williams 2015-05-16  391  static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
f0dc089ce Dan Williams 2015-05-16  392  {
f0dc089ce Dan Williams 2015-05-16  393  	struct gendisk *disk = bio->bi_bdev->bd_disk;
f0dc089ce Dan Williams 2015-05-16  394  
f0dc089ce Dan Williams 2015-05-16  395  	if (!blk_queue_io_stat(disk->queue))
f0dc089ce Dan Williams 2015-05-16  396  		return false;
f0dc089ce Dan Williams 2015-05-16  397  
8d7c22ac0 Toshi Kani   2016-10-19  398  	*start = jiffies;
8d7c22ac0 Toshi Kani   2016-10-19  399  	generic_start_io_acct(bio_data_dir(bio),
8d7c22ac0 Toshi Kani   2016-10-19  400  			      bio_sectors(bio), &disk->part0);
f0dc089ce Dan Williams 2015-05-16  401  	return true;
f0dc089ce Dan Williams 2015-05-16  402  }
8d7c22ac0 Toshi Kani   2016-10-19  403  static inline void nd_iostat_end(struct bio *bio, unsigned long start)
8d7c22ac0 Toshi Kani   2016-10-19  404  {
8d7c22ac0 Toshi Kani   2016-10-19  405  	struct gendisk *disk = bio->bi_bdev->bd_disk;
8d7c22ac0 Toshi Kani   2016-10-19  406  
8d7c22ac0 Toshi Kani   2016-10-19 @407  	generic_end_io_acct(bio_data_dir(bio), &disk->part0, start);

:::::: The code at line 407 was first introduced by commit
:::::: 8d7c22ac0c036978a072b7e13c607b5402c474e0 libnvdimm: use generic iostat interfaces

:::::: TO: Toshi Kani <toshi.kani@hpe.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
