Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68CA52095E518
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 23:29:23 -0700 (PDT)
Date: Tue, 26 Sep 2017 08:32:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
Message-ID: <20170926063234.GA6870@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-4-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-4-ross.zwisler@linux.intel.com>
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
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

We can't just take locking one level up, as we need differnet locking
for different kinds of I/O.

I think you probably want an IOCB_DAX flag to check IS_DAX once and
then stick to it, similar to what we do for direct I/O.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
