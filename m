Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D39B21A02F37
 for <linux-nvdimm@lists.01.org>; Mon, 12 Jun 2017 07:46:07 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id b6so2337531oia.1
 for <linux-nvdimm@lists.01.org>; Mon, 12 Jun 2017 07:47:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170612120714.zypyvp3e4zypqfvf@black.fi.intel.com>
References: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149713137723.17377.8854203820807564559.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170612120714.zypyvp3e4zypqfvf@black.fi.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Jun 2017 07:47:19 -0700
Message-ID: <CAPcyv4jb6Vqvm-rZ84z44LaoerMcJUZiR59TAiQ2itTqwb0j7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: always enable thp for dax mappings
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
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 12, 2017 at 5:07 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> On Sat, Jun 10, 2017 at 02:49:37PM -0700, Dan Williams wrote:
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index c4706e2c3358..901ed3767d1b 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -1,6 +1,8 @@
>>  #ifndef _LINUX_HUGE_MM_H
>>  #define _LINUX_HUGE_MM_H
>>
>> +#include <linux/fs.h>
>> +
>
> It means <linux/mm.h> now depends on <linux/fs.h>. I don't think it's a
> good idea.

Seems to be ok as far as 0day-kbuild-robot is concerned. The
alternative is to move vma_is_dax() out of line. I think
transparent_hugepage_enabled() is called frequently enough to make it
worth it to keep it inline.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
