Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66DCB2034714B
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 08:19:24 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id v132so20553728oie.1
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 08:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020075735.GA14378@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Oct 2017 08:23:02 -0700
Message-ID: <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 20, 2017 at 12:57 AM, Christoph Hellwig <hch@lst.de> wrote:
>> --- a/arch/powerpc/sysdev/axonram.c
>> +++ b/arch/powerpc/sysdev/axonram.c
>> @@ -172,6 +172,7 @@ static size_t axon_ram_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>
>>  static const struct dax_operations axon_ram_dax_ops = {
>>       .direct_access = axon_ram_dax_direct_access,
>> +
>>       .copy_from_iter = axon_ram_copy_from_iter,
>
> Unrelated whitespace change.  That being said - I don't think axonram has
> devmap support in any form, so this basically becomes dead code, doesn't
> it?
>
>> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
>> index 7abb240847c0..e7e5db07e339 100644
>> --- a/drivers/s390/block/dcssblk.c
>> +++ b/drivers/s390/block/dcssblk.c
>> @@ -52,6 +52,7 @@ static size_t dcssblk_dax_copy_from_iter(struct dax_device *dax_dev,
>>
>>  static const struct dax_operations dcssblk_dax_ops = {
>>       .direct_access = dcssblk_dax_direct_access,
>> +
>>       .copy_from_iter = dcssblk_dax_copy_from_iter,
>
> Same comments apply here.

Yes, however it seems these drivers / platforms have been living with
the lack of struct page for a long time. So they either don't use DAX,
or they have a constrained use case that never triggers
get_user_pages(). If it is the latter then they could introduce a new
configuration option that bypasses the pfn_t_devmap() check in
bdev_dax_supported() and fix up the get_user_pages() paths to fail.
So, I'd like to understand how these drivers have been using DAX
support without struct page to see if we need a workaround or we can
go ahead delete this support. If the usage is limited to
execute-in-place perhaps we can do a constrained ->direct_access() for
just that case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
