Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
In-Reply-To: <87bm267ywc.fsf@linux.ibm.com>
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com> <20190228083522.8189-2-aneesh.kumar@linux.ibm.com> <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com> <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com> <87k1hc8iqa.fsf@linux.ibm.com> <CAPcyv4ir4irASBQrZD_a6kMkEUt=XPUCuKajF75O7wDCgeG=7Q@mail.gmail.com> <871s3aqfup.fsf@linux.ibm.com> <CAPcyv4i0SahDP=_ZQV3RG_b5pMkjn-9Cjy7OpY2sm1PxLdO8jA@mail.gmail.com> <87bm267ywc.fsf@linux.ibm.com>
Date: Wed, 20 Mar 2019 13:39:14 +0530
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <878sxa7ys5.fsf@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com> writes:

> Dan Williams <dan.j.williams@intel.com> writes:
>
>>
>>> Now what will be page size used for mapping vmemmap?
>>
>> That's up to the architecture's vmemmap_populate() implementation.
>>
>>> Architectures
>>> possibly will use PMD_SIZE mapping if supported for vmemmap. Now a
>>> device-dax with struct page in the device will have pfn reserve area aligned
>>> to PAGE_SIZE with the above example? We can't map that using
>>> PMD_SIZE page size?
>>
>> IIUC, that's a different alignment. Currently that's handled by
>> padding the reservation area up to a section (128MB on x86) boundary,
>> but I'm working on patches to allow sub-section sized ranges to be
>> mapped.
>
> I am missing something w.r.t code. The below code align that using nd_pfn->align
>
> 	if (nd_pfn->mode == PFN_MODE_PMEM) {
> 		unsigned long memmap_size;
>
> 		/*
> 		 * vmemmap_populate_hugepages() allocates the memmap array in
> 		 * HPAGE_SIZE chunks.
> 		 */
> 		memmap_size = ALIGN(64 * npfns, HPAGE_SIZE);
> 		offset = ALIGN(start + SZ_8K + memmap_size + dax_label_reserve,
> 				nd_pfn->align) - start;
>       }
>
> IIUC that is finding the offset where to put vmemmap start. And that has
> to be aligned to the page size with which we may end up mapping vmemmap
> area right?
>
> Yes we find the npfns by aligning up using PAGES_PER_SECTION. But that
> is to compute howmany pfns we should map for this pfn dev right?
> 	

Also i guess those 4K assumptions there is wrong?

modified   drivers/nvdimm/pfn_devs.c
@@ -783,7 +783,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		return -ENXIO;
 	}
 
-	npfns = (size - offset - start_pad - end_trunc) / SZ_4K;
+	npfns = (size - offset - start_pad - end_trunc) / PAGE_SIZE;
 	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
 	pfn_sb->dataoff = cpu_to_le64(offset);
 	pfn_sb->npfns = cpu_to_le64(npfns);


-aneesh
