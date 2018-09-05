From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] libnvdimm: nd_region flush callback support
Date: Wed, 5 Sep 2018 04:40:13 -0400 (EDT)
Message-ID: <1687915522.10201150.1536136813773.JavaMail.zimbra@redhat.com>
References: <20180904152917.GE17047@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180904152917.GE17047-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


Hello,

Thanks for the report.

> 
> Hi Pankaj,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
> [also build test WARNING on v4.19-rc2 next-20180831]
> [if your patch is applied to the wrong git tree, please drop us a note to
> help improve the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/Pankaj-Gupta/kvm-fake-DAX-device/20180903-160032
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
> libnvdimm-for-next
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
> :::::: branch date: 7 hours ago
> :::::: commit date: 7 hours ago
> 
>    drivers/nvdimm/pmem.c:116:25: sparse: expression using sizeof(void)
>    drivers/nvdimm/pmem.c:135:25: sparse: expression using sizeof(void)
> >> drivers/nvdimm/pmem.c:204:32: sparse: incorrect type in assignment
> >> (different base types) @@    expected restricted blk_status_t [usertype]
> >> bi_status @@    got e] bi_status @@

I will fix this in V2. Will wait for any review comments and address in v2.

Thanks,
Pankaj

>    drivers/nvdimm/pmem.c:204:32:    expected restricted blk_status_t
>    [usertype] bi_status
>    drivers/nvdimm/pmem.c:204:32:    got int
>    drivers/nvdimm/pmem.c:208:9: sparse: expression using sizeof(void)
>    drivers/nvdimm/pmem.c:208:9: sparse: expression using sizeof(void)
>    include/linux/bvec.h:82:37: sparse: expression using sizeof(void)
>    include/linux/bvec.h:82:37: sparse: expression using sizeof(void)
>    include/linux/bvec.h:83:32: sparse: expression using sizeof(void)
>    include/linux/bvec.h:83:32: sparse: expression using sizeof(void)
>    drivers/nvdimm/pmem.c:220:32: sparse: incorrect type in assignment
>    (different base types) @@    expected restricted blk_status_t [usertype]
>    bi_status @@    got e] bi_status @@
>    drivers/nvdimm/pmem.c:220:32:    expected restricted blk_status_t
>    [usertype] bi_status
>    drivers/nvdimm/pmem.c:220:32:    got int
> 
> #
> https://github.com/0day-ci/linux/commit/69b95edd2a1f4676361988fa36866b59427e2cfa
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 69b95edd2a1f4676361988fa36866b59427e2cfa
> vim +204 drivers/nvdimm/pmem.c
> 
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  107
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  108  static
> void write_pmem(void *pmem_addr, struct page *page,
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  109  		unsigned
> int off, unsigned int len)
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  110  {
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  111  	unsigned
> int chunk;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  112  	void
> *mem;
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  113
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  114  	while
> (len) {
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  115  		mem =
> kmap_atomic(page);
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06 @116  		chunk =
> min_t(unsigned int, len, PAGE_SIZE);
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  117
> 		memcpy_flushcache(pmem_addr, mem + off, chunk);
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  118
> 		kunmap_atomic(mem);
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  119  		len -=
> chunk;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  120  		off = 0;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  121  		page++;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  122
> 		pmem_addr += PAGE_SIZE;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  123  	}
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  124  }
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  125
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  126  static
> blk_status_t read_pmem(struct page *page, unsigned int off,
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  127  		void
> *pmem_addr, unsigned int len)
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  128  {
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  129  	unsigned
> int chunk;
> 60622d682 drivers/nvdimm/pmem.c Dan Williams      2018-05-03  130  	unsigned
> long rem;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  131  	void
> *mem;
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  132
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  133  	while
> (len) {
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  134  		mem =
> kmap_atomic(page);
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  135  		chunk =
> min_t(unsigned int, len, PAGE_SIZE);
> 60622d682 drivers/nvdimm/pmem.c Dan Williams      2018-05-03  136  		rem =
> memcpy_mcsafe(mem + off, pmem_addr, chunk);
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  137
> 		kunmap_atomic(mem);
> 60622d682 drivers/nvdimm/pmem.c Dan Williams      2018-05-03  138  		if (rem)
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  139  			return
> BLK_STS_IOERR;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  140  		len -=
> chunk;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  141  		off = 0;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  142  		page++;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  143
> 		pmem_addr += PAGE_SIZE;
> 98cc093cb drivers/nvdimm/pmem.c Huang Ying        2017-09-06  144  	}
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  145  	return
> BLK_STS_OK;
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  146  }
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  147
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  148  static
> blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
> 3f289dcb4 drivers/nvdimm/pmem.c Tejun Heo         2018-07-18  149
> 			unsigned int len, unsigned int off, unsigned int op,
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  150
> 			sector_t sector)
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  151  {
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  152
> 	blk_status_t rc = BLK_STS_OK;
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  153  	bool
> bad_pmem = false;
> 32ab0a3f5 drivers/nvdimm/pmem.c Dan Williams      2015-08-01  154
> 	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> 7a9eb2066 drivers/nvdimm/pmem.c Dan Williams      2016-06-03  155  	void
> *pmem_addr = pmem->virt_addr + pmem_off;
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  156
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  157  	if
> (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  158  		bad_pmem
> = true;
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  159
> 3f289dcb4 drivers/nvdimm/pmem.c Tejun Heo         2018-07-18  160  	if
> (!op_is_write(op)) {
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  161  		if
> (unlikely(bad_pmem))
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  162  			rc =
> BLK_STS_IOERR;
> b5ebc8ec6 drivers/nvdimm/pmem.c Dan Williams      2016-03-06  163  		else {
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  164  			rc =
> read_pmem(page, off, pmem_addr, len);
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  165
> 			flush_dcache_page(page);
> b5ebc8ec6 drivers/nvdimm/pmem.c Dan Williams      2016-03-06  166  		}
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  167  	} else {
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  168  		/*
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  169  		 * Note
> that we write the data both before and after
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  170  		 *
> clearing poison.  The write before clear poison
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  171  		 *
> handles situations where the latest written data is
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  172  		 *
> preserved and the clear poison operation simply marks
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  173  		 * the
> address range as valid without changing the data.
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  174  		 * In
> this case application software can assume that an
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  175  		 *
> interrupted write will either return the new good
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  176  		 * data
> or an error.
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  177  		 *
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  178  		 *
> However, if pmem_clear_poison() leaves the data in an
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  179  		 *
> indeterminate state we need to perform the write
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  180  		 * after
> clear poison.
> 0a370d261 drivers/nvdimm/pmem.c Dan Williams      2016-04-14  181  		 */
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  182
> 		flush_dcache_page(page);
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  183
> 		write_pmem(pmem_addr, page, off, len);
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  184  		if
> (unlikely(bad_pmem)) {
> 3115bb02b drivers/nvdimm/pmem.c Toshi Kani        2016-10-13  185  			rc =
> pmem_clear_poison(pmem, pmem_off, len);
> bd697a80c drivers/nvdimm/pmem.c Vishal Verma      2016-09-30  186
> 			write_pmem(pmem_addr, page, off, len);
> 59e647398 drivers/nvdimm/pmem.c Dan Williams      2016-03-08  187  		}
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  188  	}
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  189
> b5ebc8ec6 drivers/nvdimm/pmem.c Dan Williams      2016-03-06  190  	return
> rc;
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  191  }
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  192
> dece16353 drivers/nvdimm/pmem.c Jens Axboe        2015-11-05  193  static
> blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  194  {
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  195
> 	blk_status_t rc = 0;
> f0dc089ce drivers/nvdimm/pmem.c Dan Williams      2015-05-16  196  	bool
> do_acct;
> f0dc089ce drivers/nvdimm/pmem.c Dan Williams      2015-05-16  197  	unsigned
> long start;
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  198  	struct
> bio_vec bvec;
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  199  	struct
> bvec_iter iter;
> bd842b8ca drivers/nvdimm/pmem.c Dan Williams      2016-03-18  200  	struct
> pmem_device *pmem = q->queuedata;
> 7e267a8c7 drivers/nvdimm/pmem.c Dan Williams      2016-06-01  201  	struct
> nd_region *nd_region = to_region(pmem);
> 7e267a8c7 drivers/nvdimm/pmem.c Dan Williams      2016-06-01  202
> d2d6364dc drivers/nvdimm/pmem.c Ross Zwisler      2018-06-06  203  	if
> (bio->bi_opf & REQ_PREFLUSH)
> 69b95edd2 drivers/nvdimm/pmem.c Pankaj Gupta      2018-08-31 @204
> 		bio->bi_status = nd_region->flush(nd_region);
> 69b95edd2 drivers/nvdimm/pmem.c Pankaj Gupta      2018-08-31  205
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  206
> f0dc089ce drivers/nvdimm/pmem.c Dan Williams      2015-05-16  207  	do_acct =
> nd_iostat_start(bio, &start);
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  208
> 	bio_for_each_segment(bvec, bio, iter) {
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  209  		rc =
> pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
> 3f289dcb4 drivers/nvdimm/pmem.c Tejun Heo         2018-07-18  210
> 				bvec.bv_offset, bio_op(bio), iter.bi_sector);
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  211  		if (rc)
> {
> 4e4cbee93 drivers/nvdimm/pmem.c Christoph Hellwig 2017-06-03  212
> 			bio->bi_status = rc;
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  213  			break;
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  214  		}
> e10624f8c drivers/nvdimm/pmem.c Dan Williams      2016-01-06  215  	}
> f0dc089ce drivers/nvdimm/pmem.c Dan Williams      2015-05-16  216  	if
> (do_acct)
> f0dc089ce drivers/nvdimm/pmem.c Dan Williams      2015-05-16  217
> 		nd_iostat_end(bio, start);
> 61031952f drivers/nvdimm/pmem.c Ross Zwisler      2015-06-25  218
> 1eff9d322 drivers/nvdimm/pmem.c Jens Axboe        2016-08-05  219  	if
> (bio->bi_opf & REQ_FUA)
> 69b95edd2 drivers/nvdimm/pmem.c Pankaj Gupta      2018-08-31  220
> 		bio->bi_status = nd_region->flush(nd_region);
> 61031952f drivers/nvdimm/pmem.c Ross Zwisler      2015-06-25  221
> 4246a0b63 drivers/nvdimm/pmem.c Christoph Hellwig 2015-07-20  222
> 	bio_endio(bio);
> dece16353 drivers/nvdimm/pmem.c Jens Axboe        2015-11-05  223  	return
> BLK_QC_T_NONE;
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  224  }
> 9e853f231 drivers/block/pmem.c  Ross Zwisler      2015-04-01  225
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
