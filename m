Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D0A021B02822
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 15:00:02 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id j21so4771071oii.8
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 15:00:02 -0800 (PST)
MIME-Version: 1.0
References: <20190108221510.28553-1-vishal.l.verma@intel.com>
In-Reply-To: <20190108221510.28553-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Jan 2019 14:59:49 -0800
Message-ID: <CAPcyv4gDuv9RX1njn+wmaC=nuU+Tv5Cck-KfQz3A9GDg+B+8fQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl: ignore ENXIO in ndctl_namespace_delete
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

On Tue, Jan 8, 2019 at 2:15 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The kernel will return ENXIO and fail attempts to set the size of a
> namespace that has already been deleted. When we are deleting a
> namespace, we don't care that it has been previously destroyed, or is
> in an uninitialized state.
>
> Ignore the ENXIO from setting the size to zero in this case, and report
> to the callers of this API that the deletion was successful.
>
> This addresses github issue #73.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
