Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E0D3202E53D9
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 12:11:31 -0700 (PDT)
Date: Tue, 26 Jun 2018 13:11:29 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Message-ID: <20180626191129.GA18273@linux.intel.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180626185830.GA7171@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 02:58:30PM -0400, Mike Snitzer wrote:
> On Tue, Jun 26 2018 at  2:52pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
> > <ross.zwisler@linux.intel.com> wrote:
> > > QUEUE_FLAG_DAX is an indication that a given block device supports
> > > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> > > or "sector" modes.  These namespaces lack struct page and are prevented
> > > from participating in filesystem DAX.
> > >
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Suggested-by: Mike Snitzer <snitzer@redhat.com>
> > > Cc: stable@vger.kernel.org
> > 
> > Why is this cc: stable? What is the user visible impact of this change
> > especially given the requirement to validate QUEUE_FLAG_DAX with
> > bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
> > afaics.
> 
> This isn't cosmetic when you consider that stacking up a DM device is
> looking at this flag to determine whether a table does or does _not_
> support DAX.
> 
> So this patch, in conjunction with the other changes in the series, is
> certainly something I'd consider appropriate for stable.
> 
> Mike

Because in patch 3 of this series we now use the full bdev_dax_supported()
instead of just checking the queue flag in device_supports_dax(), I agree that
this isn't strictly necessary for stable.  device_supports_dax() will still
notice that the raw/sector namespaces don't support DAX because
bdev_dax_supported() will fail, and we'll end up doing the right thing and not
setting QUEUE_FLAG_DAX on the DM device.

I think maybe it's good to have in stable for completeness (and it's a very
small change), but if we drop it from stable the code will still do the right
thing AFAICT.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
