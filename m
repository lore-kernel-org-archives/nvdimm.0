Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AC04201B0419
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 10:28:01 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id s5so29862546oth.7
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 10:28:01 -0800 (PST)
MIME-Version: 1.0
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard> <20190216053957.GU20493@dastard>
 <66c6ad91-9e8c-a01b-d0c0-ce04e628db67@suse.de>
In-Reply-To: <66c6ad91-9e8c-a01b-d0c0-ce04e628db67@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Feb 2019 10:27:49 -0800
Message-ID: <CAPcyv4gYvf923G62uFhuW+tKwY2cdQ=1xqCudqkmQqRN5W0b-g@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 18, 2019 at 2:50 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> On 16/02/2019 06:39, Dave Chinner wrote:
> [..]
>
> >> We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
> >> allow per-device dax status checking for filesystems"). That is,
> >> we can have DAX on the XFS RT device indepently of the data device.
> >>
> >> That is, you set up pmem in three segments - two small identical
> >> segments start get mirrored with RAID1 as the data device, and
> >> the remainder as a block device that is dax capable set up as the
> >> XFS realtime device. Set the RTINHERIT bit on the root directory at
> >> mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
> >> capable realtime device, and all the metadata goes to the software
> >> raided pmem block devices that aren't DAX capable.
> >>
> >> Problem already solved, yes?
> >
> > Sorry, this was meant to be a reply to Dan's email commenting about
> > some people needing mirrored metadata, not the parent that was
> > talking about whole device RAID...
> >
> > i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> > problem...
>
> Trying to answer you both.
>
> But deferring the data redundancy to the application sounds like a no-go
> to me, sorry. We don't do that for "traditional" block storage (SCSI,
> NVMe, you name it). Some applications might already be able to handle it
> but definitively not all. I don't see your random DBMS like MariaDB or
> Postgres already doing data duplication over interleave sets of NV-DIMMs.

Oh, definitely agreed. I was just saying for the subset of
applications that *do* perform application level redundancy the lack
of metadata redundancy was a liability.

> And if you carve out a bit of your pmem space into an own namespace for
> the metadata (did I understand you right here?) you still have the
> problem that all data written to the DIMMs is interleaved in an
> interleave set, if I understand it correctly.
>
> So if one DIMM in your interleave set goes bad, you're lost anyways.

Yes, if you want to be able to survive the loss of a single-DIMM then
you need to disable interleaving and RAID across the DIMMs. However,
once you do that, dax for data can't work by definition, but RAID for
metadata would work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
