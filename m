Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38A7421A16ECB
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 18:43:42 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 05/14] dm: add ->flush() dax operation support
Date: Thu, 15 Jun 2017 01:44:54 +0000
Message-ID: <1497491062.9288.19.camel@hpe.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703985321.20620.13954624502810597823.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149703985321.20620.13954624502810597823.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <FEFFC8E73D2A434CA87A21416DB02246@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2017-06-09 at 13:24 -0700, Dan Williams wrote:
> Allow device-mapper to route flush operations to the
> per-target implementation. In order for the device stacking to work
> we need a dax_dev and a pgoff relative to that device. This gives
> each layer of the stack the information it needs to look up the
> operation pointer for the next level.
> 
> This conceptually allows for an array of mixed device drivers with
> varying flush implementations.
> 
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me.

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
