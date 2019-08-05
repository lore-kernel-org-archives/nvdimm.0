Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com
 [IPv6:2a00:1450:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C170921959CB2
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 04:55:44 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p74so74416695wme.4
 for <linux-nvdimm@lists.01.org>; Mon, 05 Aug 2019 04:53:14 -0700 (PDT)
Subject: Re: [PATCH] dax: dax_layout_busy_page() should not unmap cow pages
References: <20190802192956.GA3032@redhat.com>
 <CAPcyv4jxknEGq9FzGpsMJ6E7jC51d1W9KbNg4HX6Cj6vqt7dqg@mail.gmail.com>
From: Boaz Harrosh <boaz@plexistor.com>
Message-ID: <9678e812-08c1-fab7-f358-eaf123af14e5@plexistor.com>
Date: Mon, 5 Aug 2019 14:53:06 +0300
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jxknEGq9FzGpsMJ6E7jC51d1W9KbNg4HX6Cj6vqt7dqg@mail.gmail.com>
Content-Language: en-MW
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
To: Dan Williams <dan.j.williams@intel.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 02/08/2019 22:37, Dan Williams wrote:
> On Fri, Aug 2, 2019 at 12:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> As of now dax_layout_busy_page() calls unmap_mapping_range() with last
>> argument as 1, which says even unmap cow pages. I am wondering who needs
>> to get rid of cow pages as well.
>>
>> I noticed one interesting side affect of this. I mount xfs with -o dax and
>> mmaped a file with MAP_PRIVATE and wrote some data to a page which created
>> cow page. Then I called fallocate() on that file to zero a page of file.
>> fallocate() called dax_layout_busy_page() which unmapped cow pages as well
>> and then I tried to read back the data I wrote and what I get is old
>> data from persistent memory. I lost the data I had written. This
>> read basically resulted in new fault and read back the data from
>> persistent memory.
>>
>> This sounds wrong. Are there any users which need to unmap cow pages
>> as well? If not, I am proposing changing it to not unmap cow pages.
>>
>> I noticed this while while writing virtio_fs code where when I tried
>> to reclaim a memory range and that corrupted the executable and I
>> was running from virtio-fs and program got segment violation.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
>>  fs/dax.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: rhvgoyal-linux/fs/dax.c
>> ===================================================================
>> --- rhvgoyal-linux.orig/fs/dax.c        2019-08-01 17:03:10.574675652 -0400
>> +++ rhvgoyal-linux/fs/dax.c     2019-08-02 14:32:28.809639116 -0400
>> @@ -600,7 +600,7 @@ struct page *dax_layout_busy_page(struct
>>          * guaranteed to either see new references or prevent new
>>          * references from being established.
>>          */
>> -       unmap_mapping_range(mapping, 0, 0, 1);
>> +       unmap_mapping_range(mapping, 0, 0, 0);
> 
> Good find, yes, this looks correct to me and should also go to -stable.
> 

Please pay attention that unmap_mapping_range(mapping, ..., 1) is for the truncate case and friends

So as I understand the man page:
fallocate(FL_PUNCH_HOLE); means user is asking to get rid also of COW pages.
On the other way fallocate(FL_ZERO_RANGE) only the pmem portion is zeroed and COW (private pages) stays

Just saying I have not followed the above code path
(We should have an xfstest for this?)

Cheers
Boaz
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
