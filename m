Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EB2921E87986
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 00:13:41 -0700 (PDT)
Date: Wed, 13 Sep 2017 15:16:35 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/3] ext4: test for inline data + DAX corruption
Message-ID: <20170913071635.GB8034@eguan.usersys.redhat.com>
References: <20170912044521.22644-1-ross.zwisler@linux.intel.com>
 <20170912044521.22644-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912044521.22644-3-ross.zwisler@linux.intel.com>
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
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 11, 2017 at 10:45:21PM -0600, Ross Zwisler wrote:
> Add a regression test for the following kernel commit:
> 
>   ext4: prevent data corruption with inline data + DAX
> 
> The test passes either if we don't encounter corruption, or if mounting
> with DAX + inline data fails.  The latter is the way that we prevent this
> issue in the kernel.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Besides the gitignore entry order issue and call the test program from
$here/src/... issue, need another require rule:

_require_ext4_mkfs_feature "inline_data"

Otherwise this looks fine to me.

Thanks,
Eryu
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
