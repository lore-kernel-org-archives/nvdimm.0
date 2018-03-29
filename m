Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E969221F0DB1D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 11:02:49 -0700 (PDT)
Date: Thu, 29 Mar 2018 20:09:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 05/14] ext4, dax: introduce ext4_dax_aops
Message-ID: <20180329180927.GA16055@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167305782.5268.13485258587227210521.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180329154035.lvsepjvt6vcplshw@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180329154035.lvsepjvt6vcplshw@quack2.suse.cz>
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 29, 2018 at 05:40:35PM +0200, Jan Kara wrote:
> So ext4_direct_IO() for IS_DAX() files will just bail out. So could you
> just provide ext4_dax_direct_IO() which will bail out and use it here? With
> a similar comment as in xfs_vm_direct_IO() that open still needs this
> method set... Thanks!

In fact a common noop_direct_IO might make sense.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
