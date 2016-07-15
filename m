Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 8D8381A1F00
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 22:52:07 -0700 (PDT)
Subject: Re: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
References: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Xiao Guangrong <guangrong.xiao@intel.com>
Message-ID: <578878E7.9060504@intel.com>
Date: Fri, 15 Jul 2016 13:47:19 +0800
MIME-Version: 1.0
In-Reply-To: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 07/15/2016 11:28 AM, Dan Williams wrote:
> acpi_evaluate_object() allocates memory. Free the buffer allocated
> during acpi_nfit_add().
>

Dan, thanks for your fix.

Another one is the use-after-free issue in acpi_nfit_notify():

	/* Evaluate _FIT */
	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
         ...
  		acpi_desc->nfit =
			(struct acpi_nfit_header *)obj->buffer.pointer;
         ...
         kfree(buf.pointer);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
