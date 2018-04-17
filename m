Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB77A22590E08
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 16:35:09 -0700 (PDT)
Date: Tue, 17 Apr 2018 19:34:59 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417233459.GB23194@thunk.org>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org>
 <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
 <20180417165756.GC24738@magnolia>
 <BE1492A6-DF52-428C-A3CE-E91F0ACC0ADA@dilger.ca>
 <20180417175007.GB5210@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180417175007.GB5210@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 10:50:07AM -0700, Darrick J. Wong wrote:
> syslinux does FIEMAP w/ FIBMAP fallback.
> 
> lilo & elilo still use FIBMAP only, but lilo hasn't seen a release since
> 2015 and elilo 2013.  I prefer not to add FIBMAP support in XFS-DAX for
> the singular case of booting off pmem via lilo.

It shouldn't be that hard to write a userspace emulation layer which
exports a FIBMAP-like functional interface but gets the information
from the kernel using the FIMAP ioctl....

					- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
