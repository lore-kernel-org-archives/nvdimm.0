Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 636BC21A02937
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:06:16 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id k98so14727879otk.3
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:06:16 -0800 (PST)
MIME-Version: 1.0
References: <20181119080056.13386-1-oohall@gmail.com>
In-Reply-To: <20181119080056.13386-1-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 12:06:05 -0800
Message-ID: <CAPcyv4jKk9xnXx6DgW5LbqHuZr1HaASxDOdY2n2RzB476O33Kg@mail.gmail.com>
Subject: Re: [PATCH 1/4] libndctl: Use the supported_alignment attribute
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 19, 2018 at 12:11 AM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> Newer kernels provide the "supported_alignments" sysfs attribute that
> indicates what alignments can be used with a PFN or DAX namespace. This
> patch adds the plumbing inside of libndctl to allow users to query this
> information through using:
>         ndctl_{dax|pfn}_get_supported_alignment(), and
>         ndctl_{dax|pfn}_get_num_alignments()
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>

Looks good to me,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
