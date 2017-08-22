Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A67452095B9CE
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 02:32:08 -0700 (PDT)
Date: Tue, 22 Aug 2017 11:34:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170822093438.GC4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170821215703.GA24473@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170821215703.GA24473@linux.intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 21-08-17 15:57:03, Ross Zwisler wrote:
> On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
> > Pretty crude for now...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> One other thing that should probably be wired up before this is all said and
> done is the VmFlag string in /proc/<pid>/smaps.  Right now when we set this
> flag it ends up as ??:

Thanks. Patch folded so that I don't forget about this when updating the
patch to the new interface :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
