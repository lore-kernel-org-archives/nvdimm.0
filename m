Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BEDF7211F888F
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 12:13:49 -0700 (PDT)
Date: Tue, 26 Jun 2018 15:13:46 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Message-ID: <20180626191346.GA7233@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
 <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26 2018 at  3:07pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, Jun 26, 2018 at 11:58 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > On Tue, Jun 26 2018 at  2:52pm -0400,
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >
> >> On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
> >> <ross.zwisler@linux.intel.com> wrote:
> >> > QUEUE_FLAG_DAX is an indication that a given block device supports
> >> > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
> >> > or "sector" modes.  These namespaces lack struct page and are prevented
> >> > from participating in filesystem DAX.
> >> >
> >> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> >> > Suggested-by: Mike Snitzer <snitzer@redhat.com>
> >> > Cc: stable@vger.kernel.org
> >>
> >> Why is this cc: stable? What is the user visible impact of this change
> >> especially given the requirement to validate QUEUE_FLAG_DAX with
> >> bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
> >> afaics.
> >
> > This isn't cosmetic when you consider that stacking up a DM device is
> > looking at this flag to determine whether a table does or does _not_
> > support DAX.
> >
> > So this patch, in conjunction with the other changes in the series, is
> > certainly something I'd consider appropriate for stable.
> 
> I think this classifies as something that never worked correctly and
> is not a regression. It does not identify which commit it is repairing
> or the user visible failure mode.

So you're taking issue with making stacked dax configs work in older
kernels?  That's fine.  We can drop the stable cc if you like.

But I mean we intended for this to work.. so the Fixes commit references
can easily be added, e.g.: 545ed20e6df68a4d2584a29a2a28ee8b2f7e9547
("dm: add infrastructure for DAX support")
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
