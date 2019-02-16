Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id 44939208EB3E1
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 21:37:13 -0800 (PST)
Date: Sat, 16 Feb 2019 16:37:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190216053711.GA14116@dastard>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com>
 <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
 <20190214200840.GB12668@bombadil.infradead.org>
 <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
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
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 12:20:11PM -0800, Dan Williams wrote:
> On Thu, Feb 14, 2019 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Feb 14, 2019 at 11:31:24AM -0800, Dan Williams wrote:
> > > On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
> > > > I am just again working on my struct page mapping patchset as well as
> > > > the generic page write protection that sits on top. I hope to be able
> > > > to post the v2 in couple weeks. You can always look at my posting last
> > > > year to see more details.
> > >
> > > Yes, I have that in mind as one of the contenders. However, it's not
> > > clear to me that its a suitable fit for filesystem-reflink. Others
> > > have floated the 'page proxy' idea, so it would be good to discuss the
> > > merits of the general approaches.
> >
> > ... and my preferred option of putting pfn entries in the page cache.
> 
> Another option to include the discussion.
> 
> > Or is that what you meant by "page proxy"?
> 
> Page proxy would be an object that a filesystem could allocate to
> point back to a single physical 'struct page *'. The proxy would
> contain an override for page->index.

Needs to override page->mapping, potentially the page flags, what
happens when someone takes a gup reference to the proxy structure,
etc?

Besides, didn't we discuss all this last year? how about we start
with a summary of all the options considered last year, the pros and
cons, etc, and then go from there? Regurgitating everything we've
already talked about last year doesn't seem particularly useful to
me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
