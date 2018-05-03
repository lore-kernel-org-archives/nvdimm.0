Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 741AB203BEA30
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 16:53:19 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id l1-v6so17678823oii.1
 for <linux-nvdimm@lists.01.org>; Thu, 03 May 2018 16:53:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 May 2018 16:53:18 -0700
Message-ID: <CAPcyv4ihoGPJWA4X7V0h4BsX9_+4AXdHF=bmb==8iQMfc94YMQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/9] dax: fix dma vs truncate/hole-punch
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
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Alasdair Kergon <agk@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Thomas Meyer <thomas@m3y3r.de>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 24, 2018 at 4:33 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Changes since v8 [1]:
> * Rebase on v4.17-rc2
>
> * Fix get_user_pages_fast() for ZONE_DEVICE pages to revalidate the pte,
>   pmd, pud after taking references (Jan)
>
> * Kill dax_layout_lock(). With get_user_pages_fast() for ZONE_DEVICE
>   fixed we can then rely on the {pte,pmd}_lock to synchronize
>   dax_layout_busy_page() vs new page references (Jan)
>
> * Hold the iolock over repeated invocations of dax_layout_busy_page() to
>   enable truncate/hole-punch to make forward progress in the presence of
>   a constant stream of new direct-I/O requests (Jan).
>
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2018-March/015058.html

I'll push this for soak time in -next if there are no further comments...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
