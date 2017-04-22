Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DB0621A04817
 for <linux-nvdimm@lists.01.org>; Sat, 22 Apr 2017 08:42:20 -0700 (PDT)
Date: Sat, 22 Apr 2017 11:25:06 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [resend PATCH v2 11/33] dm: add dax_device and dax_operations
 support
Message-ID: <20170422152505.GB22651@redhat.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149245618859.10206.13182319600260215993.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4iskwS2izbZEtf7vSsk06cd3C0jhbDF3sfsOkWakc6jaw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iskwS2izbZEtf7vSsk06cd3C0jhbDF3sfsOkWakc6jaw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 20 2017 at 12:30pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Mon, Apr 17, 2017 at 12:09 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > Allocate a dax_device to represent the capacity of a device-mapper
> > instance. Provide a ->direct_access() method via the new dax_operations
> > indirection that mirrors the functionality of the current direct_access
> > support via block_device_operations.  Once fs/dax.c has been converted
> > to use dax_operations the old dm_blk_direct_access() will be removed.
> >
> > A new helper dm_dax_get_live_target() is introduced to separate some of
> > the dm-specifics from the direct_access implementation.
> >
> > This enabling is only for the top-level dm representation to upper
> > layers. Converting target direct_access implementations is deferred to a
> > separate patch.
> >
> > Cc: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> 
> Hi Mike,
> 
> Any concerns with these dax_device and dax_operations changes to
> device-mapper for the upcoming merge window?

Sorry for the delay.

I just reviewed them, overall looks good.  The enabling functions in the
DAX code, that are mixed in with the DM changes, could maybe be factored
out into separate earlier patches but I don't feel that strongly about
that.

Feel free to add this tag to the handful of relevant DM patches:

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

I haven't done a merge with the linux-dm.git 'dm-4.12' branch but it'd
be good to verify there aren't any merge conflicts.  If there are then
it'd be nice to know going in to the merge so that we can forecast as
much to Linus.

I really appreciate you doing this work!

Thanks,
Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
