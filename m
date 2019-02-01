Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 485AB211C3F77
 for <linux-nvdimm@lists.01.org>; Thu, 31 Jan 2019 17:51:02 -0800 (PST)
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
 by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x111YlKe122546
 for <linux-nvdimm@lists.01.org>; Fri, 1 Feb 2019 01:51:02 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
 by aserp2130.oracle.com with ESMTP id 2q8d2em7tm-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <linux-nvdimm@lists.01.org>; Fri, 01 Feb 2019 01:51:01 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
 by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x111p15b010623
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
 for <linux-nvdimm@lists.01.org>; Fri, 1 Feb 2019 01:51:01 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
 by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x111p07K006604
 for <linux-nvdimm@lists.01.org>; Fri, 1 Feb 2019 01:51:01 GMT
From: jane.chu@oracle.com
Subject: Make sense to add ->pagesize in daxfs vm_ops ?
Message-ID: <1ea2d046-1064-17c9-c0f4-5030a623b350@oracle.com>
Date: Thu, 31 Jan 2019 17:50:59 -0800
MIME-Version: 1.0
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

The /proc/<pid>/smaps MMUPageSize field for a mapping backed by
a daxfs(xfs,ext4) on a namespace created in 2MiB alignment is 4KB.
It's understandable because both xfs and ext4's vm_operations_struct
are missing vm_ops->pagesize() - a callback that could potentially
retrieve the alignment value from the driver as implemented for 
dax_vm_ops for device-dax.

1GiB aligned /dev/dax2.0 :

7f19c0000000-7f1a40000000 rw-s 00000000 00:06 928839 
/dev/dax2.0
Size:            2097152 kB
KernelPageSize:  1048576 kB
MMUPageSize:     1048576 kB

/mnt_nm4/file2GB backed by /dev/pmem4 that is 2MiB aligned :

7fd3d5600000-7fd415600000 rw-p 00000000 103:03 195 
/mnt_nm4/file2GB
Size:            1048576 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB

Things work because xfs_file_mmap() always does
    if (IS_DAX(file_inode(filp)))
                 vma->vm_flags |= VM_HUGEPAGE;
Since it knows that it only support 2 pagesizes if S_DAX is set:
4K or 2M, it can always try dax_iomap_pmd_fault(), and that fails
then fall back to dax_iomap_pte_fault() later.

If the /dev/pmem device is created in 4K alignment and 4K pagesize
was intended, the extra code that needs to be executed per page fault
is unnecessary right?

7efdce200000-7efe0e200000 rw-p 00000000 103:02 195 
/mnt_nm3_4Kalign/file_2G
Size:            1048576 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
..
VmFlags: rd wr mr mw me ac sd mm hg  <= VM_HUGEPAGE set in 4K alignment

Would it make sense to add vm_ops->pagesize() op to xfs, and make
xfs_file_mmap() to check the pagesize() instead of always setting
VM_HUGEPAGE?  Same for ext4.

Doing so bring the additional benefit of exposing the true MMUPageSize
to users through procfs besides for daxfs not making assumptions on 
pagesize.


thanks!
-jane





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
