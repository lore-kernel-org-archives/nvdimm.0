Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.113])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AC492117FD5E
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 06:27:33 -0800 (PST)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [RFC PATCH v2 0/3] realize dax_operations for
 dm-snapshot
Date: Wed, 28 Nov 2018 14:27:12 +0000
Message-ID: <HK2PR03MB4418C7DE4A2A55E691711CE692D10@HK2PR03MB4418.apcprd03.prod.outlook.com>
References: <20181121032702.3048-1-yehs2007@zoho.com>
 <CAPcyv4hmCsNOZPEAzOLxhFCQpyaG0_9TJvJnyuytQAVEU7_wbA@mail.gmail.com>
In-Reply-To: <CAPcyv4hmCsNOZPEAzOLxhFCQpyaG0_9TJvJnyuytQAVEU7_wbA@mail.gmail.com>
Content-Language: zh-CN
MIME-Version: 1.0
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
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, NingTing Cheng <chengnt@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>
Sent: Monday, November 26, 2018 5:00 AM> 
> On Tue, Nov 20, 2018 at 7:27 PM Huaisheng Ye <yehs2007@zoho.com> wrote:
> >
> > From: Huaisheng Ye <yehs1@lenovo.com>
> >
> > Changes
> > v1->v2:
> >         Add NULL funtions for origin_dax_direct_access and
> >         origin_dax_copy_from/to_iter in order to avoid building
> >         error when CONFIG_DAX_DRIVER has NOT been enabled.
> >
> > [v1]: https://lkml.org/lkml/2018/11/20/759
> >
> > This series patches are used to realize the dax_operations for dm-snapshot
> > with persistent memory device.
> 
> How does this interact with mmap write faults if the mapping is dax
> and the page needs to be cow'd?

Hi Dan,

Based on my understanding, I think dm-snapshot is impossible to work
with file mapping in DAX way.

When file mapping has been used with DAX, userspace could get the pointer
To access persistent memory directly by page fault.
Here is the call trace.

 74 [ 7677.897354] Call Trace:
 75 [ 7677.900538]  dump_stack+0x67/0x82
 76 [ 7677.904695]  __pmem_direct_access+0xa9/0x101 [nd_pmem]
 77 [ 7677.910922]  ? linear_ctr+0x12a/0x12a [dm_mod]
 78 [ 7677.916340]  pmem_dax_direct_access+0x30/0x37 [nd_pmem]
 79 [ 7677.922641]  dax_direct_access+0x30/0x58
 80 [ 7677.927480]  linear_dax_direct_access+0x66/0x71 [dm_mod]
 81 [ 7677.933848]  dm_dax_direct_access+0x9c/0xf1 [dm_mod]
 82 [ 7677.939856]  ? origin_dax_copy_from_iter+0x88/0x88 [dm_snapshot]
 83 [ 7677.947032]  dax_direct_access+0x30/0x58
 84 [ 7677.951876]  origin_dax_direct_access+0x6a/0x75 [dm_snapshot]
 85 [ 7677.958753]  dm_dax_direct_access+0x9c/0xf1 [dm_mod]
 86 [ 7677.964738]  dax_direct_access+0x30/0x58
 87 [ 7677.969542]  dax_iomap_pfn+0x84/0x10d
 88 [ 7677.974061]  dax_iomap_pte_fault+0x4a9/0x773
 89 [ 7677.979271]  dax_iomap_fault+0x21/0x36
 90 [ 7677.983895]  ext2_dax_fault+0x70/0x9a [ext2]
 91 [ 7677.989061]  __do_fault+0x1d/0x74
 92 [ 7677.993159]  __handle_mm_fault+0xf04/0x17a4
 93 [ 7677.998225]  handle_mm_fault+0x1a0/0x204
 94 [ 7678.003035]  __do_page_fault+0x39b/0x4d3
 95 [ 7678.007839]  do_page_fault+0xfc/0x11b
 96 [ 7678.012316]  ? page_fault+0x8/0x30
 97 [ 7678.016498]  page_fault+0x1e/0x30

The application in userspace could directly read or write the data of
the file content by mmap in DAX way.
dm-snapshot works at kernel space, so it doesn't have chance to be aware
of the modification of FS.

I think in this case, perhaps userspace should take the responsibility
for snapshot when file mapping has been used in DAX way. Just like what
NVML has done as CLFLUSH for cache lines flush.

Correct me if anything is not accurate.

Cheers,
Huaisheng Ye
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
