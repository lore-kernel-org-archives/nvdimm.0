Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45C9021A04802
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 15:18:20 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id b187so75899879oif.0
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 15:18:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490996758-2156-1-git-send-email-linda.knippers@hpe.com>
References: <1490996758-2156-1-git-send-email-linda.knippers@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 31 Mar 2017 15:18:18 -0700
Message-ID: <CAPcyv4gyo-hszJ+P2kx0t0624rtv=QgEZDe+FHh1f0k9reEB6A@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl: Add package dependency information
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 31, 2017 at 2:45 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> To help people avoid discovering the required packages
> as a result of configure failures, add a reference to
> BuildRequires infomation.
>
> Signed-off-by: Linda Knippers <linda.knippers@hpe.com>

Looks good, thanks Linda!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
