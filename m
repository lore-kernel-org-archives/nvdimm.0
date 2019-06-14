Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C75C12129EBB3
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 12:52:51 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id d17so3769730oth.5
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jun 2019 12:52:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190614185222.30068-1-vishal.l.verma@intel.com>
In-Reply-To: <20190614185222.30068-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Jun 2019 12:52:39 -0700
Message-ID: <CAPcyv4hjFB+y=ibae9fT6UBs=VeAC0NEWHrqzs2pnaeBHx-y_w@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl/inject: Refuse error injection for BTT
 namespaces
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
Cc: Marek de Rosier <marekx.de.rosier@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 14, 2019 at 11:52 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Error injection on a BTT namespace would treat the namespace as 'raw'
> for the purposes of the injection. This can be useful for development,
> but to a user this can be surprising, as injecting with --block=1 would
> corrupt the BTT info block, and the BTT would be lost.
>
> The unit tests do not rely on injecting errors directly into a BTT
> namespace - they convert the namespace to 'raw' mode before performing
> such an injection. For development and testing purposes, we will still
> retain this ability by enforcing that the BTT namespace be explicitly
> forced into raw mode before injection.
>
> Reported-by: Marek de Rosier <marekx.de.rosier@intel.com>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
