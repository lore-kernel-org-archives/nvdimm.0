Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 715AE212DD340
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jul 2019 22:49:16 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] mm/memory-failure: Poison read receives SIGKILL
 instead of SIGBUS if mmaped more than once
References: <1564007603-9655-1-git-send-email-jane.chu@oracle.com>
 <1564007603-9655-2-git-send-email-jane.chu@oracle.com>
 <20190724234318.GA21820@hori.linux.bs1.fc.nec.co.jp>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <3fa73abd-225c-cc71-719d-7ee296867ad4@oracle.com>
Date: Wed, 24 Jul 2019 22:46:31 -0700
MIME-Version: 1.0
In-Reply-To: <20190724234318.GA21820@hori.linux.bs1.fc.nec.co.jp>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 7/24/2019 4:43 PM, Naoya Horiguchi wrote:
> On Wed, Jul 24, 2019 at 04:33:23PM -0600, Jane Chu wrote:
>> Mmap /dev/dax more than once, then read the poison location using address
>> from one of the mappings. The other mappings due to not having the page
>> mapped in will cause SIGKILLs delivered to the process. SIGKILL succeeds
>> over SIGBUS, so user process looses the opportunity to handle the UE.
>>
>> Although one may add MAP_POPULATE to mmap(2) to work around the issue,
>> MAP_POPULATE makes mapping 128GB of pmem several magnitudes slower, so
>> isn't always an option.
>>
>> Details -
>>
>> ndctl inject-error --block=10 --count=1 namespace6.0
>>
>> ./read_poison -x dax6.0 -o 5120 -m 2
>> mmaped address 0x7f5bb6600000
>> mmaped address 0x7f3cf3600000
>> doing local read at address 0x7f3cf3601400
>> Killed
>>
>> Console messages in instrumented kernel -
>>
>> mce: Uncorrected hardware memory error in user-access at edbe201400
>> Memory failure: tk->addr = 7f5bb6601000
>> Memory failure: address edbe201: call dev_pagemap_mapping_shift
>> dev_pagemap_mapping_shift: page edbe201: no PUD
>> Memory failure: tk->size_shift == 0
>> Memory failure: Unable to find user space address edbe201 in read_poison
>> Memory failure: tk->addr = 7f3cf3601000
>> Memory failure: address edbe201: call dev_pagemap_mapping_shift
>> Memory failure: tk->size_shift = 21
>> Memory failure: 0xedbe201: forcibly killing read_poison:22434 because of failure to unmap corrupted page
>>    => to deliver SIGKILL
>> Memory failure: 0xedbe201: Killing read_poison:22434 due to hardware memory corruption
>>    => to deliver SIGBUS
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> ---
>>   mm/memory-failure.c | 62 ++++++++++++++++++++++-------------------------------
>>   1 file changed, 26 insertions(+), 36 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index d9cc660..bd4db33 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -199,7 +199,6 @@ struct to_kill {
>>   	struct task_struct *tsk;
>>   	unsigned long addr;
>>   	short size_shift;
>> -	char addr_valid;
>>   };
>>   
>>   /*
>> @@ -304,43 +303,43 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
>>   /*
>>    * Schedule a process for later kill.
>>    * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
>> - * TBD would GFP_NOIO be enough?
>>    */
>>   static void add_to_kill(struct task_struct *tsk, struct page *p,
>>   		       struct vm_area_struct *vma,
>> -		       struct list_head *to_kill,
>> -		       struct to_kill **tkc)
>> +		       struct list_head *to_kill)
>>   {
>>   	struct to_kill *tk;
>>   
>> -	if (*tkc) {
>> -		tk = *tkc;
>> -		*tkc = NULL;
>> -	} else {
>> -		tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
>> -		if (!tk) {
>> -			pr_err("Memory failure: Out of memory while machine check handling\n");
>> -			return;
>> -		}
>> +	tk = kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
>> +	if (!tk) {
>> +		pr_err("Memory failure: Out of memory while machine check handling\n");
>> +		return;
> 
> As Dan pointed out, the cleanup part can be delivered as a separate patch.

My bad, will take care splitting up the patch.

> 
>>   	}
>> +
>>   	tk->addr = page_address_in_vma(p, vma);
>> -	tk->addr_valid = 1;
>>   	if (is_zone_device_page(p))
>>   		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
>>   	else
>>   		tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
>>   
>>   	/*
>> -	 * In theory we don't have to kill when the page was
>> -	 * munmaped. But it could be also a mremap. Since that's
>> -	 * likely very rare kill anyways just out of paranoia, but use
>> -	 * a SIGKILL because the error is not contained anymore.
>> +	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
>> +	 * "tk->size_shift" is always non-zero for !is_zone_device_page(),
>> +	 * so "tk->size_shift == 0" effectively checks no mapping on
>> +	 * ZONE_DEVICE. Indeed, when a devdax page is mmapped N times
>> +	 * to a process' address space, it's possible not all N VMAs
>> +	 * contain mappings for the page, but at least one VMA does.
>> +	 * Only deliver SIGBUS with payload derived from the VMA that
>> +	 * has a mapping for the page.
> 
> OK, so SIGBUSs are sent M times (where M is the number of mappings
> for the page). Then I'm convinced that we need "else if" block below.

Yes. I run read_poison that mmaps /dev/dax 4 times with MAPS_POPULATE flag
set, so the kernel attempted sending SIGBUS 4 times.
One time, while the poison was consumed at uaddr[1] (2nd mmap), but the
SIGBUS payload indicated the si_addr was uaddr[3] (4th mmap).

thanks!
-jane


> 
> Thanks,
> Naoya Horiguchi
> 
>>   	 */
>> -	if (tk->addr == -EFAULT || tk->size_shift == 0) {
>> +	if (tk->addr == -EFAULT) {
>>   		pr_info("Memory failure: Unable to find user space address %lx in %s\n",
>>   			page_to_pfn(p), tsk->comm);
>> -		tk->addr_valid = 0;
>> +	} else if (tk->size_shift == 0) {
>> +		kfree(tk);
>> +		return;
>>   	}
>> +
>>   	get_task_struct(tsk);
>>   	tk->tsk = tsk;
>>   	list_add_tail(&tk->nd, to_kill);
>> @@ -366,7 +365,7 @@ static void kill_procs(struct list_head *to_kill, int forcekill, bool fail,
>>   			 * make sure the process doesn't catch the
>>   			 * signal and then access the memory. Just kill it.
>>   			 */
>> -			if (fail || tk->addr_valid == 0) {
>> +			if (fail || tk->addr == -EFAULT) {
>>   				pr_err("Memory failure: %#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
>>   				       pfn, tk->tsk->comm, tk->tsk->pid);
>>   				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,
>> @@ -432,7 +431,7 @@ static struct task_struct *task_early_kill(struct task_struct *tsk,
>>    * Collect processes when the error hit an anonymous page.
>>    */
>>   static void collect_procs_anon(struct page *page, struct list_head *to_kill,
>> -			      struct to_kill **tkc, int force_early)
>> +				int force_early)
>>   {
>>   	struct vm_area_struct *vma;
>>   	struct task_struct *tsk;
>> @@ -457,7 +456,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
>>   			if (!page_mapped_in_vma(page, vma))
>>   				continue;
>>   			if (vma->vm_mm == t->mm)
>> -				add_to_kill(t, page, vma, to_kill, tkc);
>> +				add_to_kill(t, page, vma, to_kill);
>>   		}
>>   	}
>>   	read_unlock(&tasklist_lock);
>> @@ -468,7 +467,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
>>    * Collect processes when the error hit a file mapped page.
>>    */
>>   static void collect_procs_file(struct page *page, struct list_head *to_kill,
>> -			      struct to_kill **tkc, int force_early)
>> +				int force_early)
>>   {
>>   	struct vm_area_struct *vma;
>>   	struct task_struct *tsk;
>> @@ -492,7 +491,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
>>   			 * to be informed of all such data corruptions.
>>   			 */
>>   			if (vma->vm_mm == t->mm)
>> -				add_to_kill(t, page, vma, to_kill, tkc);
>> +				add_to_kill(t, page, vma, to_kill);
>>   		}
>>   	}
>>   	read_unlock(&tasklist_lock);
>> @@ -501,26 +500,17 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
>>   
>>   /*
>>    * Collect the processes who have the corrupted page mapped to kill.
>> - * This is done in two steps for locking reasons.
>> - * First preallocate one tokill structure outside the spin locks,
>> - * so that we can kill at least one process reasonably reliable.
>>    */
>>   static void collect_procs(struct page *page, struct list_head *tokill,
>>   				int force_early)
>>   {
>> -	struct to_kill *tk;
>> -
>>   	if (!page->mapping)
>>   		return;
>>   
>> -	tk = kmalloc(sizeof(struct to_kill), GFP_NOIO);
>> -	if (!tk)
>> -		return;
>>   	if (PageAnon(page))
>> -		collect_procs_anon(page, tokill, &tk, force_early);
>> +		collect_procs_anon(page, tokill, force_early);
>>   	else
>> -		collect_procs_file(page, tokill, &tk, force_early);
>> -	kfree(tk);
>> +		collect_procs_file(page, tokill, force_early);
>>   }
>>   
>>   static const char *action_name[] = {
>> -- 
>> 1.8.3.1
>>
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
