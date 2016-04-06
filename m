Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9B2D1A1F98
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 01:22:49 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 06 Apr 2016 10:22:47 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm, nfit: report multiple interface codes per-dimm
In-Reply-To: <20160406003515.6719.15443.stgit@dwillia2-desk3.jf.intel.com>
References: <20160406003515.6719.15443.stgit@dwillia2-desk3.jf.intel.com>
Message-ID: <90956f627d907989f05b03fd4e6d826d@suse.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 2016-04-06 02:35, Dan Williams wrote:
> Starting with ACPI 6.1 an NFIT table will report multiple 'NVDIMM
> Control Region Structure' instances per-dimm, one for each supported
> format interface.  Report that code in the following format in sysfs:
> 
>     nmemX/nfit/formats
>     nmemX/nfit/format
>     nmemX/nfit/format1
>     nmemX/nfit/format2
>     ...
>     nmemX/nfit/formatN
> 
> Where format2 - formatN are theoretical as there are no known DIMMs 
> with
> support for more than two interface formats.
> 
> This layout is compatible with existing libndctl binaries that only
> expect one code per-dimm as they will ignore nmemX/nfit/formats and
> nmemX/nfit/formatN.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks OK to me
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
