Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D46620214B40
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 00:07:08 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7J730gq107710
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 03:05:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2ufnsmtx3t-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 03:05:38 -0400
Received: from localhost
 by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Mon, 19 Aug 2019 08:05:36 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v5 1/4] nvdimm: Consider probe return -EOPNOTSUPP as
 success
In-Reply-To: <CAPcyv4hxo4HvtqZ-B6JG5iATo_vEAKPzO5EU5Lugs2_edEbW7Q@mail.gmail.com>
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
 <20190809074520.27115-2-aneesh.kumar@linux.ibm.com>
 <CAPcyv4jmxKPkTh0_Bbu2tRXm4vcBHonZJ6UcKrOBnPGCG2_i1A@mail.gmail.com>
 <CAPcyv4hxo4HvtqZ-B6JG5iATo_vEAKPzO5EU5Lugs2_edEbW7Q@mail.gmail.com>
Date: Mon, 19 Aug 2019 12:35:30 +0530
MIME-Version: 1.0
Message-Id: <87y2zp1vph.fsf@linux.ibm.com>
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
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Tue, Aug 13, 2019 at 9:22 PM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Hi Aneesh, logic looks correct but there are some cleanups I'd like to
>> see and a lead-in patch that I attached.
>>
>> I've started prefixing nvdimm patches with:
>>
>>     libnvdimm/$component:
>>
>> ...since this patch mostly impacts the pmem driver lets prefix it
>> "libnvdimm/pmem: "
>>
>> On Fri, Aug 9, 2019 at 12:45 AM Aneesh Kumar K.V
>> <aneesh.kumar@linux.ibm.com> wrote:
>> >
>> > This patch add -EOPNOTSUPP as return from probe callback to
>>
>> s/This patch add/Add/
>>
>> No need to say "this patch" it's obviously a patch.
>>
>> > indicate we were not able to initialize a namespace due to pfn superblock
>> > feature/version mismatch. We want to consider this a probe success so that
>> > we can create new namesapce seed and there by avoid marking the failed
>> > namespace as the seed namespace.
>>
>> Please replace usage of "we" with the exact agent involved as which
>> "we" is being referred to gets confusing for the reader.
>>
>> i.e. "indicate that the pmem driver was not..." "The nvdimm core wants
>> to consider this...".
>>
>> >
>> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> > ---
>> >  drivers/nvdimm/bus.c  |  2 +-
>> >  drivers/nvdimm/pmem.c | 26 ++++++++++++++++++++++----
>> >  2 files changed, 23 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>> > index 798c5c4aea9c..16c35e6446a7 100644
>> > --- a/drivers/nvdimm/bus.c
>> > +++ b/drivers/nvdimm/bus.c
>> > @@ -95,7 +95,7 @@ static int nvdimm_bus_probe(struct device *dev)
>> >         rc = nd_drv->probe(dev);
>> >         debug_nvdimm_unlock(dev);
>> >
>> > -       if (rc == 0)
>> > +       if (rc == 0 || rc == -EOPNOTSUPP)
>> >                 nd_region_probe_success(nvdimm_bus, dev);
>>
>> This now makes the nd_region_probe_success() helper obviously misnamed
>> since it now wants to take actions on non-probe success. I attached a
>> lead-in cleanup that you can pull into your series that renames that
>> routine to nd_region_advance_seeds().
>>
>> When you rebase this needs a comment about why EOPNOTSUPP has special handling.
>>
>> >         else
>> >                 nd_region_disable(nvdimm_bus, dev);
>> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> > index 4c121dd03dd9..3f498881dd28 100644
>> > --- a/drivers/nvdimm/pmem.c
>> > +++ b/drivers/nvdimm/pmem.c
>> > @@ -490,6 +490,7 @@ static int pmem_attach_disk(struct device *dev,
>> >
>> >  static int nd_pmem_probe(struct device *dev)
>> >  {
>> > +       int ret;
>> >         struct nd_namespace_common *ndns;
>> >
>> >         ndns = nvdimm_namespace_common_probe(dev);
>> > @@ -505,12 +506,29 @@ static int nd_pmem_probe(struct device *dev)
>> >         if (is_nd_pfn(dev))
>> >                 return pmem_attach_disk(dev, ndns);
>> >
>> > -       /* if we find a valid info-block we'll come back as that personality */
>> > -       if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
>> > -                       || nd_dax_probe(dev, ndns) == 0)
>>
>> Similar need for an updated comment here to explain the special
>> translation of error codes.
>>
>> > +       ret = nd_btt_probe(dev, ndns);
>> > +       if (ret == 0)
>> >                 return -ENXIO;
>> > +       else if (ret == -EOPNOTSUPP)
>>
>> Are there cases where the btt driver needs to return EOPNOTSUPP? I'd
>> otherwise like to keep this special casing constrained to the pfn /
>> dax info block cases.
>
> In fact I think EOPNOTSUPP is only something that the device-dax case
> would be concerned with because that's the only interface that
> attempts to guarantee a given mapping granularity.

We need to do similar error handling w.r.t fsdax when the pfn superblock
indicates different PAGE_SIZE and struct page size? I don't think btt
needs to support EOPNOTSUPP. But we can keep it for consistency?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
