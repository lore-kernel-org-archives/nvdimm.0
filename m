Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC545211F8872
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:45:50 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id r16-v6so1790105oie.3
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:45:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49h8logrpd.fsf@segfault.boston.devel.redhat.com>
References: <x49h8logrpd.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Jun 2018 08:45:49 -0700
Message-ID: <CAPcyv4h0w3Nn_=gUgO9QLR5b0ujyqZKBrO4uT9bmpqPiHkTgMw@mail.gmail.com>
Subject: Re: [patch,v2] dev-dax: check_vma: ratelimit dev_info-s
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 8:43 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> This is easily triggered from userspace, so let's ratelimit the
> messages.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> ---
> v2 - fix up all of the dev_info calls in check_vma

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
