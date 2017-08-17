Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DAF32095B9CB
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 08:18:28 -0700 (PDT)
Date: Thu, 17 Aug 2017 09:20:54 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: explain how read(2)/write(2) addresses are validated
Message-ID: <20170817152054.GA27641@linux.intel.com>
References: <CAGXu5jJqoegDg07vR0iRRV1U_qOpZx5eLbywEwD_sm-D7sQmdA@mail.gmail.com>
 <20170816173615.10098-1-ross.zwisler@linux.intel.com>
 <20170817085332.GA7644@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170817085332.GA7644@quack2.suse.cz>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, Will Deacon <will.deacon@arm.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-fsdevel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 10:53:32AM +0200, Jan Kara wrote:
> On Wed 16-08-17 11:36:15, Ross Zwisler wrote:
> > Add a comment explaining how the user addresses provided to read(2) and
> > write(2) are validated in the DAX I/O path.  We call dax_copy_from_iter()
> > or copy_to_iter() on these without calling access_ok() first in the DAX
> > code, and there was a concern that the user might be able to read/write to
> > arbitrary kernel addresses with this path.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Looks OK to me so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Just I'd note that standard buffered read / write path is no different so I
> don't see a big point in adding this comment when it is not in any other
> path either...

Fair enough.  Yea, if it's not in any of the other paths either and it's just
common knowledge that these addresses are validated at the VFS layer, we can
leave it out.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
