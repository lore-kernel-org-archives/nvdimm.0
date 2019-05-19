Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5239212108F7
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 09:30:59 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id v10so8365735oib.1
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 09:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190514025449.9416-1-aneesh.kumar@linux.ibm.com>
 <875zq9m8zx.fsf@vajain21.in.ibm.com>
 <de5cbe7d-bd47-6793-1f1a-2274c5c59eb5@linux.ibm.com>
 <87sgtaddru.fsf@linux.ibm.com>
In-Reply-To: <87sgtaddru.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 19 May 2019 09:30:47 -0700
Message-ID: <CAPcyv4gi3NR4NFCQYYg2_Mpb7+qWGMsRodpf8sK1Pnz3+dCe3A@mail.gmail.com>
Subject: Re: [PATCH] mm/nvdimm: Pick the right alignment default when creating
 dax devices
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, May 19, 2019 at 1:55 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
>
> Hi Dan,
>
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>
> > On 5/17/19 8:19 PM, Vaibhav Jain wrote:
> >> Hi Aneesh,
> >>
>
> ....
>
> >>
> >>> +   /*
> >>> +    * Check whether the we support the alignment. For Dax if the
> >>> +    * superblock alignment is not matching, we won't initialize
> >>> +    * the device.
> >>> +    */
> >>> +   if (!nd_supported_alignment(align) &&
> >>> +       memcmp(pfn_sb->signature, DAX_SIG, PFN_SIG_LEN)) {
> >> Suggestion to change this check to:
> >>
> >> if (memcmp(pfn_sb->signature, DAX_SIG, PFN_SIG_LEN) &&
> >>     !nd_supported_alignment(align))
> >>
> >> It would look  a bit more natural i.e. "If the device has dax signature and alignment is
> >> not supported".
> >>
> >
> > I guess that should be !memcmp()? . I will send an updated patch with
> > the hash failure details in the commit message.
> >
>
> We need clarification on what the expected failure behaviour should be.
> The nd_pmem_probe doesn't really have a failure behaviour in this
> regard. For example.
>
> I created a dax device with 16M alignment
>
> {
>   "dev":"namespace0.0",
>   "mode":"devdax",
>   "map":"dev",
>   "size":"9.98 GiB (10.72 GB)",
>   "uuid":"ba62ef22-ebdf-4779-96f5-e6135383ed22",
>   "raw_uuid":"7b2492f9-7160-4ee9-9c3d-2f547d9ef3ee",
>   "daxregion":{
>     "id":0,
>     "size":"9.98 GiB (10.72 GB)",
>     "align":16777216,
>     "devices":[
>       {
>         "chardev":"dax0.0",
>         "size":"9.98 GiB (10.72 GB)"
>       }
>     ]
>   },
>   "align":16777216,
>   "numa_node":0,
>   "supported_alignments":[
>     65536,
>     16777216
>   ]
> }
>
> Now what we want is to fail the initialization of the device when we
> boot a kernel that doesn't support 16M page size. But with the
> nd_pmem_probe failure behaviour we now end up with
>
> [
>   {
>     "dev":"namespace0.0",
>     "mode":"fsdax",
>     "map":"mem",
>     "size":10737418240,
>     "uuid":"7b2492f9-7160-4ee9-9c3d-2f547d9ef3ee",
>     "blockdev":"pmem0"
>   }
> ]
>
> So it did fallthrough the
>
>         /* if we find a valid info-block we'll come back as that personality */
>         if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
>                         || nd_dax_probe(dev, ndns) == 0)
>                 return -ENXIO;
>
>         /* ...otherwise we're just a raw pmem device */
>         return pmem_attach_disk(dev, ndns);
>
>
> Is it ok if i update the code such that we don't do that default
> pmem_atach_disk if we have a label area?

Yes. This seems a new case where the driver finds a valid info-block,
but the capability to load that configuration is missing. So perhaps
special case a EOPNOTSUPP return code from those info-block probe
routines as "fail, and don't fallback to a raw device".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
