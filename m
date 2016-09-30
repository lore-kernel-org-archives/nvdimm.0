Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3354B1A1E05
 for <linux-nvdimm@lists.01.org>; Fri, 30 Sep 2016 15:48:39 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id r126so146431204oib.0
 for <linux-nvdimm@lists.01.org>; Fri, 30 Sep 2016 15:48:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1475266203-18559-4-git-send-email-vishal.l.verma@intel.com>
References: <1475266203-18559-1-git-send-email-vishal.l.verma@intel.com>
 <1475266203-18559-4-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Sep 2016 15:48:37 -0700
Message-ID: <CAPcyv4jqXSjS-Yeex-1rG4Xinx5saxM2LrkyQ=qdVVEBnqi2Ag@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] libnvdimm: clear the internal poison_list when
 clearing badblocks
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 30, 2016 at 1:10 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> nvdimm_clear_poison cleared the user-visible badblocks, and sent
> commands to the NVDIMM to clear the areas marked as 'poison', but it
> neglected to clear the same areas from the internal poison_list which is
> used to marshal ARS results before sorting them by namespace. As a
> result, once on-demand ARS functionality was added:
>
> 37b137f nfit, libnvdimm: allow an ARS scrub to be triggered on demand
>
> A scrub triggered from either sysfs or an MCE was found to be adding
> stale entries that had been cleared from gendisk->badblocks, but were
> still present in nvdimm_bus->poison_list.
>
> This adds the missing step of clearing poison_list entries when clearing
> poison, so that it is in sync with badblocks.
>
> Fixes: 37b137f nfit, libnvdimm: allow an ARS scrub to be triggered on demand
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good, when you resend the other patches amend this changelog to
also say that the cleared errors come back if you disable and
re-enable a namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
