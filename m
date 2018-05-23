Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4783B203BBBBD
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 06:51:00 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id p62-v6so19539833oie.10
 for <linux-nvdimm@lists.01.org>; Wed, 23 May 2018 06:51:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180523093537.duw6jlglcx7fnutw@quack2.suse.cz>
References: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152700000355.24093.14726378287214432782.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180523093537.duw6jlglcx7fnutw@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 May 2018 06:50:59 -0700
Message-ID: <CAPcyv4hbwPFxvfJVot14dtxJyxttChM06bsP+E5mCN4=VjG5BA@mail.gmail.com>
Subject: Re: [PATCH 06/11] filesystem-dax: perform
 __dax_invalidate_mapping_entry() under the page lock
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
To: Jan Kara <jack@suse.cz>
Cc: "Luck, Tony" <tony.luck@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 23, 2018 at 2:35 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 22-05-18 07:40:03, Dan Williams wrote:
>> Hold the page lock while invalidating mapping entries to prevent races
>> between rmap using the address_space and the filesystem freeing the
>> address_space.
>>
>> This is more complicated than the simple description implies because
>> dev_pagemap pages that fsdax uses do not have any concept of page size.
>> Size information is stored in the radix and can only be safely read
>> while holding the xa_lock. Since lock_page() can not be taken while
>> holding xa_lock, drop xa_lock and speculatively lock all the associated
>> pages. Once all the pages are locked re-take the xa_lock and revalidate
>> that the radix entry did not change.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Matthew Wilcox <mawilcox@microsoft.com>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> IMO this is too ugly to live.

The same thought crossed my mind...

> The combination of entry locks in the radix
> tree and page locks is just too big mess. And from a quick look I don't see
> a reason why we could not use entry locks to protect rmap code as well -
> when you have PFN for which you need to walk rmap, you can grab
> rcu_read_lock(), then you can safely look at page->mapping, grab xa_lock,
> verify the radix tree points where it should and grab entry lock. I agree
> it's a bit complicated but for memory failure I think it is fine.

Ah, I missed this cleverness with rcu relative to keeping the
page->mapping valid. I'll take a look.

> Or we could talk about switching everything to page locks instead of entry
> locks but that isn't trivial either as we need something to serialized page
> faults on even before we go into the filesystem and allocate blocks for the
> fault...

I'd rather use entry locks everywhere and not depend on the page lock
for rmap if at all possible. Ideally lock_page is only used for
typical pages and not these dev_pagemap related structures.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
