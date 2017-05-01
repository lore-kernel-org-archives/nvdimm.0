Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79FBB21A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 15:41:59 -0700 (PDT)
Date: Mon, 1 May 2017 15:41:58 -0700
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH v3] ndctl: add clear error support for ndctl
Message-ID: <20170501224158.GA21546@djiang5-desk3.ch.intel.com>
References: <149367376823.14721.16804310177322088175.stgit@djiang5-desk3.ch.intel.com>
 <1493676369.30303.30.camel@hpe.com>
 <ebf0cdd5-106c-9fb4-8272-589466423e9c@intel.com>
 <1493677696.30303.32.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493677696.30303.32.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 01, 2017 at 03:28:18PM -0700, Kani, Toshimitsu wrote:
> On Mon, 2017-05-01 at 15:16 -0700, Dave Jiang wrote:
> >
> > On 05/01/2017 03:06 PM, Kani, Toshimitsu wrote:
> > > On Mon, 2017-05-01 at 14:23 -0700, Dave Jiang wrote:
> > >  :
> > > > +++ b/Documentation/ndctl-clear-error.txt
> > > > @@ -0,0 +1,37 @@
> > > > +ndctl-clear-error(1)
> > > > +====================
> > > > +
> > > > +NAME
> > > > +----
> > > > +ndctl-clear-error - clear badblocks for a device
> > > > +
> > > > +SYNOPSIS
> > > > +--------
> > > > +[verse]
> > > > +'ndctl clear-error' [<options>]
> > > > +
> > > > +EXAMPLES
> > > > +--------
> > > > +
> > > > +Clear poison (bad blocks) for the provided device
> > > > +[verse]
> > > > +ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
> > > > +
> > > > +Clear poison (bad blocks) at block offset 0 for 8 blocks on
> > > > device
> > > > /dev/dax0.0
> > > > +
> > > > +OPTIONS
> > > > +-------
> > > > +-f::
> > > > +--file::
> > > > +The device/file to be cleared of poison (bad blocks).
> > > > +
> > > > +-s::
> > > > +--start::
> > > > +The offset where the poison (bad block) starts for this
> > > > device.
> > > > +Typically this is acquired from the sysfs badblocks file.
> > > > +
> > > > +-l::
> > > > +--len::
> > > > +The number of badblocks to clear in size of 512 bytes
> > > > increments.
> > > > +
> > >
> > > When a specified range is larger than a badblock range, the command
> > > completes with no-op without any message.  I think it should either
> > > fail with an error message or clear an inclusive badblock.
> >
> > It's suppose to just fail. Looks like I just forgot to insert an
> > error print out.
> 
> Yes, I am fine with the behavior with a proper error message. It'd be
> good to clarify it in the document as well.
> 
> Thanks,
> -Toshi

-- 

Does something like this work for you?

diff --git a/ndctl/clear-error.c b/ndctl/clear-error.c
index 33d930a..1a9b94a 100644
--- a/ndctl/clear-error.c
+++ b/ndctl/clear-error.c
@@ -167,6 +167,7 @@ static int clear_error(struct clear_err *ce)
 	if (check_user_input_range(ce->region, clear_err.bb_start,
 				clear_err.bb_len) == 0) {
 		rc = -EINVAL;
+		error("badblocks region input out of range.\n");
 		goto cleanup;
 	}
 


Dave Jiang
Software Engineer, Data Center Group
Intel Corp.
dave.jiang@intel.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
