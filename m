Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0BA9202110C1
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 21:47:01 -0700 (PDT)
Subject: Re: [PATCH] nvdimm/of_pmem: Provide a unique name for bus provider
References: <20190807040029.11344-1-aneesh.kumar@linux.ibm.com>
 <156711523501.12658.8795324273505326478.git-patchwork-notify@kernel.org>
 <87lfvbnujk.fsf@linux.ibm.com>
 <CAPcyv4g7nQ201DV6r1-2Jq2vyHWzstHD2txwZvR5z6NMY_mqiw@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <ccf23b5e-4dc8-14c6-31db-cef3bfdf7269@linux.ibm.com>
Date: Fri, 30 Aug 2019 10:15:07 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g7nQ201DV6r1-2Jq2vyHWzstHD2txwZvR5z6NMY_mqiw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 8/30/19 10:10 AM, Dan Williams wrote:
> On Thu, Aug 29, 2019 at 9:31 PM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
>>
>> patchwork-bot+linux-nvdimm@kernel.org writes:
>>
>>> Hello:
>>>
>>> This patch was applied to nvdimm/nvdimm.git (refs/heads/libnvdimm-for-next).
>>>
>>> On Wed,  7 Aug 2019 09:30:29 +0530 you wrote:
>>>> ndctl utility requires the ndbus to have unique names. If not while
>>>> enumerating the bus in userspace it drops bus with similar names.
>>>> This results in us not listing devices beneath the bus.
>>>>
>>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>>>> ---
>>>>   drivers/nvdimm/of_pmem.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>>
>>> Here is a summary with links:
>>>    - nvdimm/of_pmem: Provide a unique name for bus provider
>>>      https://git.kernel.org/nvdimm/nvdimm/c/49bddc73d15c25a68e4294d76fc74519fda984cd
>>>
>>> You are awesome, thank you!
>>
>> We decided to fix this in ndctl tool? If we go with ndctl fix, we
>> can drop the kernel change.
> 
> Oh, I was planning to do both any concerns if I keep the kernel
> change, otherwise I'll need to rebase the branch.
> 

I guess rebasing is not going to be nice. So we can keep the patch and 
if we are really need to move the provider name to indicate backend 
driver, I will fixup both of_pmem and papr_scm together.

Thanks.
-aneesh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
