Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F4E7211439B1
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 06:32:06 -0700 (PDT)
Date: Tue, 2 Oct 2018 15:32:04 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002133204.GC9127@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002105058.GE18342@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181002105058.GE18342@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 02-10-18 12:50:58, Michal Hocko wrote:
> On Tue 02-10-18 12:05:31, Jan Kara wrote:
> > Hello,
> > 
> > commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and device dax" has
> > removed VM_MIXEDMAP flag from DAX VMAs. Now our testing shows that in the
> > mean time certain customer of ours started poking into /proc/<pid>/smaps
> > and looks at VMA flags there and if VM_MIXEDMAP is missing among the VMA
> > flags, the application just fails to start complaining that DAX support is
> > missing in the kernel. The question now is how do we go about this?
> 
> Do they need to check for a general DAX support or do they need a per
> mapping granularity?

General DAX support per filesystem is OK for them, at least for now. So
they might be OK with just checking for 'dax' mount option in /proc/mounts.
But I agree this is cumbersome.

> > Strictly speaking, this is a userspace visible regression (as much as I
> > think that application poking into VMA flags at this level is just too
> > bold). Is there any precedens in handling similar issues with smaps which
> > really exposes a lot of information that is dependent on kernel
> > implementation details?
> 
> Yeah, exposing all the vma flags was just a terrible idea. We have had a
> similar issue recently [1] for other flag that is no longer set while
> the implementation of the feature is still in place. I guess we really
> want to document that those flags are for debugging only and no stable
> and long term API should rely on it.

Yeah, I have some doubts about usefulness of such documentation but I guess
it's better than nothing.

> Considering how new the thing really is (does anybody do anything
> production like out there?) I would tend to try a better interface
> rather than chasing after random vma flags. E.g. what prevents a
> completely unrelated usage of VM_MIXEDMAP?

Nothing checking that flag is in production AFAIK but DAX as such is in
active use for some limited usecases already. I'll reply regarding a better
interface for checking DAX, in an email to Johannes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
