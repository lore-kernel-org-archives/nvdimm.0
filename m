Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 753A9212E13CA
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:59:03 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x21so15442593otq.12
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
 <20190724215741.18556-13-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-13-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jul 2019 19:56:25 -0700
Message-ID: <CAPcyv4jaN0ZbROkOifugpd381WhxYJhC-axWyjwN_9s8dDez8w@mail.gmail.com>
Subject: Re: [ndctl PATCH v7 12/13] contrib/ndctl: add bash-completion for the
 new daxctl commands
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

On Wed, Jul 24, 2019 at 2:58 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add bash completion helpers for the new daxctl-reconfigure-device,
> daxctl-online-memory, and daxctl-offline-memory commands.
>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
