Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E21582194EB77
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 09:45:34 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/7] libnvdimm/pfn: Fix section-alignment padding
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4j9uEn9j=Y0Vo3oQJaXo-d-Xf=2-=0ucufhcXWeYOb0Yg@mail.gmail.com>
Date: Wed, 20 Feb 2019 12:45:31 -0500
In-Reply-To: <CAPcyv4j9uEn9j=Y0Vo3oQJaXo-d-Xf=2-=0ucufhcXWeYOb0Yg@mail.gmail.com>
 (Dan Williams's message of "Wed, 20 Feb 2019 09:11:04 -0800")
Message-ID: <x49pnrm2w1w.fsf@segfault.boston.devel.redhat.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Tue, Feb 12, 2019 at 1:37 PM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Lately Linux has encountered platforms that collide Persistent Memory
>> regions between each other, specifically cases where ->start_pad needed
>> to be non-zero. This lead to commit ae86cbfef381 "libnvdimm, pfn: Pad
>> pfn namespaces relative to other regions". That commit allowed
>> namespaces to be mapped with devm_memremap_pages(). However dax
>> operations on those configurations currently fail if attempted within the
>> ->start_pad range because pmem_device->data_offset was still relative to
>> raw resource base not relative to the section aligned resource range
>> mapped by devm_memremap_pages().
>>
>> Luckily __bdev_dax_supported() caught these failures and simply disabled
>> dax. However, to fix this situation a non-backwards compatible change
>> needs to be made to the interpretation of the nd_pfn info-block.
>> ->start_pad needs to be accounted in ->map.map_offset (formerly
>> ->data_offset), and ->map.map_base (formerly ->phys_addr) needs to be
>> adjusted to the section aligned resource base used to establish
>> ->map.map formerly (formerly ->virt_addr).
>>
>> See patch 7 "libnvdimm/pfn: Fix 'start_pad' implementation" for more
>> details, and the ndctl patch series "Improve support + testing for
>> labels + info-blocks" for the corresponding regression test.
>
> Hello valued reviewers, can I plead for a sanity check of at least
> "libnvdimm/pfn: Introduce super-block minimum version requirements"
> and "libnvdimm/pfn: Fix 'start_pad' implementation"? In particular
> Jeff / Johannes this has end user / distro impact in that users may
> lose access to namespaces that are upgraded to v1.3 info-blocks and
> then boot an old kernel. I did not see a way around that sharp edge.

Yes, I'll take a look.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
