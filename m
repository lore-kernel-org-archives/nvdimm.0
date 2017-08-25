Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B89B21E47D53
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 00:00:13 -0700 (PDT)
Date: Fri, 25 Aug 2017 09:02:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: cache dax_device lookup result
Message-ID: <20170825070247.GB9103@lst.de>
References: <150362134292.39142.1715377949592729029.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150362134833.39142.12423673180125514125.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170825053246.GF4800@magnolia>
 <CAPcyv4iXvOV6gHc=VsozHhxCdWDibx64agAk86K-G2-CdHVpuA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iXvOV6gHc=VsozHhxCdWDibx64agAk86K-G2-CdHVpuA@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 11:24:10PM -0700, Dan Williams wrote:
> This would also fix the bug I just realized was in these patches
> around matching dax_get_by_host() with put_dax(). In fact, if it's
> acceptable to hang a dax_dev off a gendisk then we don't need
> dax_get_by_host() at all.

I want to get the block code out of the loop entirely.  I'm a little
overloaded with work at the moment, but my plan was to add a mount_dax
equivalent to mount_bdev, and add support to the XFS buffer cache and
log code to go straight to DAX.  For the buffer cache we'd still have
to double buffer to provide transaction gurantees, but for the log
formatting it directly to memory should also provide nice speedups.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
