Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A157C;
	Fri, 24 Jun 2022 09:08:44 +0000 (UTC)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LTrmD1S0sz686l0;
	Fri, 24 Jun 2022 17:04:44 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 11:08:39 +0200
Received: from localhost (10.81.207.131) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 24 Jun
 2022 10:08:38 +0100
Date: Fri, 24 Jun 2022 10:08:36 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <20220624100836.00004191@Huawei.com>
In-Reply-To: <62b4a3f259aad_32f38a294ee@dwillia2-xfh.notmuch>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
	<20220520172325.000043d8@huawei.com>
	<CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
	<20220531132157.000022c7@huawei.com>
	<62b3fce0bde02_3baed529440@dwillia2-xfh.notmuch>
	<20220623160857.00005fe2@Huawei.com>
	<62b4a3f259aad_32f38a294ee@dwillia2-xfh.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.207.131]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 10:33:38 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> > On Wed, 22 Jun 2022 22:40:48 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >   
> > > Jonathan Cameron wrote:  
> > > > ....
> > > >     
> > > > > > Hi Ben,
> > > > > >
> > > > > > I finally got around to actually trying this out on top of Dan's recent fix set
> > > > > > (I rebased it from the cxl/preview branch on kernel.org).
> > > > > >
> > > > > > I'm not having much luck actually bring up a region.
> > > > > >
> > > > > > The patch set refers to configuring the end point decoders, but all their
> > > > > > sysfs attributes are read only.  Am I missing a dependency somewhere or
> > > > > > is the intent that this series is part of the solution only?
> > > > > >
> > > > > > I'm confused!      
> > > > > 
> > > > > There's a new series that's being reviewed internally before going to the list:
> > > > > 
> > > > > https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3
> > > > > 
> > > > > Given the proximity to the merge window opening and the need to get
> > > > > the "mem_enabled" series staged, I asked Ben to hold it back from the
> > > > > list for now.
> > > > > 
> > > > > There are some changes I am folding into it, but I hope to send it out
> > > > > in the next few days after "mem_enabled" is finalized.    
> > > > 
> > > > Hi Dan,
> > > > 
> > > > I switched from an earlier version of the region code over to a rebase of the tree.
> > > > Two issues below you may already have fixed.
> > > > 
> > > > The second is a carry over from an earlier set so I haven't tested
> > > > without it but looks like it's still valid.
> > > > 
> > > > Anyhow, thought it might save some cycles to preempt you sending
> > > > out the series if these issues are still present.
> > > > 
> > > > Minimal testing so far on these with 2 hb, 2 rp, 4 directly connected
> > > > devices, but once you post I'll test more extensively.  I've not
> > > > really thought about the below much, so might not be best way to fix.
> > > > 
> > > > Found a bug in QEMU code as well (missing write masks for the
> > > > target list registers) - will post fix for that shortly.    
> > > 
> > > Hi Jonathan,
> > > 
> > > Tomorrow I'll post the tranche to the list, but wanted to let you and
> > > others watching that that the 'preview' branch [1] now has the proposed
> > > initial region support. Once the bots give the thumbs up I'll send it
> > > along.
> > > 
> > > To date I've only tested it with cxl_test and an internal test vehicle.
> > > The cxl_test script I used to setup and teardown a x8 interleave across
> > > x2 host bridges and x4 switches is:  
> > 
> > Thanks.  Trivial feedback from a very quick play (busy day).
> > 
> > Bit odd that regionX/size is once write - get an error even if
> > writing same value to it twice.  
> 
> Ah true, that should just silently succeed.
> 
> > Also not debugged yet but on just got a null pointer dereference on
> > 
> > echo decoder3.0 > target0
> > 
> > Beyond a stacktrace pointing at store_targetN and dereference is of
> > 0x00008 no idea yet.  
> 
> The compiler unfortunately does a good job inlining the entirety of all the
> leaf functions beneath store_targetN() so I have found myself needing to
> sprinkle "noinline" to get better back traces.
> 
> > 
> > I was testing with a slightly modified version of a nasty script
> > I was using to test with Ben's code previously.  Might well be
> > doing something wrong but obviously need to fix that crash anyway!  
> 
> Most definitely.
> 
> > Will move to your nicer script below at somepoint as I've been lazy
> > enough I'm still hand editing a few lines depending on number on
> > a particular run.
> > 
> > Should have some time tomorrow to debug, but definitely 'here be
> > dragons' at the moment.  
> 
> Yes. Even before this posting I had shaken out a few crash scenarios just from
> moving from my old QEMU baseline to "jic123/cxl-rework-draft-2" which did
> things like collide PCI MMIO with cxl_test fake CXL ranges. By the way, is
> there a "latest" tag I should be following to stay in sync with what you are
> running for QEMU+CXL? 

For this particular feature should just be mainline QEMU now.
Switch support was picked up a few days ago and I haven't pushed out a rebase
on top of that yet. Famous last words, but I don't 'think' that anything
that isn't yet in upstream QEMU should effect the region code.

I am testing on ARM (which requires the arch and board support which is
awaiting review) but doubt that causes this problem...

> If only to reproduce the same crash scenarios.

