Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C663621A07A80
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 08:26:42 -0700 (PDT)
Date: Tue, 11 Sep 2018 17:26:41 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/2] ext4: Close race between direct IO and
 ext4_break_layouts()
Message-ID: <20180911152641.GF6104@quack2.suse.cz>
References: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
 <e5232336-757e-2338-5b28-7dfadc8eb2c8@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e5232336-757e-2338-5b28-7dfadc8eb2c8@redhat.com>
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
To: sandeen@redhat.com
Cc: lczerner@redhat.com, tytso@mit.edu, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, zwisler@kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon 10-09-18 11:23:56, Eric Sandeen wrote:
> On 8/8/18 12:25 PM, Dave Jiang wrote:
> > From: Ross Zwisler <zwisler@kernel.org>
> > 
> > If the refcount of a page is lowered between the time that it is returned
> > by dax_busy_page() and when the refcount is again checked in
> > ext4_break_layouts() => ___wait_var_event(), the waiting function
> > ext4_wait_dax_page() will never be called.  This means that
> > ext4_break_layouts() will still have 'retry' set to false, so we'll stop
> > looping and never check the refcount of other pages in this inode.
> > 
> > Instead, always continue looping as long as dax_layout_busy_page() gives us
> > a page which it found with an elevated refcount.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Ted - wondering if this one is still on your radar?

Resent the patch to Ted to catch more attention.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
