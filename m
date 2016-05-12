Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD28E1A1E5A
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 01:38:57 -0700 (PDT)
Date: Thu, 12 May 2016 10:38:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 5/6] dax: for truncate/hole-punch, do zeroing through
 the driver if possible
Message-ID: <20160512083852.GB10306@quack2.suse.cz>
References: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
 <1463000932-31680-6-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463000932-31680-6-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 11-05-16 15:08:51, Vishal Verma wrote:
> In the truncate or hole-punch path in dax, we clear out sub-page ranges.
> If these sub-page ranges are sector aligned and sized, we can do the
> zeroing through the driver instead so that error-clearing is handled
> automatically.
> 
> For sub-sector ranges, we still have to rely on clear_pmem and have the
> possibility of tripping over errors.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

The patch looks good to me now. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
