Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE53821A0BA8E
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 14:17:22 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nvdimm, btt: make sure initializing new metadata clears
 poison
Date: Mon, 8 May 2017 21:17:21 +0000
Message-ID: <1494278239.4192.1.camel@intel.com>
References: <20170426224307.28075-1-vishal.l.verma@intel.com>
 <CAPcyv4hHRf6MEUxj1WvOjb9+JUmTBEh0x4RGGXEHg=kJT+anmg@mail.gmail.com>
In-Reply-To: <CAPcyv4hHRf6MEUxj1WvOjb9+JUmTBEh0x4RGGXEHg=kJT+anmg@mail.gmail.com>
Content-Language: en-US
Content-ID: <ED747FBE871D02448B61AA6FB985616A@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2017-05-08 at 10:00 -0700, Dan Williams wrote:
> On Wed, Apr 26, 2017 at 3:43 PM, Vishal Verma <vishal.l.verma@intel.c
> om> wrote:
> > If we had badblocks/poison in the metadata area of a BTT,
> > recreating the
> > BTT would not clear the poison in all cases, notably the flog area.
> > This
> > is because rw_bytes will only clear errors if the request being
> > sent
> > down is 512B aligned and sized.
> > 
> > Make sure that when writing the map and info blocks, the rw_bytes
> > being
> > sent are of the correct size/alignment. For the flog, instead of
> > doing
> > the smaller log_entry writes only, first do a 'wipe' of the entire
> > area
> > by writing zeroes in large enough chunks so that errors get
> > cleared.
> 
> These eventually nsio_rw_bytes() while the namespace is claimed by a
> btt instance, so this collides with the hack to disable error
> clearing
> for btt. If we want to fix this up for 4.12 I think we need to pass a
> 'flags' parameter to the ->rw_bytes() routine to indicate that we are
> in atomic context (NVDIMM_IO_ATOMIC), rather than assuming that all
> BTT I/O is atomic. Care to code that up? I think we can include it in
> a pull request before the merge window closes.

Ah good point. You mean a flag to say that we're in process context
right?We want to skip the clearing in atomic context..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
