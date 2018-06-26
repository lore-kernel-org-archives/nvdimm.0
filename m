Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9739211F8889
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 13:54:27 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 20:54:03 +0000
Message-ID: <1530046327.14039.273.camel@hpe.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
 <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com>
In-Reply-To: <20180626191346.GA7233@redhat.com>
Content-Language: en-US
Content-ID: <3D1889CB4901114A9FD8D1212F7DAD23@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-06-26 at 15:13 -0400, Mike Snitzer wrote:
> On Tue, Jun 26 2018 at  3:07pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > On Tue, Jun 26, 2018 at 11:58 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > > On Tue, Jun 26 2018 at  2:52pm -0400,
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > > 
> > > > On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
> > > > <ross.zwisler@linux.intel.com> wrote:
> > > > > QUEUE_FLAG_DAX is an indication that a given block device supports
> > > > > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> > > > > or "sector" modes.  These namespaces lack struct page and are prevented
> > > > > from participating in filesystem DAX.
> > > > > 
> > > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > > Suggested-by: Mike Snitzer <snitzer@redhat.com>
> > > > > Cc: stable@vger.kernel.org
> > > > 
> > > > Why is this cc: stable? What is the user visible impact of this change
> > > > especially given the requirement to validate QUEUE_FLAG_DAX with
> > > > bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
> > > > afaics.
> > > 
> > > This isn't cosmetic when you consider that stacking up a DM device is
> > > looking at this flag to determine whether a table does or does _not_
> > > support DAX.
> > > 
> > > So this patch, in conjunction with the other changes in the series, is
> > > certainly something I'd consider appropriate for stable.
> > 
> > I think this classifies as something that never worked correctly and
> > is not a regression. It does not identify which commit it is repairing
> > or the user visible failure mode.
> 
> So you're taking issue with making stacked dax configs work in older
> kernels?  That's fine.  We can drop the stable cc if you like.
> 
> But I mean we intended for this to work.. so the Fixes commit references
> can easily be added, e.g.: 545ed20e6df68a4d2584a29a2a28ee8b2f7e9547
> ("dm: add infrastructure for DAX support")

When this dm change was made, the pmem driver supported DAX for both raw
and memory modes (note: sector mode does not use the pmem driver).  I
think the issue was introduced when we dropped DAX support from raw
mode.

Thanks,
-Toshi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
