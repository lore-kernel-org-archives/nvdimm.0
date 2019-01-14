Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa7.dell-outbound.iphmx.com (esa7.dell-outbound.iphmx.com
 [68.232.153.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C66B21A143EF
 for <linux-nvdimm@lists.01.org>; Sun, 13 Jan 2019 23:21:12 -0800 (PST)
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
 by mx0b-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x0E7JeFS086349
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 02:21:10 -0500
Received: from esa3.dell-outbound2.iphmx.com (esa3.dell-outbound2.iphmx.com
 [68.232.154.63])
 by mx0b-00154901.pphosted.com with ESMTP id 2q0jugruhs-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 02:21:10 -0500
From: "Pandel, Sujith" <Sujith.Pandel@dell.com>
Subject: Re: [PATCH] acpi/nfit: Fix command-supported detection
References: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-ID: <29b49260-8b67-ec44-24f6-8fdc32e8f648@dell.com>
Date: Mon, 14 Jan 2019 12:51:03 +0530
MIME-Version: 1.0
In-Reply-To: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On 12-Jan-19 5:29 AM, Dan Williams wrote:
> The _DSM function number validation only happens to succeed when the
> generic Linux command number translation corresponds with a
> DSM-family-specific function number. This breaks NVDIMM-N
> implementations that correctly implement _LSR, _LSW, and _LSI, but do
> not happen to publish support for DSM function numbers 4, 5, and 6.
>
> Recall that the support for _LS{I,R,W} family of methods results in the
> DIMM being marked as supporting those command numbers at
> acpi_nfit_register_dimms() time. The DSM function mask is only used for
> ND_CMD_CALL support of non-NVDIMM_FAMILY_INTEL devices.
>
> Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command...")
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/pmem/ndctl/issues/78
> Reported-by: Sujith Pandel <sujith_pandel@dell.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Sujith, this is a larger change than what you originally tested, but it
> should behave the same. I wanted to consolidate all the code that
> handles Linux command number to DIMM _DSM function number translation.
>
> If you have a chance to re-test with this it would be much appreciated.
>
> Thanks for the report!
Re-verified by applying this patch over LTS kernel-4.20.2 with ndctl v62.
namespace creation and modification works fine on Dell NVDIMM-Ns.
Thanks for helping me on this!

Tested-by: Sujith Pandel <sujith_pandel@dell.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
