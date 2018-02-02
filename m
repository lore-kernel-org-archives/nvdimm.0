Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA72A223CCF01
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 08:28:23 -0800 (PST)
Received: by mail-ot0-x22f.google.com with SMTP id v5so20846747oth.5
 for <linux-nvdimm@lists.01.org>; Fri, 02 Feb 2018 08:34:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A7FB1D6BACEF4D4EB3E2672A06076E736A6EB69A@irsmsx111.ger.corp.intel.com>
References: <151756015373.24501.12460100041032944306.stgit@dwillia2-desk3.amr.corp.intel.com>
 <A7FB1D6BACEF4D4EB3E2672A06076E736A6EB69A@irsmsx111.ger.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Feb 2018 08:33:58 -0800
Message-ID: <CAPcyv4in73j+=t+wg9_y0YBzp89x9cNMu4Vs=3Fk6KQdcsJ1cA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: fix leak of daxctl_region instances
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
To: "Plewa, Lukasz" <lukasz.plewa@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 2, 2018 at 7:15 AM, Plewa, Lukasz <lukasz.plewa@intel.com> wrote:
> This fix will not work, as daxctl_ctx is freed before free_dax() and daxctl_region_unref() tries to update daxctl_ctx.

Ah true, we need to take and hold another daxctl_ctx reference for
each daxctl_region and unref the daxctl_ctx for each daxctl_region.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
