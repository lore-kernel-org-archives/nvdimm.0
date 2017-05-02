Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61FC121A13483
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 11:44:32 -0700 (PDT)
Date: Tue, 2 May 2017 12:43:10 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4] ndctl: add clear error support for ndctl
Message-ID: <20170502184309.GA11414@omniknight.lm.intel.com>
References: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
 <1493684163.30303.36.camel@hpe.com>
 <dc1d6252-9c8c-5298-2823-2609db70ceb6@intel.com>
 <1493743683.30303.38.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493743683.30303.38.camel@hpe.com>
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

On 05/02, Kani, Toshimitsu wrote:
> On Tue, 2017-05-02 at 09:18 -0700, Dave Jiang wrote:
> > > +-l::
> > > > +--len::
> > > > +The number of badblocks to clear in size of 512 bytes
> > > > increments. The
> > > > +length must fit within the badblocks range. If the length
> > > > exceeds the
> > > > +badblock range or is 0, the command will fail.
> > >
> > > Actually, I am seeing '-l 0' works just like '-l 1'.
> >
> > Oh now I remembered that Vishal requested that no length does 1 block
> > clear. Do you want me to correct documentation or behavior?
> 
> What is the reason behind of his request?

Ah, so my intention/reasoning was if someone does a simple:
  ndctl clear-error -s 'X'
without providing a -l argument, it should dimply clear that one block.
However I wouldn't think -l0 should clear one block, we should either
error out, or treat it as a dry-run (perhaps this could be an indirect
way to check if a certain block is in the badblocks list?)

Anyway, I'm not too attached to the "should work without providing a -l"
thing, and we can make -l mandatory again if that makes most sense.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
