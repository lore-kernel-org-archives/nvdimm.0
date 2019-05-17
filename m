Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FB7121250464
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 22:36:33 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4H5aXL6072462
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 01:36:33 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2shnbhuk83-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 01:36:32 -0400
Received: from localhost
 by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <vaibhav@linux.ibm.com>;
 Fri, 17 May 2019 06:36:24 +0100
From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] dax: Fix last_page check in __bdev_dax_supported()
In-Reply-To: <CAPcyv4j6Jhpqg9SqAAmz2A6PDry7UUtnniNVoc_qG=WXwuVOWA@mail.gmail.com>
References: <20190516055422.16939-1-vaibhav@linux.ibm.com>
 <CAPcyv4j6Jhpqg9SqAAmz2A6PDry7UUtnniNVoc_qG=WXwuVOWA@mail.gmail.com>
Date: Fri, 17 May 2019 11:06:16 +0530
MIME-Version: 1.0
Message-Id: <87bm01mylr.fsf@vajain21.in.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Chandan Rajendra <chandan@linux.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Wed, May 15, 2019 at 10:55 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>>
>> Presently __bdev_dax_supported() checks if first sector of last
>> page ( last_page ) on the block device is aligned to page
>> boundary. However the code to compute 'last_page' assumes that there
>> are 8 sectors/page assuming a 4K page-size.
>>
>> This assumption breaks on architectures which use a different page
>> size specifically PPC64 where page-size == 64K. Hence a warning is
>> seen while trying to mount a xfs/ext4 file-system with dax enabled:
>>
>> $ sudo mount -o dax /dev/pmem0 /mnt/pmem
>> XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
>> XFS (pmem0): DAX unsupported by block device. Turning off DAX.
>>
>> The patch fixes this issue by updating calculation of 'last_var' to
>> take into account number-of-sectors/page instead of assuming it to be
>> '8'.
>
> Yes, I noticed this too and fixed it up in a wider change that also
> allows device-mapper to validate each component device. Does this
> patch work for you?
>
> https://lore.kernel.org/lkml/155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com/

Thanks Dan, I tested your patch and not seeing the issue anymore.

So, please ignore this patch.

-- 
Vaibhav Jain <vaibhav@linux.ibm.com>
Linux Technology Center, IBM India Pvt. Ltd.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
