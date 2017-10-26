Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E751F203525E5
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 11:18:21 -0700 (PDT)
Date: Thu, 26 Oct 2017 12:22:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20171026182205.GA8048@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-19-jack@suse.cz>
 <20171024211007.GA1611@linux.intel.com>
 <20171026132402.GB31161@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171026132402.GB31161@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 26, 2017 at 03:24:02PM +0200, Jan Kara wrote:
> On Tue 24-10-17 15:10:07, Ross Zwisler wrote:
> > On Tue, Oct 24, 2017 at 05:24:15PM +0200, Jan Kara wrote:
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > This looks unchanged since the previous version?
> 
> Ah, thanks for checking. I forgot to commit modifications. Attached is
> really updated patch.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

> From 59eeec2998ed9b3840aab951f213148cb1d053a5 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 19 Oct 2017 14:44:55 +0200
> Subject: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and MAP_SYNC
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, you can add: 

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
