Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: Re: what's in nvdimm.git for v4.4?
References: <1445383903.6611.39.camel@intel.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <5627CFBC.4080801@fb.com>
Date: Wed, 21 Oct 2015 11:47:40 -0600
MIME-Version: 1.0
In-Reply-To: <1445383903.6611.39.camel@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On 10/20/2015 05:31 PM, Williams, Dan J wrote:
> ===
> for-4.4/dax-gup: get_user_pages() support for dax mappings
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lists.01.org_pipermail_linux-2Dnvdimm_2015-2DOctober_002387.html&d=CwIGaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=cK1a7KivzZRh1fKQMjSm2A&m=GDROuamLFa0boM8dkPE6fXkQ-bqUhy3M3gH-W-7UaUU&s=S8I_OUhMMB7AAcJn6TzV01M9jB6e2wB3aMIT4lTGHf8&e=
> ===
>
>          Needs acks from core -mm folks particularly for:
>                  x86, mm: introduce vmem_altmap to augment
>                  vmemmap_populate()
>                  mm, x86: get_user_pages() for dax mappings
>
>          Dan Williams (22):
>                block: generic request_queue reference counting
>                dax: increase granularity of dax_clear_blocks() operations
>                block, dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()
>                mm: introduce __get_dev_pagemap()
>                x86, mm: introduce vmem_altmap to augment vmemmap_populate()
>                libnvdimm, pfn, pmem: allocate memmap array in persistent memory
>                avr32: convert to asm-generic/memory_model.h
>                hugetlb: fix compile error on tile
>                frv: fix compiler warning from definition of __pmd()
>                um: kill pfn_t
>                kvm: rename pfn_t to kvm_pfn_t
>                mips: fix PAGE_MASK definition
>                mm, dax, pmem: introduce pfn_t
>                mm, dax, gpu: convert vm_insert_mixed to pfn_t, introduce _PAGE_DEVMAP
>                mm, dax: convert vmf_insert_pfn_pmd() to pfn_t
>                list: introduce list_del_poison()
>                mm, dax, pmem: introduce {get|put}_dev_pagemap() for dax-gup
>                block: notify queue death confirmation
>                mm, pmem: devm_memunmap_pages(), truncate and unmap ZONE_DEVICE pages
>                mm, x86: get_user_pages() for dax mappings
>                block: introduce file_bd_inode()
>                block: enable dax for raw block devices

We really should pull these core block changes in separately.

> ===
> for-4.4/blk-integrity:
> ===
>
>          Jens?  I've folded my fixes with Martin's latest and
>          block.git/for-4.4/drivers.
>
>          Dan Williams (7):
>                md, dm, scsi, nvme, libnvdimm: drop blk_integrity_unregister() at shutdown
>                md: suspend i/o during runtime blk_integrity_unregister
>                nvme: suspend i/o during runtime blk_integrity_unregister
>                block: generic request_queue reference counting
>                block: move blk_integrity to request_queue
>                block: blk_flush_integrity() for bio-based drivers
>                block, libnvdimm, nvme: provide a built-in blk_integrity nop profile
>
>          Martin K. Petersen (5):
>                block: Move integrity kobject to struct gendisk
>                block: Consolidate static integrity profile properties
>                block: Reduce the size of struct blk_integrity
>                block: Export integrity data interval size in sysfs
>                block: Inline blk_integrity in struct gendisk

I'll pull these in.


-- 
Jens Axboe

