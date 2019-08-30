Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A85152020D32A
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 21:33:24 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7U4QnXE084609
 for <linux-nvdimm@lists.01.org>; Fri, 30 Aug 2019 00:31:34 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2upjrv2g5w-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 30 Aug 2019 00:31:34 -0400
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Fri, 30 Aug 2019 05:31:32 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] nvdimm/of_pmem: Provide a unique name for bus provider
In-Reply-To: <156711523501.12658.8795324273505326478.git-patchwork-notify@kernel.org>
References: <20190807040029.11344-1-aneesh.kumar@linux.ibm.com>
 <156711523501.12658.8795324273505326478.git-patchwork-notify@kernel.org>
Date: Fri, 30 Aug 2019 10:01:27 +0530
MIME-Version: 1.0
Message-Id: <87lfvbnujk.fsf@linux.ibm.com>
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
To: linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

patchwork-bot+linux-nvdimm@kernel.org writes:

> Hello:
>
> This patch was applied to nvdimm/nvdimm.git (refs/heads/libnvdimm-for-next).
>
> On Wed,  7 Aug 2019 09:30:29 +0530 you wrote:
>> ndctl utility requires the ndbus to have unique names. If not while
>> enumerating the bus in userspace it drops bus with similar names.
>> This results in us not listing devices beneath the bus.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>  drivers/nvdimm/of_pmem.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> Here is a summary with links:
>   - nvdimm/of_pmem: Provide a unique name for bus provider
>     https://git.kernel.org/nvdimm/nvdimm/c/49bddc73d15c25a68e4294d76fc74519fda984cd
>
> You are awesome, thank you!

We decided to fix this in ndctl tool? If we go with ndctl fix, we
can drop the kernel change. Parallely I am planning to do a  fix
for papr_scm driver that will update the provider name as "papr_scm". That
way we can find out the backend driver using

:~> ndctl list -B
[
  {
    "provider":"papr_scm",
    "dev":"ndbus1"
  },
  {
    "provider":"of_pmem",
    "dev":"ndbus0"
  }
]


-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
