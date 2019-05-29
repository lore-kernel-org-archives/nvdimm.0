Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6ED8F21275462
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 10:49:44 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v25so2226278oic.9
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 10:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-9-vishal.l.verma@intel.com>
In-Reply-To: <20190528222440.30392-9-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 May 2019 10:49:33 -0700
Message-ID: <CAPcyv4iKz-x4oLjW1=TDByfw9_ergexAGNDpPuTwP-88P_v4=A@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 08/10] Documentation/daxctl: add a man page for
 daxctl-reconfigure-device
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a man page describing the new daxctl-reconfigure-device command.
>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/daxctl/Makefile.am              |   3 +-
>  .../daxctl/daxctl-reconfigure-device.txt      | 118 ++++++++++++++++++
>  2 files changed, 120 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/daxctl/daxctl-reconfigure-device.txt
[..]
> +-N::
> +--no-online::
> +       By default, memory sections provided by system-ram devices will be
> +       brought online automatically and immediately. Use this option to
> +       disable the automatic onlining behavior.

With a --no-online option it feels like we also need a "daxctl
online-memory" command to hot-add the memory range associated with the
given dax device. Otherwise, this looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
