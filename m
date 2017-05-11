Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F01C21A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 10:50:56 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id b204so39384814oii.1
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 10:50:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149452421176.25868.9410889126303443053.stgit@djiang5-desk3.ch.intel.com>
References: <149452421176.25868.9410889126303443053.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 10:50:54 -0700
Message-ID: <CAPcyv4ipBob2T4wS5PKuiWX2=gAtZJB0MhykmuR+Qkryan4wfA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] ndctl: add foreach helper for region badblocks in
 libndctl
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 11, 2017 at 10:37 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> The helper function allow iteration through the badblocks file that's part
> of the region sysfs attributes. This will support the region list badblocks
> code that's coming.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2: added cleanup of opened badblocks file, from Dan's comments.
> v3: fixed inconsistent return code, from Andy Rudoff's comments.
> v4: removed unnecessary code comment, from Vishal's comments.
> v5: no change.

Thanks Dave, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
