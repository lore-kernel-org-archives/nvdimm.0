Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8323C21161690
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 20:40:25 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 36-v6so512817oth.11
 for <linux-nvdimm@lists.01.org>; Mon, 01 Oct 2018 20:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20181002033500.3383-1-fugz2012@zoho.com>
In-Reply-To: <20181002033500.3383-1-fugz2012@zoho.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Oct 2018 20:40:13 -0700
Message-ID: <CAPcyv4hfDDrXsKnVwkHYX4WRZPw8NiWkOEjm46uMt_TNqPo3Rw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, namespace: Drop the repeat assignment for
 variable dev->parent
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
To: fugz2012@zoho.com
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Guangzhe GZ1 Fu <fugz1@lenovo.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 1, 2018 at 8:36 PM GuangZhe Fu <fugz2012@zoho.com> wrote:
>
> From: GuangZhe Fu <fugz1@lenovo.com>
>
> The variable dev-parent is assigned twice with the same &nd_region->dev. I think we could drop the second one.
>
> Signed-off-by: GuangZhe Fu <fugz1@lenovo.com>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
