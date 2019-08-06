Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5D692130A4E5
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 22:08:26 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7652UK1147354
 for <linux-nvdimm@lists.01.org>; Tue, 6 Aug 2019 01:05:56 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2u730t881d-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 06 Aug 2019 01:05:55 -0400
Received: from localhost
 by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <vaibhav@linux.ibm.com>;
 Tue, 6 Aug 2019 06:05:53 +0100
From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] ndctl,
 check: Ensure mmap of BTT sections work with 64K page-size
In-Reply-To: <2cc108a1f65fb008670c272473df40e51e97b9ad.camel@intel.com>
References: <20190704025143.22856-1-vaibhav@linux.ibm.com>
 <b01607421be5f487662e973c30967a0bf8a8389d.camel@intel.com>
 <878ss721yq.fsf@vajain21.in.ibm.com>
 <2cc108a1f65fb008670c272473df40e51e97b9ad.camel@intel.com>
Date: Tue, 06 Aug 2019 10:35:47 +0530
MIME-Version: 1.0
Message-Id: <875zna289g.fsf@vajain21.in.ibm.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "harish@linux.ibm.com" <harish@linux.ibm.com>, "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Mon, 2019-08-05 at 18:39 +0530, Vaibhav Jain wrote:
>> Thanks for reviewing this patch Vishal. I have prepped a v2 adressing
>> all your review comments with one exception below:
>
> No problem, thanks for fixing this.
>
>> 
>> "Verma, Vishal L" <vishal.l.verma@intel.com> writes:
>> 
>> > On Thu, 2019-07-04 at 08:21 +0530, Vaibhav Jain wrote:
>> > > 
>> > 
>> > > +	if (addr != MAP_FAILED)
>> > > +		addr = (void *) ((uintptr_t)addr + shift);
>> > 
>> > The (uintptr_t) cast should be ok to drop, for v66 we are removing
>> > the
>> > pointer arithmatic warning:
>> > https://patchwork.kernel.org/patch/11062697/
>> > 
>> > In fact, since 'shift' is in bytes, isn't an unsigned int cast
>> > actually *wrong*?
>> Not sure if I understand your review comment correctly. With uintptr_t
>> cast and 'shift' in bytes, addr will be assigned 'addr + shift'
>> instead
>> of 'addr + shift * sizeof (unsigned int)'
>> 
>> So I think the arithmetic I am doing here is correct.
>> 
> Yes you're right - I conflated a (uintptr_t) cast with an (unsigned int)
> cast. The latter would actually be wrong, but I see now that uintptr_t
> is correct. However, given the above patch where we drop the pointer
> arithmetic warning, I think it should be OK to manipulate the void
> pointer directly, and this makes the line cleaner and more concise.
>
> Thanks,
> 	-Vishal

Sure agreed. I have sent out a v2 patch titled "[PATCH v2] ndctl, check:
Ensure mmap of BTT sections work with 64K page-sizes" with the changes.

Thanks,
-- 
Vaibhav Jain <vaibhav@linux.ibm.com>
Linux Technology Center, IBM India Pvt. Ltd.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
