Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6609D8220D
 for <linux-nvdimm@lists.01.org>; Wed, 21 Dec 2016 04:36:07 -0800 (PST)
Date: Wed, 21 Dec 2016 13:36:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/3] dax: masking off __GFP_FS in fs DAX handlers
Message-ID: <20161221123603.GA10320@quack2.suse.cz>
References: <148184524161.184728.14005697153880489871.stgit@djiang5-desk3.ch.intel.com>
 <20161216010730.GY4219@dastard>
 <20161216161916.GA2410@linux.intel.com>
 <20161216220450.GZ4219@dastard>
 <20161219195302.GI17598@quack2.suse.cz>
 <20161219211711.GD4219@dastard>
 <20161220101352.GE3769@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161220101352.GE3769@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, hch@lst.de, linux-mm@kvack.org, tytso@mit.edu, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 20-12-16 11:13:52, Michal Hocko wrote:
> I am not fully familiar with the DAX changes which started this
> discussion but if there is a reclaim recursion problem from within the
> fault path then the scope api sounds like a good fit here.
> 
> [1] http://lkml.kernel.org/r/20161215140715.12732-1-mhocko@kernel.org

Yes, once your scope API and associated ext4 changes are in, we can stop
playing tricks with gfp_mask in DAX code at least for ext4.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
