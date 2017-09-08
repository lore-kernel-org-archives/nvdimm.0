Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A102121E87969
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 13:17:06 -0700 (PDT)
Date: Sat, 9 Sep 2017 04:18:58 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-nvdimm:libnvdimm-for-next 22/22] drivers//nvdimm/btt.c:430:3:
 warning: format '%lx' expects argument of type 'long unsigned int',
 but argument 4 has type 'size_t'
Message-ID: <201709090455.GrDO2alc%fengguang.wu@intel.com>
MIME-Version: 1.0
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
head:   86652d2eb347080a991968c9d68708dc010ac56c
commit: 86652d2eb347080a991968c9d68708dc010ac56c [22/22] libnvdimm, btt: clean up warning and error messages
config: i386-randconfig-c0-09090349 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
reproduce:
        git checkout 86652d2eb347080a991968c9d68708dc010ac56c
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers//nvdimm/btt.c: In function 'btt_map_init':
>> drivers//nvdimm/btt.c:430:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'size_t' [-Wformat=]
      dev_WARN_ONCE(to_dev(arena), size < 512,
      ^
   drivers//nvdimm/btt.c: In function 'btt_log_init':
   drivers//nvdimm/btt.c:474:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'size_t' [-Wformat=]
      dev_WARN_ONCE(to_dev(arena), size < 512,
      ^

vim +430 drivers//nvdimm/btt.c

   402	
   403	/*
   404	 * This function initializes the BTT map to the initial state, which is
   405	 * all-zeroes, and indicates an identity mapping
   406	 */
   407	static int btt_map_init(struct arena_info *arena)
   408	{
   409		int ret = -EINVAL;
   410		void *zerobuf;
   411		size_t offset = 0;
   412		size_t chunk_size = SZ_2M;
   413		size_t mapsize = arena->logoff - arena->mapoff;
   414	
   415		zerobuf = kzalloc(chunk_size, GFP_KERNEL);
   416		if (!zerobuf)
   417			return -ENOMEM;
   418	
   419		/*
   420		 * mapoff should always be at least 512B  aligned. We rely on that to
   421		 * make sure rw_bytes does error clearing correctly, so make sure that
   422		 * is the case.
   423		 */
   424		dev_WARN_ONCE(to_dev(arena), !IS_ALIGNED(arena->mapoff, 512),
   425			"arena->mapoff: %#llx is unaligned\n", arena->mapoff);
   426	
   427		while (mapsize) {
   428			size_t size = min(mapsize, chunk_size);
   429	
 > 430			dev_WARN_ONCE(to_dev(arena), size < 512,
   431				"chunk size: %#lx is unaligned\n", size);
   432			ret = arena_write_bytes(arena, arena->mapoff + offset, zerobuf,
   433					size, 0);
   434			if (ret)
   435				goto free;
   436	
   437			offset += size;
   438			mapsize -= size;
   439			cond_resched();
   440		}
   441	
   442	 free:
   443		kfree(zerobuf);
   444		return ret;
   445	}
   446	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
