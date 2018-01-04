Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36CD521F833D6
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 10:07:03 -0800 (PST)
Date: Thu, 4 Jan 2018 13:12:03 -0500
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6 0/2] dax, dm: stop requiring dax for device-mapper
Message-ID: <20180104181202.GA14491@redhat.com>
References: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Alasdair Kergon <agk@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 29 2017 at  1:59pm -0500,
Dan Williams <dan.j.williams@intel.com> wrote:

> Changes since v5 [1]:
> * Make DAX_DRIVER select DAX to simplify the Kconfig dependencies
>   (Michael)
> * Rebase on 4.15-rc1 and add new IS_ENABLED(CONFIG_DAX_DRIVER) checks in
>   drivers/md/dm-log-writes.c.
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2017-September/012569.html
> 
> ---
> 
> Hi Mike,
> 
> Bart points out that the DAX core is unconditionally enabled if
> device-mapper is enabled. Add some config machinery and some
> stub/static-inline routines to allow dax infrastructure to be deleted
> from device-mapper at compile time.

Hey Dan,

Did you want me to pick this up for 4.16 or were you thinking of sending
the changes through a different tree?

I'm fine with picking these up so long as you don't expect the dax.h and
Kconfig changes to become a source of conflict come merge time.

Let me know, thanks!
Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
