Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E349223DB11C
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 09:33:45 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id x12so9318199oie.13
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 09:40:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180310094633.GA31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180310094633.GA31604@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Mar 2018 09:40:03 -0800
Message-ID: <CAPcyv4iZFW9Lk=KdEy=0iYzM9GmQ4ccoN2imYNDq6XwXDgXsDw@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] xfs, dax: introduce xfs_dax_aops
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Mar 10, 2018 at 1:46 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +int dax_set_page_dirty(struct page *page)
>> +{
>> +     /*
>> +      * Unlike __set_page_dirty_no_writeback that handles dirty page
>> +      * tracking in the page object, dax does all dirty tracking in
>> +      * the inode address_space in response to mkwrite faults. In the
>> +      * dax case we only need to worry about potentially dirty CPU
>> +      * caches, not dirty page cache pages to write back.
>> +      *
>> +      * This callback is defined to prevent fallback to
>> +      * __set_page_dirty_buffers() in set_page_dirty().
>> +      */
>> +     return 0;
>> +}
>
> Make this a generic noop_set_page_dirty maybe?
>
>> +EXPORT_SYMBOL(dax_set_page_dirty);
>> +
>> +void dax_invalidatepage(struct page *page, unsigned int offset,
>> +             unsigned int length)
>> +{
>> +     /*
>> +      * There is no page cache to invalidate in the dax case, however
>> +      * we need this callback defined to prevent falling back to
>> +      * block_invalidatepage() in do_invalidatepage().
>> +      */
>> +}
>
> Same here.

I guess I'm not sure what you mean. These nops are specific to dax I
don't think they make sense in another context besides dax.

>
>> +EXPORT_SYMBOL(dax_invalidatepage);
>
> And EXPORT_SYMBOL_GPL for anything dax-related, please.
>
>> +const struct address_space_operations xfs_dax_aops = {
>> +     .writepages             = xfs_vm_writepages,
>
> Please split out the DAX case from xfs_vm_writepages.

Will do.

> This patch should probably also split into VFS and XFS parts.

Ok.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
