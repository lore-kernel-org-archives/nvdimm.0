Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C077E211B6C2B
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 17:07:18 -0800 (PST)
Subject: Re: [PATCH] mm: hwpoison: use do_send_sig_info() instead of
 force_sig() (Re: PMEM error-handling forces SIGKILL causes kernel panic)
References: <e3c4c0e0-1434-4353-b893-2973c04e7ff7@oracle.com>
 <CAPcyv4j67n6H7hD6haXJqysbaauci4usuuj5c+JQ7VQBGngO1Q@mail.gmail.com>
 <20190111081401.GA5080@hori1.linux.bs1.fc.nec.co.jp>
 <20190116093046.GA29835@hori1.linux.bs1.fc.nec.co.jp>
 <97e179e1-8a3a-5acb-78c1-a4b06b33db4c@oracle.com>
 <20190116233207.GA5868@hori1.linux.bs1.fc.nec.co.jp>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <6fa27824-d86d-f642-db7c-a13faaac527d@oracle.com>
Date: Wed, 16 Jan 2019 17:07:09 -0800
MIME-Version: 1.0
In-Reply-To: <20190116233207.GA5868@hori1.linux.bs1.fc.nec.co.jp>
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
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 1/16/2019 3:32 PM, Naoya Horiguchi wrote:
> Hi Jane,
> 
> On Wed, Jan 16, 2019 at 09:56:02AM -0800, Jane Chu wrote:
>> Hi, Naoya,
>>
>> On 1/16/2019 1:30 AM, Naoya Horiguchi wrote:
>>
>>      diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>      index 7c72f2a95785..831be5ff5f4d 100644
>>      --- a/mm/memory-failure.c
>>      +++ b/mm/memory-failure.c
>>      @@ -372,7 +372,8 @@ static void kill_procs(struct list_head *to_kill, int forcekill, bool fail,
>>                              if (fail || tk->addr_valid == 0) {
>>                                      pr_err("Memory failure: %#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
>>                                             pfn, tk->tsk->comm, tk->tsk->pid);
>>      -                               force_sig(SIGKILL, tk->tsk);
>>      +                               do_send_sig_info(SIGKILL, SEND_SIG_PRIV,
>>      +                                                tk->tsk, PIDTYPE_PID);
>>                              }
>>
>>
>> Since we don't care the return from do_send_sig_info(), would you mind to
>> prefix it with (void) ?
> 
> Sorry, I'm not sure about the benefit to do casting the return value
> just being ignored, so personally I'd like keeping the code simple.
> Do you have some in mind?

It's just coding style I'm used to, no big deal.
Up to you to decide. :)

thanks,
-jane

> 
> - Naoya
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
