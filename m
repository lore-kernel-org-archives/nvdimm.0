Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38BC821AEB0A0
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 11:53:31 -0700 (PDT)
Date: Wed, 2 Aug 2017 14:55:38 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/2] dax, dm: stop requiring dax for device-mapper
Message-ID: <20170802185537.GA16551@redhat.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 02 2017 at  1:57pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> Changes since v2 [1]:
> * rebase on -next to integrate with commit 273752c9ff03 "dm, dax: Make
>   sure dm_dax_flush() is called if device supports it" (kbuild robot)
> * fix CONFIG_DAX dependencies to upgrade CONFIG_DAX=m to CONFIG_DAX=y
>   (kbuild robot)
> 
> [1]: https://www.spinics.net/lists/kernel/msg2570522.html
> 
> ---
> 
> Bart points out that the DAX core is unconditionally enabled if
> device-mapper is enabled. Add some config machinery and some
> stub-static-inline routines to allow dax infrastructure to be deleted
> from device-mapper at compile time.
> 
> Since this depends on commit 273752c9ff03 that's already in -next, this
> should go through the device-mapper tree.

Commit 273752c9ff03eb83856601b2a3458218bb949e46 is upstream as of
v4.13-rc3 -- so no real need to have this go via linux-dm.git

That said, I don't mind picking it up once we are satisfied with the
implementation.  I'll start reviewing shortly.

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
