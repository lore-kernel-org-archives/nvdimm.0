Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22f.google.com (mail-lf0-x22f.google.com
 [IPv6:2a00:1450:4010:c07::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 86E7E222630B8
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 22:35:04 -0800 (PST)
Received: by mail-lf0-x22f.google.com with SMTP id t79so10883135lfe.3
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 22:41:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151933258802.36856.4324987007442257845.stgit@djiang5-desk3.ch.intel.com>
References: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
 <151933258802.36856.4324987007442257845.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:41:03 -0800
Message-ID: <CAPcyv4hcyjAswiETSc-QxHBTiOa0HSch04anrbHRycxBTFsbzw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ndctl: accept DIMM name without -d option
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 22, 2018 at 12:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Making update-firmware in sync with other ndctl syntax and accept DIMM
> id without using a switch. The -d option will still be accepted. Now
> it will accept multiple dimm ids as well as the "all" option.
> i.e.
> ndctl update-firmware -f file.bin nmem0 nmem1
>

This is duplicating the infrastructure that exists in ndctl/dimm.c
let's drop this patch and proceed with merging firmware update into
that file.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
