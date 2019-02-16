Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 150BF2194EB78
 for <linux-nvdimm@lists.01.org>; Sat, 16 Feb 2019 09:05:43 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 98so21866531oty.1
 for <linux-nvdimm@lists.01.org>; Sat, 16 Feb 2019 09:05:43 -0800 (PST)
MIME-Version: 1.0
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard> <20190216053957.GU20493@dastard>
In-Reply-To: <20190216053957.GU20493@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 16 Feb 2019 09:05:31 -0800
Message-ID: <CAPcyv4jkT5i=akskXCzS7ST47iEk=x8Oh84Cp7q+WRpdOX8hGg@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 15, 2019 at 9:40 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
> > On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
> > > (This is a joint proposal with Hannes Reinecke)
> > >
> > > Servers with NV-DIMM are slowly emerging in data centers but one key feature
> > > for reliability of these systems hasn't been addressed up to now, data
> > > redundancy.
> > >
> > > While it would be best to solve this issue in the memory controller of the CPU
> > > itself, I don't see this coming in the next few years. This puts us as the OS
> > > in the burden to create the redundant copies of data for the users.
> > >
> > > If we leave of the DAX support Linux' software RAID implementations (MD,
> > > device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> > > are incompatible with DAX.
> > >
> > > In this session Hannes and I would like to discuss eventual ways how we as an
> > > operating system can mitigate these issues for our users.
> >
> > We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
> > allow per-device dax status checking for filesystems"). That is,
> > we can have DAX on the XFS RT device indepently of the data device.
> >
> > That is, you set up pmem in three segments - two small identical
> > segments start get mirrored with RAID1 as the data device, and
> > the remainder as a block device that is dax capable set up as the
> > XFS realtime device. Set the RTINHERIT bit on the root directory at
> > mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
> > capable realtime device, and all the metadata goes to the software
> > raided pmem block devices that aren't DAX capable.
> >
> > Problem already solved, yes?
>
> Sorry, this was meant to be a reply to Dan's email commenting about
> some people needing mirrored metadata, not the parent that was
> talking about whole device RAID...
>
> i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> problem...

Ah true, thanks for the clarification. I'll give it a try, the last
time I looked RT configurations failed with DAX, but perhaps that's
been fixed and I can drop if from my list of broken DAX items.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
