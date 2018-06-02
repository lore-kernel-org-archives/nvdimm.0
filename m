Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6387721131DAA
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jun 2018 17:05:07 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id f79-v6so9965460oib.7
 for <linux-nvdimm@lists.01.org>; Fri, 01 Jun 2018 17:05:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180601232814.27865-1-vishal.l.verma@intel.com>
References: <20180601232814.27865-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Jun 2018 17:05:06 -0700
Message-ID: <CAPcyv4j6KzoUuawLtMdR520ZCs0ArbAezoxUnmFki8fegJacFA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl,
 ars: don't invalidate the user-provided command
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

On Fri, Jun 1, 2018 at 4:28 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> In ndctl_cmd_ars_in_progress, which expects a successfully completed
> ars_status command, we used to invalidate the command by setting its
> status to '1', so that the user has to provide a fresh ars_status
> command the next time this check is performed.
>
> In hindsight, this is needless and violates the principle of least
> surprise. We shouldn't be touching the user's data (command), so remove
> this invalidation. If the user uses the same ars_status command again,
> we will simply report that ARS is still in progress.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/ars.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
