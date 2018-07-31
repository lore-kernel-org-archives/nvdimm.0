Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6F43210C1247
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 20:07:11 -0700 (PDT)
Subject: Re: [PATCH] ipc/shm.c add ->pagesize function to shm_vm_ops
References: <20180727211727.5020-1-jane.chu@oracle.com>
 <20180728190248.GA883@bombadil.infradead.org>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <026b057d-ec11-9273-40bc-072a8958bb64@oracle.com>
Date: Mon, 30 Jul 2018 20:06:40 -0700
MIME-Version: 1.0
In-Reply-To: <20180728190248.GA883@bombadil.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: mhocko@suse.com, jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, dave@stgolabs.net, akpm@linux-foundation.org, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

Hi, Mathew,


On 7/28/2018 12:02 PM, Matthew Wilcox wrote:
> On Fri, Jul 27, 2018 at 03:17:27PM -0600, Jane Chu wrote:
>> +++ b/include/linux/mm.h
>> @@ -387,6 +387,13 @@ enum page_entry_size {
>>    * These are the virtual MM functions - opening of an area, closing and
>>    * unmapping it (needed to keep files on disk up-to-date etc), pointer
>>    * to the functions called when a no-page or a wp-page exception occurs.
>> + *
>> + * Note, when a new function is introduced to vm_operations_struct and
>> + * added to hugetlb_vm_ops, please consider adding the function to
>> + * shm_vm_ops. This is because under System V memory model, though
>> + * mappings created via shmget/shmat with "huge page" specified are
>> + * backed by hugetlbfs files, their original vm_ops are overwritten with
>> + * shm_vm_ops.
>>    */
>>   struct vm_operations_struct {
> I don't think this header file is the right place for this comment.
> I'd think a better place for it would be at the definition of hugetlb_vm_ops.

Agreed, will make the change.
Thanks for reviewing!

-jane

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
