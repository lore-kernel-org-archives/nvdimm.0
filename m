Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v5 3/4] mm/nvdimm: Use correct #defines instead of open coding
In-Reply-To: <87v9ut1vev.fsf@linux.ibm.com>
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com> <20190809074520.27115-4-aneesh.kumar@linux.ibm.com> <CAPcyv4hc_-oGMp6jGVknnYs+rmj4W1A_gFCbmAX2LFw0hsfL5g@mail.gmail.com> <87v9ut1vev.fsf@linux.ibm.com>
Date: Mon, 19 Aug 2019 15:00:47 +0530
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87mug5biyg.fsf@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com> writes:

> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Fri, Aug 9, 2019 at 12:45 AM Aneesh Kumar K.V
>> <aneesh.kumar@linux.ibm.com> wrote:
>>>
>>

...

>>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>>> index 37e96811c2fc..c1d9be609322 100644
>>> --- a/drivers/nvdimm/pfn_devs.c
>>> +++ b/drivers/nvdimm/pfn_devs.c
>>> @@ -725,7 +725,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>>>                  * when populating the vmemmap. This *should* be equal to
>>>                  * PMD_SIZE for most architectures.
>>>                  */
>>> -               offset = ALIGN(start + SZ_8K + 64 * npfns, align) - start;
>>> +               offset = ALIGN(start + SZ_8K + sizeof(struct page) * npfns,
>>
>> I'd prefer if this was not dynamic and was instead set to the maximum
>> size of 'struct page' across all archs just to enhance cross-arch
>> compatibility. I think that answer is '64'.
>
>
> That still doesn't take care of the case where we add new elements to
> struct page later. If we have struct page size changing across
> architectures, we should still be ok as long as new size is less than what is
> stored in pfn superblock? I understand the desire to keep it
> non-dynamic. But we also need to make sure we don't reserve less space
> when creating a new namespace on a config that got struct page size >
> 64? 


How about

libnvdimm/pfn_dev: Add a build check to make sure we notice when struct page size change

When namespace is created with map device as pmem device, struct page is stored in the
reserve block area. We need to make sure we account for the right struct page
size while doing this. Instead of directly depending on sizeof(struct page)
which can change based on different kernel config option, use the max struct
page size (64) while calculating the reserve block area. This makes sure pmem
device can be used across kernels built with different configs.

If the above assumption of max struct page size change, we need to update the
reserve block allocation space for new namespaces created.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

1 file changed, 7 insertions(+)
drivers/nvdimm/pfn_devs.c | 7 +++++++

modified   drivers/nvdimm/pfn_devs.c
@@ -722,7 +722,14 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		 * The altmap should be padded out to the block size used
 		 * when populating the vmemmap. This *should* be equal to
 		 * PMD_SIZE for most architectures.
+		 *
+		 * Also make sure size of struct page is less than 64. We
+		 * want to make sure we use large enough size here so that
+		 * we don't have a dynamic reserve space depending on
+		 * struct page size. But we also want to make sure we notice
+		 * if we end up adding new elements to struct page.
 		 */
+		BUILD_BUG_ON(64 < sizeof(struct page));
 		offset = ALIGN(start + SZ_8K + 64 * npfns, align) - start;
 	} else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K, align) - start;


-aneesh
