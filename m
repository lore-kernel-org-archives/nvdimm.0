Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2715B20961061
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 17:16:53 -0700 (PDT)
Date: Mon, 7 May 2018 17:16:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v9 0/9] dax: fix dma vs truncate/hole-punch
Message-ID: <20180508001636.GM4141@magnolia>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ihoGPJWA4X7V0h4BsX9_+4AXdHF=bmb==8iQMfc94YMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ihoGPJWA4X7V0h4BsX9_+4AXdHF=bmb==8iQMfc94YMQ@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Alasdair Kergon <agk@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Thomas Meyer <thomas@m3y3r.de>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 03, 2018 at 04:53:18PM -0700, Dan Williams wrote:
> On Tue, Apr 24, 2018 at 4:33 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > Changes since v8 [1]:
> > * Rebase on v4.17-rc2
> >
> > * Fix get_user_pages_fast() for ZONE_DEVICE pages to revalidate the pte,
> >   pmd, pud after taking references (Jan)
> >
> > * Kill dax_layout_lock(). With get_user_pages_fast() for ZONE_DEVICE
> >   fixed we can then rely on the {pte,pmd}_lock to synchronize
> >   dax_layout_busy_page() vs new page references (Jan)
> >
> > * Hold the iolock over repeated invocations of dax_layout_busy_page() to
> >   enable truncate/hole-punch to make forward progress in the presence of
> >   a constant stream of new direct-I/O requests (Jan).
> >
> > [1]: https://lists.01.org/pipermail/linux-nvdimm/2018-March/015058.html
> 
> I'll push this for soak time in -next if there are no further comments...

I don't have any. :D

--D
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
