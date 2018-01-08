Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC3202236BA8B
 for <linux-nvdimm@lists.01.org>; Mon,  8 Jan 2018 08:03:32 -0800 (PST)
Date: Mon, 8 Jan 2018 11:08:38 -0500
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6 2/2] dm: allow device-mapper to operate without dax
 support
Message-ID: <20180108160838.GC10224@redhat.com>
References: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151198200599.7051.6920383092194777505.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151198200599.7051.6920383092194777505.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, kbuild test robot <lkp@intel.com>, Alasdair Kergon <agk@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 29 2017 at  2:00pm -0500,
Dan Williams <dan.j.williams@intel.com> wrote:

> Change device-mapper's DAX dependency to require the presence of at
> least one DAX_DRIVER. This allows device-mapper to be built without
> bringing the DAX core along which is especially wasteful when there are
> no DAX drivers, like BLK_DEV_PMEM, configured.
> 
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
