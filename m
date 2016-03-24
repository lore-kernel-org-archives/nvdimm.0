Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AA861A1E89
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 05:32:48 -0700 (PDT)
Date: Thu, 24 Mar 2016 13:32:51 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/10] dax: Remove complete_unwritten argument
Message-ID: <20160324123251.GG4025@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-4-git-send-email-jack@suse.cz>
 <20160323171226.GB5544@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323171226.GB5544@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-03-16 11:12:26, Ross Zwisler wrote:
> On Mon, Mar 21, 2016 at 02:22:48PM +0100, Jan Kara wrote:
> > Fault handlers currently take complete_unwritten argument to convert
> > unwritten extents after PTEs are updated. However no filesystem uses
> > this anymore as the code is racy. Remove the unused argument.
> 
> This looks good.  Looking at this reminded me that at some point it may be
> good to clean up our buffer head flags checks and make sure we don't have
> checks that don't make sense - we still check for buffer_unwritten() in
> buffer_written(), for instance. 
> 
> The handling of BH_New isn't consistent among filesystems, either - XFS & ext4
> go out of their way to make sure BH_New is not set, while ext2 sets BH_New.
> 
> But I think those are separate from this patch, I think.

Yes, that's a separate thing and I think I've handled most of that in the
following patches. Thanks for review!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
