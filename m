Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22c.google.com (mail-lf0-x22c.google.com
 [IPv6:2a00:1450:4010:c07::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1595721F6A6D2
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:41:18 -0800 (PST)
Received: by mail-lf0-x22c.google.com with SMTP id r80so14320759lfe.13
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:47:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180223213827.24808-1-ross.zwisler@linux.intel.com>
References: <20180223213827.24808-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Feb 2018 13:47:17 -0800
Message-ID: <CAPcyv4ifuvD04hOvRAk8MpUG10dna=SgqPVMxujQCoMUcvooqQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, tests: firmware-update.sh post-test cleanup
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 23, 2018 at 1:38 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> When firmware-update.sh is run multiple times by itself, all runs but the
> first fail with this:
>
> + ../ndctl/ndctl update-firmware -d nmem1 -f update-fw.img
>   Error: START FIRMWARE UPDATE failed: 0x9
>
>   Error: Another firmware upload in progress or finished.
>
> Fix this by having the test properly clean up and disable all the nfit_test
> regions and unloading the nfit_test module, as we do in test/pmem-errors.sh
> et al.

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
