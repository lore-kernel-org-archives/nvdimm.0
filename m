Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DC1121E14554
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 01:04:04 -0700 (PDT)
Date: Thu, 17 Aug 2017 16:06:03 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
Message-ID: <201708171601.hxeGHqMv%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kbuild-all@01.org, luto@kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.13-rc5 next-20170816]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/fs-xfs-introduce-S_IOMAP_SEALED/20170817-114711
config: xtensa-allmodconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All errors (new ones prefixed by >>):

   mm/mmap.c: In function 'do_mmap':
>> mm/mmap.c:1391:8: error: 'MAP_VALIDATE' undeclared (first use in this function)
      case MAP_VALIDATE:
           ^
   mm/mmap.c:1391:8: note: each undeclared identifier is reported only once for each function it appears in

vim +/MAP_VALIDATE +1391 mm/mmap.c

  1316	
  1317	/*
  1318	 * The caller must hold down_write(&current->mm->mmap_sem).
  1319	 */
  1320	unsigned long do_mmap(struct file *file, unsigned long addr,
  1321				unsigned long len, unsigned long prot,
  1322				unsigned long flags, vm_flags_t vm_flags,
  1323				unsigned long pgoff, unsigned long *populate,
  1324				struct list_head *uf)
  1325	{
  1326		struct mm_struct *mm = current->mm;
  1327		int pkey = 0;
  1328	
  1329		*populate = 0;
  1330	
  1331		if (!len)
  1332			return -EINVAL;
  1333	
  1334		/*
  1335		 * Does the application expect PROT_READ to imply PROT_EXEC?
  1336		 *
  1337		 * (the exception is when the underlying filesystem is noexec
  1338		 *  mounted, in which case we dont add PROT_EXEC.)
  1339		 */
  1340		if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
  1341			if (!(file && path_noexec(&file->f_path)))
  1342				prot |= PROT_EXEC;
  1343	
  1344		if (!(flags & MAP_FIXED))
  1345			addr = round_hint_to_min(addr);
  1346	
  1347		/* Careful about overflows.. */
  1348		len = PAGE_ALIGN(len);
  1349		if (!len)
  1350			return -ENOMEM;
  1351	
  1352		/* offset overflow? */
  1353		if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
  1354			return -EOVERFLOW;
  1355	
  1356		/* Too many mappings? */
  1357		if (mm->map_count > sysctl_max_map_count)
  1358			return -ENOMEM;
  1359	
  1360		/* Obtain the address to map to. we verify (or select) it and ensure
  1361		 * that it represents a valid section of the address space.
  1362		 */
  1363		addr = get_unmapped_area(file, addr, len, pgoff, flags);
  1364		if (offset_in_page(addr))
  1365			return addr;
  1366	
  1367		if (prot == PROT_EXEC) {
  1368			pkey = execute_only_pkey(mm);
  1369			if (pkey < 0)
  1370				pkey = 0;
  1371		}
  1372	
  1373		/* Do simple checking here so the lower-level routines won't have
  1374		 * to. we assume access permissions have been handled by the open
  1375		 * of the memory object, so we don't do any here.
  1376		 */
  1377		vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
  1378				mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
  1379	
  1380		if (flags & MAP_LOCKED)
  1381			if (!can_do_mlock())
  1382				return -EPERM;
  1383	
  1384		if (mlock_future_check(mm, vm_flags, len))
  1385			return -EAGAIN;
  1386	
  1387		if (file) {
  1388			struct inode *inode = file_inode(file);
  1389	
  1390			switch (flags & MAP_TYPE) {
> 1391			case MAP_VALIDATE:
  1392				if (flags & ~(MAP_SUPPORTED_MASK | MAP_VALIDATE))
  1393					return -EINVAL;
  1394				if (!file->f_op->fmmap)
  1395					return -EOPNOTSUPP;
  1396				/* fall through */
  1397			case MAP_SHARED:
  1398				if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
  1399					return -EACCES;
  1400	
  1401				/*
  1402				 * Make sure we don't allow writing to an append-only
  1403				 * file..
  1404				 */
  1405				if (IS_APPEND(inode) && (file->f_mode & FMODE_WRITE))
  1406					return -EACCES;
  1407	
  1408				/*
  1409				 * Make sure there are no mandatory locks on the file.
  1410				 */
  1411				if (locks_verify_locked(file))
  1412					return -EAGAIN;
  1413	
  1414				vm_flags |= VM_SHARED | VM_MAYSHARE;
  1415				if (!(file->f_mode & FMODE_WRITE))
  1416					vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
  1417	
  1418				/* fall through */
  1419			case MAP_PRIVATE:
  1420				if (!(file->f_mode & FMODE_READ))
  1421					return -EACCES;
  1422				if (path_noexec(&file->f_path)) {
  1423					if (vm_flags & VM_EXEC)
  1424						return -EPERM;
  1425					vm_flags &= ~VM_MAYEXEC;
  1426				}
  1427	
  1428				if (!file->f_op->mmap)
  1429					return -ENODEV;
  1430				if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
  1431					return -EINVAL;
  1432				break;
  1433	
  1434			default:
  1435				return -EINVAL;
  1436			}
  1437		} else {
  1438			switch (flags & MAP_TYPE) {
  1439			case MAP_SHARED:
  1440				if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
  1441					return -EINVAL;
  1442				/*
  1443				 * Ignore pgoff.
  1444				 */
  1445				pgoff = 0;
  1446				vm_flags |= VM_SHARED | VM_MAYSHARE;
  1447				break;
  1448			case MAP_PRIVATE:
  1449				/*
  1450				 * Set pgoff according to addr for anon_vma.
  1451				 */
  1452				pgoff = addr >> PAGE_SHIFT;
  1453				break;
  1454			default:
  1455				return -EINVAL;
  1456			}
  1457		}
  1458	
  1459		/*
  1460		 * Set 'VM_NORESERVE' if we should not account for the
  1461		 * memory use of this mapping.
  1462		 */
  1463		if (flags & MAP_NORESERVE) {
  1464			/* We honor MAP_NORESERVE if allowed to overcommit */
  1465			if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
  1466				vm_flags |= VM_NORESERVE;
  1467	
  1468			/* hugetlb applies strict overcommit unless MAP_NORESERVE */
  1469			if (file && is_file_hugepages(file))
  1470				vm_flags |= VM_NORESERVE;
  1471		}
  1472	
  1473		if ((flags & MAP_VALIDATE) == MAP_VALIDATE)
  1474			flags &= MAP_SUPPORTED_MASK;
  1475		else
  1476			flags = 0;
  1477	
  1478		addr = mmap_region(file, addr, len, vm_flags, pgoff, uf, flags);
  1479		if (!IS_ERR_VALUE(addr) &&
  1480		    ((vm_flags & VM_LOCKED) ||
  1481		     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
  1482			*populate = len;
  1483		return addr;
  1484	}
  1485	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
