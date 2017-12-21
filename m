Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43FC7208F7A5D
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 15:00:08 -0800 (PST)
Received: by mail-oi0-x242.google.com with SMTP id w125so17890305oie.7
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 15:04:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171218162839.25166-1-vishal.l.verma@intel.com>
References: <CAPcyv4i=rsA3xO-RdPYV6uYx_NEyT1WcfwjGmh8PkDP58CQnMQ@mail.gmail.com>
 <20171218162839.25166-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Dec 2017 15:04:56 -0800
Message-ID: <CAPcyv4jpRSnsBB+ZB7YWjtEDi5jaQg_yR2QKQ_ZBrW2yVksimQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libnvdimm,
 btt: Fix an incompatibility in the log layout
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
Cc: stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 18, 2017 at 8:28 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Due to a spec misinterpretation, the Linux implementation of the BTT log
> area had different padding scheme from other implementations, such as
> UEFI and NVML.
>
> This fixes the padding scheme, and defaults to it for new BTT layouts.
> We attempt to detect the padding scheme in use when probing for an
> existing BTT. If we detect the older/incompatible scheme, we continue
> using it.
>
> Reported-by: Juston Li <juston.li@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/btt.c | 201 ++++++++++++++++++++++++++++++++++++++++++---------
>  drivers/nvdimm/btt.h |  45 +++++++++++-
>  2 files changed, 211 insertions(+), 35 deletions(-)

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
