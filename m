Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E08821F0DB0C
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 01:22:24 -0700 (PDT)
Date: Fri, 30 Mar 2018 10:22:21 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 07/14] fs, dax: use page->mapping to warn if truncate
 collides with a busy page
Message-ID: <20180330082221.cea5hz7kq3gyg7w5@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167306807.5268.8483232024444414342.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180329160215.glnrmyunujcc4vwg@quack2.suse.cz>
 <CAPcyv4jK92ev=yWaKCUdxN5z+4+feH+ts3j6KHk57bZVu_QqYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jK92ev=yWaKCUdxN5z+4+feH+ts3j6KHk57bZVu_QqYQ@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 29-03-18 16:02:45, Dan Williams wrote:
> On Thu, Mar 29, 2018 at 9:02 AM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 21-03-18 15:57:48, Dan Williams wrote:
> [..]
> > I find it quite tricky that in case we pass zero page / empty entry into
> > dax_[dis]associate_entry(), it will not do anything because
> > dax_entry_size() will return 0. Can we add an explicit check into
> > dax_[dis]associate_entry() or at least a comment there?
> 
> How about the following, i.e. rename the loop helper to
> for_each_dax_pfn() to make it clearer that we're only operating on
> mapped pfns, and also add a comment to indicate the same:
> 
> /*
>  * Iterate through all mapped pfns represented by an entry, i.e. skip
>  * 'empty' and 'zero' entries.
>  */
> #define for_each_dax_pfn(entry, pfn) \
>         for (pfn = dax_radix_pfn(entry); \
>                         pfn < dax_radix_end_pfn(entry); pfn++)

Maybe call it for_each_mapped_pfn()? Other than that it looks fine to me.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
