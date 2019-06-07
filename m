Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BFBA21290D5D
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jun 2019 23:00:47 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id x24so809328otp.7
 for <linux-nvdimm@lists.01.org>; Thu, 06 Jun 2019 23:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com>
 <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
 <20190214200840.GB12668@bombadil.infradead.org>
 <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
 <20190605162204.jzou5hry5exly5wx@fiona>
In-Reply-To: <20190605162204.jzou5hry5exly5wx@fiona>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jun 2019 23:00:35 -0700
Message-ID: <CAPcyv4gZSsAA+GE9otf=WfKSkGMcTbxgdgSCErNys4sOCdCzuA@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
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
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jerome Glisse <jglisse@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 5, 2019 at 9:22 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> Hi Dan/Jerome,
>
> On 12:20 14/02, Dan Williams wrote:
> > On Thu, Feb 14, 2019 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Thu, Feb 14, 2019 at 11:31:24AM -0800, Dan Williams wrote:
> > > > On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
> > > > > I am just again working on my struct page mapping patchset as well as
> > > > > the generic page write protection that sits on top. I hope to be able
> > > > > to post the v2 in couple weeks. You can always look at my posting last
> > > > > year to see more details.
> > > >
> > > > Yes, I have that in mind as one of the contenders. However, it's not
> > > > clear to me that its a suitable fit for filesystem-reflink. Others
> > > > have floated the 'page proxy' idea, so it would be good to discuss the
> > > > merits of the general approaches.
> > >
> > > ... and my preferred option of putting pfn entries in the page cache.
> >
> > Another option to include the discussion.
> >
> > > Or is that what you meant by "page proxy"?
> >
> > Page proxy would be an object that a filesystem could allocate to
> > point back to a single physical 'struct page *'. The proxy would
> > contain an override for page->index.
>
> Was there any outcome on this and its implementation? I am specifically
> interested in this for DAX support on btrfs/CoW: The TODO comment on
> top of dax_associate_entry() :)
>
> If there are patches/git tree I could use to base my patches on, it would
> be nice.

Half joking, but I was hoping that by the time I had circled back to
finally reviewing the brtfs dax patches that a solution to this
problem would be waiting. We spent more time on other DAX topics. I
recall that Jerome and I were mutually skeptical of each others
approaches at first glance, but we did not get into the details. So, I
think it will be a matter of getting the idea coded up. I'm finally
coming out from under a pile of mm work so I should have some time
this cycle to push the page proxy idea forward.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
