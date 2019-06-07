Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99053211CED9A
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 12:54:44 -0700 (PDT)
Subject: Re: [PATCH v3 08/10] device-dax: Add a driver for "hmem" devices
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155993567538.3036719.16306480832003017141.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <e2fd563a-1be4-b4dc-09fa-886f0319be5b@intel.com>
Date: Fri, 7 Jun 2019 12:54:44 -0700
MIME-Version: 1.0
In-Reply-To: <155993567538.3036719.16306480832003017141.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kbuild test robot <lkp@intel.com>, ard.biesheuvel@linaro.org, peterz@infradead.org, dave.hansen@linux.intel.com, linux-nvdimm@lists.01.org, linux-efi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/7/19 12:27 PM, Dan Williams wrote:
> This consumes "hmem" devices the producer of "hmem" devices is saved for
> a follow-on patch so that it can reference the new CONFIG_DEV_DAX_HMEM
> symbol to gate performing the enumeration work.

Do these literally show up as /dev/hmemX?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
