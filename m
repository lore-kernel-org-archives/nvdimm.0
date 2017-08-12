Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4860C2095DFE2
 for <linux-nvdimm@lists.01.org>; Sat, 12 Aug 2017 01:44:45 -0700 (PDT)
Date: Sat, 12 Aug 2017 16:46:33 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 5/7] mm:swap: use on-stack-bio for BDI_CAP_SYNCHRONOUS
 device
Message-ID: <201708121619.CYNstSAy%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1502428647-28928-6-git-send-email-minchan@kernel.org>
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
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, kbuild-all@01.org, seungho1.park@lge.com, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Minchan,

[auto build test ERROR on mmotm/master]
[also build test ERROR on next-20170811]
[cannot apply to linus/master v4.13-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Minchan-Kim/Replace-rw_page-with-on-stack-bio/20170812-152541
base:   git://git.cmpxchg.org/linux-mmotm.git master
config: sparc64-allmodconfig (attached as .config)
compiler: sparc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=sparc64 

All errors (new ones prefixed by >>):

   mm/page_io.c: In function '__swap_writepage':
>> mm/page_io.c:345:11: error: passing argument 1 of 'bio_get' from incompatible pointer type [-Werror=incompatible-pointer-types]
      bio_get(&bio);
              ^
   In file included from include/linux/writeback.h:205:0,
                    from include/linux/memcontrol.h:31,
                    from include/linux/swap.h:8,
                    from mm/page_io.c:17:
   include/linux/bio.h:252:20: note: expected 'struct bio *' but argument is of type 'struct bio **'
    static inline void bio_get(struct bio *bio)
                       ^~~~~~~
   cc1: some warnings being treated as errors

vim +/bio_get +345 mm/page_io.c

   275	
   276	int __swap_writepage(struct page *page, struct writeback_control *wbc)
   277	{
   278		int ret;
   279		struct swap_info_struct *sis = page_swap_info(page);
   280		struct bio *bio;
   281		/* on-stack-bio */
   282		struct bio sbio;
   283		struct bio_vec sbvec;
   284	
   285		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
   286		if (sis->flags & SWP_FILE) {
   287			struct kiocb kiocb;
   288			struct file *swap_file = sis->swap_file;
   289			struct address_space *mapping = swap_file->f_mapping;
   290			struct bio_vec bv = {
   291				.bv_page = page,
   292				.bv_len  = PAGE_SIZE,
   293				.bv_offset = 0
   294			};
   295			struct iov_iter from;
   296	
   297			iov_iter_bvec(&from, ITER_BVEC | WRITE, &bv, 1, PAGE_SIZE);
   298			init_sync_kiocb(&kiocb, swap_file);
   299			kiocb.ki_pos = page_file_offset(page);
   300	
   301			set_page_writeback(page);
   302			unlock_page(page);
   303			ret = mapping->a_ops->direct_IO(&kiocb, &from);
   304			if (ret == PAGE_SIZE) {
   305				count_vm_event(PSWPOUT);
   306				ret = 0;
   307			} else {
   308				/*
   309				 * In the case of swap-over-nfs, this can be a
   310				 * temporary failure if the system has limited
   311				 * memory for allocating transmit buffers.
   312				 * Mark the page dirty and avoid
   313				 * rotate_reclaimable_page but rate-limit the
   314				 * messages but do not flag PageError like
   315				 * the normal direct-to-bio case as it could
   316				 * be temporary.
   317				 */
   318				set_page_dirty(page);
   319				ClearPageReclaim(page);
   320				pr_err_ratelimited("Write error on dio swapfile (%llu)\n",
   321						   page_file_offset(page));
   322			}
   323			end_page_writeback(page);
   324			return ret;
   325		}
   326	
   327		ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
   328		if (!ret) {
   329			count_swpout_vm_event(page);
   330			return 0;
   331		}
   332	
   333		ret = 0;
   334		if (!(sis->flags & SWP_SYNC_IO)) {
   335	
   336			bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
   337			if (bio == NULL) {
   338				set_page_dirty(page);
   339				unlock_page(page);
   340				ret = -ENOMEM;
   341				goto out;
   342			}
   343		} else {
   344			bio = &sbio;
 > 345			bio_get(&bio);
   346	
   347			bio_init(&sbio, &sbvec, 1);
   348			sbio.bi_bdev = sis->bdev;
   349			sbio.bi_iter.bi_sector = swap_page_sector(page);
   350			sbio.bi_end_io = end_swap_bio_write;
   351			bio_add_page(&sbio, page, PAGE_SIZE, 0);
   352		}
   353	
   354		bio_set_op_attrs(bio, REQ_OP_WRITE, wbc_to_write_flags(wbc));
   355		set_page_writeback(page);
   356		unlock_page(page);
   357		submit_bio(bio);
   358		count_swpout_vm_event(page);
   359	out:
   360		return ret;
   361	}
   362	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
