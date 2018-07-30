Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85F012098C8DB
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 09:45:11 -0700 (PDT)
Date: Mon, 30 Jul 2018 09:44:59 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH] ipc/shm.c add ->pagesize function to shm_vm_ops
Message-ID: <20180730164459.zduhnk7itoldqnom@linux-r8p5>
References: <20180727211727.5020-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180727211727.5020-1-jane.chu@oracle.com>
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
To: Jane Chu <jane.chu@oracle.com>
Cc: mhocko@suse.com, jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 27 Jul 2018, Jane Chu wrote:

>Commit 05ea88608d4e13 (mm, hugetlbfs: introduce ->pagesize() to
>vm_operations_struct) adds a new ->pagesize() function to
>hugetlb_vm_ops, intended to cover all hugetlbfs backed files.
>
>With System V shared memory model, if "huge page" is specified,
>the "shared memory" is backed by hugetlbfs files, but the mappings
>initiated via shmget/shmat have their original vm_ops overwritten
>with shm_vm_ops, so we need to add a ->pagesize function to shm_vm_ops.
>Otherwise, vma_kernel_pagesize() returns PAGE_SIZE given a hugetlbfs
>backed vma, result in below BUG:
>
>fs/hugetlbfs/inode.c
>        443             if (unlikely(page_mapped(page))) {
>        444                     BUG_ON(truncate_op);
>
>[  242.268342] hugetlbfs: oracle (4592): Using mlock ulimits for SHM_HUGETLB is deprecated
>[  282.653208] ------------[ cut here ]------------
>[  282.708447] kernel BUG at fs/hugetlbfs/inode.c:444!
>[  282.818957] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 ...
>[  284.025873] CPU: 35 PID: 5583 Comm: oracle_5583_sbt Not tainted 4.14.35-1829.el7uek.x86_64 #2
>[  284.246609] task: ffff9bf0507aaf80 task.stack: ffffa9e625628000
>[  284.317455] RIP: 0010:remove_inode_hugepages+0x3db/0x3e2
>....
>[  285.292389] Call Trace:
>[  285.321630]  hugetlbfs_evict_inode+0x1e/0x3e
>[  285.372707]  evict+0xdb/0x1af
>[  285.408185]  iput+0x1a2/0x1f7
>[  285.443661]  dentry_unlink_inode+0xc6/0xf0
>[  285.492661]  __dentry_kill+0xd8/0x18d
>[  285.536459]  dput+0x1b5/0x1ed
>[  285.571939]  __fput+0x18b/0x216
>[  285.609495]  ____fput+0xe/0x10
>[  285.646030]  task_work_run+0x90/0xa7
>[  285.688788]  exit_to_usermode_loop+0xdd/0x116
>[  285.740905]  do_syscall_64+0x187/0x1ae
>[  285.785740]  entry_SYSCALL_64_after_hwframe+0x150/0x0
>
>Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
>Signed-off-by: Jane Chu <jane.chu@oracle.com>

Acked-by: Davidlohr Bueso <dbueso@suse.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
