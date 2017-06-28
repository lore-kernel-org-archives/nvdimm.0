Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x232.google.com (mail-yb0-x232.google.com
 [IPv6:2607:f8b0:4002:c09::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 751BB21CB74AB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 14:09:50 -0700 (PDT)
Received: by mail-yb0-x232.google.com with SMTP id e201so23086395ybb.1
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 14:11:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1f95797092f647a92ee382e80b9b739b18518ee3.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
 <1f95797092f647a92ee382e80b9b739b18518ee3.1497939166.git.jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jun 2017 14:11:21 -0700
Message-ID: <CAPcyv4iWbQV0PthwdE0F-3TAd_oVhgSwujPLcdPek5MYN8kL=g@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] libnvdimm: New ACPI 6.2 DSM functions
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 20, 2017 at 9:51 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> ACPI 6.2 added new NVDIMM root DSM functions.  Define their
> data structures.
>
> Update the definition of nd_cmd_ars_cap to match the 6.2 spec.
>
> Add the new 6.2 functions names to nvdimm_bus_cmd_name.

This part of the changelog is stale, just trim it when you resend the
series with the other fixups.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
