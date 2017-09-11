Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A925421E87990
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 07:38:22 -0700 (PDT)
Date: Mon, 11 Sep 2017 10:41:11 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 2/2] dm: allow device-mapper to operate without dax
 support
Message-ID: <20170911144111.GA15556@redhat.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150169668989.39569.8174620146135008137.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150169668989.39569.8174620146135008137.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 02 2017 at  1:58pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> Rather than have device-mapper directly 'select DAX', let the fact that
> BLK_DEV_PMEM selects dax act as a gate for the device-mapper dax
> support. We arrange for all the dax core routines to compile to nops
> when CONFIG_DAX=n. With that in place we can simply handle the
> alloc_dax() error as expected and ifdef out the other device-mapper-dax
> support code.
> 
> Now, if dax is provided by a leaf driver that driver may only arrange to
> compile the dax core as a module. Since device-mapper dax support is
> consumed by the always-built-in portion of the device-mapper
> implementation we need to upgrade from DAX=m to DAX=y.

I applied the patches and then got nervous once I dug in.. this last
paragraph makes little sense to me.  "the always-built-in portion of the
device-mapper implementation" is why: DM core can happily be compiled as
a module (dm-mod.ko).

And I'm not sure why you're referencing DAX related
drivers/md/dm-builtin.c, why are you attachd DM's DAX support to that?
I'm not seeing where that is actually happening.

I don't see why DM's support for DAX would need to force DAX to be
builtin rather than just a module.

Sorry I didn't get around to looking at this until now, but it seems you
went wrong along the way?  Or maybe I'm just missing something?

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
