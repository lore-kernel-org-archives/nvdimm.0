Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41FDE1A1DFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 14:16:16 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id b65so154240525oia.1
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 14:16:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464037676-5776-3-git-send-email-vishal.l.verma@intel.com>
References: <1464037676-5776-1-git-send-email-vishal.l.verma@intel.com>
 <1464037676-5776-3-git-send-email-vishal.l.verma@intel.com>
Date: Mon, 23 May 2016 14:16:06 -0700
Message-ID: <CAPcyv4gy+4=_eBKrzW=P-JmTXZoOnvkp+HCLvT-SOXuBfRB17w@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 2/2] ndctl: add bash completion
From: Dan Williams <dan.j.williams@intel.com>
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

On Mon, May 23, 2016 at 2:07 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add bash completion support to ndctl and integrate it with autotools.
> The completion is based on perf/git, and the usage experience is very
> similar.
>
> We do dynamic generation of options using --list-opts for the different
> subcommands. We also attempt to complete long-options that take an
> additional parameter (such as --region=region0), and non-option
> arguments, such as the namespace for a 'disable-namespace' command.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
