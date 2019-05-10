Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com
 [IPv6:2607:f8b0:4864:20::330])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8B2521268F9C
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 12:58:57 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id g8so6655019otl.8
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 12:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190510190839.29637-1-vishal.l.verma@intel.com>
In-Reply-To: <20190510190839.29637-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 May 2019 12:58:45 -0700
Message-ID: <CAPcyv4h+hRYTAefvK78PEe0+1UQAmmvR=feDderNc7nB35nGzg@mail.gmail.com>
Subject: Re: [ndctl PATCH 0/4] static analysis fixes
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 10, 2019 at 12:08 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> This series just contains a handful of static analysis fixes in
> preparation for the v65 release.
>
> Vishal Verma (4):
>   ndctl/namespace.c: fix resource leak
>   ndctl/namespace.c: fix an unchecked return value
>   libndctl: Fix an unhandled return in ndctl_bus_poll_scrub_completion()
>   ndctl/namespace.c: Fix a potential integer overflow

These all look good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
