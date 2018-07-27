Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDA8A20986AD0
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 14:50:12 -0700 (PDT)
Date: Fri, 27 Jul 2018 14:50:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ipc/shm.c add ->pagesize function to shm_vm_ops
Message-Id: <20180727145009.5dde68fb680ec148a7504f37@linux-foundation.org>
In-Reply-To: <20180727211727.5020-1-jane.chu@oracle.com>
References: <20180727211727.5020-1-jane.chu@oracle.com>
Mime-Version: 1.0
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
To: Jane Chu <jane.chu@oracle.com>
Cc: dave@stgolabs.net, jack@suse.cz, linux-nvdimm@lists.01.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 27 Jul 2018 15:17:27 -0600 Jane Chu <jane.chu@oracle.com> wrote:

> Commit 05ea88608d4e13 (mm, hugetlbfs: introduce ->pagesize() to
> vm_operations_struct) adds a new ->pagesize() function to
> hugetlb_vm_ops, intended to cover all hugetlbfs backed files.

That was merged three months ago.  Can you suggest why this was only
noticed now?

What workload triggered this?  I see no cc:stable, but 4.17 is affected?

> With System V shared memory model, if "huge page" is specified,
> the "shared memory" is backed by hugetlbfs files, but the mappings
> initiated via shmget/shmat have their original vm_ops overwritten
> with shm_vm_ops, so we need to add a ->pagesize function to shm_vm_ops.
> Otherwise, vma_kernel_pagesize() returns PAGE_SIZE given a hugetlbfs
> backed vma, result in below BUG:
> 
> fs/hugetlbfs/inode.c
>         443             if (unlikely(page_mapped(page))) {
>         444                     BUG_ON(truncate_op);

OK, help me out here.  How does an incorrect return value from
vma_kernel_pagesize() result in remove_inode_hugepages() deciding that
it's truncating a mapped page?


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
