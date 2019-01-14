Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22B7721A09130
 for <linux-nvdimm@lists.01.org>; Sun, 13 Jan 2019 20:41:23 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id a77so16847290oii.5
 for <linux-nvdimm@lists.01.org>; Sun, 13 Jan 2019 20:41:23 -0800 (PST)
MIME-Version: 1.0
References: <20190114021929.3658-1-richardw.yang@linux.intel.com>
In-Reply-To: <20190114021929.3658-1-richardw.yang@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 13 Jan 2019 20:41:11 -0800
Message-ID: <CAPcyv4h7DeZmoRMxNpC2nGCWHJEw_QOy2J6nev037Ywtd-NTKQ@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: remove duplicate set nd_set in
 acpi_nfit_init_interleave_set()
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
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 13, 2019 at 6:19 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> We allocate nd_set in acpi_nfit_init_interleave_set() and assignn it to
> ndr_desc, while the assignment is done twice in this function.
>
> This patch removes the second assignment. No functional change.

I think it makes more sense to remove the first assignment. Don't let
an uninitialized nd_set escape that routine. Either ->nd_set is left
NULL or it points to an initialized instance instead of potentially a
zeroed one.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
