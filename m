Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29557210C42A7
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 17:40:27 -0700 (PDT)
Subject: Re: [PATCH] ipc/shm.c add ->pagesize function to shm_vm_ops
References: <20180727211727.5020-1-jane.chu@oracle.com>
 <20180727145009.5dde68fb680ec148a7504f37@linux-foundation.org>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <6ea01f10-066a-6fe6-bf82-3a3b4ddf1175@oracle.com>
Date: Fri, 27 Jul 2018 17:40:16 -0700
MIME-Version: 1.0
In-Reply-To: <20180727145009.5dde68fb680ec148a7504f37@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave@stgolabs.net, jack@suse.cz, linux-nvdimm@lists.01.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

Hi, Andrew,

On 7/27/2018 2:50 PM, Andrew Morton wrote:

> On Fri, 27 Jul 2018 15:17:27 -0600 Jane Chu <jane.chu@oracle.com> wrote:
>
>> Commit 05ea88608d4e13 (mm, hugetlbfs: introduce ->pagesize() to
>> vm_operations_struct) adds a new ->pagesize() function to
>> hugetlb_vm_ops, intended to cover all hugetlbfs backed files.
> That was merged three months ago.  Can you suggest why this was only
> noticed now?

The issue was recently reported by a QA engineer running Oracle database
test in Oracle Linux. He first noticed the issue in upstream 4.17, then 4.18,
but because the issue wasn't in Oracle product, it wasn't reported, not
until I cherry picked the patch into Oracle Linux recently.

> What workload triggered this?  I see no cc:stable, but 4.17 is affected?

It's Oracle database workload. Large shared memory segments(SGAs) were created
and shared among dozens to hundreds of processes. The crash occurs when the
test stops the database workload.  I do not have access to the test source.
Yes, 4.17 is affected.

>> With System V shared memory model, if "huge page" is specified,
>> the "shared memory" is backed by hugetlbfs files, but the mappings
>> initiated via shmget/shmat have their original vm_ops overwritten
>> with shm_vm_ops, so we need to add a ->pagesize function to shm_vm_ops.
>> Otherwise, vma_kernel_pagesize() returns PAGE_SIZE given a hugetlbfs
>> backed vma, result in below BUG:
>>
>> fs/hugetlbfs/inode.c
>>          443             if (unlikely(page_mapped(page))) {
>>          444                     BUG_ON(truncate_op);
> OK, help me out here.  How does an incorrect return value from
> vma_kernel_pagesize() result in remove_inode_hugepages() deciding that
> it's truncating a mapped page?

To be honest, I don't have a satisfactory answer to how the wrong
pagesize causes a page that's about to be truncated remain mapped.
I relied on the hind sight of BUG_ON(truncate_op).

At a time I inserted dump_stack() into vma_kernel_pagesize() as Mike
suggested to try to dig out more,

unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
{
-       if (vma->vm_ops && vma->vm_ops->pagesize)
+       if (vma->vm_ops && vma->vm_ops->pagesize) {
                 return vma->vm_ops->pagesize(vma);
+        } else if (is_vm_hugetlb_page(vma)) {
+               struct hstate *hstate;
+               dump_stack();
+               hstate = hstate_vma(vma);
+               return 1UL << huge_page_shift(hstate);
+       }
         return PAGE_SIZE;
}

There were too many stack traces that clogged the console, I didn't
capture the entire output, perhaps I should go back to capture them.

Any other ideas?

Regards,
-jane


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
