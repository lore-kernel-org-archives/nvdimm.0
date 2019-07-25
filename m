Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/1] mm/memory-failure: Poison read receives SIGKILL
 instead of SIGBUS issue
References: <1564007603-9655-1-git-send-email-jane.chu@oracle.com>
 <CAPcyv4iqdbL+=boCciMTgUEn-GU1RQQmBJtNU9RHoV84XNMS+g@mail.gmail.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <fa353250-2ea2-3be3-5e4d-1ccf7dc06014@oracle.com>
Date: Wed, 24 Jul 2019 22:39:38 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iqdbL+=boCciMTgUEn-GU1RQQmBJtNU9RHoV84XNMS+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 7/24/2019 3:52 PM, Dan Williams wrote:
> On Wed, Jul 24, 2019 at 3:35 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Changes in v2:
>>   - move 'tk' allocations internal to add_to_kill(), suggested by Dan;
> 
> Oh, sorry if it wasn't clear, this should move to its own patch that
> only does the cleanup, and then the follow on fix patch becomes
> smaller and more straightforward.
> 

Make sense, thanks! I'll split up the patch next.

thanks,
-jane
