Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E562CA1
	for <nvdimm@lists.linux.dev>; Thu, 27 Jan 2022 19:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643312354; x=1674848354;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eY/bKymh/uUeFbsSmJKZ1CVvViDHVKHvZv1YTayd+uk=;
  b=TgyiV/kMrQHZVhlEZewZksvolnWtLjvJ1Lki6YktQjG5jL3JjW415Xld
   PD0UFpQxZJKQHDuqPqcgH/aGV1nR3svs3y91p9Urf7ZZpuphFOb+bPD+z
   Tj+HSFw34Jj2QXT0/qoNOWZOD7vPYPEDCI0vkjtL4aC9GUPVdWIN9Rclr
   OQCO3sJfA9B3FnFze9X7dJvrdtEJKBG9dC6jJ86qlfs5dPrwCZl8k2zZ4
   bH/X05Z0Kj8DNHkaNgt6IwWnsXOymEvs6FCIClChK0HECn/r2vP1wu+nr
   pKtiL1jO7asikl7irbvy6XupBf7ojcW9rJLJSEUfVU23MSpbUtQaek/4z
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245789382"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="245789382"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 11:39:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="618451561"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jan 2022 11:39:10 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nDAbu-000My1-2e; Thu, 27 Jan 2022 19:39:10 +0000
Date: Fri, 28 Jan 2022 03:39:05 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: kbuild-all@lists.01.org, djwong@kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v10 8/9] xfs: Implement ->notify_failure() for XFS
Message-ID: <202201280314.SI8wtlfT-lkp@intel.com>
References: <20220127124058.1172422-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127124058.1172422-9-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Shiyang,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linux/master]
[also build test ERROR on linus/master v5.17-rc1 next-20220127]
[cannot apply to xfs-linux/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220127-204239
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2c271fe77d52a0555161926c232cd5bc07178b39
config: ia64-defconfig (https://download.01.org/0day-ci/archive/20220128/202201280314.SI8wtlfT-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/cb7650562991fc273fbf4c53b6e3db4bb9bb0b5e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220127-204239
        git checkout cb7650562991fc273fbf4c53b6e3db4bb9bb0b5e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=ia64 SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from fs/xfs/xfs_buf.h:14,
                    from fs/xfs/xfs_linux.h:80,
                    from fs/xfs/xfs.h:22,
                    from fs/xfs/xfs_buf.c:6:
   include/linux/dax.h:73:30: warning: 'struct dax_holder_operations' declared inside parameter list will not be visible outside of this definition or declaration
      73 |                 const struct dax_holder_operations *ops)
         |                              ^~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_buf.c: In function 'xfs_alloc_buftarg':
>> fs/xfs/xfs_buf.c:1959:33: error: passing argument 3 of 'dax_register_holder' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1959 |                                 &xfs_dax_holder_operations);
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                 |
         |                                 const struct dax_holder_operations *
   In file included from fs/xfs/xfs_buf.h:14,
                    from fs/xfs/xfs_linux.h:80,
                    from fs/xfs/xfs.h:22,
                    from fs/xfs/xfs_buf.c:6:
   include/linux/dax.h:73:53: note: expected 'const struct dax_holder_operations *' but argument is of type 'const struct dax_holder_operations *'
      73 |                 const struct dax_holder_operations *ops)
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors
--
   In file included from fs/xfs/xfs_buf.h:14,
                    from fs/xfs/xfs_linux.h:80,
                    from fs/xfs/xfs.h:22,
                    from fs/xfs/xfs_notify_failure.c:6:
   include/linux/dax.h:73:30: warning: 'struct dax_holder_operations' declared inside parameter list will not be visible outside of this definition or declaration
      73 |                 const struct dax_holder_operations *ops)
         |                              ^~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/xfs_notify_failure.c:220:14: error: variable 'xfs_dax_holder_operations' has initializer but incomplete type
     220 | const struct dax_holder_operations xfs_dax_holder_operations = {
         |              ^~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/xfs_notify_failure.c:221:10: error: 'const struct dax_holder_operations' has no member named 'notify_failure'
     221 |         .notify_failure         = xfs_dax_notify_failure,
         |          ^~~~~~~~~~~~~~
   fs/xfs/xfs_notify_failure.c:221:35: warning: excess elements in struct initializer
     221 |         .notify_failure         = xfs_dax_notify_failure,
         |                                   ^~~~~~~~~~~~~~~~~~~~~~
   fs/xfs/xfs_notify_failure.c:221:35: note: (near initialization for 'xfs_dax_holder_operations')
>> fs/xfs/xfs_notify_failure.c:220:36: error: storage size of 'xfs_dax_holder_operations' isn't known
     220 | const struct dax_holder_operations xfs_dax_holder_operations = {
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/dax_register_holder +1959 fs/xfs/xfs_buf.c

  1938	
  1939	struct xfs_buftarg *
  1940	xfs_alloc_buftarg(
  1941		struct xfs_mount	*mp,
  1942		struct block_device	*bdev)
  1943	{
  1944		xfs_buftarg_t		*btp;
  1945	
  1946		btp = kmem_zalloc(sizeof(*btp), KM_NOFS);
  1947	
  1948		btp->bt_mount = mp;
  1949		btp->bt_dev =  bdev->bd_dev;
  1950		btp->bt_bdev = bdev;
  1951		btp->bt_daxdev = fs_dax_get_by_bdev(bdev, &btp->bt_dax_part_off);
  1952		if (btp->bt_daxdev) {
  1953			if (dax_get_holder(btp->bt_daxdev)) {
  1954				xfs_err(mp, "DAX device already in use?!");
  1955				goto error_free;
  1956			}
  1957	
  1958			dax_register_holder(btp->bt_daxdev, mp,
> 1959					&xfs_dax_holder_operations);
  1960		}
  1961	
  1962		/*
  1963		 * Buffer IO error rate limiting. Limit it to no more than 10 messages
  1964		 * per 30 seconds so as to not spam logs too much on repeated errors.
  1965		 */
  1966		ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
  1967				     DEFAULT_RATELIMIT_BURST);
  1968	
  1969		if (xfs_setsize_buftarg_early(btp, bdev))
  1970			goto error_free;
  1971	
  1972		if (list_lru_init(&btp->bt_lru))
  1973			goto error_free;
  1974	
  1975		if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
  1976			goto error_lru;
  1977	
  1978		btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
  1979		btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
  1980		btp->bt_shrinker.seeks = DEFAULT_SEEKS;
  1981		btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
  1982		if (register_shrinker(&btp->bt_shrinker))
  1983			goto error_pcpu;
  1984		return btp;
  1985	
  1986	error_pcpu:
  1987		percpu_counter_destroy(&btp->bt_io_count);
  1988	error_lru:
  1989		list_lru_destroy(&btp->bt_lru);
  1990	error_free:
  1991		kmem_free(btp);
  1992		return NULL;
  1993	}
  1994	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
