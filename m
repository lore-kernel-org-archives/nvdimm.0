Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from vena.lwn.net (tex.lwn.net [70.33.254.29])
 (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CEA51A1E40
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jul 2016 16:13:57 -0700 (PDT)
Date: Wed, 20 Jul 2016 17:13:02 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/2] dax: some small updates to dax.txt documentation
Message-ID: <20160720171302.13e14a0d@lwn.net>
In-Reply-To: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
References: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-doc@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 14 Jul 2016 15:40:48 -0600
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> These are originally from Matthew Wilcox and were part of his huge
> "mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
> support.
> 
> I'm breaking these small changes out as they stand on their own and add
> useful information to Documentation/filesystems/dax.txt.

So how were you thinking of routing these?  I can take the docs fix, of
course, but part 2 is a bit out of my turf.  If you want to route them
together via another tree that's fine, just let me know.

Thanks,

jon
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
