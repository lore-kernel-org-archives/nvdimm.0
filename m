Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x229.google.com (mail-ua0-x229.google.com
 [IPv6:2607:f8b0:400c:c08::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0190F21E1DAF5
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 16:28:45 -0700 (PDT)
Received: by mail-ua0-x229.google.com with SMTP id d29so13178469uai.2
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 16:30:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804180822.27C4.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
 <20170804180822.27C4.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 16:30:56 -0700
Message-ID: <CAPcyv4heeENTKxGezk65+1NPKn_mmiqygpEhDYdLEgx2SQUZOA@mail.gmail.com>
Subject: Re: [RFC/Patch 2/5] Support Translate SPA for NVDIMM Root Device.
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 4, 2017 at 2:08 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Support Translate SPA for NVDIMM Root Device.
>
> ACPI 6.2 has new specification on _DSM of NVDIMM Root Device
> It is "Translate SPA" which translate from system physical address(SPA)
> to NVDIMM handle and dimm physical address(DPA).
>
> This patch is to support Translate SPA.
>

Ah, yes, this is not needed. The Translate SPA command can be
submitted via ND_CMD_CALL mechanism.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
