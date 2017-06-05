Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5717121A02920
 for <linux-nvdimm@lists.01.org>; Mon,  5 Jun 2017 13:43:06 -0700 (PDT)
Received: by mail-it0-x243.google.com with SMTP id i206so24242790ita.3
 for <linux-nvdimm@lists.01.org>; Mon, 05 Jun 2017 13:44:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170605195057.31492-2-ross.zwisler@linux.intel.com>
References: <20170602205956.28351-1-ross.zwisler@linux.intel.com>
 <20170605195057.31492-1-ross.zwisler@linux.intel.com>
 <20170605195057.31492-2-ross.zwisler@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 5 Jun 2017 22:44:11 +0200
Message-ID: <CAJZ5v0iARt8WT+VHt21trSvYqqy6f4ExLEL3UVxJ4vbX_=_bcQ@mail.gmail.com>
Subject: Re: [resend RFC 1/6] ACPICA: add HMAT table definitions
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
Cc: "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Nachimuthu,, "Lukasz  <lukasz.anaczkowski@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Moore,, "David E  <david.e.box@intel.com>, Lahtinen, Joonas" <joonas.lahtinen@intel.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "Odzioba, Lukasz  <lukasz.odzioba@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "devel@acpica.org" <devel@acpica.org>, Schmauss,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 5, 2017 at 9:50 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Import HMAT table definitions from the ACPICA codebase.
>
> This kernel patch was generated using an ACPICA patch from "Zheng, Lv"
> <lv.zheng@intel.com>.  The actual upstream patch that adds these table
> definitions will come from the Intel ACPICA team as part of their greater
> ACPI 6.2 update.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Can you please hold on util we have integrated all of the pending
ACPICA changes?

Thanks,
Rafael
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
