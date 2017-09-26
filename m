Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B10E82095E537
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 07:30:47 -0700 (PDT)
Date: Tue, 26 Sep 2017 16:33:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
Message-ID: <20170926143357.GA18758@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-4-ross.zwisler@linux.intel.com>
 <20170926063234.GA6870@lst.de>
 <CAPcyv4hKb1PshbjLxyWz2fdj=dK2fi2qgJLFaT9pVnmaOoWV6g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hKb1PshbjLxyWz2fdj=dK2fi2qgJLFaT9pVnmaOoWV6g@mail.gmail.com>
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
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 26, 2017 at 06:59:37AM -0700, Dan Williams wrote:
> > I think you probably want an IOCB_DAX flag to check IS_DAX once and
> > then stick to it, similar to what we do for direct I/O.
> 
> I wonder if this works better with a reference count mechanism
> per-file so that we don't need a hold a lock over the whole
> transition. Similar to request_queue reference counting, when DAX is
> being turned off we block new references and drain the in-flight ones.

Maybe.  But that assumes we want to be stuck in a perpetual binary
DAX on/off state on a given file.  Which makes not only for an awkward
interface (inode or mount flag), but also might be fundamentally the
wrong thing to do for some media where you'd happily read directly
from it but rather buffer writes in DRAM.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
