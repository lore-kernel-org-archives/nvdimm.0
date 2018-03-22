Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D6A322551B9C
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 00:21:04 -0700 (PDT)
Date: Thu, 22 Mar 2018 08:27:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 13/14] xfs: prepare xfs_break_layouts() for another
 layout type
Message-ID: <20180322072734.GB28713@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
> +				| (reason == BREAK_UNMAPI
> +					? XFS_MMAPLOCK_EXCL : 0)));

please split the assert, e.g.:

	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));

	switch (reason) {
+	case BREAK_UNMAPI:
		ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
> +		/* fall through */
> +	case BREAK_WRITE:
> +		error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
> +		break;
> +	default:
> +		error = -EINVAL;
> +		break;
> +	}
> +
> +	return error;

I have to say I'd prefer BREAK_UNMAP over BREAK_UNMAPI given that weird
I suffix doesn't buy us anything, but that's just a minor issue.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
