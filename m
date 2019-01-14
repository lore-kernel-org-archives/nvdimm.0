Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84C92211B5A32
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 10:51:28 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 81so86288otj.2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 10:51:28 -0800 (PST)
MIME-Version: 1.0
References: <20190114181115.11983-1-vishal.l.verma@intel.com>
 <20190114181115.11983-5-vishal.l.verma@intel.com>
 <CAPcyv4j7R6_V4fkoOYavswCSZGXVLnAD=3E3gZy+RSedsuTgVA@mail.gmail.com>
 <a5dbd65d944a2cf45e1ebbfbb4b2e898f3a86778.camel@intel.com>
 <20190114184912.GA17520@vverma7-desk1.lm.intel.com>
In-Reply-To: <20190114184912.GA17520@vverma7-desk1.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 10:51:15 -0800
Message-ID: <CAPcyv4gRKwPfRu_QqR_6+cgS+uWiHd1txwR6YS5jcDEm-UkHow@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 4/4] ndctl: clean up usage of ndctl_cmd_submit
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 14, 2019 at 10:49 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
[..]
> I see how it can be replaced now. Here is a revised patch 4 that
> includes thses conversions:
>
> 8<----
>
>
> From 5c19c269dd0037c3f68725e0f721784056172433 Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Fri, 11 Jan 2019 18:20:31 -0700
> Subject: [ndctl PATCH] ndctl: clean up usage of ndctl_cmd_submit
>
> It is possible for ndctl_cmd_submit to return a positive number,
> indicating a buffer underrun. It is only truly an error if it returns a
> negative number. Several places in the library, the ndctl utility, and
> in test/ were simply checking for an error with "if (rc)". Fix these to
> only error out for negative returns.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me. For the series:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
