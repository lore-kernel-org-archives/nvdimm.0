Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5907D2194EB75
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 01:06:56 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2K86Det051936
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 04:06:55 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rbh93sqha-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 04:06:54 -0400
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Wed, 20 Mar 2019 08:06:46 -0000
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
In-Reply-To: <CAPcyv4i0SahDP=_ZQV3RG_b5pMkjn-9Cjy7OpY2sm1PxLdO8jA@mail.gmail.com>
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com>
 <CAPcyv4ir4irASBQrZD_a6kMkEUt=XPUCuKajF75O7wDCgeG=7Q@mail.gmail.com>
 <871s3aqfup.fsf@linux.ibm.com>
 <CAPcyv4i0SahDP=_ZQV3RG_b5pMkjn-9Cjy7OpY2sm1PxLdO8jA@mail.gmail.com>
Date: Wed, 20 Mar 2019 13:36:43 +0530
MIME-Version: 1.0
Message-Id: <87bm267ywc.fsf@linux.ibm.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

>
>> Now what will be page size used for mapping vmemmap?
>
> That's up to the architecture's vmemmap_populate() implementation.
>
>> Architectures
>> possibly will use PMD_SIZE mapping if supported for vmemmap. Now a
>> device-dax with struct page in the device will have pfn reserve area aligned
>> to PAGE_SIZE with the above example? We can't map that using
>> PMD_SIZE page size?
>
> IIUC, that's a different alignment. Currently that's handled by
> padding the reservation area up to a section (128MB on x86) boundary,
> but I'm working on patches to allow sub-section sized ranges to be
> mapped.

I am missing something w.r.t code. The below code align that using nd_pfn->align

	if (nd_pfn->mode == PFN_MODE_PMEM) {
		unsigned long memmap_size;

		/*
		 * vmemmap_populate_hugepages() allocates the memmap array in
		 * HPAGE_SIZE chunks.
		 */
		memmap_size = ALIGN(64 * npfns, HPAGE_SIZE);
		offset = ALIGN(start + SZ_8K + memmap_size + dax_label_reserve,
				nd_pfn->align) - start;
      }

IIUC that is finding the offset where to put vmemmap start. And that has
to be aligned to the page size with which we may end up mapping vmemmap
area right?

Yes we find the npfns by aligning up using PAGES_PER_SECTION. But that
is to compute howmany pfns we should map for this pfn dev right?
	
-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
