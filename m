Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F36E921CE748D
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 14:33:55 -0700 (PDT)
Date: Tue, 29 Aug 2017 23:36:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
Message-ID: <20170829213635.GA8946@lst.de>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170829212606.GC8608@lst.de>
 <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g@mail.gmail.com>
 <CAPcyv4i2rS0sAxiJSVxFSHirsycaYofuxp3yPxeyB8xzsryx3g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i2rS0sAxiJSVxFSHirsycaYofuxp3yPxeyB8xzsryx3g@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 29, 2017 at 02:35:27PM -0700, Dan Williams wrote:
> Actually, why not just do this directly in xfs_fs_mount()? I think I
> can refactor this to not touch mount_bdev() and put all the details in
> the per-fs mount/umount paths.

Yes, and just cache in in the fs specific superblock.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
