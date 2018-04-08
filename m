Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BDDE226516D8
 for <linux-nvdimm@lists.01.org>; Sun,  8 Apr 2018 10:49:00 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id d9-v6so4014431oth.10
 for <linux-nvdimm@lists.01.org>; Sun, 08 Apr 2018 10:49:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180406212417.16227-2-vishal.l.verma@intel.com>
References: <20180406212417.16227-1-vishal.l.verma@intel.com>
 <20180406212417.16227-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 8 Apr 2018 10:48:59 -0700
Message-ID: <CAPcyv4gkVdn6j_=pObCJKWis637gRgzRZ1+BLWskz+km+d6zbg@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl, test: add write_cache testing to libndctl
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

On Fri, Apr 6, 2018 at 2:24 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> in check_namespaces(), add a step to validate the write_cache status and
> controls for the namespaces that support it. Also add a negative test
> for the namespaces that don't have a write_cache (blk, sector etc),
> making sure the APIs fail as expected.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Wiiliams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
