Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4743C21CF58D0
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 10:35:46 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id j126so7177311oib.8
 for <linux-nvdimm@lists.01.org>; Fri, 06 Oct 2017 10:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015405.29908-5-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
 <20171006015405.29908-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Oct 2017 10:39:09 -0700
Message-ID: <CAPcyv4hmeUpYZ+KOdw0PL=7gytRP4OP0djAzTKxmCZsZO6fQfg@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/8] ccan/list: add a list_add_after helper
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

On Thu, Oct 5, 2017 at 6:54 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> In preparation for the error-inject command, add anew helper to
> ccan/list for adding a list element in the middle of a list.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ccan/list/list.h | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

Let's not touch the ccan files since these should always match what is
in upstream ccan. Create a local util/list.h to add new routines. It
would also be nice to rename this to list_splice() to bring us closer
in line with kernel list primitives.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
