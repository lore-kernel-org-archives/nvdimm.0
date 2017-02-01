Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B300681F87
 for <linux-nvdimm@lists.01.org>; Wed,  1 Feb 2017 00:08:40 -0800 (PST)
Date: Wed, 1 Feb 2017 09:08:38 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 13/17] fs: update mount_bdev() to lookup dax
 infrastructure
Message-ID: <20170201080838.GC29170@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148559263442.11180.2158046423959539211.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170130122658.GB9043@lst.de>
 <CAPcyv4imiVCvtKbXJeK5_BhPhd-Gnr9nOz-ML6TKfVSQ9Rr3Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4imiVCvtKbXJeK5_BhPhd-Gnr9nOz-ML6TKfVSQ9Rr3Cg@mail.gmail.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 30, 2017 at 10:29:12AM -0800, Dan Williams wrote:
> On Mon, Jan 30, 2017 at 4:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> > On Sat, Jan 28, 2017 at 12:37:14AM -0800, Dan Williams wrote:
> >> This is in preparation for removing the ->direct_access() method from
> >> block_device_operations.
> >
> > I don't think mount_bdev has any business knowing about DAX.
> > Just call dax_get_by_host manually from the affected file systems for
> > now, and in the future we can have a pure-DAX mount_dax helper.
> 
> Ok, since we already need dax_get_by_host() in the blkdev_writepages()
> path I can sprinkle a few more of those calls and leave mount_bdev
> alone.

Huh?  I thought we stopped using DAX I/O for the block device nodes
a while ago?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
