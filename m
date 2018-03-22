Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 522462252CBA8
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 09:56:22 -0700 (PDT)
Date: Thu, 22 Mar 2018 18:02:52 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 14/14] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180322170252.GA5542@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167311132.5268.8502709708606276650.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180322074303.GC28713@lst.de>
 <CAPcyv4iO+xDLTgYcAApQwec1hDrVSrAyeAiFoA=anzpxEiBydA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iO+xDLTgYcAApQwec1hDrVSrAyeAiFoA=anzpxEiBydA@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 22, 2018 at 09:28:11AM -0700, Dan Williams wrote:
> I can switch to the for() loop model, but it isn't 'done' flag, it's a
> 'retry' flag. I.e. if xfs_break_leased_layouts() dropped
> XFS_MMAPLOCK_EXCL we need to retry xfs_break_dax_layouts(), and if

Oh, indeed.

> xfs_break_dax_layouts() slept we need to immediately retry it.
> So, how
> about this?

Ah, with that that the loop doesn't work too well, especially the
continue inside a switch statement is probably not to good.  I guess
we should just stick to your original, modulo better variable naming.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
