Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B6F421F0DB2F
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 08:38:17 -0700 (PDT)
Date: Thu, 29 Mar 2018 17:44:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 06/14] ext2, dax: introduce ext2_dax_aops
Message-ID: <20180329154455.rq4dcvtplgciv3xm@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167306296.5268.6656046711107190095.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167306296.5268.6656046711107190095.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed 21-03-18 15:57:43, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings.
> 
> Cc: Jan Kara <jack@suse.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks for the cleanup in the patch when setting inode ops. The patch looks
good except the same comment applies as for ext4 - please provide
ext2_dax_direct_IO() which will just bail and use it in ext2_dax_aops.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
