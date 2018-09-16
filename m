Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E780521962301
 for <linux-nvdimm@lists.01.org>; Sat, 15 Sep 2018 18:32:41 -0700 (PDT)
Date: Sat, 15 Sep 2018 21:32:31 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 1/3] ext4, dax: add ext4_bmap to ext4_dax_aops
Message-ID: <20180916013231.GD8652@thunk.org>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
 <20180914145114.11122-2-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180914145114.11122-2-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 14, 2018 at 08:51:12AM -0600, Toshi Kani wrote:
> Ext4 mount path calls .bmap to the journal inode. This currently
> works for the DAX mount case because ext4_iget() always set
> 'ext4_da_aops' to any regular files.
> 
> In preparation to fix ext4_iget() to set 'ext4_dax_aops' for ext4
> DAX files, add ext4_bmap() to 'ext4_dax_aops'. .bmap works for
> DAX inodes. [1]
> 
> [1]: https://lkml.org/lkml/2018/9/12/803
> Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: <stable@vger.kernel.org>

Thanks, applied.

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
